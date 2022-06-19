% goals for within token
intoken([], end_of_file).

intoken([C|T1], C) :-
	char_type(C, alnum),
	get_char(C1),
	intoken(T1, C1).

intoken([], C) :-
	char_type(C, space).

% goals for beginning token
token(end_of_file, end_of_file).

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

parse(end_of_file, end_of_file).

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
process([X, Y], [X, Y, _], end_of_file, _).

process(R, [X, Y, I], forward, A) :-
	parse(C1),
	parse(A1),
	X1 is A+X,
	Y1 is Y+I*A,
	process(R, [X1, Y1, I], C1, A1).

process(R, [X, Y, I], up, A) :-
	parse(C1),
	parse(A1),
	I1 is I-A,
	process(R, [X, Y, I1], C1, A1).

process(R, [X, Y, I], down, A) :-
	parse(C1),
	parse(A1),
	I1 is I+A,
	process(R, [X, Y, I1], C1, A1).

process(X, Y) :-
	parse(C),
	parse(A),
	process([X, Y], [0,0,0], C, A).
