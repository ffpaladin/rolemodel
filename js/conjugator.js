/* 
 * @param string	verb: the verb to be conjugated
 * @param string	tense: the tense
 * @param int 		person: (1)st person, (2)nd person, (3)rd person
 * @param bool 		plural: whether the subject is plural or not
 */
function conjugate(verb, tense, person, plural){
	switch(tense){
	case "present":
		//singular
		if(!plural){
			switch(person){
			case 1:
				return (verb); 
				break;
			case 2:
				return (verb);
				break;
			case 3:
				return (verb + "s");
				break;
			}
		}
		//plural
		else{
			switch(person){
			case 1:
				return (verb); 
				break;
			case 2:
				return (verb);
				break;
			case 3:
				return (verb);
				break;
			}
		}
	break;
	}
};