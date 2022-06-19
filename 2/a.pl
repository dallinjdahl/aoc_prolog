% goals for within token
intoken(T, end_of_file) :-
	=(T, []).

intoken(T, C) :-
	char_type(C, alnum),
	get_char(C1),
	intoken(T1, C1),
	=(T, [C|T1]).

intoken(T, C) :-
	char_type(C, space),
	=(T, []).

% goals for beginning token
token(T, end_of_file) :-
	=(T, end_of_file).

token(T, C) :-
	char_type(C, alnum),
	intoken(T, C).

token(T, C) :-
	char_type(C, space),
	get_char(C1),
	token(T, C1).

token(T) :-
	get_char(C),
	token(T, C).

% parse tokens into commands, numbers, or end_of_file
isnum([]).

isnum([H|T]) :-
	char_type(H, digit),
	isnum(T).

parse(N, end_of_file) :-
	=(N, end_of_file).

parse(N, T) :-
	\+ isnum(T),
	atom_chars(N, T).

parse(N, T) :-
	isnum(T),
	number_chars(N, T).

parse(N) :-
	token(T),
	parse(N, T).

% process input to measure movement
process(X, Y, end_of_file, _) :-
	X is 0,
	Y is 0.

process(X, Y, forward, A) :-
	parse(C1),
	parse(A1),
	process(X1, Y, C1, A1),
	X is A+X1.

process(X, Y, up, A) :-
	parse(C1),
	parse(A1),
	process(X, Y1, C1, A1),
	Y is Y1-A.

process(X, Y, down, A) :-
	parse(C1),
	parse(A1),
	process(X, Y1, C1, A1),
	Y is Y1+A.

process(X, Y) :-
	parse(C),
	parse(A),
	process(X, Y, C, A).
