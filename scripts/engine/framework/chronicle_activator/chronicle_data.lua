-- Chronicle Data Management
-- Simple implementation with all chronicle content in one file

local core = require("openmw.core")

-- Chronicle data structure
local chronicleData = {
    -- Base chronicles - EMPTY until quests are completed
    baseChronicles = {},
    
    -- Quest-related chronicles with simple stage checks
    questChronicles = {
        {
            id = "chronicle_bards_guild",
            title = "The Bard's Guild",
            text = [[A new chapter begins in the halls of music.
The Guild opens its doors to those who understand power
lies not in weapons, but in words and melodies.
Stories become weapons, songs become shields.]],
            requirements = {
                questId = "jmcg_bards_guild",
                stage = 20
            },
            unlocked = false
        },
        {
            id = "chronicle_tuning_master",
            title = "The Devil's Tuning Fork",
            text = [[Ancient technology resonates with forgotten power.
The Propylon chambers hold secrets of the Dwemer.
Abelle Chridtite's research unlocks their potential.
A network of teleportation awaits the Guild's control.]],
            requirements = {
                questId = "jmcg_tuning_master",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_joseph_personal",
            title = "The Rhythm of the Street",
            text = [[Information flows through the taverns like wine.
Joseph's network spans seven establishments, each a node
in the Guild's growing intelligence apparatus.
Rumors become weapons, gossip becomes strategy.]],
            requirements = {
                questId = "jmcg_joseph_personal",
                stage = 50
            },
            unlocked = false
        },
        {
            id = "chronicle_chroniclers_saint",
            title = "Saint Jiub's Ballad",
            text = [[From death wish to sainthood, a Nord's transformation.
The cliff racer scourge falls to his determination.
The Temple elevates him, the Guild documents him.
A legend born from music and martyrdom.]],
            requirements = {
                questId = "jmcg_the_chroniclers_saint",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_hist_lore",
            title = "The Deep-Dreaming",
            text = [[Argonni's memories fade like autumn leaves.
The Hist calls through mushroom dreams and ritual.
In the depths of consciousness, a Dremora waits.
Ancient paths bridge Hist memory to Dwemer resonance.]],
            requirements = {
                questId = "jmcg_hist_lore",
                stage = 50
            },
            unlocked = false
        },
        {
            id = "chronicle_imperial_business",
            title = "The North-Star Lullaby",
            text = [[A song of freedom whispered in the darkest night.
The Twin Lamps movement gains a voice through music.
Ilmeni Dren's patronage enables daring rescues.
Slaves find their way to freedom following the melody of hope.]],
            requirements = {
                questId = "jmcg_imperial_business",
                stage = 30
            },
            unlocked = false
        },
        {
            id = "chronicle_twin_lamps_hymn",
            title = "The Abolitionist's Anthem",
            text = [[Chains break like brittle reeds beneath the melody.
The Camonna Tong's grip weakens as resistance grows.
Each rescued slave adds a verse to the song of freedom.
The Guild's music becomes a weapon of liberation.]],
            requirements = {
                questId = "jmcg_twin_lamps_hymn",
                stage = 40
            },
            unlocked = false
        },
        {
            id = "chronicle_shane_lore",
            title = "The Sand-Eater's Chronicle",
            text = [[An Orc poet finds her voice in a foreign land.
Shane gra-Bagol records the Guild's deeds with ink and wisdom.
Her quill captures what swords cannot - the truth of power.
History becomes poetry, and poetry becomes prophecy.]],
            requirements = {
                questId = "jmcg_shane_lore",
                stage = 25
            },
            unlocked = false
        },
        {
            id = "chronicle_thieves_lore",
            title = "The Undercover Act",
            text = [[Shadows dance with music in the criminal underground.
The Guild's influence extends to those who live by the knife.
Even thieves have songs worth preserving in our archives.
Information flows from the darkest corners to our illuminated halls.]],
            requirements = {
                questId = "jmcg_thieves_lore",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_abelle",
            title = "The Vibrating Earth",
            text = [[Abelle Chriditte's research delves into propylon mysteries.
The earth itself hums with Dwemer tonal architecture.
Alchemy and ancient technology converge in harmony.
The Guild gains a master of resonance and forgotten arts.]],
            requirements = {
                questId = "jmcg_ablle",
                stage = 40
            },
            unlocked = false
        },
        {
            id = "chronicle_ashsinger",
            title = "The Ash Singers Echo",
            text = [[Ashlander voices rise from the volcanic wastes.
Ancient traditions persist beyond the reach of civilization.
The Guild collects what the Empire would erase.
In ash and song, the true Dunmer spirit endures.]],
            requirements = {
                questId = "jmcg_ashsinger_echo",
                stage = 60
            },
            unlocked = false
        },
        {
            id = "chronicle_ballad",
            title = "St Jiub's Ballad",
            text = [[From outcast to saint, a legend takes flight.
The cliff racers fall before Jiub's determined wrath.
Red Mountain witnesses the birth of a hero.
The Guild pens the verses that temples will chant.]],
            requirements = {
                questId = "jmcg_ballad",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_daisy",
            title = "The Silent Melody",
            text = [[Daisy Dives Deep listens to what others cannot hear.
Hist memories flow through her enchanter's fingers.
The resonance of souls speaks in frequencies unknown.
A dancer who hears the music between worlds.]],
            requirements = {
                questId = "jmcg_daisy_lore",
                stage = 110
            },
            unlocked = false
        },
        {
            id = "chronicle_guide",
            title = "The Ashlander Guide",
            text = [[The wastelands hold wisdom for those who listen.
An outcast becomes teacher, exile becomes guide.
The Guild learns that survival is its own poetry.
Ancient ways persist where civilization fears to tread.]],
            requirements = {
                questId = "jmcg_guide",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_orc_diplomacy",
            title = "Orc Diplomacy",
            text = [[Iron Orc hammers strike a different rhythm.
Valenvaryon's walls witness unlikely alliances.
The Guild bridges worlds separated by blood and stone.
Malacath's children find new voices in our chorus.]],
            requirements = {
                questId = "jmcg_orc_diplomacy",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_path_bad",
            title = "The Shadow's Path",
            text = [[Not all songs are sung in light and virtue.
The Guild walks darker roads when necessity demands.
Camonna Tong whispers become tools of liberation.
Ends justify means in the mathematics of freedom.]],
            requirements = {
                questId = "jmcg_path_bad",
                stage = 30
            },
            unlocked = false
        },
        {
            id = "chronicle_path_good",
            title = "The Abolitionist",
            text = [[Righteous fury burns brighter than any torch.
The Twin Lamps gain a voice that cannot be silenced.
Each chain broken adds a verse to freedom's song.
The Guild becomes instrument of divine justice.]],
            requirements = {
                questId = "jmcg_path_good",
                stage = 30
            },
            unlocked = false
        },
        {
            id = "chronicle_recruitment",
            title = "Recruitment Drive",
            text = [[The Guild grows like roots through stone.
Each new voice strengthens our collective harmony.
From taverns and prisons, talent rises to our call.
A family forged from misfits, dreamers, and visionaries.]],
            requirements = {
                questId = "jmcg_recruitment",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_shane_lore_1",
            title = "Orc True Nature",
            text = [[Blood tells stories that history forgets.
The Pig Children carry wisdom in their scars.
Shane's research reveals truths both terrible and beautiful.
What the world calls barbarism is often misunderstood nobility.]],
            requirements = {
                questId = "jmcg_shane_lore_1",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_shane_lore_2",
            title = "Gaze of Malacath",
            text = [[The Code of Malacath speaks through iron and ash.
The Ashen Forge reveals secrets of Orcish honor.
Pariah gods understand exile better than golden ones.
Strength born from rejection shapes the strongest steel.]],
            requirements = {
                questId = "jmcg_shane_lore_2",
                stage = 60
            },
            unlocked = false
        },
        {
            id = "chronicle_family_ties",
            title = "Family Ties",
            text = [[Blood binds tighter than any contract signed.
The Guild becomes family for those who have none.
Old wounds heal through new connections forged.
Loyalty transcends biology in our chosen family.]],
            requirements = {
                questId = "jmcg_the_family_ties",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_tong_dirge",
            title = "The Shadow's Duet",
            text = [[The Camonna Tong's dirge plays a dangerous melody.
Crime and culture intertwine in Balmora's alleys.
The Guild learns to dance with devils when we must.
Information extracted from shadows serves the light.]],
            requirements = {
                questId = "jmcg_tong_dirge",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_joseph_lore",
            title = "Crossed Chords",
            text = [[Joseph's past contains music both sweet and bitter.
The Choir Master's history shapes our present symphony.
Old alliances resurface like notes in recurring themes.
Every master was once a student of pain.]],
            requirements = {
                questId = "jmcg_joseph_lore",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_jack_lore",
            title = "The Silent Architect",
            text = [[Jack builds influence where others see only chaos.
The political wing extends through networks unseen.
PR becomes warfare conducted with whispers instead of blades.
Power accumulated silently shakes foundations loudest.]],
            requirements = {
                questId = "jmcg_jack_lore",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_div_good",
            title = "Tonal Echoes",
            text = [[Divayth Fyr's wisdom guides our research into harmonics.
The tonal architecture speaks to those who understand vibration.
Good outcomes resonate through probability like perfect chords.
Knowledge preserved in sound outlasts stone or steel.]],
            requirements = {
                questId = "jmcg_div_good",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_div_myth",
            title = "The Pattern Weavers",
            text = [[Mythic patterns underlie all historical narrative.
The Telvanni wizard's cryptic lessons shape our understanding.
Reality itself responds to properly woven stories.
We who document become we who determine truth.]],
            requirements = {
                questId = "jmcg_div_myth",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_dragon",
            title = "The Forgotten Name",
            text = [[Dragon consciousness experiences time as river, not road.
The Guild encounters minds that remember what never happened.
Temporal paradox becomes poetry in ancient tongues.
Some names, once spoken, reshape the speaker forever.]],
            requirements = {
                questId = "jmcg_dragon",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_myth",
            title = "Living Breathing History",
            text = [[History lives in those who carry it forward.
The Guild does not merely record - we resurrect.
Dead legends find new breath through our documentation.
Myth made manifest changes the world that birthed it.]],
            requirements = {
                questId = "jmcg_myth",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_tavern",
            title = "Sweet Little Lies",
            text = [[Taverns are temples where alcohol replaces faith.
The Haload establishment teaches lessons in deception.
Truth and lie dance together in every performance.
Audiences hear what they need, not what is spoken.]],
            requirements = {
                questId = "jmcg_tavern_haload",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_fara",
            title = "Silence is Golden",
            text = [[Fara's stewardship proves that quiet carries weight.
Gnaar Mok's markets teach commerce without noise.
The Guild learns that some transactions require no words.
Gold speaks louder than any speech, yet says nothing.]],
            requirements = {
                questId = "jmcg_fara",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_aldruhn_seed",
            title = "Miming Seeds",
            text = [[Ald'ruhn's sands hide seeds of future influence.
Lirielle Stoine plants narratives that will grow for decades.
The Guild's reach extends through time as well as space.
Today's whispers become tomorrow's accepted history.]],
            requirements = {
                questId = "jmcg_aldruhn_seed",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_ally_lore",
            title = "The Silent Archive",
            text = [[Ally's archives preserve what empires would destroy.
The Guild Master's records contain dangerous truths.
Silent archives speak louder than public proclamations.
Knowledge hidden is often knowledge most powerful.]],
            requirements = {
                questId = "jmcg_ally_lore",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_endgame",
            title = "Northern Breeze",
            text = [[Endgames approach like winter winds from the north.
The Guild's preparations span years in compressed moments.
All storylines converge toward singular resolution.
The breeze before the storm carries both promise and warning.]],
            requirements = {
                questId = "jmcg_endgame",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_final",
            title = "The Last Ballad",
            text = [[Final songs carry the weight of all preceding verses.
The Guild's ultimate performance approaches its crescendo.
Every story must end, yet endings birth new beginnings.
We who chronicle become the chronicled in final accounts.]],
            requirements = {
                questId = "jmcg_final",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_theend",
            title = "The Last Note",
            text = [[All symphonies resolve in final chords.
The Guild's greatest tale approaches its ultimate measure.
What we have built will outlast our individual breath.
The last note echoes through eternity's halls.]],
            requirements = {
                questId = "jmcg_theend",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_goodend",
            title = "Redemption Song",
            text = [[Redemption comes to those who document truth.
The Guild's good ending proves virtue's ultimate triumph.
Light prevails through persistent resistance to darkness.
Our redemption song becomes chorus for future ages.]],
            requirements = {
                questId = "jmcg_goodend",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_freedom",
            title = "The Symphony of Light",
            text = [[Freedom rings as symphony through liberated halls.
The Twin Lamps' success proves music's revolutionary power.
Chains broken become instruments of liberation songs.
Light prevails when bards lend their voices to justice.]],
            requirements = {
                questId = "jmcg_freedom",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_freedom2",
            title = "Resource Acquisition",
            text = [[Operations require resources acquired through diverse means.
The Guild's logistics extend beyond mere performance fees.
Supply chains become as important as the art they support.
Even revolutionaries must balance their ledgers.]],
            requirements = {
                questId = "jmcg_freedom2",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_freedom3",
            title = "A Dire Strike",
            text = [[Direct action becomes necessary when words fail.
The Guild's most desperate operations risk everything.
Striking at evil's heart requires precision and courage.
Some victories demand prices measured in blood and bond.]],
            requirements = {
                questId = "jmcg_freedom3",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_herm",
            title = "The Margin of the World",
            text = [[Hermaeus Mora's realm borders our own thinly.
Apocrypha's margins contain erased truths and contradictions.
The Guild tiptoes through memories that should not exist.
Knowledge forbidden proves sweetest to the chronicler's tongue.]],
            requirements = {
                questId = "jmcg_herm",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_lostbard",
            title = "The Lost Bard",
            text = [[Some voices vanish into silence without warning.
The Guild searches for those who strayed from our path.
Lost bards carry songs that must not be forgotten.
Recovery becomes rescue, rescue becomes redemption.]],
            requirements = {
                questId = "jmcg_lostbard",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_stack",
            title = "The Stack",
            text = [[Layers of reality pile like parchment in archives.
The Stack represents accumulated history's weight.
Each story added increases the whole's gravitas.
We are but pages in volumes greater than ourselves.]],
            requirements = {
                questId = "jmcg_stack",
                stage = 100
            },
            unlocked = false
        },
        {
            id = "chronicle_web",
            title = "The Web",
            text = [[Connections intertwine in patterns beyond simple sight.
The Web captures all who touch its silken strands.
The Guild sits at the center, feeling every vibration.
Conspiracy becomes symphony when properly conducted.]],
            requirements = {
                questId = "jmcg_web",
                stage = 100
            },
            unlocked = false
        }
    },
    
    -- Reputation-based chronicles
    reputationChronicles = {
        {
            id = "chronicle_bard_master",
            title = "Master of the Bardic Arts",
            text = [[The Guild recognizes true mastery in the musical arts.
Through dedication and practice, the Bard achieves renown.
Taverns across Vvardenfell echo with tales of their skill.
The very fabric of reality responds to their perfected craft.]],
            requirements = {
                reputation = "Resonant",
                skillLevel = 75
            },
            unlocked = false
        },
        {
            id = "chronicle_story_weaver",
            title = "The Story Weaver",
            text = [[Words become weapons in the hands of a master.
Rumors and tales shape the world around them.
The Guild's influence grows through carefully crafted narratives.
Reality itself bends to the power of their storytelling.]],
            requirements = {
                reputation = "Legendary",
                influenceLevel = 50
            },
            unlocked = false
        }
    }
}

-- Helper functions
local chronicleManager = {}

-- Check if chronicle requirements are met
chronicleManager.checkRequirements = function(requirements, playerReputation, playerSkills, questStages)
    if not requirements then return true end
    
    -- Check quest requirements
    if requirements.questId and requirements.stage then
        local currentStage = questStages[requirements.questId] or 0
        if currentStage < requirements.stage then
            return false
        end
    end
    
    -- Check reputation requirements
    if requirements.reputation then
        if playerReputation ~= requirements.reputation then
            return false
        end
    end
    
    -- Check skill requirements
    if requirements.skillLevel then
        -- This would need to integrate with SkillFramework
        -- For now, assume skill check passes
    end
    
    -- Check influence requirements
    if requirements.influenceLevel then
        -- This would need to integrate with influence system
        -- For now, assume influence check passes
    end
    
    return true
end

-- Get all unlocked chronicles based on player progress
chronicleManager.getUnlockedChronicles = function(playerReputation, playerSkills, questStages)
    local unlocked = {}
    
    -- NO base chronicles - book starts empty
    
    -- Check quest chronicles only
    for _, chronicle in ipairs(chronicleData.questChronicles) do
        if chronicleManager.checkRequirements(chronicle.requirements, playerReputation, playerSkills, questStages) then
            chronicle.unlocked = true
            table.insert(unlocked, chronicle)
        end
    end
    
    -- Check reputation chronicles
    for _, chronicle in ipairs(chronicleData.reputationChronicles) do
        if chronicleManager.checkRequirements(chronicle.requirements, playerReputation, playerSkills, questStages) then
            chronicle.unlocked = true
            table.insert(unlocked, chronicle)
        end
    end
    
    return unlocked
end

-- Export the chronicle manager
return {
    chronicleManager = chronicleManager
}
