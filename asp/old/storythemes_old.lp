

% this file contains the rulesets for complex actions and themes.
%

expectation(murdered).			% S1 kills S2
expectation(manipulated).		% S1 manips S2 to do E
%expectation(stole).			% S1 stole O from S2
expectation(regretted).			% S1 regrets doing E to S2
expectation(mourned).			% S1 mourns the loss of O/S2
expectation(rejoiced).			% S1 celebrates E
%expectation(helped).			% S1 facilitates E for S2
%expectation(revenged).			% S1 punishes S2 with E
expectation(avengence).			% S1 punishes S2 with E for S3/O
%expectation(freaked).			% S1 does E out of insanity
%expectation(misunderstood).		% S1 does E for S2 mistakenly 
%expectation(instructed).		% S1 tells S2 to do E
%expectation(intended).			% S1 decided to do E 
%expectation(unintended).		% S1 did not intend to do E
%expectation(cheated).			% S1 broke trust with S2
%expectation(informed).			% S1 told S2 about E
expectation(assaulted).			% S1 attacks S2	
%expectation(premeditated_attack).
expectation(self_defended_murder).	% S1 kills S2 in defense 
expectation(wooed).			% S1 established relationship to S2
expectation(fall_in_love).
expectation(lost_friend).
expectation(accidental_tragedy).
expectation(indifferent_tragedy).
expectation(depressed).			% S1 is depressed
expectation(masochism).			% S1 is depressed and wants to be harmed

harms(murdered).
harms(manipulated).
harms(stole).
harms(cheated).
harms(assaulted).
harms(lost_friend).

%presentation(motiv(X,S1,S2),T) :- expectation_realized(X,S1,S2,T).

expectation_realized(murdered,S1,S2,T) :- happens(svo(S1,kills,S2),T).
% knowing the properties of murdered. i did a T+1
% presentation(svo(S1,attacks(O),S2),T) :- expectation_realized(murdered,S1,S2,T),
%					 happens(svo(S1,attacks(O),S2),T-1).


% A manipulates B, if A transfers X to B before T, B performs X at T.
expectation_realized(manipulated,S1,S2,T) :- 
			happens(svo(S1,mtrans(motiv(X,S2,S3)),S2),T1),
			T1 < T,
			harms(X),
			X != manipulated,
			S1 != S2,
			expectation_realized(X,S2,S3,T).
% present manipulation
presentation(svo(S1,mtrans(motiv(X,S2,S3)),S2),T1) :-
			happens(svo(S1,mtrans(motiv(X,S2,S3)),S2),T1),
			T1 < T,
			expectation_realized(manipulated,S1,S2,T).
presentation(motiv(manipulated,S1,S2),T) :- expectation_realized(manipulated,S1,S2,T).

% assaulted
expectation_realized(assaulted,S1,S2,T) :- happens(svo(S1,attacks(O),S2),T), S1 != S2.

%self defense
expectation_realized(self_defended_murder,S1,S2,T) :- 
			expectation_realized(assaulted,S2,S1,T-1),
			expectation_realized(murdered,S1,S2,T). 

%retribution for past harm, S2 caused S1 a loss of friend
expectation_realized(avengence,S1,S2,T) :-
			expectation_realized(lost_friend,S2,S1,T1),
			T1<T,
			expectation_realized(X,S1,S2,T),
			harms(X).

presentation(motiv(avengence,S1,S2),T) :- expectation_realized(avengence,S1,S2,T).

% wooed
expectation_realized(wooed,S1,S2,T) :- 
			happens(svo(S1,ptrans(O),S2),T-1),
			obj_is(O,gift).

presentation(svo(S1,ptrans(O),S2),T-1) :- 
			happens(svo(S1,ptrans(O),S2),T-1),
                        obj_is(O,gift).

presentation(motiv(wooed,S1,S2),T) :- expectation_realized(wooed,S1,S2,T).

% lost friend - S1 murders S3. S2 is the victim of loss

expectation_realized(lost_friend,S1,S2,T) :-
			expectation_realized(mourned,S2,S3,T+1),
			happens(svo(S1,kills,S3),T),
			not holds(attrib(S2,rel(stranger,S3)),T),
			S2 != S3.
% mourning

expectation_realized(mourned,S,S2,T) :-
			happens(svo(S1,kills,S2),T-1),
			happens(svo(S,mtrans(motiv(mourned,S,S2)),S),T).

presentation(motiv(mourned,S1,S2),T) :-
			expectation_realized(mourned,S1,S2,T).

% regret

expectation_realized(regretted,S1,S2,T) :-
			expectation_realized(X,S1,S2,T1),
			harms(X),
			T1 < T,
			happens(svo(S1,mtrans(motiv(regretted,S1,S2)),S1),T).

presentation(motiv(regretted,S1,S2),T) :-
			expectation_realized(regretted,S1,S2,T).
