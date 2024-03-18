null(Obj) :- Obj == null.
not_null(Obj) :- not(null(Obj)).

% Prädikat A1: vorfahre(X,Y), nachkomme(X,Y), nachkommen(X,Y)
nachkomme(X, Y) :- elternteil(Y, X).
nachkomme(X, Y) :- elternteil(Y, YKind), nachkomme(X, YKind).
vorfahre(X, Y) :- elternteil(X, Y).
vorfahre(X, Y) :- elternteil(YEltern, Y), vorfahre(X, YEltern).

nachkommen(Person, Res) :- findall(
    Nachkommen,
    nachkomme(Nachkommen, Person),
    Out
    ),
    list_to_set(Out, Res).
    
% Prädikat A2: eheleute(X,Y) und kind(X,Y)
eheleute(X, Y) :- verheiratet(X, Y).
eheleute(X, Y) :- verheiratet(Y, X).

kind(Kind, Elternteil) :- elternteil(Elternteil, Kind).

% Prädikat A3: geschwister(X,Y)
geschwister(X, Y) :- not(X == Y), kind(X, Elternteil), kind(Y, Elternteil).

% Prädikat A4: bruder(X,Y) schwester(X,Y)
bruder(X, Y) :- maennlich(X), geschwister(X, Y).

schwester(X, Y) :- weiblich(X), geschwister(X, Y).

% Prädikat A5: onkel(X,Y), tante(X,Y), oma(X,Y), opa(X,Y), uropa(X,Y) und uroma(X,Y)
onkel(X, Y) :- kind(Y, Elternteil), bruder(X, Elternteil).

tante(X, Y) :- kind(Y, Elternteil), schwester(X, Elternteil).

oma(X, Y) :- weiblich(X), kind(Mutter,X), elternteil(Mutter,Y).

opa(X, Y) :- maennlich(X), kind(Vater,X), elternteil(Vater,Y).

uroma(X,Y) :- weiblich(X), kind(UromaKind,X), elternteil(UromaKind,YEltern), elternteil(YEltern,Y).

uroma(X,Y) :- maennlich(X), kind(UropaKind,X), elternteil(UropaKind,YEltern), elternteil(YEltern,Y).

% Prädikat A6: maenUweibl(Res), verhKor(Res), elterVoll(Res) und wurzel(Res)
maenUweibl(Res) :- findall(
    Name,
    (maennlich(Name),
    weiblich(Name)),
    Out
    ),
    list_to_set(Out, Res).
    
verhKor(Res) :- findall(
    (X, Y),
    (verheiratet(X, Y), not((maennlich(X), weiblich(Y)))),
    Out
    ),
    list_to_set(Out, Res).
    
elterVoll(Res) :- findall(
    (X, Y),
    (elternteil(X, Y), not(weiblich(X)), not(maennlich(X))),
    Out
    ),
    list_to_set(Out, Res).

alle(Person) :- maennlich(Person).
alle(Person) :- weiblich(Person).

wurzel(Res) :- findall(
    X,
    (alle(X), not(elternteil(_, X))),
    Out
    ),
    list_to_set(Out, Res).



