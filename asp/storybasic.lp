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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%
%%%% DOMAINS
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Subjects are actors in for the SVO actions
% Person is declared by the author spec, and identifies characters
% Currently, all person = subject.

#domain subject(S).
#domain subject(S1).
#domain subject(S2).
#domain subject(S3).
#domain subject(S4).

#domain person(P).

subject(P).

% An object is (not to be confused with SVO object), it's an inanimate item
% item might be a better description (might make the change in the documentation)

#domain object(O).
#domain object(O1).
#domain object(O2).

% Time points

#domain t(T).
#domain t(T1).
#domain t(T2).

% Trait is outside of time, things that don't change

#domain trait(Tr).

has_trait(P,Tr).

% Affinity is a type of attribute and that demonstrates how someone feels about a situation

#domain affinity(Af).

% Relationships indicate how people are connected

#domain relation(Re).

% Expectations are patterns of verbs that create a circumstance

#domain expectation(X).
#domain expectation(X1).
#domain expectation(X2).

% Motivation are the things people want.
% I don't know why S1 != S2

#domain motivation(M).

motivation(motiv(X,S1,S2)) :- S1 != S2.

% Attributes are qualities of people, their desires and feelings

#domain attribute(A).

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

% Fluent is something that is temporal, like a person being alive

#domain fluent(F).

fluent(attrib(P,A)).

% Verbs taken from Condeptual Dep

#domain verb(V).
#domain verb(V1).
#domain verb(V2).

% Roles

#domain role(R).

% events are: SVO

#domain event(E).

event(svo(S1,V,S2)).


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

action_satisfied(E) :- happens(E,T).

:- required_action(E), not action_satisfied(E).
:- forbidden_action(E), happens(E,T).

%% time input capable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- required_action(E,T),not happens(E,T).
:- forbidden_action(E,T), happens(E,T).

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

% feelings!!!!
{ initially(attrib(P,A)) } :- att_is(A,feeling).

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

possible(svo(S1,mtrans(motiv(X,S,P)),S2),T) :- 
       	not holds(attrib(S1,restrained),T),
	not holds(attrib(S2,restrained),T),
	not holds(attrib(S,inactive),T),
	not holds(attrib(P,inactive),T),
  not holds(attrib(S2,wants(motiv(X,S,P))),T).


initiates(svo(S1,mtrans(M),S2),attrib(S2,wants(M)),T).

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

% presentation(svo(S,V,S1),T) :- author_spec(svo(S,V,S1),T).


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



