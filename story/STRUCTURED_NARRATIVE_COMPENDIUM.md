# JMCG Bards Guild — Structured Narrative Compendium

> **Purpose**: One-place, organized summary of the mod’s core narrative arcs, metaphysics, key characters, and world systems.  
> **Scope**: All story files in `/story/` consolidated, de-duplicated, and arranged for clarity.  
> **Tone**: Lore-friendly, concise, and implementation-ready.

---

## 1. Core Premise: The “Fracture” and the Bard’s Role

- **The Problem**: Mundus is “out of tune.” Forbidden memories from erased timelines are leaking into the present.  
- **The Cause**: Hermaeus Mora’s “editing room” — a sub-realm of Apocrypha where overwritten outcomes are stored.  
- **The Bard’s Function**: The player (Lore Keeper) is a “Journalist of the Absurd,” tasked with finding, stabilizing, and recording these memories before they unravel causality.

---

## 2. Metaphysical Framework

### 2.1 The Margin of the World (Apocrypha Sub-Realm)

- **What it is**: A buffer for “deleted” realities — events, people, and outcomes Mora has edited out of existence.  
- **Rules**:
  - Time does not flow; it remembers.
  - NPCs repeat moments that never resolved.
  - Contradictions accumulate; memory is unstable.
  - The player is a trespasser in Mora’s editing room.

### 2.2 Types of Contradictions

| Type | Description | Example |
|------|-------------|---------|
| **Temporal** | Unresolved Dragon Breaks, time loops | A Dragon that never entered linear time |
| **Divine** | Gods that failed to mantle / were erased | Talos’ apotheosis vs. Thalmor doctrine |
| **Racial** | Erased transformations / histories | Chimer who never became Dunmer |
| **Mythic** | Beliefs that never manifested | A god that almost existed |

---

## 3. Major Narrative Arcs

### 3.1 The Lost Song Symphony (12 Cultural Frequencies)

The Bard must collect “notes” from each race to reconstruct a lost tonal architecture that can stabilize reality.

| Race | Note | Source |
|------|------|--------|
| Orc | The Drum (Stone-Singing) | Iron Orcs, Malacath’s trial |
| Nord | The Thrum (The Voice) | Saint Jiub, Red Mountain |
| Breton | The Dance (Direnni-Waltz) | Hisin/Lysandra, Gnaar Mok |
| Argonian | The Bass (Hist-Pulse) | Argonni, Pelagiad |
| Imperial | The Choir (Chorus Master) | Jack of the Choir, Balmora |
| Khajiit | The Purr (Moon-Vibration) | Jo’Zhaf’s network |
| Redguard | The Blade-Song | Sword-singing traditions |
| Altmer | The High-Note | Dusk Song / Ayleid echoes |
| Bosmer | The Green-Singing | Storytelling/forest rites |
| Dunmer | The Lyrics (Ash-Hymn) | Tribunal/Ashlander lore |
| Dremora | The Divine Note | Azura’s Garden/Sustain |
| Dwemer | The Brass-Vibration | Tonal Architecture, Propylons |

### 3.2 The Hist Memory Arc

- **Hook**: Argonni (Halfway Inn, Pelagiad) is losing Hist memories.  
- **Ritual**: Deep-Dreaming (3x Luminous Russula, 3x Violet Coprinus).  
- **Reveal**: Dremora Lord Valos in a Hist Dream cell; points to Mudan Grotto Lore Vault.  
- **Outcome**: Bridge to Dwemer resonance and the “Lost Resonance” endgame.

### 3.3 The PR Warfare (Balmora)

- **NPC**: Jack of the Choir (Bosmer).  
- **Mechanic**: Faction influence via songs (ModFactionReaction).  
- **Branches**:
  - **Good Path**: Twin Lamps, Ilmeni Dren, North-Star Lullaby at Dren Plantation.  
  - **Evil Path**: Camonna Tong, Durus Marius, Ebonheart Distraction.  
- **Reward**: 1000g (Good) or 2000g (Evil).

### 3.4 Saint Jiub’s Finale

- **Path**: Ghostgate → Red Mountain summit → Matriarch Nest battle.  
- **Outcome**: Jiub’s sainthood, “Ballad of Saint Jiub,” and the Aria’s Bloom activator (Silt Strider home).

### 3.5 The Iron Orc Reclamation

- **Location**: Valenvaryon → The Beating Drum (Iron Orc settlement).  
- **Mechanics**: Bed rental, shop construction timer, “Stone-Singing” drum ritual.  
- **Outcome**: “Iron Pulse” note (Orc frequency), Malacath trial.

