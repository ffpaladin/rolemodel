% http://potassco.sourceforge.net/
% this file contains the rulesets for
%     -event calclulas
%     -abducibles
%     -atomic actions
%     -...all other story/character traits
%     -domain variables
%     -#hide and #show
%     -#const
%     -integrity constraints  


%%%%
%%%% DOMAINS
%%%%

#domain subject(S).
#domain subject(S1).
#domain subject(S2).
#domain subject(S3).
#domain subject(S4).
#domain person(P).
#domain object(O).
#domain object(O1).
#domain object(O2).
#domain fluent(F).
#domain t(T).
#domain t(T1).
#domain trait(Tr).
#domain attribute(A).
#domain verb(V).
#domain verb(V1).
#domain verb(V2).
#domain affinity(Af).
#domain relation(Re).
#domain expectation(X).
#domain expectation(X1).
#domain expectation(X2).
#domain role(R).
#domain event(E).
#domain motivation(M).
#domain desires(D).

motivation(motiv(X,S1,S2)) :- S1 != S2.
subject(P).
fluent(attrib(P,A)).
event(svo(S1,V,S2)).
attribute(aff(Af,S)).
attribute(rel(Re,S)).
attribute(wants(M)).
attribute(carries(O)).
attribute(alive).
attribute(restrained).
attribute(unhappy).
attribute(inactive).
attribute(happy).
attribute(inlove).
attribute(crazy).


att_type(feeling).
att_is(unhappy;happy;inlove;crazy,feeling).

desires(love).
desires(selfish).
desires(crazy).
% this needs to change
has_trait(P,Tr).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%
%%%% POSSIBILITY INTEGRITY CONSTRAINTS
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- happens(E,T), not possible(E,T).

% each person can only do one thing at a time
:- 2 { happens(svo(S,Ve,Su),T):verb(Ve):subject(Su) }.

% each object can only be carried by one person at a time
:- 2 { initially(attrib(Su,carries(O))):subject(Su) }.

% one thing happen at a time
%1 { happens(svo(S,Ve,Su),T):subject(S):verb(Ve):subject(Su) } 1.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Presentation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- author_spec(attrib(P,A),T), not holds(attrib(P,A),T).

:- author_spec(svo(S1,V,S2),T), not happens(svo(S1,V,S2),T). 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% REQUIRE AND FORBID 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- required_role(R,P), not role_satisfied(R,P).
:- forbidden_role(R,P), role_satisfied(R,P).

%% expectations

:- required_expectation(X,S1,S2,T), not expectation_realized(X,S1,S2,T).
:- forbidden_expectation(X,S1,S2,T), expectation_realized(X,S1,S2,T).

%% story

%:- required_story(St), not story(St).
%:- forbidden_story(St), story(St).


action_satisfied(E) :- happens(E,T).

:- required_action(E), not action_satisfied(E).
:- forbidden_action(E), happens(E,T).

%% time input capable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- required_action(E,T),not happens(E,T).
:- forbidden_action(E,T), happens(E,T).

%% partial order capable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% NOT WORKING

%action_satisfied_PO(E,PO) :- happens(E,T).
										 
%:-  happens(S1,V,O,T), outoforder(S1,S2).
		
%outoforder(S1,S2) :- required_partialorder(S1,V1,O1,PO1), 
%		required_partialorder(S2,V2,O2,PO2), 
%		happens(S1,V1,O1,T1), happens(S2,V2,O2,T2), PO1 < PO2, T1 > T2.
					 
%:- required_partialorder(S,V,O,PO), not action_satisfied_PO(S,V,O,PO).
%:- forbidden_partialorder(S,V,O,PO), action_satisfied_PO(S,V,O,PO).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PLAYERS ON THE STAGE %%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



1 {on_stage(Su,T):subject(Su) } 2 :- t(T).

:- happens(svo(S,V,P),T),  
	not on_stage(S,T). % actor must be on stage

:- happens(svo(S,V,S2),T),  
	not on_stage(S2,T). % if object is a person, they must be on stage also


:- happens(svo(S,V,S1),T), holds(attrib(S,inactive),T).

