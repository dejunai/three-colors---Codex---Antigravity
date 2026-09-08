extends RefCounted

# Narrative scenes and factual observations for Chapter One Slice III: The Subterranean Descent.
# In accordance with Design Bible v13 and the 14 Design Laws:
# - Unreliable presentation / honest facts
# - Zero morality scoring
# - Permanent local victories and honest stats

const FACTS = {
	"corroded_whistle": [
		"CORRODED WHISTLE",
		"A municipal police whistle half-buried in salt silt. The stamped badge number belongs to Patrolman Thomas, who vanished from the harbor beat in November 1918.",
		"Subterranean passage · silt alcove"
	],
	"impossible_strata": [
		"IMPOSSIBLE STRATA",
		"The granite bedding dips at conflicting angles along the fracture lines. Light reflects in cold violet-blue along surfaces that do not conform to coastal geology.",
		"Central fissure · mineral observation"
	],
	"lost_flask": [
		"THE GROUND TOOK IT",
		"The pewter flask tore loose along the fissure ledge and fell into the black water below. Nothing about its contents betrayed Walter; the ground simply took it.",
		"Rock ledge · dropped personal effect"
	],
	"silver_needles": [
		"HOLLOW SILVER IMPLEMENTS",
		"Six slender silver probes with bulb reservoirs resting in a stone niche. The tip caliber matches the wound above the bridge of the nose on each man in the rose garden.",
		"Sea-gate chamber · carved plinth"
	],
	"sea_gate": [
		"THE SUBTERRANEAN BERTH",
		"A natural sea-arch reinforced with dry-fitted cyclopean stone, opening directly onto the Atlantic surf beneath the estate cliffs. Built before the town's founding.",
		"Sea-cave basin · architectural examination"
	]
}

const SCENES = {
	"stair_return": [
		["THE PANTRY STAIR", "Walter looks back up the winding granite steps.\n\nThe draft carries the smell of cold stone and aged cedar from the pantry above."],
		["WALTER CORWIN", "The way back is clear.\n\nWhatever has been brought down here was carried on foot."]
	],
	"whistle": [
		["THE SILT ALCOVE", "Something catches the lantern light in a drift of dry silt.\n\nWalter kneels and brushes away the salt crust."],
		["PATROLMAN'S WHISTLE", "Municipal nickel plate, corroded green at the seam.\n\nThe stamped precinct number is clear: 4.\nThe badge number below it is 114."],
		["WALTER'S NOTEBOOK", "Thomas. November 1918.\n\nThey recorded him as walked off his post after the armistice celebrations.\n\nHe did not walk off his post."]
	],
	"strata": [
		["THE FRACTURE LINE", "Walter holds the lantern closer to the passage wall.\n\nThe stone is granite, but the grain turns ninety degrees without a seam."],
		["WALTER CORWIN", "Perception is not belief. It is noticing where the join has been hidden."],
		["A COLD VIOLET GLINT", "Along the cleft, the lantern oil reflects a hue that is not yellow and not grey.\n\nWalter blinks. The eye protests, but the rock does not change."]
	],
	"fissure_examine": [
		["THE CHASM LEDGE", "The passage narrows to a shelf of wet rock over an unmeasured drop.\n\nBelow, the Atlantic swells and recedes inside hollow stone with the rhythm of a slow lung."],
		["WALTER CORWIN", "Three inches of shale between Walter and cold water.\n\nHe reaches for the inner coat pocket where the flask sits to steady his hand."],
		["THE TEAR", "The damp seam gives way.\n\nThe pewter flask strikes the ledge once, rolls silently, and disappears into the abyss."],
		["WALTER'S NOTEBOOK", "Empty or full, the metal makes no sound when the water takes it.\n\nWhat steadied the hands is gone.\nThe inquiry goes on sober."]
	],
	"plinth_needles": [
		["THE STONE PLINTH", "In the center of the cavern stands an unhewn stone block dressed only on top.\n\nSix bronze shallow basins sit in a circle. In the center lies a velvet roll."],
		["EXAMINE · IMPLEMENTS", "Six hollow silver needles, six inches in length.\n\nThe bevel is ground razor-fine. The interior channel is clean."],
		["WALTER'S NOTEBOOK", "No powder burns on the garden collars because no cartridge was fired.\n\nA mechanical puncture above the nasal bone. A fluid extraction, or an insertion.\n\nThe wounds in the garden match the tools in this cave."]
	],
	"sea_gate_view": [
		["THE SEA ARCH", "Cold salt spray drifts across the stone floor.\n\nBeyond the iron ringbolts, the cavern opens to the open bay under the cliff shadow."],
		["WALTER CORWIN", "No boat could reach this from the harbor unnoticed by day.\n\nBy night, with the tide running, a skiff could slip inside and tie up before the watch changed."],
		["THE CASE RECORD", "Eight dead above. A missing officer from five years ago.\nSix silver needles matching six wounds.\n\nThe investigation has found its shape."]
	]
}
