null(Obj) :- Obj == null.
not_null(Obj) :- not(null(Obj)).

% Prädikat A1: collect_stueck(Collection)
collect_stueck(Res) :- findall(
        (Titel, Tonart),
        (stueck(SNR, KNR, Titel, Tonart, _Opus), not_null(SNR), not_null(KNR), not_null(Titel), not_null(Tonart)),
        Out
    ),
    list_to_set(Out, Res).

% Prädikat A2: collect_gs(Collection)
collect_gs(Res) :- findall(
        (CDNR, GesLaenge),
        (cd(CDNR, _Name, _Hersteller, _Anzahl, GesLaenge), not_null(CDNR), not_null(GesLaenge), GesLaenge >= 88, GesLaenge =< 342),
        Out
    ),
    list_to_set(Out, Res).
    
% Prädikat A3: collect_st(KListe, Collection)
collect_st(List, Res) :- collect_st(List, Res, []).
collect_st([], Res, Acc) :- list_to_set(Acc, Res).
collect_st([Name|KListe], Res, Acc) :- findall(
        (Name, Title),
        (komponist(KNR, _Vorname, Name, _Geboren, _Gestorben), not_null(KNR),
        stueck(_SNR, KNR, Title, _Tonart, _Opus)),
        Out
    ),
    append(Acc, Out, NewAcc),
    collect_st(KListe, Res, NewAcc).

% Prädikat A4: collect_komp(Instrument, Collection)
collect_komp(Instrument, Res) :- findall(
    (Vorname, Name),
    (solist(_CDNR, SNR, _Name, Instrument), not_null(SNR),
    stueck(SNR, KNR, _Titel, _Tonart, _Opus), not_null(KNR),
    komponist(KNR, Vorname, Name, _Geboren, _Gestorben)),
    Out
    ),
    list_to_set(Out, Res).
    
% Prädikat A5: collect_time(Collection)
collect_time(Res) :- findall(
    (Vorname, Nachname, Gesamtspieldauer),
    (komponist(KNR, Vorname, Nachname, _Geboren, _Gestorben), not_null(KNR), not_null(Vorname), not_null(Nachname),
    gesamtspieldauer_per_komponist(Vorname, Nachname, Gesamtspieldauer)),
    Out),
    list_to_set(Out, Res).

gesamtspieldauer_per_komponist(Vorname, Nachname, Res) :-
     cds_von_komponist(Vorname, Nachname, Out), gesamtspieldauer(Out, Res).

cds_von_komponist(Vorname, Nachname, Res) :- findall(
    (Vorname, Nachname, Spielzeit),
    (komponist(KNR, Vorname, Nachname, _Geboren, _Gestorben), not_null(KNR),
    stueck(SNR, KNR, _Titel, _Tonart, _Opus), not_null(SNR),
    aufnahme(CDNR, SNR, _Orchester, _Leitung), not_null(CDNR),
    cd(CDNR, _Name, _Hersteller, _AnzahlCds, Spielzeit)),
    Out
    ),
    list_to_set(Out, Res).

gesamtspieldauer([], 0).
gesamtspieldauer([(_Vorname, _Nachname, Spielzeit)|Tail], Gesamtspielzeit) :-
    gesamtspieldauer(Tail, Sum), Gesamtspielzeit is Sum + Spielzeit.
    






