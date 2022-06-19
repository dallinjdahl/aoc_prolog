% goals for within token
intoken(T, end_of_file) :-
	=(T, []).

intoken(T, C) :-
	char_type(C, digit),
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
	char_type(C, digit),
	intoken(T, C).

token(T, C) :-
	char_type(C, space),
	get_char(C1),
	token(T, C1).

token(T) :-
	get_char(C),
	token(T, C).

% parse tokens into numbers or end_of_file
parse(N, end_of_file) :-
	=(N, end_of_file).

parse(N, T) :-
	number_chars(N, T).

parse(N) :-
	token(T),
	parse(N, T).

% process input to detect increases
process(Acc, _, end_of_file) :-
	Acc is 0.

process(Acc, end_of_file, _) :-
	Acc is 0.

process(Acc, N1, N2) :-
	N1 >= N2,
	parse(N3),
	process(Acc, N2, N3).

process(Acc, N1, N2) :-
	N1 < N2,
	parse(N3),
	process(Acc1, N2, N3), 
	Acc is Acc1+1.

process(Acc) :-
	parse(N1),
	parse(N2),
	process(Acc, N1, N2).