---

## 4. Key Characters

| Name | Role | Signature Trait | Key Lines/Flavor |
|------|------|-----------------|-----------------|
| **Ally** | Guild Master / Moral Compass | “Stillness in the pupils” — clinical dread | “Someone is writing a biography of the Bards Guild, and I fear they are reaching the final chapter.” |
| **Shane gra-Bagol** | Record Keeper / Orc Poet | “The Sand-Eater’s Chronicle” author | “I am a long way from the burning sands of the Alik’r… I am an Orc by blood, but my soul was forged in the heat of the desert sun and Breton inkwell.” |
| **Joseph (Jo’Zhaf)** | Spy / Rumor Network | 7-tavern intelligence, “Rhythm of the Street” | “Songs pass through us. Rumors linger. Truth bends, depending on who is listening.” |
| **Jack** | Chorus Master / PR | Faction manipulation, “Discordant String” | “Dirty business is good business, my friend. Go to the Fighters Guild. Pitch our ‘herald services.’” |
| **Daisy Dives Deep** | Enchanter / Dancer | “Resonating Pitch,” Hist ties | “I am an Enchanter by trade and a dancer by choice. My foster-family in High Rock taught me that every soul has a melody.” |
| **Xeech** | Alchemist / Harmonizer | “Vastei-Sei” ritual, Hist alchemy | “I erect the spine of recognition, beeko. I am Xeech, a Mota-Xeech. I will hunt for songs for the Guild.” |
| **Abelle Chriditte** | Scholar / Propylon Tuner | “Master Alchemist,” Valenvaryon | “I am a master of the alchemical arts, and I’ve found that the Propylon Chamber’s unique resonance… is essential for my work.” |
| **Tarer Brayn** | Recruited Zealot | Cyrodiil-born, Sermon 36 | “A Guild that values cultural preservation? This is exactly what I sought when I left the Imperial City.” |
| **Hisin Deep-Raed** | Nord Skald / Smith | “Tactical Landing,” SkyForge lore | “A Nord of my stature does not ‘fall.’ I transitioned from a high-altitude performance to a low-altitude recovery.” |
| **Lysandra Direnni** | Enchanter / Direnni Scion | “De Rerum Dirennis,” Gnaar Mok | “My mother, a lady of the Direnni, taught me that a name is a Woven thing. Mine was woven from a king’s memory and a sorceress’s grief.” |
| **Jiub** | Saint / Chronicler | Red Mountain climax | “I don’t belong in a guild hall, and I certainly don’t belong in a tavern. I belong in a cell… I go now on a holy mission to rid Vvardenfell of the scourge of the sky.” |
| **Valos (Dremora)** | Archive Keeper | Azura’s Garden, Mudan Grotto | “A mortal melody wandering my halls? How discordant… Speak, little ephemeral. Shall I score your life as a mere grace note in my ledger, or is there a rhythm in your spirit?” |
| **Umbra** | Cursed Warrior | “Condition, not citizen,” Valenvaryon | “I have no more to do in this life. I have saved whole towns from packs of daedra… All that is left for me is my own death.” |
| **Fara** | Gnaar Mok Steward | “Silent trade,” market ethics | “You weighed the risk and brought the prize… Five thousand gold is a lot of weight to carry, but I think your pockets are deep enough for the risk.” |
| **Im-Kilaya** | Twin Lamps Contact | Argonian Mission, Ebonheart | “The friend of Rabinna returns. The Twin Lamps have seen your work in Balmora. We need a way to guide those in the dark without alerting the hunters.” |
| **Ilmeni Dren** | Noble Abolitionist | Duke’s daughter, Vivec | “The path of the north-star lullaby is a dangerous one, Bard. Do you have news?” |
| **Lirielle Stoine** | Ald’ruhn Seeding Operative | “Bards’ stewartship,” narrative planting | “A Bard’s greatest power is not playing the lute, but deciding which stories the future is allowed to remember.” |
| **Bumbub gro-Murgol** | Iron Orc Warchief | Valenvaryon chief, “Task Sutable” | “Valenvaryon is Iron Orc land now. My cousin Shane says you ‘Bards’ think words are as loud as our hammers to drums.” |
| **Lurog gro-Khagdum** | Keeper of the Ashen Flame | “Soot-Chant,” pyre rites | “The Soot-Chant is the breath of Malacath himself… If your guild wants to hear the oldest music of my people, stand by the pyre when the wind is low.” |
| **Yadba gro-Khash** | Iron Records Keeper | “Iron Records,” Valenvaryon | “The Dunmer write on paper that rots. The Iron Arm writes on stone that sings.” |
| **Kharzug gra-Gat** | Ashen Forge Interpreter | “Soot-stains,” Valenvaryon | “I am the daughter of the Ashen Forge, and I interpret the soot-stains on the altar.” |
| **Hul** | Balmora Gate Observer | “Little advice,” street wisdom | “Sometimes places change. Sometimes they don’t. Hard to tell which matters more.” |
| **Ra’virr** | Khajiit Secrets Broker | “Lost doors,” moon-sugar | “There are doors in these hills that forgot their owners. Stone doors. Quiet doors.” |
| **Garrus Vane** | Alchemist Villain | Molag Amur experimenter | “I am not killing them, %PCName… I am making them immortal. I am turning their screams into a symphony that will last forever.” |
| **Duras Marius** | Sewer “Silent Partner” | Thieves Guild liaison | “My Silent Partner has to remain as silent as I, what do you want?” |
| **Hlevala Madalve** | Tong Plantation Overseer | Dren Plantation ops | “You’ve got more than just a voice, singer—you’ve got nerves of steel.” |
| **Bugrol gro-Bagul** | Orc Rogue | Caldera misadventures | “Fine, take the book. You’re a good sort for a non-Orc. Besides, I heard the whispers… Orcs are coming from all over to that Valenvaryon place.” |

