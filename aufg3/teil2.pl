% Prädikat Is Atomic Expressions
is_atomic_expr(Formel) :- var(Formel).

% Prädikat IsLiteral
is_literal(Formel) :- is_atomic_expr(Formel), !.
is_literal(mnot(Formel)) :- is_atomic_expr(Formel). % verneinte atomoische Aussagen sind auch Literale

% Prädikat Negationsnormalform
nnf_expr(Formel, Res) :- replace(Formel, Res), !.

replace(Atomic, Atomic) :- is_literal(Atomic), !.

replace(mnot(mnot(A)), NewA) :- replace(A, NewA).

                       % Wieso muss die Negation beim XOR nach Vorne?!
%replace(xor(A, B), and(or(NewA, NewB), or(NewNegA, NewNegB))) :- replace(A, NewA), replace(B, NewB), replace(mnot(A), NewNegA), replace(mnot(B), NewNegB).
replace(xor(A, B), and(or(NewNegA, NewNegB), or(NewA, NewB))) :- replace(A, NewA), replace(B, NewB), replace(mnot(A), NewNegA), replace(mnot(B), NewNegB).
replace(mnot(xor(A, B)), or(and(NewA, NewB), and(NewNegA, NewNegB))) :- replace(A, NewA), replace(B, NewB), replace(mnot(A), NewNegA), replace(mnot(B), NewNegB).

replace(aequiv(A, B), or(and(NewA, NewB), and(NewNegA, NewNegB))) :- replace(A, NewA), replace(B, NewB), replace(mnot(A), NewNegA), replace(mnot(B), NewNegB).
replace(mnot(aequiv(A, B)), and(or(NewA, NewB), or(NewNegA, NewNegB))) :- replace(A, NewA), replace(B, NewB), replace(mnot(A), NewNegA), replace(mnot(B), NewNegB).

replace(impl(A, B), or(NewNegA, NewB)) :- replace(mnot(A), NewNegA), replace(B, NewB).
replace(mnot(impl(A, B)), and(NewA, NewNegB)) :- replace(A, NewA), replace(mnot(B), NewNegB).

replace(nor(A, B), and(NewNegA, NewNegB)) :- replace(mnot(A), NewNegA), replace(mnot(B), NewNegB).
replace(mnot(nor(A, B)), or(NewA, NewB)) :- replace(A, NewA), replace(B, NewB).

replace(nand(A, B), or(NewNegA, NewNegB)) :- replace(mnot(A), NewNegA), replace(mnot(B), NewNegB).
replace(mnot(nand(A, B)), and(NewA, NewB)) :- replace(A, NewA), replace(B, NewB).

replace(or(A, B), or(NewA, NewB)) :- replace(A, NewA), replace(B, NewB).
replace(mnot(or(A, B)), and(NewNegA, NewNegB)) :- replace(mnot(A), NewNegA), replace(mnot(B), NewNegB).

replace(and(A, B), and(NewA, NewB)) :- replace(A, NewA), replace(B, NewB).
replace(mnot(and(A, B)), or(NewNegA, NewNegB)) :- replace(mnot(A), NewNegA), replace(mnot(B), NewNegB).

% Prädit ist Klausel
is_clause(Formel) :- is_literal(Formel), !.
is_clause(or(A, B)) :- is_clause(A), is_clause(B).

% Prädikat Ist Horn Klausel
is_horn_clause(Formel) :- collect_literals(Formel, Literals), count_positive_literals(Literals, Res), Res =< 1.

collect_literals(Atomic, [Atomic]) :- is_literal(Atomic), !.
collect_literals(or(A, B), Res) :- collect_literals(A, ResA), collect_literals(B, ResB), append(ResA, ResB, Res).

count_positive_literals([], 0).
count_positive_literals([Head|Tail], Res) :- is_atomic_expr(Head), count_positive_literals(Tail, Count), Res is Count+1.
count_positive_literals([Head|Tail], Res) :- not(is_atomic_expr(Head)), count_positive_literals(Tail, Res).











