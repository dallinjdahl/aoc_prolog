% goals for within token
intoken([], end_of_file).

intoken([C|T1], C) :-
	(=(C, '0'); =(C, '1')),
	get_char(C1),
	intoken(T1, C1).

intoken([], C) :-
	char_type(C, space).

% goals for beginning token
token(end_of_file, end_of_file).

token(T, C) :-
	(=(C, '0'); =(C, '1')),
	intoken(T, C).

token(T, C) :-
	char_type(C, space),
	get_char(C1),
	token(T, C1).

token(T) :-
	get_char(C),
	token(T, C).

% parse tokens into commands, numbers, or end_of_file

parse(end_of_file, end_of_file).

parse(1, '1').
parse(0, '0').
parse([], []).

parse([H|T], [H1|T1]) :-
	parse(H, H1),
	parse(T, T1).

parse(L) :-
	token(T),
	parse(L, T).

% process input to measure movement

gamma([], _, []).

gamma([B|Bs], Count, [Freq|Freqs]) :-
	gamma_bit(B, Count, Freq),
	gamma(Bs, Count, Freqs).

gamma_bit(1, Count, Freq) :-
	Freq*2 > Count.

gamma_bit(0, Count, Freq) :-
	Freq*2 < Count.


epsilon(1, 0). 
epsilon(0, 1).
epsilon([], []).
epsilon([E|Es], [G|Gs]) :-
	epsilon(E, G),
	epsilon(Es, Gs).

binary(N, N, []).

binary(R, N, [B|Bs]) :-
	N1 is 2*N+B,
	binary(R, N1, Bs).

binary(N, B) :-
	binary(N, 0, B).

freq([Freq|Freqs], [Freq1|Freqs1], [B|Bs]) :-
	Freq is Freq1 + B,
	freq(Freqs, Freqs1, Bs).

freq(F, [], F).

process(0, [], end_of_file).

process(Count, Freqs, B) :-
	parse(B1),
	process(Count1, Freqs1, B1),
	freq(Freqs, Freqs1, B),
	Count is Count1 + 1.

process(Count, Freqs) :-
	parse(B),
	process(Count, Freqs, B).

% process(C, F), gamma(G, C, F), epsilon(E, G), binary(En, E), binary(Gn, G), P is En*Gn
