var al = {
	name: "Al",
	myself: "himself",
	pronoun: "He",
	posessive: "his",
	object: "him"
	};
	
var parry = {
	name: "Parry",
	myself: "himself",
	pronoun: "He",
	posessive: "his",
	object: "him"
	};
	
var eliza = {
	name: "Eliza",
	myself: "herself",
	pronoun: "She",
	posessive: "her",
	object: "her"
	};

var manipulated = {
	present: "manipulate",
	past: "had manipulated"};

var depressed = {
	present: "is deeply depressed about",
	past: "had become depressed about"};

var couple = "fell in love and became a couple";
var acquaintance = "became acquaintances";
var apple = "apples";

var wooed = {
	present: "won the affections of",
	past: "had won the affections of"};

var rejoiced = {
	present: "is glad about what happened to",
	past: "was glad about what happened to"};

var unhappy = "unhappy";

var indifferent_tragedy = {
	present: "not care what happened to",
	past: "not cared what happened to"};

var lost_friend = {
	past: "caused this great loss for",
	present: "cause this great loss for",
	};

var mourned = {
	present: "grieve the loss of",
	past: "grieved the loss of"};

var murdered = {
	present: "murder",
	past: "murdered"};

var kills = "kills";
var flowers = "flowers";
var brother = "are brothers";
var assaulted = {
	present: "pick a fight with",
	past: "picked a fight with"};

var regretted = {
	present: "show great remorse for what happened to",
	past: "showed great remorse for what happened to"};

var masochism = {
	present: "feel deserving of the treatment from",
	past: "felt deserving of the treatment from"};

var self_defended_murder = {
	present: "kill in self defense against",
	past: "killed in self defense against"};

var sword = "sword";
var knife = "knife";

var captions = new Array();

// transitions per page
var trans = new Array();

trans[0] = "Once upon a time...";
trans[1] = "It was the case that ";
trans[2] = "One day, ";
trans[3] = "Then, ";
trans[4] = "For whatever reason, ";
trans[5] = "It seemed that ";
trans[6] = "As a result, ";
trans[7] = "In the end, ";
trans[8] = "";

// Mo Objects less Strings

function presentation(s, index){
	
	var c = captions[index];

	if(c == undefined){
		c = captions[index] = new Array();
		c.text = trans[index] + s + ". ";
	}
	// if the subj is repeated, the replace with pronoun
	else if (c[c.length-1].subj === s.subj){
		c.text += (s.str.replace(s.subj.name,s.subj.pronoun) + ". ");		
	}
	else{
		c.text += s + ". ";
	}
	
	c.push(s);

	return index;
}


function setstr(o,s)
{
	o.str = s ;
	o.toString = function() { return this.str; }
	return o;
}


// TOP LEVEL SENTENCES MODIFIERS: svo, attib, and motiv

function svo(s, v, o){
	var x = {subj:s};
	var sent;

	switch (v.type)
	{
	case "attacks":
       		return setstr(x,s.name + " " + v.type + " " + o.name + " with a " + v.w);
	case "mtrans":
		if (o === v.o.p)	// if you convince someone to do something themself
			sent = s.name + " convinced " + o.name + " to " + v.o.a.present + " ";
		else
			sent = s.name + " convinced " + o.name + " to " + v.o;
		
		
		if (s === v.o.r)	// if you convince someone to do something to you
			sent += v.o.r.object;
		else
			sent += v.o.r.name;

		return setstr(x,sent);
	default:	
		return setstr(x,s.name + " " + v + " " + o.name);
	}
}
 
function attrib(subject, attribute){
	
	var x = {subj:subject};
	
	var sent;

	if (typeof attribute !== 'string')
	{	
		
		// if attribute is a relationship
		if (attribute.type === "rel") 
			if (attribute.p === subject)	// someone in a relationship with themself
				return setstr(x, subject.name +
				" and " + subject.obj + " " + attribute.rel);
			else
				return setstr(x,subject.name + " " + attribute);
		
		
		// else it is a held motivation
		else if (attribute.type === "motiv")
			if (attribute.r === subject)   // someone does something to themself
				return setstr(x,subject.name + " " + attribute.r.obj);
			else
				return setstr(x,subject.name + " " + attribute);

		// else it is a want
		else if (attribute.type === "wants") {
			sent = subject.name + " " + attribute.motive.a.present + attribute.motive.r.name;
			
			if (attribute.motive.r === subject) // someone wants something on themself
				 sent = subject.name + " wanted " + attribute.motive.p.name + " to " +
				 			attribute.motive.a.present + " " + attribute.motive.r.object;
                        if (attribute.motive.p === subject)
			{
				var re = RegExp(subject.name,"g");
        			sent = subject.name + sent.replace(re,"");
				sent = sent.replace(subject.object,subject.myself);	
			}
       		        
			return setstr(x,sent);
		}

      	}
	else
      	{
		// attribute is just a single word
		return setstr(x,subject.name + " was " + attribute);
	}
}


function motiv(act, actor, recipient){
      	
	var obj = {	subj:actor, 
			p: actor,
			a: act,
			r: recipient,
			type: "motiv"};

      	if (actor === recipient)
		return setstr(obj,actor.name + " " + act.past + " " + actor.myself);
		
	else 
      		return setstr(obj,actor.name + " " + act.past + " " + recipient.name);
	
}

// SECONDARY: includes motiv (motiv has 2 uses)

function rel(relationship, person){

	return setstr(	{type: "rel", 
				rel: relationship,
				p: person}, " and " + person.name + " " + relationship);
}


function attacks(weapon){
	var obj = {
		type: "attacks",
		w: weapon,
	};

	return setstr(obj, "attacked with a " + weapon + " at");
}

function ptrans(object){
	var obj = {o: object,
		type: "ptrans"};

	setstr(obj,"gave " + object + " to");

	return obj;
}

function mtrans(object){
	var obj = {o: object,
		type: "mtrans"};

	setstr(obj,"told " + object + " to");

	return obj;
}


function wants(object){
	
	var obj = {};

	obj.motive = object;
	obj.type = "wants";

	if (typeof object === 'string')
		setstr(obj, "desired to have " + object) ;
	else
		setstr(obj, "desired that " + object + " would happen");

	return obj;
}