---

## 5. World Systems & Mechanics

### 5.1 Rumor Echo System

- **Function**: Quest outcomes spread through Jo’Zhaf’s 7-tavern network.  
- **Paths**: Good/Bad/Mythic generate different rumors.  
- **Taverns**: Balmora (Eight Plates), Ald’ruhn (Rat in the Pot), Vivec (Black Shalk), Suran (Tradehouse), Gnaar Mok (Nadene’s), Hla Oad (Fatleg’s), Sadrith Mora (Dirty Muriel’s).

### 5.2 Propylon Travel (Tuning Fork)

- **Device**: “Devil’s Tuning Fork” (JMCG_Fork).  
- **Mechanic**: Lua-driven travel to 10 Dunmer strongholds.  
- **Progression**: Stages 10–100, resonance cache markers, 24h cooldown.

### 5.3 Bardic Influence HUD

- **UI**: Gold progress bar, numerical percentage.  
- **Logic**: Weighted quest database, morality tracking.  
- **Scripts**: `quest_database.lua`, `quest_logic.lua`, `influence_ui.lua`.

---

## 6. Antagonist & Endgame

### 6.1 Hermaeus Mora

- **Role**: Archivist of erased truths.  
- **Goal**: Preserve “record” at the cost of “growth.”  
- **Weakness**: Cannot control tone, rhythm, or free will.

### 6.2 The “Pied Piper” (Temporal Saboteur)

- **Nature**: A figure using a bone-flute to “play” the future into the present.  
- **Effect**: Causes temporal stutters, memory leaks, and “stillness in pupils.”  
- **Goal**: Collapse the Margin, release contradictions.

### 6.3 Endgame: The Lost Song (Dynamic Book)

- **Trigger**: 12/12 frequencies + Hist completion.  
- **Mechanic**: A dynamically generated book titled “The Lost Song” that compiles the player’s entire journey.  
  - **Pages pull from a dialogue data table**, reflecting every major choice, rumor, and path taken.  
  - **Content mutates** based on morality, faction alignment, and discoveries (e.g., “good” paths get truth, “evil” paths get lies or propaganda).  
  - **Hermaeus Mora and the Pied Piper are never explicitly named**; only deep-immersion players will connect the dots.  
- **Thematic Core**: The Bard’s work is ultimately erased by history, but the book preserves the truth—or a version of it.  
- **Player Outcomes**:
  - **Truthful Archive**: Full, coherent narrative for “good” or completionist runs.  
  - **Fractured/Lying Book**: Contradictions, propaganda, or redactions for “evil” or incomplete runs.  
  - **Silent Void**: Minimalist entries for players who missed key lore.  
- **Meta Design**: The mod’s story “never really happened” in the world’s canon, but the player’s experience is immortalized in a unique, personalized artifact.

---

### 6.4 Dynamic Book Page Examples

