check(A) :- var(A), !, fail, writeln('Ungebundene Variable').
check(_).

% Prädikat Not
mnot(A) :- not(var(A)), A, !, fail. % if A is true, then fail
mnot(A) :- not(var(A)). % else resolve to true

% Prädikat And
and(A, B) :- check(A), check(B), A, B.

% Prädikat Or
or(A, B) :- check(A), check(B), A. % if A is true, return true
or(A, B) :- check(A), check(B), B. % else if B is true, return true

% Prädikat Nand
nand(A, B) :- check(A), check(B), not(and(A, B)).

% Prädikat Nor
nor(A, B) :- check(A), check(B), not(or(A, B)).

% Prädikat Implikation
impl(A, B) :- check(A), check(B), or(mnot(A), B).

% Prädikat Äquivalenz
aequiv(A, B) :- check(A), check(B), A, B.
aequiv(A, B) :- check(A), check(B), not(A), not(B).

% Prädikat Xor
xor(A, B) :- check(A), check(B), mnot(aequiv(A, B)).

% Hilfsprädikate Formatierte Tabellen
printBelegung([Belegung|Tail]) :- write(Belegung), spacing, printBelegung(Tail).
printBelegung([]).

printFormel(Formel) :- Formel, trennzeichen, printTrue, !.
printFormel(Formel) :- not(Formel), trennzeichen, printFail.

trennzeichen :- write('|  ').
printTrue :- writeln('true').
printFail :- writeln('fail').
spacing :- write('   ').

% Erzeugt Permutation von true/false in Liste
perm(List, Res) :- perm(List, Res, []).
perm([], Res, Res).
perm([Head|Tail], Res, Acc) :- bool(Head), append(Acc, [Head], NewAcc), perm(Tail, Res, NewAcc).

bool(A) :- A = true ; A = fail.

% Prädikat Tafeln
tafeln(List, Formel) :- perm(List, Belegung), printBelegung(Belegung), printFormel(Formel), fail.

% Prädikat Tafel2
tafel2(A, B, Formel) :- tafeln([A, B], Formel).

% Prädikat Tafel3
tafel3(A, B, C, Formel) :- tafeln([A, B, C], Formel).

% Prädikat AvarListe
avarListe(A, [A]) :- var(A).
avarListe(mnot(A), Res) :- avarListe(A, Res), !.
avarListe(and(A, B), Res) :- avarListe(A, ResLeft), avarListe(B, ResRight), append(ResLeft, ResRight, List), list_to_set(List, Res), !.
avarListe(or(A, B), Res) :- avarListe(A, ResLeft), avarListe(B, ResRight), append(ResLeft, ResRight, List), list_to_set(List, Res), !.
avarListe(nand(A, B), Res) :- avarListe(A, ResLeft), avarListe(B, ResRight), append(ResLeft, ResRight, List), list_to_set(List, Res), !.
avarListe(nor(A, B), Res) :- avarListe(A, ResLeft), avarListe(B, ResRight), append(ResLeft, ResRight, List), list_to_set(List, Res), !.
avarListe(impl(A, B), Res) :- avarListe(A, ResLeft), avarListe(B, ResRight), append(ResLeft, ResRight, List), list_to_set(List, Res), !.
avarListe(aequiv(A, B), Res) :- avarListe(A, ResLeft), avarListe(B, ResRight), append(ResLeft, ResRight, List), list_to_set(List, Res), !.
avarListe(xor(A, B), Res) :- avarListe(A, ResLeft), avarListe(B, ResRight), append(ResLeft, ResRight, List), list_to_set(List, Res), !.

% Prädikate für die Knusperhausarchitektur
formelF1(L1, L2, _L3) :- mnot(and(L1, L2)).
formelF2(_L1, L2, L3) :- impl(L3, L2).
formelF3(L1, L2, L3) :- impl(and(L2, mnot(L1)), mnot(L3)).
formelF0(_L1, _L2, L3) :- mnot(L3).

formelGes(L1, L2, L3) :- impl(and(formelF1(L1, L2, L3), and(formelF2(L1, L2, L3), formelF3(L1, L2, L3))), formelF0(L1, L2, L3)).

knfL1(L1, L2, _L3) :- or(mnot(L1), mnot(L2)).
knfL2(_L1, L2, L3) :- or(mnot(L3), L2).
knfL3(L1, L2, L3) :- or(mnot(L2), or(L1, mnot(L3))).
knfL0(_L1, _L2, L3) :- L3.

knfGes(L1, L2, L3) :- and(knfL1(L1, L2, L3), and(knfL2(L1, L2, L3), and(knfL3(L1, L2, L3), knfL0(L1, L2, L3)))).

formelA :- tafeln([L1, L2, L3], formelGes(L1, L2, L3)).
formelA.
formelB :- tafeln([L1, L2, L3], aequiv(knfGes(L1, L2, L3), mnot(formelGes(L1, L2, L3)))).
formelB.




