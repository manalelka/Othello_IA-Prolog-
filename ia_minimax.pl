% IA MINI MAX
%
% Fonctionnement de l'algo : https://www.youtube.com/watch?v=l-hh51ncgDI
%
% Grid est la grille sur laquelle l'IA doit jouer
%
% Depth est la profondeur càd le nb de tours futurs pour lesquels on va
% évaluer tous les coups possibles afin d'optimiser ce que l'IA doit
% jouer
%
% Player est au départ le joueur correspondant à l'IA, puis il
% représente l'autre joueur quand on évalue le coup de l'adversaire
% et ainsi de suite
%
% GridResult est la grille résultant du coup choisi par l'IA (ou du coup
% choisi par l'adversaire)
%
% Eval est l'heuristique, qui représente ici le nombre de pions de
% différence entre le joueur IA et le joueur adverse (par exemple si
% l'IA a 15 pions et l'adversaire 11 : eval = 4 ; si l'IA a 2 pions et
% l'adversaire 10 : eval = -8). L'Eval min est initialisée à -65 et
% l'Eval max à 65.

% max : début de l'algo d'évaluation du meilleur coup à jouer pour
% l'IA. On répète un process sur tous les moves possibles (AllMoves)

% MAX QUI VA CONTINUER A JOUER IL FAUT ECRIRE LA DEPTH DEXECUTION EN
% 2EME ARGUMENT ET NORMALEMENT CA MARCHE MDRRRRRRRRRRRRRRRRRRRRRRRRR
miniMax(ia, Grid, 0, Player, GridResult, EvalMax, [], Player2) :-
    nextPlayer(Player,NextPlayer),
    displayGrid(GridResult,NextPlayer), !,
    play(GridResult,NextPlayer,Player2,minimax).

% si le jeu est fini
% on dit que la profondeur est de 0 afin que max() évalue la grille
miniMax(IaOther, Grid, Depth, Player, GridResult, EvalMax, AllMoves, Player2) :-
   endGame(Grid),
   Depth=0,
   miniMax(IaOther,Grid, Depth, Player, GridResult, EvalMax, AllMoves, Player2).

% Profondeur de 0
% pour chaque move on l'exécute puis on évalue la grille obtenue
miniMax(IaOther, Grid, Depth, Player, GridResult, EvalMax, [],Player2).
miniMax(IaOther, Grid, 0, Player, GridResult, EvalMax, [[Line,Col]|RemainingMoves],Player2) :-
    write("test Move"), write(IaOther), write(" : "), write(Line), write(Col), write(" Remaining :"), write(RemainingMoves), nl,
    doMove(Grid,Line,Col,Player,NewGrid),
    heuristic(IaOther, Grid, 0, Player, RemainingMoves, GridResult, EvalMax, NewGrid,Player2). % on remplace la grid résultat si la grille obtenue est max, puis on exécute max pour les grilles possibles restantes
% cas où la profondeur 0 n'est pas atteinte on calcule les futurs
% coups
miniMax(IaOther,Grid,Depth,Player,GridResult,EvalMax,[[Line,Col]|RemainingMoves],Player2) :-
    Depth\=0,
    write("test Move : "), write(IaOther), write(Line), write(Col), write(" Remaining :"), write(RemainingMoves), nl,
    doMove(Grid,Line,Col,Player,NewGrid), % on exécute le move Line,Col
    nextPlayer(Player,NextPlayer),
    all_possible_moves(NextPlayer, NewGrid, AllNewMoves),  % on calcule tous les move possibles pour l'adversaire sur la nouvelle grille obtenue
    nextIaOther(IaOther,NewIaOther),
    NewDepth is Depth-1,
    miniMax(NewIaOther,NewGrid, NewDepth, NextPlayer, GridResult, 65, AllNewMoves, Player2). % on exécute mini pour la nouvelle grille et avec tous les move possibles
   % on remplace la grid résultat si la grille obtenue est max, puis on exécute max pour les grilles possibles restantes

% maxHeuristic fait que GridResult est toujours la grille max
heuristic(IaOther, OldGrid, Depth, Player, RemainingMoves, GridResult, EvalMax, GridToCompare, Player2) :-
    evaluateH1(IaOther,GridToCompare,Player,Eval),
    getMiniMax(IaOther,OldGrid, Depth, Player, RemainingMoves, GridResult, EvalMax, GridToCompare, Eval ,Player2),!.

evaluateH1(ia,Grid,Player,Eval) :-
    countTokens(Grid, Player, 0, NbTokensIA),
    nextPlayer(Player,Next),
    countTokens(Grid, Next, 0, NbTokensOther),
    Eval is NbTokensIA-NbTokensOther.
evaluateH1(other,Grid,Player,Eval) :-
    countTokens(Grid, Player, 0, NbTokensOther),
    nextPlayer(Player,Next),
    countTokens(Grid, Next, 0, NbTokensIA),
    Eval is NbTokensIA-NbTokensOther.

getMiniMax(ia,OldGrid,Depth,Player,RemainingMoves,GridResult,EvalMax,GridToCompare,Eval,Player2) :-
    Eval =< EvalMax,
    write("La grille évaluée :"), displayGrid(GridToCompare,Player), write(" a une eval="),write(Eval), write(" inférieur à l'eval max de "),write(EvalMax),nl,
    miniMax(ia,OldGrid, Depth, Player, GridResult, EvalMax, RemainingMoves,Player2).
getMiniMax(ia,OldGrid,Depth,Player,RemainingMoves,GridResult,EvalMax,GridToCompare,Eval,Player2) :-
    Eval>EvalMax,
    % write("L'eval est supérieur à l'evalMax. "),
    write("NOUVELLE GRILLE RESULT"), nl,
    displayGrid(GridToCompare,Player),
    miniMax(ia,OldGrid, Depth, Player, GridToCompare, Eval, RemainingMoves, Player2). % on remplace GridResult par Grid et EvalMax par Eval
    %write("La grille max est celle d'eval="), write(Eval), nl
getMiniMax(other,OldGrid,Depth,Player,RemainingMoves,GridResult,EvalMax,GridToCompare,Eval,Player2) :-
    Eval >= EvalMax,
    write("La grille évaluée :"), displayGrid(GridToCompare,Player), write(" a une eval="),write(Eval), write(" inférieur à l'eval max de "),write(EvalMax),nl,
    miniMax(other,OldGrid, Depth, Player, GridResult, EvalMax, RemainingMoves,Player2).
getMiniMax(other,OldGrid,Depth,Player,RemainingMoves,GridResult,EvalMax,GridToCompare,Eval,Player2) :-
    Eval<EvalMax,
    % write("L'eval est supérieur à l'evalMax. "),
    write("NOUVELLE GRILLE RESULT"), nl,
    displayGrid(GridToCompare,Player),
    miniMax(other,OldGrid, Depth, Player, GridToCompare, Eval, RemainingMoves,Player2). % on remplace GridResult par Grid et EvalMax par Eval
    %write("La grille max est celle d'eval="), write(Eval), nl

nextIaOther(ia,other).
nextIaOther(other,ia).

% Générer arbre avec toutes les coordonn�es des coups valides
all_possible_moves(Player, Grid, AllMoves) :-
   %write("Tous les coups possibles pour "), write(Player),
   findall([Line, Column], isValidMove(Grid,Line,Column,Player),
   AllMoves).
   %write(" sont "), write(AllMoves), nl.
