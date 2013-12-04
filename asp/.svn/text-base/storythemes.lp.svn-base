% this file contains the rulesets for complex actions and themes.


story(assasin_story) :- expectation_realized(paid_assasination(S1,S2,S3),T), S1 != S3.
story(murder_story) :- expectation_realized(murder(S1,S2),T), S1 != S2.
story(suicide_story) :- expectation_realized(suicide(S),T).
story(sibling_story) :- is_related(sibling,S1,S2),S1!=S2.

%story(avenge_story) :- expectation


expectation(selling(S1,O,S2)) :- S1 != S2.
expectation(premeditated_attack(S1,S2)) :- S1 != S2.
expectation(counter_attack(S1,S2)) :- S1 != S2.
expectation(murder(S1,S2)) :- S1 != S2. 
expectation(suicide(S)).
%expectation(avenged_death(S1,S2,S3)) :- S1 != S2

% MURDER
expectation_realized( murder(S1,S2) ,T) :-
	happens(svo(S1,kills,S2),T).

% SUICIDE
expectation_realized( suicide(S) ,T) :-
	happens(svo(S,kills,S),T).

% SELLING - selling is transferring one object in exchange for money
expectation_realized( selling(S1,O,S2) ,T) :-
        has_trait(S1,vendor),
        happens(svo(S1,ptrans(O),S2),T),
        happens(svo(S2,ptrans(O1),S1),T),
  	obj_is(O1,money),
	not obj_is(O,money).

% PREMED ATTACK
expectation_realized( premeditated_attack(S1,S2), T2) :-
        happens(svo(S1,propel(O),S2),T2),
        expectation_realized(selling(S3,O,S1), T1),
        T1 < T2.

% PAID ASSAS
expectation_realized( paid_assasination(S1,S2,S3), T2) :-
        expectation_realized(premeditated_attack(S2,S3),T2),
        happens(svo(S1,ptrans(O1),S2),T1),
	obj_is(O1,money),
        T1 < T2.

% COUNTER ATTACK
expectation_realized( counter_attack(S1,S2), T2 ) :-
        happens(svo(S1,propel(O1),S2), T1),
        happens(svo(S2,propel(O2),S1), T2),
        T2 = T1+1.