:- happens(svo(S,V,S1),T), holds(attrib(S1,inactive),T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%
%%%% TIMEPOINTS

%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#const t_max=8.
t(0..t_max).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%
%%%% GENERATION ABDUCIBLES
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



{ happens(Ev,T):event(Ev) }  :- T<t_max.

% assign inventory
{ initially(attrib(P,carries(O))) }.

% relationships are assigned in the begining (like inventory)
% any pair of subjects can have any combination of relationships (including all)
% there must be at least 1

% Relationships are going on the back burner
% 1 { is_related(Re,S1,S2):relationship(Re) } 1 :- subject(S1;S2), S1!=S2.

% a desire is a timeless motivation 

{ desires(S,D) } :- desire(D).

{ has_trait(Tr,P) } :- trait(Tr).

% feelings!!!!
{ initially(attrib(P,A)) } :- att_is(A,feeling).

%{ sentiment(S,V,O,T,Fe):feeling(Fe) } 1 :- happens(S,V,O,T).
%{ context(S,V,O,T,D) } :- contextualizes(D,V), happens(S,V,O,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%
%%%% OBJECTS
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obj_type(weapon).
obj_type(projectile).
obj_type(money).
obj_type(gift).

obj_is(cash1,money).
obj_is(cash2,money).

obj_is(sword;knife;gun,weapon).

obj_is(apple;flowers,gift).

object(sword).
object(apple).
object(cash1).
object(cash2).
object(knife).
object(flowers).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%
%%%% VERBS
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trait(vendor).

verb(ptrans(O)).
verb(propel(O)).
verb(attacks(O)).
verb(kills).
verb(mtrans(M)).  % transfer expectation to be performed
verb(idle).

possible(svo(S,idle,S),T).


% Mental Transfers: MTRANS

possible(svo(S1,mtrans(motiv(X,S,P)),S2),T) :- not holds(attrib(S2,wants(motiv(X,S,P))),T),
       	not holds(attrib(S1,restrained),T),
	not holds(attrib(S2,restrained),T),
	not holds(attrib(S,inactive),T),
	not holds(attrib(P,inactive),T).


initiates(svo(S1,mtrans(M),S2),attrib(S2,wants(M)),T).



% A PERSON STIRS DESIRES
%possible(svo(S,mtrans(M),S),T) :- not holds(attrib(S2,wants(M)),T).
			

%initiates(svo(S1,mtrans(M),S2),attrib(S2,wants(M)),T).

% PROPEL and TRANSFER
% do not give away a gift
possible(svo(S1,ptrans(O),S2),T) :- 
	holds(attrib(S1,carries(O)),T), S1 != S2,
	not holds(attrib(S1,restrained),T),
	not holds(attrib(S2,restrained),T),
	not regifted(O,T).

regifted(O,T) :- holds(attrib(S1,carries(O)),T),
	happens(svo(S,ptrans(O),S1),T1),
	T1<T.

possible(svo(S1,propel(O),S2),T) :- 
	holds(attrib(S1,carries(O)),T), S1 != S2,
	not holds(attrib(S1,restrained),T),
	not holds(attrib(S2,restrained),T).

initiates(svo(S1,ptrans(O),S2),attrib(S2,carries(O)),T).
terminates(svo(S1,ptrans(O),S2),attrib(S1,carries(O)),T).

terminates(svo(S1,propel(O),S2),attrib(S1,carries(O)),T).

% AttackS
possible(svo(S,attacks(O),P),T) :-
	obj_is(O,weapon),
	holds(attrib(S,carries(O)),T),
	holds(attrib(S,alive),T),	
	holds(attrib(P,alive),T),
	not holds(attrib(S,restrained),T).

% KILLS
possible(svo(S,kills,P),T) :-
        holds(attrib(S,alive),T),
        holds(attrib(P,alive),T),
        not holds(attrib(S,restrained),T),
	happens(svo(S,attacks(O),P),T-1).

terminates(svo(S1,kills,S2),attrib(S2,alive),T).
initiates(svo(S1,kills,S2),attrib(S2,restrained),T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%
%%%% ATTRIBUTES
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% INITIALIZATION
% everyone lives! and everyone is a stranger
initially(attrib(P,alive)).
initially(attrib(S1,rel(stranger,S2))):-S1!=S2.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Relationships
% these are all grounded to appropriate actions 
% and accessed when trying to choose a motivation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


affinity(likes).
affinity(hates).
affinity(loves).
affinity(indifferent).

% hating someone who kills someone you like 

%initiates(svo(S1,kills,S2),attrib(S3,aff(hates,S1)),T) :- 
%	holds(attrib(S3,aff(likes,S2)),T).


% New Relationships


relation(couple).
relation(acquaintance).
relation(stranger).
relation(brother).


% show brotherhood
 
initially(attrib(S1,rel(brother,S2))) :- 
		author_spec(attrib(S1,rel(brother,S2)),T),
		S1!=S2.
initially(attrib(S2,rel(brother,S1))) :-
                author_spec(attrib(S1,rel(brother,S2)),T),
		S1!=S2.

% meeting someone

initiated(attrib(S1,rel(acquaintance,S2)),T) :- 
		author_spec(attrib(S1,rel(acquaintance,S2)),T+1),
		S1!=S2.

initiated(attrib(S2,rel(acquaintance,S1)),T) :-
                author_spec(attrib(S1,rel(acquaintance,S2)),T+1),
		S1!=S2.

% becoming a couple

initiated(attrib(S1,rel(couple,S2)),T) :-
                author_spec(attrib(S1,rel(couple,S2)),T+1).
initiated(attrib(S2,rel(couple,S1)),T) :-
               author_spec(attrib(S1,rel(couple,S2)),T+1).
required_expectation(wooed,S1,S2,T) :- author_spec(attrib(S1,rel(couple,S2)),T).

% if at time T you have a relationship that nots stranger, terminate stranger

terminated(attrib(S1,rel(stranger,S2)),T) :- holds(attrib(S1,rel(stranger,S2)),T), 
					holds(attrib(S1,rel(Re,S2)),T),
					Re!=stranger.
terminated(attrib(S,inactive),T-1) :- author_spec(svo(S,introduces,S),T).


initiated(attrib(S,unhappy),T-1) :- author_spec(attrib(S,unhappy),T).

presentation(attrib(S,A),T) :- author_spec(attrib(S,A),T).
presentation(svo(S,V,S1),T) :- author_spec(svo(S,V,S1),T).


% Old Relationships -----------

% you like your friends
% initially(attrib(S1,aff(likes,S2))) :- is_related(friend,S1,S2).

% indifferent

%holds(attrib(S1,aff(indifferent,S2)),T) :- not existing_affinity(S1,S2,T).

% existing_affinity(S1,S2,T) :-  
%	holds(attrib(S1,aff(Af,S2)),T), subject(S1;S2), t(T),  Af != indifferent.


%relationship(parent).
%relationship(child).

%relationship(sibling).
%relationship(spouse).

%relationship(mentor).

%relationship(stranger).
%relationship(friend).

% a child cannot be a parent to its parent 
%:- is_related(parent,S1,S2), is_related(parent,S2,S1). 
%:- is_related(mentor,S1,S2), is_related(mentor,S2,S1).

% you cannot mentor your mentor's mentor
%:- is_related(mentor,S1,S2), is_related(mentor,S2,S3), is_related(mentor,S3,S1).

% you cannot be married to your parent or child or sibling or stranger
%:- is_related(parent,S1,S2), is_related(spouse,S1,S2).
%:- is_related(parent,S1,S2), is_related(spouse,S2,S1).
%:- is_related(sibling,S1,S2), is_related(spouse,S1,S2).

% child only exists when parent exists
%:- is_related(child,S1,S2), not is_related(parent,S2,S1).

% you can only marry one person.
%:- is_related(spouse,S1,S2), is_related(spouse,S1,S3), S2!=S3.

% reflexive properties
%:- is_related(spouse,S1,S2), not is_related(spouse,S2,S1).
%:- is_related(sibling,S1,S2), not is_related(sibling,S2,S1).
%:- is_related(friend,S1,S2), not is_related(friend,S2,S1).
%:- is_related(stranger,S1,S2), not is_related(stranger,S2,S1).

% siblings have the same parent
%is_related(sibling,S1,S2) :- is_related(parent,S3,S1), is_related(parent,S3,S2), S1!=S2.

% you are the parent of your spouses children
%is_related(parent,S1,S2) :- is_related(parent,S3,S2), is_related(spouse,S1,S3).
%is_related(spouse,S1,S2) :- is_related(parent,S1,S3), is_related(parent,S2,S3).

% you can't be friends with someone you have one or more other relationships with
%:- is_related(friend,S1,S2), 1 { is_related(Re,S1,S2):relationship(Re):Re!=friend }.

% you can't be a stranger with someone you have one or more other relationships with
%:- is_related(stranger,S1,S2), 1 { is_related(Re,S1,S2):relationship(Re):Re!=stranger }.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%
%%%% MAKING SENSE // MOTIVATION
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% every event must be motivated

% motivations include: 
% (1) affinity for another
% (2) wants to be liked/loved
% (3) wants an object

%desire(like_of(S)).
%desire(love_of(S)).
%desire(have(O)).

% no event can happen if it is not motivated
%:- happens(E,T), not motivated(E,M,T).


% no expectations can happen unmotivated
%:- motivated(svo(S1,V,S2), 

% any verb is motivated, if it is part of an expectation
%motivated(svo(S1,V,S2),M,T) :- 

%expectation(selling(S1,O,S2)) :- S1 != S2.
%expectation(premeditated_attack(S1,S2)) :- S1 != S2.
%expectation(counter_attack(S1,S2)) :- S1 != S2.
%expectation(murder(S1,S2)) :- S1 != S2.
%expectation(suicide(S)).


% reasons to kill

% you desire what they have
%motivated(svo(S1,kills,S2),have(O),T) :- desires(S1,have(O)), 
%	holds(attrib(S2,carries(O)),T).

%motivated(svo(S1,kills,S2),love_of(S3),T) :- desires(S1,love_of(S3)), 
%					is_related(spouse,S3,S2).

% reason to transfer, b/c of selling
%motivated(svo(S1,ptrans(O),S2),selling,T) :- expectation_realized(selling(S1,O,S2),T).

% reason to transer $$, b/c of selling
%motivated(svo(S1,ptrans(O),S2),buying,T) :- expectation_realized(selling(S2,O1,S1),T), 
%						obj_is(money,O).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%
%%%% DISPLAY STUFF
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#hide.

#show presentation(_,T).
%#show required_story(St).
#show expectation_realized(X,S1,S2,T).
#show happens(E,T).
%#show forbidden_story(St).
#show aggression_nullified(X,S,P,T).
#show harm_nullified(_,_,_,_).
%#show required_action(E).
%#show on_stage(S,T).
%#show forbidden_action(E,T).
#show role_satisfied(R,P).
%#show required_action(E,T).
%#show author_spec(_,T).

%#show required_expectation(Ex).
%#show is_related(Re,S1,S2).
%#show person(P).
%#show initially(F).
%#show holds(attrib(P,restrained),T).
%#show forbidden_expectation(Ex).
%#show forbidden_action(E).
%#show possible(svo(S,V,S1),T).
%#show attribute(A).
%#show verb(V).
%#show t(T).
%#show role(R).
%#show motivated(E,M,T).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
%%% EVENT CALCULUS
%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


initiated(F,T) :-
	happens(E,T),
	initiates(E,F,T).

terminated(F,T) :-
	happens(E,T),
	terminates(E,F,T).

holds(F,T+1) :-
	holds(F,T),
	not terminated(F,T).

-holds(F,T+1) :-
	-holds(F,T),
	not initiated(F,T).

holds(F,T+1) :-
	initiated(F,T).

-holds(F,T+1) :-
	terminated(F,T).

holds(F,0) :- initially(F).
-holds(F,0) :- not initially(F).





%%%
%%%
%% motivation idea
% expectation_realized( motivated(E), T) :-
% 	holds(intends(S,attrib(O2,A)),T),
% 	happens(svo(S,V,O1),T),
% 	initiates(svo(S,V,O1),attrib(O2,A),T).



