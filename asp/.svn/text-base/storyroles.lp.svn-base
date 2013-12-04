% this file contains the rules for roles and nullifiers

%%%%
%%%% ROLES
%%%%

has_role(R,P) :-
        role_satisfied(R,P),
        not role_blocked(R,P).

:- required_role(R,P), not has_role(R,P).
:- forbidden_role(R,P), has_role(R,P).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ROLE: victim (gets harmed)
role(victim).

role_satisfied(victim,P) :-
        harms(V),
        happens(svo(S,V,P),T),
        not harm_nullified(svo(S,V,P),T).

%harm_nullified(S,V,O,T) :-
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
        harms(V),
        happens(svo(S,V,P),T),
        not aggression_nullified(svo(S,V,P),T).

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

