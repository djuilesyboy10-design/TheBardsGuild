-- Special Titles Data Management
-- Quest-based title entries that unlock like chronicles

local core = require("openmw.core")

-- Title data structure with quest requirements
local titleData = {
    -- Quest-based titles that unlock based on quest progress
    questTitles = {
        {
            id = "title_bards_guild",
            name = "Guild Initiate",
            description = [[You have taken the first steps into the Bard's Guild.
The halls of music open to those who seek harmony in chaos.
Your journey begins among voices raised in unity.]],
            requirements = {
                questId = "jmcg_bards_guild",
                stage = 20
            },
            unlocked = false
        },
        {
            id = "title_tuning_master",
            name = "Tuning Seeker",
            description = [[Ancient resonance calls to your understanding.
The Dwemer's tonal architecture reveals its secrets.
Through Abelle's research, you grasp frequencies beyond hearing.]],
            requirements = {
                questId = "jmcg_tuning_master",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_joseph_personal",
            name = "Street Whisperer",
            description = [[Joseph's network flows through taverns like wine.
You understand that information is the true currency.
Seven establishments answer to your subtle inquiries.]],
            requirements = {
                questId = "jmcg_joseph_personal",
                stage = 50
            },
            unlocked = false
        },
        {
            id = "title_chroniclers_saint",
            name = "Jiub's Scribe",
            description = [[From outcast to saint, you chronicled the transformation.
The cliff racers fell, but the legend rises eternal.
Your words preserve what temples will chant for ages.]],
            requirements = {
                questId = "jmcg_the_chroniclers_saint",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_hist_lore",
            name = "Deep-Dreamer",
            description = [[Argonni's memories flow through your consciousness.
The Hist speaks in mushroom dreams and ritual smoke.
You have touched the bridge between Hist and Dwemer resonance.]],
            requirements = {
                questId = "jmcg_hist_lore",
                stage = 50
            },
            unlocked = false
        },
        {
            id = "title_imperial_business",
            name = "Freedom's Voice",
            description = [[The North-Star Lullaby guides slaves to liberty.
Your music becomes a beacon in the darkest night.
The Twin Lamps movement gains strength through your voice.]],
            requirements = {
                questId = "jmcg_imperial_business",
                stage = 30
            },
            unlocked = false
        },
        {
            id = "title_twin_lamps_hymn",
            name = "Abolitionist Bard",
            description = [[Chains break beneath the melody of liberation.
The Camonna Tong's grip weakens as your songs spread.
Each verse strikes another blow against oppression.]],
            requirements = {
                questId = "jmcg_twin_lamps_hymn",
                stage = 40
            },
            unlocked = false
        },
        {
            id = "title_shane_lore",
            name = "Sand-Eater's Friend",
            description = [[Shane gra-Bagol's wisdom flows through your understanding.
An Orc poet in a foreign land, teaching truth through ink.
You carry her research into halls that once shunned her.]],
            requirements = {
                questId = "jmcg_shane_lore",
                stage = 25
            },
            unlocked = false
        },
        {
            id = "title_thieves_lore",
            name = "Shadow's Confidant",
            description = [[The criminal underground shares secrets with you.
Shadows dance with music in alleys of Balmora.
You preserve songs from those who live by the knife.]],
            requirements = {
                questId = "jmcg_thieves_lore",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_abelle",
            name = "Resonance Seeker",
            description = [[Abelle Chriditte's research opens Dwemer mysteries.
The earth hums with tonal architecture in your presence.
Alchemy and ancient technology converge through your studies.]],
            requirements = {
                questId = "jmcg_ablle",
                stage = 40
            },
            unlocked = false
        },
        {
            id = "title_ashsinger",
            name = "Ash Singer",
            description = [[Ashlander voices rise through you from volcanic wastes.
Ancient traditions persist beyond the Empire's reach.
You preserve what civilization would erase.]],
            requirements = {
                questId = "jmcg_ashsinger_echo",
                stage = 60
            },
            unlocked = false
        },
        {
            id = "title_ballad",
            name = "Saint's Chronicler",
            description = [[From outcast to saint, you penned Jiub's legend.
Red Mountain witnessed the birth of a hero through your words.
The Temple chants verses you first set to parchment.]],
            requirements = {
                questId = "jmcg_ballad",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_daisy",
            name = "Silent Melody Keeper",
            description = [[Daisy Dives Deep listens through your understanding.
Hist memories flow where your fingers touch.
You hear the music between worlds.]],
            requirements = {
                questId = "jmcg_daisy_lore",
                stage = 110
            },
            unlocked = false
        },
        {
            id = "title_guide",
            name = "Wasteland Scribe",
            description = [[The Ashlander wastes revealed wisdom to your quill.
An outcast became teacher through your documentation.
Survival itself became poetry in your records.]],
            requirements = {
                questId = "jmcg_guide",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_orc_diplomacy",
            name = "Iron Singer",
            description = [[Iron Orc hammers struck alliance through your mediation.
Valenvaryon's walls witnessed bridges you built.
Malacath's children found new voices in your chorus.]],
            requirements = {
                questId = "jmcg_orc_diplomacy",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_path_bad",
            name = "Shadow's Minstrel",
            description = [[Not all your songs are sung in light and virtue.
The Camonna Tong's whispers became your tools.
You walk darker roads when necessity demands.]],
            requirements = {
                questId = "jmcg_path_bad",
                stage = 30
            },
            unlocked = false
        },
        {
            id = "title_path_good",
            name = "Virtue's Voice",
            description = [[Righteous fury burns through your melodies.
The Twin Lamps gain strength from your righteous songs.
Each chain you break adds verses to freedom's anthem.]],
            requirements = {
                questId = "jmcg_path_good",
                stage = 30
            },
            unlocked = false
        },
        {
            id = "title_recruitment",
            name = "Guild Builder",
            description = [[The Guild grew through your recruitment like roots through stone.
Each new voice strengthened the collective harmony.
You forged family from misfits and dreamers.]],
            requirements = {
                questId = "jmcg_recruitment",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_shane_lore_1",
            name = "Orc Truth Seeker",
            description = [[Shane's research revealed truths through your understanding.
Blood tells stories that history forgets.
You carry wisdom that the world misunderstood.]],
            requirements = {
                questId = "jmcg_shane_lore_1",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_shane_lore_2",
            name = "Malacath's Witness",
            description = [[The Code of Malacath spoke through your documentation.
The Ashen Forge revealed secrets of Orcish honor.
You understand strength born from rejection.]],
            requirements = {
                questId = "jmcg_shane_lore_2",
                stage = 60
            },
            unlocked = false
        },
        {
            id = "title_family_ties",
            name = "Chosen Family Scribe",
            description = [[The Guild became family for those who had none.
Your chronicles show loyalty transcending biology.
Old wounds healed through new connections you forged.]],
            requirements = {
                questId = "jmcg_the_family_ties",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_tong_dirge",
            name = "Shadow's Dancer",
            description = [[The Camonna Tong's dirge taught you dangerous steps.
You learned to dance with devils when necessary.
Information from shadows serves your chronicles.]],
            requirements = {
                questId = "jmcg_tong_dirge",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_joseph_lore",
            name = "Crossed Chords Bearer",
            description = [[Joseph's past contained music both sweet and bitter.
You chronicled how the Choir Master's history shaped the present.
Old alliances resurface like notes in your records.]],
            requirements = {
                questId = "jmcg_joseph_lore",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_jack_lore",
            name = "Silent Architect",
            description = [[Jack's influence built through your documentation.
Political networks extended through your chronicled whispers.
PR became warfare conducted without blades.]],
            requirements = {
                questId = "jmcg_jack_lore",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_div_good",
            name = "Tonal Chronicler",
            description = [[Divayth Fyr's wisdom guided your harmonic research.
Tonal architecture speaks to your understanding.
Good outcomes resonate through your documentation.]],
            requirements = {
                questId = "jmcg_div_good",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_div_myth",
            name = "Pattern Weaver",
            description = [[Mythic patterns underlie your historical narratives.
The Telvanni wizard's lessons shaped your understanding.
You document how reality responds to woven stories.]],
            requirements = {
                questId = "jmcg_div_myth",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_dragon",
            name = "Dragon's Memory",
            description = [[Dragon consciousness touched your understanding of time.
You encountered minds that remember what never happened.
Temporal paradox became poetry in your records.]],
            requirements = {
                questId = "jmcg_dragon",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_myth",
            name = "Living History",
            description = [[History lives in those who carry it forward.
You do not merely record - you resurrect through words.
Dead legends find new breath through your documentation.]],
            requirements = {
                questId = "jmcg_myth",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_tavern",
            name = "Tavern Truth Seeker",
            description = [[Taverns are temples where you learned deception's lessons.
Truth and lie dance together in every performance you chronicled.
Audiences hear what they need through your records.]],
            requirements = {
                questId = "jmcg_tavern_haload",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_fara",
            name = "Silent Steward",
            description = [[Fara's stewardship taught you quiet's weight.
Gnaar Mok's markets showed commerce without noise.
You learned that some transactions require no words.]],
            requirements = {
                questId = "jmcg_fara",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_aldruhn_seed",
            name = "Miming Seed Planter",
            description = [[Ald'ruhn's sands hide seeds of your future influence.
Lirielle's narratives grow through your documentation.
Today's whispers become tomorrow's history.]],
            requirements = {
                questId = "jmcg_aldruhn_seed",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_ally_lore",
            name = "Silent Archive Keeper",
            description = [[Ally's archives preserve dangerous truths through your work.
The Guild Master's records flow through your quill.
Knowledge hidden proves most powerful in your hands.]],
            requirements = {
                questId = "jmcg_ally_lore",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_endgame",
            name = "Northern Breeze",
            description = [[Endgames approach like winter winds in your chronicles.
The Guild's preparations span years in your records.
All storylines converge toward singular resolution.]],
            requirements = {
                questId = "jmcg_endgame",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_final",
            name = "Final Chronicler",
            description = [[Final songs carry the weight of all preceding verses.
The Guild's ultimate performance approaches crescendo.
Every story must end, yet endings birth new beginnings.]],
            requirements = {
                questId = "jmcg_final",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_theend",
            name = "Last Note Keeper",
            description = [[All symphonies resolve in final chords you record.
The Guild's greatest tale approaches its ultimate measure.
The last note echoes through eternity's halls.]],
            requirements = {
                questId = "jmcg_theend",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_goodend",
            name = "Redemption Singer",
            description = [[Redemption comes to those who document truth.
The Guild's good ending proves virtue's triumph through your words.
Light prevails through persistent resistance you chronicled.]],
            requirements = {
                questId = "jmcg_goodend",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_freedom",
            name = "Symphony of Light",
            description = [[Freedom rings as symphony through your liberation songs.
The Twin Lamps' success proves music's revolutionary power.
Chains broken become instruments in your verses.]],
            requirements = {
                questId = "jmcg_freedom",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_freedom2",
            name = "Resource Steward",
            description = [[Operations require resources you help acquire.
The Guild's logistics extend beyond performance fees.
Even revolutionaries balance ledgers in your records.]],
            requirements = {
                questId = "jmcg_freedom2",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_freedom3",
            name = "Dire Strike Chronicler",
            description = [[Direct action became necessary when words failed.
You chronicled the Guild's most desperate operations.
Some victories demand prices measured in blood.]],
            requirements = {
                questId = "jmcg_freedom3",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_herm",
            name = "Margin Walker",
            description = [[Hermaeus Mora's realm borders your own thinly.
Apocrypha's margins contain erased truths in your records.
Knowledge forbidden proves sweetest to your chronicler's tongue.]],
            requirements = {
                questId = "jmcg_herm",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_lostbard",
            name = "Lost Bard Seeker",
            description = [[Some voices vanish into silence without warning.
You search for bards who strayed from the Guild's path.
Recovery becomes rescue in your chronicles.]],
            requirements = {
                questId = "jmcg_lostbard",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_stack",
            name = "Stack Keeper",
            description = [[Layers of reality pile like parchment in your archives.
The Stack represents accumulated history's weight.
You are but pages in volumes greater than yourself.]],
            requirements = {
                questId = "jmcg_stack",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "title_web",
            name = "Web Weaver",
            description = [[Connections intertwine in patterns you document.
The Web captures all who touch its silken strands.
You sit at the center, feeling every vibration.]],
            requirements = {
                questId = "jmcg_web",
                stage = 100
            },
            unlocked = false
        }
    },
    
    -- Reputation-based titles
    reputationTitles = {
        {
            id = "title_bard_master",
            name = "Master Bard",
            description = [[The Guild recognizes true mastery in your musical arts.
Taverns across Vvardenfell echo with tales of your skill.
The very fabric of reality responds to your perfected craft.]],
            requirements = {
                reputation = "Resonant",
                minQuestsCompleted = 5
            },
            unlocked = false
        },
        {
            id = "title_story_weaver",
            name = "Legendary Chronicler",
            description = [[Words become weapons in your masterful hands.
Rumors and tales shape the world around you.
Reality itself bends to the power of your storytelling.]],
            requirements = {
                reputation = "Legendary",
                minQuestsCompleted = 10
            },
            unlocked = false
        }
    }
}

-- Helper functions
local titleManager = {}

-- Check if title requirements are met
function titleManager.checkRequirements(requirements, questProgress, reputationLevel)
    if not requirements then return true end
    
    -- Check quest requirements
    if requirements.questId and requirements.stage then
        local currentStage = questProgress[requirements.questId] or 0
        if currentStage < requirements.stage then
            return false
        end
    end
    
    -- Check reputation requirements
    if requirements.reputation then
        if reputationLevel ~= requirements.reputation then
            return false
        end
    end
    
    return true
end

-- Get all unlocked titles based on player progress
function titleManager.getUnlockedTitles(questProgress, reputationLevel)
    local unlocked = {}
    
    -- Check quest titles
    for _, title in ipairs(titleData.questTitles) do
        if titleManager.checkRequirements(title.requirements, questProgress, reputationLevel) then
            title.unlocked = true
            table.insert(unlocked, title)
        end
    end
    
    -- Check reputation titles
    for _, title in ipairs(titleData.reputationTitles) do
        if titleManager.checkRequirements(title.requirements, questProgress, reputationLevel) then
            title.unlocked = true
            table.insert(unlocked, title)
        end
    end
    
    return unlocked
end

-- Export the title manager and data tables
return {
    titleManager = titleManager,
    questTitles = titleData.questTitles,
    reputationTitles = titleData.reputationTitles
}