| Event | Truthful Page (Good Path) | Fractured Page (Evil Path) | Silent Void (Incomplete) |
|-------|---------------------------|----------------------------|--------------------------|
| **Rabinna’s Fate** | “The Bard’s Guild guided Rabinna to Ebonheart. Her freedom was sung as the ‘North-Star Lullaby,’ and the Twin Lamps gained a voice they never had.” | “A Khajiit slave vanished near Hla Oad. The Camonna Tong cleaned up the mess. No one asks questions when the gold flows.” | “A slave girl’s chains broke. Some say a Bard helped. Others say it’s just a comforting song.” |
| **Jiub’s Sainthood** | “At Red Mountain’s summit, Jiub faced the Matriarch Nest. The cliff racer scourge ended, and the Temple anointed him a living saint. The skies cleared.” | “A Dunmer with a death wish found glory on a volcano. The Temple called it a miracle to quiet the masses. The Bards got paid to sing.” | “They say a Nord cleared the skies. Some call him a saint. The Temple moved fast when it profits them.” |
| **Propylon Network** | “Abelle Chriditte and the Bards restored the Propylon network. The ‘Devil’s Tuning Fork’ unlocked ancient resonance, and scholars across Vvardenfell celebrated.” | “A rogue Guild activated old stones. Smugglers and spies now teleport. The Empire demands answers. The Telvanni want control.” | “Some stones sing. Scholars care. Fishermen don’t.” |
| **Umbra’s End** | “Umbra walked away from the cursed blade. In Valenvaryon, he found peace among the Iron Orcs, becoming a Soot Singer. His name was rewritten with honor.” | “The berserker fell. The flame took its due. Orcs sing with the soot to honor Umbra. His story ends in fire.” | “An old warrior died. Some say honorably. Some say not.” |
| **Lost Song Discovery** | “The Bard recovered the ‘Lament of the Unmourned.’ Its completion revealed truths the Temple feared, but the Guild preserved it in the archives for future generations.” | “A dangerous fragment was found. The Guild sold it to the highest bidder. The Temple silenced the witnesses. Truth is expensive.” | “An old song was found. The Temple dislikes it.” |
| **Hist Ritual** | “Argonni’s Deep-Dreaming revealed a Dremora Lord in a Hist cell. The path to Mudan Grotto opened, bridging Hist memory to Dwemer resonance.” | “An Argonian hallucinated in a swamp. The Guild called it a vision. No one saw anything but mushrooms.” | “Something happened in the swamp. The Argonians keep their secrets.” |

---

## 7. Technical & Asset Rules

- **Asset Rule**: 100% vanilla (Morrowind.esm).  
- **Scripting**: One script per item, no dirty edits.  
- **Performance**: High framerate via statics/lights, not high ambient.  
- **Race**: JMCG_Dermora (Dremora head on Dark Elf body).  
- **Follower Logic**: 500-unit follow, 2500-unit teleport failsafe.

---

## 8. Quest Database Summary (Weighted Progress)

| Quest ID | Weight | Status |
|----------|--------|--------|
| The_Bards_Guild | 20 | Core arc |
| JMCG_Tuning_Master | 10 | Propylon network |
| JMCG_Joseph_Personal | 15 | Intelligence network |
| JMCG_The_Chroniclers_Saint | 15 | Jiub finale |
| JMCG_Hist_Lore | 10 | Argonni ritual |
| JMCG_Imperial_Buisness | 10 | Rabinna/Twin Lamps |
| JMCG_Twin_Lamps_Hymn | 10 | Slavery liberation |
| JMCG_Shane_Lore | 5 | Orc poet arc |
| ... | ... | (22 total tracked) |

---

## 9. Implementation Checklist

- [ ] Place `jmcg_resonance_cache` markers in 9 Propylon chambers.  
- [ ] Test Falasmaryon activator + Lua message box.  
- [ ] Write “Tavern Review” dialogue for Joseph’s PR arc.  
- [ ] Finalize Mudan Grotto Lore Vault cell.  
- [ ] Implement “Pied Piper” bone-flute activator.  
- [ ] Add “Lost Resonance” endgame quest.  
- [ ] Balance ModFactionReaction shifts for PR outcomes.  
- [ ] Tune Bardic Influence HUD refresh rate.  
- [ ] Verify all 22 quests are in lowercase in the database.  

---

## 10. Quick Reference: Core Files

| File | Purpose |
|------|---------|
| `overview1.txt` | Project sync, quest status, technical notes |
| `Quest draft.txt` | Full narrative draft, instruments, characters |
| `Dwemer memory.txt` | Dwemer pocket, Yagrum’s anchor, tonal lore |
| `hermasRelam.txt` | Margin of the World, memory pockets, rules |
| `RelamQUestsideas.txt` | Retcon loops, paradox scenarios |
| `Rumor_Echo_System.txt` | Tavern propagation, rumor tables |

---

**End of Compendium**  
*Prepared for implementation. All narrative, systems, and lore in one place.*
