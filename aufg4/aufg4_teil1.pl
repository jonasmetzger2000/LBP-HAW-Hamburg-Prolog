% Steuert ob Ausgaben zur Unifikation gemacht werden sollen.
print(false).

% 1. Prädikat Occur-check(Variable, Term)
occurs_check(X, T) :- var(T), var(X), X == T, fail.
occurs_check(X, T) :- var(T), var(X), not(X == T).
occurs_check(X, T) :- not(var(T)), T =.. [_|Args], foreach(member(Arg, Args), occurs_check(X, Arg)).

% 2. Prädikat Unifiziere(TermA, TermB, Substitution)
my_unify(S, T) :- var(S), var(T), S = T, unify_success(S, T), !.

my_unify(S, T) :- var(S), nonvar(T), not(occurs_check(S, T)), unify_fail(S, T), fail.
my_unify(S, T) :- var(S), nonvar(T), occurs_check(S, T), unify_success(S, T), S = T, !.

my_unify(S, T) :- var(T), nonvar(S), not(occurs_check(T, S)), unify_fail(T, S), fail.
my_unify(S, T) :- var(T), nonvar(S), occurs_check(T, S), unify_success(T, S), T = S, !.

%my_unify(S, T) :- nonvar(S), nonvar(T), S =.. [PredicateS|ArgsS], T =.. [PredicateT|ArgsT], PredicateS == PredicateT, length(ArgsS, ArgsSLength), length(ArgsT, ArgsTLength), ArgsSLength == ArgsTLength, nth0(Index, ArgsS, ArgS), nth0(Index, ArgsT, ArgT), my_unify(ArgS, ArgT).
my_unify(S, T) :- nonvar(S), nonvar(T), S =.. [PredicateS|ArgsS], T =.. [PredicateT|ArgsT], PredicateS == PredicateT, length(ArgsS, ArgsSLength), length(ArgsT, ArgsTLength), ArgsSLength == ArgsTLength, my_unify_list(ArgsS, ArgsT).

my_unify_list([], []).
my_unify_list([S|TailS], [T|TailT]) :- my_unify(S, T), my_unify_list(TailS, TailT).

% Print Helper
unify_success(S, T) :- print(true), format('Substitution: Variable ~w mit Term ~w~n', [S, T]).
unify_success(_, _) :- print(_).

unify_fail(S, T) :- print(true), format('Substitution nicht moeglich: Variable ~w kommt in Term ~w vor.~n', [S, T]).
unify_fail(_, _) :- print(_).

test :- test(occurs_check), test(my_unify).
test(my_unify) :-
    %positiv
    write('my_unify +'),
    my_unify(a(b,_C,d(e,_F,g(h,i,j))),a(_B,c,d(_E,f,_X1))), write('.'),!,
    my_unify(h(r(a),l(X2),g(g(Y2))),h(X2,Y2,_Z2)), write('.'),!,
    my_unify(X3,_Y3), write('.'),!,
    my_unify(X,X),
    %negativ
    write('. -'),!,
    \+ my_unify(h(r(a),l(_Z3),g(g(Y3))),h(X3,Y3,X3)), write('.'),!,
    \+ my_unify(h(r(a),l(Z4),g(g(Y4))),h(_X4,Y4,Z4)), write('.'),!,
    \+ my_unify(f(X5,Y5),f(Y5,f(X5))), write('.'),!,
    \+ my_unify(f(_X6,_Y6),f(a,b,c)), write('.'),!,
    \+ my_unify(n(a,b),f(_X7,_Y7)),!, writeln('ok').

test(occurs_check) :-
    %positiv
    write('occurs_check +'),
    occurs_check(_X,f(_Y)), write('.'),!,
    occurs_check(_X1,h(r(a),l(_Z1),g(g(_Y1)))), write('.'),!,
    occurs_check(_X2,_Y2),
    %negativ
    write('. -'),!,
    \+ occurs_check(X3,f(X3)), write('.'),!,
    \+ occurs_check(X4,h(r(a),l(X4),g(g(_Y4)))), write('.'),!,
    \+ occurs_check(X5,X5),!, writeln('ok').


