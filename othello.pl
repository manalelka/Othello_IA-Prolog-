% Initiatisation

play() :-  initialGrid(Grid),displayGrid(Grid,x),play(Grid,x).

% Ex�cution d'un tour de jeu

% Cas o� le jeu est fini : endGame(grid, player) v�rifie si le plateau
% complet ou si le joueur n'a plus de jeton
% announce(player) annonce le gagnant.
%play(Grid, Player) :- endGame(Grid, Player), !, announce(Player).
play(Grid, Player) :- chooseMove(Grid,Line,Column,Player), doMove(Grid,Line,Column,Player,NewGrid), nextPlayer(Player,Player2), displayGrid(NewGrid,Player2), !, play(NewGrid,Player2). % cas d'un tour classique

% Passage au joueur oppos�
nextPlayer(x,o).
nextPlayer(o,x).

% Pr�dicat pour v�rifier si le mouvement est valide
% existingMove(l,c) v�rifie que ligne et colonne rentr�es sont comprises
% dans [a,h] et [1,8]
% isValidMove(grid,line,col,player) v�rifier 2 choses : que la place
% choisie est libre (pas d'autre jeton) et que poser son jeton ici
% permet au player de manger des jetons adverses
chooseMove(Grid,Line,Column,Player) :- tryChooseMove(Grid,Line,Column,Player).

tryChooseMove(Grid,Line,Column,Player) :- write("Entrez la lettre de la case choisie "), read(Letter), write("Entrez le numéro de la case choisie "), read(Number), existingMove(Number,Letter,Line,Column), isValidMove(Grid,Line,Column,Player), !.
tryChooseMove(Grid,Line,Column,Player) :- write("Position illégale, "), tryChooseMove(Grid,Line,Column,Player).

% Conditions de fin du jeu endGame(grid, player) :- A FAIRE PAR LES
% MOCHES

% Les mouvements possibles
letterToNum(a,1).
letterToNum(b,2).
letterToNum(c,3).
letterToNum(d,4).
letterToNum(e,5).
letterToNum(f,6).
letterToNum(g,7).
letterToNum(h,8).

existingPosition(1).
existingPosition(2).
existingPosition(3).
existingPosition(4).
existingPosition(5).
existingPosition(6).
existingPosition(7).
existingPosition(8).

existingMove(Number,Letter,Number,Column) :-
    existingPosition(Number),
    letterToNum(Letter,Column),
    existingPosition(Column).

