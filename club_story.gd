extends RefCounted

# The Ophion Club House — Facts, Intertitles, and Dialogue Cards.
# Consistent with Design Bible v13 and the short story "No Exit Wound".

const FACTS = {
	"seventh_place": [
		"A SEVENTH PLACE",
		"The steward laid seven place settings on the last Thursday of every month. Only six men ever arrived. The seventh chair remained empty, by standing instruction.",
		"Ophion Club · banquet table linens"
	],
	"barman_her": [
		"TENDERLY, OF HER",
		"The club barman recalls the six men changing their manner toward the end. They stopped speaking of fortune and influence. They spoke, with quiet devotion, of a mother who would have them home.",
		"Ophion Club · barman's statement"
	],
	"fenn_book": [
		"OPHION DISPLACED",
		"An underlined passage in Dr. Fenn's private library: Ophion was a primordial serpent-power cast down, not destroyed. The founders named their ship for an ancient vanity; later men mistook the vanity for a prophecy.",
		"Dr. Fenn's private library · underlined volume"
	],
	"observers_discipline": [
		"THE UNHURRIED BERTH",
		"The harbor-side crew work the estate grounds with flat, unbothered competence, giving the kitchen service door a wide thirty-foot berth. A plain ring on a laborer's hand catches impossible color in the gray air.",
		"Estate service corridor · window observation"
	],
	"pantry_stair": [
		"BEHIND THE CRATES",
		"Behind a stack of pre-war gin crates in the boarded pantry, a narrow doorway stands open upon a stone stair descending into solid rock, where no cellar appears on the club's architectural blueprints.",
		"Ophion Club · service pantry"
	]
}

const ARRIVAL = [
	["THE OPHION CLUB", "The private society of Widow's Bight.\n\nFounded on the insurance payout of a vanished fleet.\nIts members died in the rose garden outside."],
	["A CLOSED HOUSE", "The morning after the killings, the doors remain unlocked to the investigation.\n\nThe staff are still inside.\nThe habits of thirty years do not stop in a night."]
]

const SCENES = {
	"steward_badge": [
		["THE CLUB STEWARD", "Officer Corwin.\nWe are assisting the captain in every official inquiry."],
		["WALTER CORWIN", "I have questions about the membership."],
		["THE CLUB STEWARD", "The roster is with Captain Odell.\nSix gentlemen, as the town already knows."]
	],
	"steward_linens": [
		["THE BANQUET TABLE", "Seven place settings laid with heavy silver.\nWalter checks the chairs. Seven chairs."],
		["WALTER CORWIN", "Who sits at the head?"],
		["THE CLUB STEWARD", "Judge Wexford, usually. Dr. Fenn to his right."],
		["WALTER CORWIN", "And the seventh setting?"],
		["THE CLUB STEWARD", "A standing instruction, Officer.\nAlways laid. Never occupied.\n\nIt was not my place to inquire why a gentleman leaves an empty chair."]
	],
	"barman_badge": [
		["THE BARMAN", "Good morning, Officer Corwin.\nCan I pour you something on duty?"],
		["WALTER CORWIN", "I'm looking into the monthly meetings."],
		["THE BARMAN", "Last Thursday of the month, Officer.\nRegular as church bells.\n\nThey drank Scotch, talked civic business, and settled up by midnight."]
	],
	"barman_plain": [
		["THE BARMAN", "You're out of uniform, Corwin.\nTake a stool at the far end."],
		["WALTER CORWIN", "The captain says it was an accident."],
		["THE BARMAN", "The captain wasn't here at three in the morning when they shut the doors.\n\nThey changed, Walter. These past six months.\nKessler used to come in talking about cattle prices and shop leases. By winter, he sat in that corner and barely took a glass."],
		["WALTER CORWIN", "What changed them?"],
		["THE BARMAN", "They stopped speaking of power, toward the end.\nThey started speaking, tenderly, of Her."]
	],
	"barman_mother": [
		["THE BARMAN", "SHE'LL HAVE US HOME, Kessler said to Fenn right here at the wood.\nSHE'S NO DIFFERENT FROM ANY MOTHER."],
		["WALTER CORWIN", "Did they name her?"],
		["THE BARMAN", "Never once. Just 'Her.' Spoke about her like boys waiting for a lamp in the hall.\n\nKessler brought a parcel wrapped in butcher paper once. Took it into the private wing and came out empty-handed."],
		["WALTER'S NOTEBOOK", "Six powerful men kneeling before a maternal idea.\nA delusion dressing itself in devotion."]
	],
	"barman_pantry_tip": [
		["THE BARMAN", "There's gin left from before the war.\nBehind the old pantry door in the kitchen wing."],
		["WALTER CORWIN", "Why tell me?"],
		["THE BARMAN", "Because nobody goes back there, Walter.\nNobody's gone back there in years.\n\nIf you're going to look, don't look in uniform."]
	],
	"fenn_library": [
		["DR. FENN'S STUDY", "A locked room. Walter slips past the steward's station while the corridor is empty.\n\nShelves of pathology, marine biology, and classical antiquities."],
		["THE OPEN VOLUME", "A book on Aegean cosmogony, left open on the desk beside an inkwell."],
		["UNDERLINED PASSAGE", "OPHION — A serpent-power of the old cosmogony, said to have ruled before the younger gods cast him down. Not slain. Displaced."],
		["FENN'S HANDWRITING", "In the margin, Fenn had penciled: 'They believed —'\n\nThe sentence was left unfinished."],
		["WALTER'S NOTEBOOK", "The ship was named by an educated merchant quoting Latin over a door.\nDecades later, guilty men decided the name had always meant something."]
	],
	"observers_window": [
		["THE KITCHEN WINDOW", "Through the glass, Walter watches three groundskeepers working the rose hedge along the kitchen wall."],
		["THE DISCIPLINE", "None of them look toward the service door. When a shovel clangs against stone, none of them startle or glance up."],
		["WALTER CORWIN", "They give the corner thirty feet of clean ground.\nNot out of fear. Out of habit."],
		["THE RING", "A young laborer straightens for half a second. A plain ring on his hand catches impossible color against the grey morning, then vanishes back into the damp."],
		["WALTER'S NOTEBOOK", "The people who work this ground know where not to walk.\nA discipline learned long before this investigation began."]
	],
	"pantry_entrance": [
		["THE SERVICE PANTRY", "Behind the kitchen stoves, past a door that had been boarded and never properly unboarded.\n\nDust, cobwebs, crates of gin gone amber with years."],
		["BEHIND THE CRATES", "Walter moves a wooden crate aside.\n\nWhere the exterior stone foundation should be, a narrow door stands ajar by two inches."],
		["THE DESCENT", "Twenty worked stone steps lead down into darkness.\nBeyond them, the stair ceases to be masonry and becomes cut rock."],
		["WALTER'S NOTEBOOK", "A corridor running beneath the earth in a direction no cellar should go.\nWater is breathing somewhere far below."]
	]
}
