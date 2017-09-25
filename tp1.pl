%Exercício RC1

male(aldo).
female(christina).
male(michael).
male(lincoln).
parent(aldo, michael).
parent(christina, michael).
parent(aldo, lincoln).
parent(christina, lincoln).
father(A,B):-parent(A,B),male(A).

%a) parent(X, michael).
%b) parent(aldo, X).

%Exercício RC2
pilot(lamb).
pilot(besenyei).
pilot(chambliss).
pilot(maclean).
pilot(mangold).
pilot(jones).
pilot(bonhomme).

team(breitling).
team(redbull).
team(mediterraneanRacingTeam).
team(cobra).
team(matador).

belongs(lamb,breitling).
belongs(besenyei,redbull).
belongs(chambliss,redbull).
belongs(maclean,mediterraneanRacingTeam).
belongs(mangold,cobra).
belongs(jones,matador).
belongs(bonhomme,matador).

plane(mx2).
plane(edge540).

drives(lamb,mx2).
drives(besenyei, edge540).
drives(chambliss, edge540).
drives(maclean, edge540).
drives(mangold, edge540).
drives(jones, edge540).
drives(bonhomme, edge540).

circuit(istanbul).
circuit(budapest).
circuit(porto).

pwinner(jones, porto).
pwinner(mangold, budapest).
pwinner(mangold, istanbul).

gates(istanbul, 9).
gates(budapest, 6).
gates(porto, 5).

twinner(X,Y):-pwinner(A,Y),belongs(A,X).

%a) pwinner(X,porto).
%b) twinner(X,porto).
%c) pwinner(X,A),pwinner(X,B),A\=B.
%d) gates(X,Y), Y>8.
%e) drives(X,Y), Y\= edge540.


%Exercício RC9
aluno(joao, paradigmas).
aluno(maria, paradigmas).
aluno(joel, lab2).
aluno(joel, estruturas).
frequenta(joao, feup).
frequenta(maria, feup).
frequenta(joel, ist).
professor(carlos, paradigmas).
professor(ana_paula, estruturas).
professor(pedro, lab2).
funcionario(pedro, ist).
funcionario(ana_paula, feup).
funcionario(carlos, feup).



%a) aluno(X,Y),professor(Z,Y).