% rejoice
expectation_realized(rejoiced,S1,S2,T) :-
			expectation_realized(X,S1,S2,T-1),
			happens(svo(S1,mtrans(motiv(rejoiced,S1,S2)),S1),T).

presentation(motiv(rejoiced,S1,S2),T) :- expectation_realized(rejoiced,S1,S2,T).

% accident

expectation_realized(accidental_tragedy,S1,S2,T) :-
			expectation_realized(mourned,S1,S2,T),
			expectation_realized(regretted,S1,S2,T),
			happens(svo(S1,mtrans(motiv(accidental_tragedy,S1,S2)),S1),T).

presentation(motiv(accidental_tragedy,S1,S2),T) :- expectation_realized(accidental_tragedy,S1,S2,T).

% indifferent if S1 wanted harm to happen to himself

expectation_realized(indifferent_tragedy,S1,S2,T) :-
			holds(attrib(S1,wants(motiv(X,S,S1))),T1),
			T1 < T,
		        harms(X),
		        expectation_realized(X,S2,S1,T),
			happens(svo(S1,mtrans(motiv(indifferent_tragedy,S,S1)),S1),T).

presentation(attrib(S1,wants(motiv(X,S2,S1))),T) :- 
			expectation_realized(indifferent_tragedy,S1,S2,T),
			expectation_realized(X,S2,S1,T),
			harms(X).
			
% S is depressed and wants bad things to happen to himself

%expectation_realized(depressed,S,S,T) :-
%			initiated(attrib(S,unhappy),T),
%			harm_nullified(X,P,S,T1),
%			T1>T.

expectation_realized(depressed,S,S,T) :-
			happens(svo(S,mtrans(motiv(murdered,P,S)),P),T).

presentation(motiv(depressed,S,S),T) :- expectation_realized(depressed,S,S,T),
			harm_nullified(X,P,S,T1),
			T1>T.

% S is depressed and wants bad things to happen to himself

expectation_realized(masochism,S1,S2,T) :-
			expectation_realized(X,S2,S1,T),
			harms(X),
			expectation_realized(depressed,S1,S1,T1),
			T1<T.

presentation(motiv(masochism,S1,S2),T) :- expectation_realized(masochism,S1,S2,T).


% self defended murder

expectation_realized(self_defended_murder,S,P,T) :- expectation_realized(murdered,S,P,T),
			expectation_realized(assaulted,P,S,T).

presentation(svo(S,attacks(O),P),T) :- happens(svo(S,attacks(O),P),T),
			expectation_realized(self_defended_murder,P,S,T).

presentation(motiv(self_defended_murder,S,P,T),T) :- expectation_realized(self_defended_murder,S,P,T).

			

% MOTIVATION

%:- expectation_realized(X,S1,S2,T), not holds(attrib(S1,wants(motiv(X,S1,S2))),T).


%story(assasin_story) :- expectation_realized(paid_assasination(S1,S2,S3),T), S1 != S3.
%story(murder_story) :- expectation_realized(murder(S1,S2),T), S1 != S2.
%story(suicide_story) :- expectation_realized(suicide(S),T).
%story(sibling_story) :- is_related(sibling,S1,S2),S1!=S2.

%story(avenge_story) :- expectation

%
%expectation(selling(S1,O,S2)) :- S1 != S2.
%expectation(premeditated_attack(S1,S2)) :- S1 != S2.
%expectation(counter_attack(S1,S2)) :- S1 != S2.
%expectation(murder(S1,S2)) :- S1 != S2. 
%expectation(suicide(S)).
%%expectation(avenged_death(S1,S2,S3)) :- S1 != S2
%
%% MURDER
%expectation_realized( murder(S1,S2) ,T) :-
%	happens(svo(S1,kills,S2),T).
%
%% SUICIDE
%expectation_realized( suicide(S) ,T) :-
%	happens(svo(S,kills,S),T).
%
%% SELLING - selling is transferring one object in exchange for money
%expectation_realized( selling(S1,O,S2) ,T) :-
%        has_trait(S1,vendor),
%        happens(svo(S1,ptrans(O),S2),T),
%        happens(svo(S2,ptrans(O1),S1),T),
%  	obj_is(O1,money),
%	not obj_is(O,money).
%
%% PREMED ATTACK
%expectation_realized( premeditated_attack(S1,S2), T2) :-
%        happens(svo(S1,propel(O),S2),T2),
%        expectation_realized(selling(S3,O,S1), T1),
%        T1 < T2.
%
%% PAID ASSAS
%expectation_realized( paid_assasination(S1,S2,S3), T2) :-
%        expectation_realized(premeditated_attack(S2,S3),T2),
%        happens(svo(S1,ptrans(O1),S2),T1),
%	obj_is(O1,money),
%        T1 < T2.
%
%% COUNTER ATTACK
%expectation_realized( counter_attack(S1,S2), T2 ) :-
%        happens(svo(S1,propel(O1),S2), T1),
%        happens(svo(S2,propel(O2),S1), T2),
%        T2 = T1+1.
%
%
