isWinner(Nb1,Nb2,100) :- Nb1 > Nb2.
isWinner(_,_,-100).
heuristic(Heur,Grid,Token,Eval) :-
    get(Token,N1),
    N2 is N1+1, %nombre de grille exploree incremente
    set(Token,N2),
    h(Heur,Grid,Token,Eval).

h(endGame,Grid,Token,Eval) :-
    next(Token,Opponent),
    countTokens(Grid, Token, 0, Nb1),
    countTokens(Grid, Opponent, 0, Nb2),
    isWinner(Nb1,Nb2,Eval).

h(global,Grid,Token,Eval) :- 
    h(countTokens,Grid,Token,Eval1),
    h(countMoves,Grid,Token,Eval2),
    h(countCorners,Grid,Token,Eval3),
    h(stability,Grid,Token,Eval4),
    Eval is Eval1*4 + Eval2*2 + Eval3*20 + Eval4*3.

h(countTokens,Grid,Token,Eval) :-
    countTokens(Grid, Token, 0, NbTokensCurrentPlayer),
    nextPlayer(Token,Opponent),
    countTokens(Grid, Opponent, 0, NbTokensOpponent),
    Eval is NbTokensCurrentPlayer-NbTokensOpponent.

h(countMoves,Grid,Token,Eval) :-
    allPossibleMoves(Token, Grid, AllMovesMax),
    length(AllMovesMax, Nb_MaxMoves),
    nextPlayer(Token,Opponent),
    allPossibleMoves(Opponent, Grid, AllMovesMin), length(AllMovesMin, Nb_MinMoves),
    Eval is Nb_MaxMoves - Nb_MinMoves.

h(countCorners,Grid,Token,Eval) :-
        getCorners(Grid,ListCorners),   
        %listeCorners est une liste de 4 elements dans laquelle est stockee
        %la valeur de chaque coin
        countTokensInRow(ListCorners,Token,0, Nb_CornersMax),
        nextPlayer(Token,Opponent),
        countTokensInRow(ListCorners,Opponent,0, Nb_CornersMin),
        Eval is Nb_CornersMax - Nb_CornersMin.

h(stability,Grid,Token,Eval):-
                   gridToLine(Grid, AsLine),
                   stability_weights(Stability_line),
                   nextPlayer(Token,Opponent),
                   stabilityHeuristic(AsLine,Stability_line,Token,Opponent,Res_PlayerMax,Res_PlayerMin),
                   Eval is Res_PlayerMax - Res_PlayerMin.

%Recuperation des valeurs des coins
getCorners(Grid,[C1,C2,C3,C4]):-
        element(Grid,1,1,C1),
        element(Grid,8,1,C2),
        element(Grid,1,8,C3),
        element(Grid,8,8,C4).

stability_weights([0,  0,   0,  0,  0,  0,  0,  0,  0, 0,
                   0,  4,  -3,  2,  2,  2,  2, -3,  4, 0,
                   0, -3,  -4, -1, -1, -1, -1, -4, -3, 0,
                   0,  2,  -1,  1,  0,  0,  1, -1,  2, 0,
                   0,  2,  -1,  0,  1,  1,  0, -1,  2, 0,
                   0,  2,  -1,  0,  1,  1,  0, -1,  2, 0,
                   0,  2,  -1,  1,  0,  0,  1, -1,  2, 0,
                   0, -3,  -4, -1, -1, -1, -1, -4, -3, 0,
                   0,  4,  -3,  2,  2,  2,  2, -3,  4, 0,
                   0,  0,   0,  0,  0,  0,  0,  0,  0, 0]).%Les 0 sur les cotés correspondent au bord de la grille sur lequel on ne peut pas poser de jeton.

stabilityHeuristic([], [],_,_, 0, 0).

stabilityHeuristic([Head_grid|Tail_grid], [Head_weights|Tail_weights], Head_grid, MinPlayer, Res_PlayerMax, Res_PlayerMin) :-
                   stabilityHeuristic(Tail_grid, Tail_weights,Head_grid, MinPlayer, Tmp_ResPlayerMax, Res_PlayerMin),!,
                   Res_PlayerMax is Tmp_ResPlayerMax + Head_weights.

stabilityHeuristic([Head_grid|Tail_grid], [Head_weights|Tail_weights],MaxPlayer,Head_grid, Res_PlayerMax, Res_PlayerMin) :-
                   stabilityHeuristic(Tail_grid, Tail_weights,MaxPlayer, Head_grid, Res_PlayerMax, Tmp_ResPlayerMin),!,
                   Res_PlayerMin is Tmp_ResPlayerMin + Head_weights.

stabilityHeuristic([_|TG], [_|TW], MaxPlayer, MinPlayer, ResMax, ResMin) :-
                    stabilityHeuristic(TG, TW, MaxPlayer, MinPlayer, ResMax, ResMin).

%Conversion grille en ligne
gridToLine(Grid, Res) :-
                   gridToLine(Grid, [], Res).
gridToLine([], Res, Res).
gridToLine([Line|Grid], Line_tmp, Line_out) :-
                   append(Line, Line_tmp, New_line),
                   gridToLine(Grid, New_line, Line_out).
