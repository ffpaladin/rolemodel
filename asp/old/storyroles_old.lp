% this file contains the rules for roles and nullifiers

%%%%
%%%% ROLES
%%%%

has_role(R,P) :-
        role_satisfied(R,P),
        not role_blocked(R,P).

%:- required_role(R,P), not has_role(R,P).
%:- forbidden_role(R,P), has_role(R,P).


% present everything that reinforces a role

present(motiv(X,S,P),T) :- harms(X),
		expectation_realized(X,S,P,T),
		role_satisfied(victim,P).
present(motiv(X,S,P),T) :- harms(X),
		expectation_realized(X,S,P,T),
		role_satisfied(aggressor,S).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ROLE: victim (gets harmed)
role(victim).

role_satisfied(victim,P) :-
        harms(X),
        expectation_realized(X,S,P,T),
        not harm_nullified(X,S,P,T).

presentation(motiv(X,S,P),T) :- role_satisfied(victim,P),
	harms(X),
	expectation_realized(X,S,P,T).


% if you manipulate someone into doing something to yourself, you are nulled

harm_nullified(X,S,P,T) :-
	expectation_realized(manipulated,P,S,T),
	happens(svo(P,mtrans(motiv(X,S,P)),S),T1),
	T1 < T,
	harms(X).

	% flash back to manipulation


% if you wanted it to happen

harm_nullified(X,S,P,T) :-
			expectation_realized(depressed,S,S,T1),
			T1 < T,
			expectation_realized(indifferent_tragedy,P,S,T),
			expectation_realized(X,S,P,T).


% if payback

harm_nullified(X,S,P,T) :-
	holds(attrib(P,wants(motiv(X1,P,S))),T1),
	harms(X1),
	T1 < T,
	expectation_realized(X2,P,S,T2),
	T2 < T,
	harms(X2),
	harms(X),
	expectation_realized(X,S,P,T).
	
% if self defense

harm_nullified(murdered,S,P,T) :- 
	expectation_realized(self_defended_murder,S,P,T).

% no harm if no mourning of death

harm_nullified(lost_friend,S1,S2,T) :-
	expectation_realized(lost_friend,S1,S2,T),
	happens(svo(S1,kills,S3),T),
	not holds(attrib(S2,rel(stranger,S3)),T),
	not expectation_realized(mourned,S2,S3,T).

harm_nullified(lost_friend,S1,S2,T) :-
        expectation_realized(lost_friend,S1,S2,T),
        happens(svo(S1,kills,S3),T),
        not holds(attrib(S2,rel(stranger,S3)),T),
        not expectation_realized(mourned,S2,S3,T),
	expectation_realized(rejoiced,S2,S3,T).





%        context(S,V,O,T,D),
%		%not motivation(S,V,O,T,hate),
%        unharms(D,V).

%harm_nullified(S,V,S,T) :-
%		%not motivation(S,V,O,T,hate),
%        sentiment(S,V,S,T,desire).
		

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ROLE: aggressor (intentionally harms)

role(aggressor).

role_satisfied(aggressor,S) :-
        harms(X),
        expectation_realized(X,S,P,T),
	expectation_realized(rejoiced,S,P,T+1),
        not aggression_nullified(X,S,P,T).


% S regrets what they did to P - This one is a bit weak
%aggression_nullified(X,S,P,T) :- expectation_realized(X,S,P,T),
%	expectation_realized(regretted,S,P,T1),
%	T1>T,
%	harms(X).

% manipulated
aggression_nullified(X,S,P,T) :- expectation_realized(X,S,P,T),
	expectation_realized(manipulated,S1,S,T),
	harms(X),
	happens(svo(S1,mtrans(X,S,P),S),T1),
	T1<T,
	expectation_realized(mourned,S,P,T+1).

% victim didn't care
aggression_nullified(X,S,P,T) :- expectation_realized(X,S,P,T),
	expectation_realized(indifferent_tragedy,P,S,T),
	harms(X),
	expectation_realized(masochism,P,P,T),
	expectation_realized(mourned,S,P,T+1),
	T1<T.


% aggressor acted out of past hurt
aggression_nullified(X,S,P,T) :- expectation_realized(X,S,P,T),
	harms(X),
	expectation_realized(avengence,S,P,T).

% aggressor accident
aggression_nullified(X,S,P,T) :- expectation_realized(accidental_tragedy,S,P,T),
			harms(X),
			expectation_realized(X,S,P,T). 


% self-defence
aggression_nullified(X,S,P,T) :- expectation_realized(self_defended_murder,S,P,T),
			harms(X),
			expectation_realized(X,S,P,T).

%aggression_nullified(S,V,O,T) :-
%        sentiment(S,V,O,T,regret).

%aggression_nullified(S,V,O,T) :-
%        holds(S,manipulated,T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ROLE: bystander

role(bystander).

role_satisfied(bystander,S) :- not role_blocked(bystander,S).

role_blocked(bystander,S) :-
        happens(svo(S,V,P),T).

% TODO: blocking?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

