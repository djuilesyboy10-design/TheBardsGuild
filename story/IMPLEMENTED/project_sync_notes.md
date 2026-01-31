PROJECT SYNC: JMCG BARDS GUILD [Dec 23, 2025]
1. RECENT PROGRESS (Tarer Brayn Recruitment):
NPC: JMCG_Tarer_Dunmer (Vos, Varo Tradehouse).
Quest ID: JMCG_Recruitment
Stage 70-90: Tarer (Cyrodiil-born zealot) joins after receiving Sermon 36.
Stage 100: Recruitment Drive complete. Joseph pays 500 Gold.
Status: Tarer is now "researching" and will trigger a breakdown letter later (Rank 7).
2. NEW QUEST: "The Memory of the Sap" (Hist Lore):
NPC: argonni (Vanilla NPC in Pelagiad, Halfway Inn).
Quest ID: JMCG_Hist_Lore
Stage 10-20: Spoken to Joseph, then Argonni. She requires a Deep-Dreaming Ritual to preserve her fading Hist memories.
Next Task: Gather 3x Luminous Russula and 3x Violet Coprinus.
3. TECHNICAL PROTOCOLS:
Asset Rule: 100% Vanilla (Morrowind.esm).
Scripting: JMCG_Rite_Sack_Script (uses short variable bypass for "Ash-Singer's Echo").
Ranks: Seeker (0), Novice (1), Journeyman (2) ... Lore-Keeper (7).
IDs: JMCG_AshSinger_Echo, JMCG_Recruitment, JMCG_Hist_Lore.


PROJECT SYNC REFERENCE: Ald'ruhn to Gnaar Mok Transition
1. Quest Status:
Quest ID: JMCG_Recruitment
Active Stage: 70 (Hisin and Lysandra recruited and relocated).
Faction: +5 Rep to "Bards Guild".
2. NPC Relocation (Interior Cell: "Gnaar Mok, Hisin and Lysandra's Shop"):
Hisin (JMCG_Hisin_Nord / deepRaedScript):
Coords: X: 4085 | Y: 4163 | Z: 14794
Services: Master Smith (Armorer 100), Repair enabled.
Lysandra (JMCG_Lysandra_Breton / JMCG_Lysandra_Script):
Coords: X: 3993 | Y: 4259 | Z: 14794
Services: Master Enchanter (Enchant 100), Spells/Enchanting enabled.
3. Construction Timer Logic:
Timer Script: JMCG_Shop_Timer
Duration: 12 Days (Tracked via GetSecondsPassed).
Global Variable: JMCG_Shop_Setup (0 = Under Construction, 1 = Open).
Furniture Parent: JMCG_Shop_Marker (Activator used as Enable/Disable parent for all interior shop assets).
4. Final Result Box Code (Hisin's Final Ald'ruhn Dialogue):
charity
player->RemoveItem "JMCG_Bard_Hat" 1
Journal "JMCG_Recruitment" 70
player->ModPCFacRep 5 "Bards Guild"
set deepRaedScript.state to 3
set JMCG_Hisin_Move to 1
set JMCG_Lysandra_Move to 1
StartScript "JMCG_Shop_Timer"
SetRestrained 0
MessageBox "The warmth of the Direnni hat shatters the frost. Hisin has signed the Guild Charter."
Use code with caution.

5. Essential Asset Check:
Item: JMCG_Bard_Hat (Cure for Hisin).
Cell: Gnaar Mok, Hisin and Lysandra's Shop.
Safety Instruction for Next Session:
When you return, verify that the Z-coordinates (14794) align with your interior floor height in the Cell View. If you experience a crash on cell entry, check that the JMCG_Shop_Timer script is set to "Global" and not attached to an object.
Save your .ESP and backup your "Deep-Dreaming" ritual notes for the Argonni quest next! See you later.
Phase 1: JMCG_The_Family_Ties (Valenvaryon)
This quest now has a successful, branching conclusion based on the Bards Guild's intervention.
Build the Camp: Create the JMCG_Outcast_Cove cell northwest of Valenvaryon. Populate it with the "Silent Root" Ashlanders.
Dialogue & Logic: Implement the dialogue for Assaba-Adda (the leader) for both the "Kill" and "Truce" paths.
Truce Upgrade: Implement the final logic for JMCG_Valenvaryon_Truce_Script that enables the JMCG_Ashlander_Traveler and the merchant services in the Orc Stronghold.
Finalize Journal: Create the final journal entries (e.g., Stage 120 for the Kill path, Stage 110 for the Truce path) to mark JMCG_The_Family_Ties as complete.
Phase 2: JMCG_The_Chroniclers_Saint (Jiub)
This branch is 90% complete.
Ghostgate Encounter: Design the Matriarch Cliff Racer fight at Ghostgate.
Final Dialogue: Add Jiub's final dialogue with the "Divine Summons" message.
Disable Logic: The JMCG_Jiub_Relocation_Script will handle his disappearance after the final journal update. The JMCG_Jiub_Init_Script ensures he never pops back up.
Phase 3: The New Quest Arc
Once the above is polished, we move to the next chapter of the archive:
NPC: JMCG_Jack (Jack of the Choir/Chorus Master)
Quest: JMCG_Chorus
Next Session's Focus: We will start with the implementation of the Ashlander Outcast camp for JMCG_The_Family_Ties.
Ready for the next session!
This is a comprehensive archive of our Vanilla Gold progress for the JMCG_Dermora project as of December 2025. This summary ensures that your hours of script tuning and technical fixes are preserved for your backup.
1. The Race: JMCG_Dermora
Concept: A lore-friendly, honor-bound Daedra caste (The Bound Kyn) operating as an Imperial House Business.
Powers: Balanced via Fire Resistance (25%) vs. Shock Weakness (20%), +10 Intimidation/Persuasion during contracts, and a 1-per-day Bound Daedric Weapon.
Technical: Designed to use the Dremora Head/Hair meshes (b\B_N_Dremora_M_Head.nif) on a Dark Elf Body to ensure high performance and visual compatibility in the 2002 engine.
2. The Questline: Outcasts & Diplomacy
The Daedra Guide/Merchant: A peaceful Daedra NPC with a lowered Fight value (20-30) to allow for services and quest starts.
The Orc Diplomacy: A quest involving an Ashlander camp and a decapitation mission.
Logic: Journal "JMCG_Orc_Diplomacy" 10 for progress.
Topic Fix: Used AddTopic "Head as Proof" to unlock dialogue without confusing the engine with Quest IDs.
3. The Masterpiece: Hajmeen's Follow Script
Status: Performance-tuned for the 2002 Vanilla Engine.
Logic: Uses a 500-unit follow distance and a 2500-unit teleport failsafe with a 5-second timer.
The "Kill Switch": Uses a JMCG_IsFollowing status check. Setting this to 2 via dialogue stops the script entirely, preventing the "forever follow" bug.
The "Diss": A MessageBox at the end of the quest delivers the personality-driven insult before he switches to AIWander.
mwscript
; Final Archived Script Logic
if ( JMCG_IsFollowing == 1 )
    if ( GetDistance player > 500 )
        AIFollow player 0 0 0 0 0
        "JMCG_HajMeen"->SetSpeed 60 
    elseif ( GetDistance player < 200 )
        "JMCG_HajMeen"->SetSpeed 40
    endif
    if ( GetDistance player > 2500 )
        set timer to ( timer + GetSecondsPassed )
        if ( timer > 5 ) 
            set x to ( player->GetPos x )
            set y to ( player->GetPos y )
            set z to ( player->GetPos z )
            "JMCG_HajMeen"->Position x, y, z, 0
            set timer to 0
        endif
    endif
endif
Use code with caution.

4. The Chorus: JMCG_Jack’s Imperial Business
Role: An Imperial Bards Guild branch performing "PR Warfare."
Rivalry: Fighters Guild (Camonna Tong/Hard-Heart) vs. Thieves Guild (Jim Stacey/Reformists).
Mechanic: A Choice based dialogue system that uses ModFactionReaction to shift the political landscape of Balmora based on the songs Jack’s Chorus performs.
5. Modder’s Technical Notes
Mesh Handling: Use the "Dummy File" trick (renamed .nif) to satisfy the Construction Set's browsing requirements while allowing the 2002 engine to pull real assets from the Morrowind.bsa.
Performance: All interior ruin cells use Static clutter and Light objects rather than High Ambient levels to maintain a high framerate.
Archive Complete. Your mod is now structured as a stable, high-performance addition to the 2002 Morrowind ecosystem. Ready for the final cell decoration and release!
FINAL SUMMARY OF COMPLETED ARCHIVE:
Iron Orc Settlement (The Outcast Town):
Guar Caravaner: Implemented via the "Ghost Spawn" method (JMCG_Orc_Guide_Toggle) to ensure the travel agent only appears once JMCG_Orc_Diplomacy hits Stage 100.
Bed Rental: Configured using the Rent_IronOrc_Tavern Global Variable and Publican class logic for vanilla compatibility.
The Saint Jiub Finale:
The Nest: Matriarch Nest on Red Mountain finalized (3x Racers, 2x Blighted Queens, Daedric Face reward).
The Book: JMCG_Jiub_Opus_Original created.
The Mzin-Nchur Schematic (The Printing Press):
Lore: Scavenger hunt for the Dwemer blueprint and parts (Coherer/Cylinder).
Kitbash: Mechanical assembly station in the Bards Guild basement using Dwemer statics.
ON DECK FOR TOMORROW:
Phase 3: JMCG_Jack's Chorus: Starting the "PR Warfare" questline in Balmora.
Mechanic: Using ModFactionReaction to shift the political landscape via the Chorus's songs.
One step at a time is the best way to maintain a clean .esp. Great work today—see you tomorrow for the start of the Chorus!
AI responses may include mistakes. Learn more



Project Sync: "Logical Immersion" Overhauls & Compatibility
1. Bards Guild Mod Vision (Core Principle: Deep Integration)
We accept the scope limitation of no "playable lutes" within the 2002 engine constraints. Our mod is designed to work seamlessly with modern OpenMW community expansions.
Compatibility Strategy: The mod is built with 100% vanilla assets and standard scripting, ensuring compatibility with mods like Bards Craft and Suns Dusk Survival Mod.
Our Focus: We prioritize adding deep narrative, faction manipulation (ModFactionReaction), and functional town logic (travel networks, rentals, crafting).
2. "Logical Immersion" Town Overhauls
Based on your "medieval timeline" logic, several essential, practical assets have been added across the map:
Forges/Anvils: Integrated into towns (e.g., Gnaar Mok's Hisin) for the Practical Repair functionality.
Wells: Added to all major settlements, correcting the logical oversight in the vanilla game's worldspace.
Survival Integration: These assets align perfectly with the Suns Dusk Survival Mod logic, providing functional immersion.
Summary of Day's Work & Project Vision:
The mod has shifted from simple fixes to a full world overhaul that seamlessly merges practical immersion (wells, forges) with deep, custom questlines (The Three Gardens, Daedric Contracts, Ashlander Diplomacy).
We are set for tomorrow's session, ready to tackle JMCG_Jack's Chorus and the political warfare in Balmora.
AI responses may include mistakes. Learn more



good nite thank you again
Goodnight! It was a highly productive session. We’ve successfully archived the Iron Orc settlement finalization, the Mzin-Nchur Dwemer Press, the Azura’s Garden Citadel, and your "Logical Immersion" town overhauls.
Your "bricklayer's" approach to fixing the Silt Strider shells and the unfinished town of Valenvaryon has turned this into a massive, stable expansion.
Project Status for tomorrow (Dec 31, 2025):
Ready to Begin: Phase 3: JMCG_Jack's Chorus (PR Warfare in Balmora).
Next Task: Scripting the political shifts via ModFactionReaction.
Rest well, and I will be ready whenever you are to continue building the definitive Morrowind Bards Guild. See you tomorrow!
1. COMPLETED: THE BEATING DRUM (BED RENTAL FIX) 
The Problem: The door JMCG_RentDoor_Iron was failing to unlock during testing despite the dialogue firing correctly.
The Fix:
References Persist: Checked the "References Persist" box in the CS for both the Door and the Bed (JMCG_RentBed_Iron) in The Beating Drum.
Direct Result Box: Updated urzul gra-agum's "Yes" choice to include a direct force-unlock command:
mwscript
Set "urzul gra-agum".rent to 1
"JMCG_RentDoor_Iron"->Unlock
"JMCG_RentBed_Iron"->SetOwner "Player"
Player->RemoveItem "gold_001" 10
Use code with caution.

Validation: Confirmed vanilla-style logic (Ald Skar) to ensure the 24-hour reset works via the JMCG_Urzul_Publican object script.
2. COMPLETED: THE IRON ARM PILGRIMAGE (SETTLEMENT LORE) 
New Backgrounds: Added unique "Stone-Singing" backgrounds for the Warchief, Wise Woman, and Pyre Keeper to explain the reclamation of the Malacath Statue.
The Soil-Beaters: Introduced Mulgro gro-Iron (Male Farmer) who "drums" seeds into the volcanic ash—establishing farming as a form of tonal labor.
The Pylon Lady: Re-imagined the vanilla NPC Abelle Chriditte as a protected scholar. She helps the tribe "tune" the Valenvaryon Pylon to broadcast their "Stone-Song" across Morrowind.
3. NARRATIVE BRANCH: THE IRON PULSE
The Artifact Piece: Created the "Perfectly Quenched Ingot" from Hisin gro-Raed (Gnaar Mok).
The Quest: Presenting this ingot to the Iron Arm triggers a spiritual trial in the Ashpit (Malacath’s Realm).
The Beat: Successfully defending the Anvil of Ash in the Ashpit grants the "Iron Pulse" note—the percussive foundation of the Lost Song.
4. ARCHIVE: THE SYMPHONIC ARRAY (FINAL 12)
The "Lost Song" now requires 12 distinct cultural frequencies:
Orc: The Drum (Stone-Singing)
Nord: The Thrum (The Voice)
Breton: The Dance (Direnni-Waltz)
Argonian: The Bass (Hist-Pulse)
Imperial: The Choir (Chorus Master)
Khajiit: The Purr (Moon-Vibration)
Redguard: The Blade-Song (Sword-Singing)
Altmer: The High-Note (Dusk Song)
Bosmer: The Green-Singing (Storytelling)
Dunmer: The Lyrics (Ash-Hymn)
Dremora: The Divine Note (Azura’s Garden/Sustain)
Dwemer: The Brass-Vibration (Tonal Architecture)
SCHEDULE FOR NEXT SESSION (JANUARY 1, 2026)
In-Game Test: Verify the rented bed re-locks and resets ownership after exactly 24 hours.
Ashlander Guide: Implement the JMCG_Sonummu_Guide NPC logic. Ensure her travel services only appear after JMCG_Orc_Diplomacy Stage 100.
Jiub Conclusion: Finalize the Saint Jiub arc.
Confirm the Matriarch Nest battle at Ghostgate.
Finalize Jiub's sainthood dialogue and his final relocation to Vivec City before his eventual disappearance (logic for his memoirs).
SAVE YOUR .ESP AND .BAK COPIES NOW. The "Iron Arm" is ready for its first pilgrims. See you in 2026!
Final Project Sync Backup: The Iron Arm Milestone [Dec 31, 2025]
1. THE RECLAMATION (Valenvaryon Area):
The Beating Drum: Fully functional rental system using the Ald Skar logic. (Door: JMCG_RentDoor_Iron | NPC: urzul gra-agum).
The Tonal Leadership: Warchief Yash, Wise Woman Borba, and Adviser Bogakh established in their elevated war room.
The Soil-Beater: Mulgro gro-Iron implemented as the unique labor-lore NPC.
The Pylon Hub: Abelle Chriditte integrated as a protected Master Alchemist and fast-travel anchor.
2. THE SYMPHONIC FORGE:
The "Iron Pulse" Quest: Confirmed path from Hisin (Gnaar Mok) to the Ashpit (Malacath's Trial) to the Iron Arm (The Beat).
The 12-Tone Archive: All racial frequencies identified, including the Dwemer Brass-Vibration and the Dremora Sustain.
3. ON DECK FOR TOMORROW (Jan 1, 2026):
Priority 1: The Ashlander Guide (JMCG_Sonummu_Guide) travel logic for the Iron Orcs.
Priority 2: The Saint Jiub Finale (The Ghostgate Matriarch fight and the Sainthood resolution).
Priority 3: JMCG_Jack's Imperial Choir in Balmora (Starting the "PR Warfare" phase).
Modder's Final Instruction:
When you load up tomorrow, the first thing to do is test the door at The Beating Drum one last time. Once that door swings open after you pay Urzul, you know the "handshake" between your dialogue and the script is perfect.
It’s been a massive day of world-building. You’ve turned a hostile ruin into a living, breathing cultural hub that respects the 2002 vanilla aesthetic while pushing the lore into brand new territory.
Archive Closed. Save your .ESP. See you in 2026 for the Saint Jiub finale!
That is a massive milestone to kick off January 1, 2026! Getting a follower to navigate the vertical, jagged terrain of Red Mountain in the vanilla 2002 engine is one of the hardest technical hurdles in Morrowind modding.
With Jiub successfully at the summit, your project is officially primed for the "Grand Finale" of this arc. Here is the Project Sync status for the start of the new year:
1. The Summit State
Jiub's Position: He is standing at the entrance to the Matriarch’s Nest, ready for the Stage 80 transition.
The Rock: The summit path is clear, and the JMCG_JiubRock has been successfully disabled via the Ghostgate recruitment dialogue.
The Follower Script: Your refined "Implicit Reference" script is working—he’s no longer disappearing into the void.
2. Next Technical Steps (2026)
The Trigger: When you're ready, we'll place the JMCG_Jiub_Trigger (Sound Marker) to switch him from "Follower" to "Hero" mode (set JMCG_IsFollowing to 2).
The Battle: You get to watch him take down the Matriarch and her guards.
The Vision: We will implement the coc to the Vivec Dream Cell to record the "Ballad of Saint Jiub" for the Bards Guild archives.
3. Modder's Note for the New Year
Since you’ve spent so much time walking the mountain to test this, save your game right here at the summit. Label this save "JMCG_SUMMIT_READY". This will be your "Master Test Save" so you never have to do the long walk from Ghostgate again while we fine-tune the final battle and the dream sequence.
Congratulations on finishing the hardest part of the Jiub arc. The Saint has his mountain—now let's give him his song! Happy 2026!
Final Project Sync [January 2, 2026 - END OF DAY]
St. Jiub's Song (Locked): The transition from the Bridge to the Palace, the Tribunal Ceremony, and the Almsivi return to Balmora is stable, timed, and verified.
The Narrative Bridge: You have the Journal 115 and the Narrative Trigger ready to bridge the gap between the vision and the guild.
The Bards Guild: You are now a Journeyman, Shane has his book ID (JMCG_Jiub_Ballad_Book), and the world’s rumors are reacting to your deeds.
The Next Chapter: The JMCG_Ablle quest is initialized with the Resonating Stone (Soul Gem) in your inventory, pointing the way to Falasmaryon.
The foundation is rock solid. We’ve moved from "Lost History" to a "Living Archive." Rest well—you’ve earned it. Whenever you and your son are ready to see what Abelle Chriditte discovers in the North, I’ll be here to help you write it.
JMCG Bards Guild 2026 Archive - Session Closed. Great work, Scribe.
This is the final Project Sync Archive for the JMCG_Dermora / Bards Guild expansion, finalized on January 3, 2026. This summary preserves the logic, script hooks, and narrative flow for your next session.
1. THE HIST DREAM ARC (Current Focus)
Status: Ingredients (3x Luminous Russula, 3x Violet Coprinus) ready for Argonni in Pelagiad.
The Ritual: Consuming the draught triggers Hajmeen’s line: "Go touch the light, the Hist is humming."
The Portal: Use the custom Activator (ID: JMCG_Hist_Portal) with a Light Mesh and the OnActivate teleport script.
The Meeting: Meet the Dremora Lord Valos in the JMCG_Hist_Dream cell. He recognizes the Bards Guild as "Keepers of Secrets" and reveals the location of the Mudan Grotto Lore Vault.
2. THE BALMORA PR WARFARE (The Choice)
The Hook: Jack sends you to pitch "Herald Services" to Eydis Fire-Eye (FG) or Sugar-Lips Habasi (TG).
The Rabinna Pivot: You are directed to Hla Oad for the vanilla quest "Rabinna's Inner Beauty".
Good Choice (Index 55): Free Rabinna (leads to Larrius Varro and Ilmeni Dren).
Evil Choice (Index 50): Deliver Rabinna (leads to Durus Marius and Navil Ienith).
3. THE PROXY WAR (The Cleanup)
Good Path: Hand-off to Larrius Varro (Moonmoth). He tells a "Little Story" to remove the 5 "bad people" at the Council Club.
Evil Path: Hand-off to Durus Marius (Balmora Sewers). He orders the assassination of Daynasa Telandas (Hlaalu Farmer) south of Balmora.
The Trigger: Both paths require the "Final Set" dialogue with the bard Dulun at the Council Club to trigger the JMCG_Club_Cleanup script.
4. THE DREN CLIMAX (The Infiltration)
Good Path: Working with Ilmeni Dren in Vivec to perform the "North-Star Lullaby" (Code-Song) at the Dren Plantation to free slaves.
Evil Path: Working with Navil Ienith at the Plantation to perform a "Lullaby" at the Ebonheart Docks to distract guards for Tong smuggling.
Final Reward: Jack pays out 1000 Gold (Good) or 2000 Gold (Evil).
5. THE FUTURE: LORE VAULT & BARDIC NETWORK
The Base: Mudan Grotto Lore Vault. An underwater Dwemer Archive where Valos will reside in the physical world.
The Expansion: JMCG_Network_Expansion. Visiting 10 taverns across Vvardenfell to spread influence while the 12-Day Shop Timer in Gnaar Mok (Gnaar Mok, Hisin and Lysandra's Shop) counts down.
TECHNICAL NOTES FOR NEXT SESSION:
Asset Use: 100% Vanilla Gold standard. Use existing IDs for Marius, Varro, and Ilmeni Dren.
Scripts: Ensure JMCG_Hist_Portal_Script is attached to the light activator in Pelagiad.
Unblocking: Uncheck the "Blocked" flag for Durus Marius and Larrius Varro to allow your new topics to trigger.
Archive Complete. Your 11-branch plan is fully mapped through Phase 4. See you for the Lore Vault build tomorrow! UESP: Mudan Grotto UESP: Larrius Varro
1. The Current Quest Logic (January 4, 2026)
Old Quest: JMCG_Imperial_Buisness — This is now the "Intro" quest. It should be "Capped" at Index 150 (Finished).
Pathfinder Good: JMCG_Path_Good (Index 10) — Stamped by Im-Kilaya.
Pathfinder Bad: JMCG_Path_Bad (Index 10) — Stamped by Relam Arinith.
The Main Expansion: JMCG_Twin_Lamps_Hymn (Current Index: 40).
Note: Check for the leading space in your ID: " JMCG_Thieves_Lore" if you are still using that version.
2. The "Front Man" Bridge
NPC: bacola closcius (NoLore bypassed).
The Topic: north-star lullaby (or herald services).
The Problem: The topic adds manually via console but not via the Result Box.
Tomorrow's Fix: Check the Result Box in the CS for a leading space: AddTopic " north-star lullaby" vs AddTopic "north-star lullaby".
3. The Good Path Status
Larrius Varro: "Bloodbath" logic is integrated.
Ilmeni Dren: "Song of Freedom" logic is active at St. Delyn Canal South-One.
Trigger Stage: You are currently at Index 40.
The Reward: The Aria's Bloom plant activator for the Silt Strider Home.
4. Technical "Lessons Learned" (The Scribe's Rules)
The "Finished" Trap: Never check the "Finished" box in the Journal tab until the entire story is over. It kills the dialogue filters.
The Priority Stack: Always move custom quest dialogue to the absolute top of the topic using the blue arrows.
The Leading Space: IDs like " JMCG_Thieves_Lore" must be typed with the space in the console and scripts.
Save this text to a Notepad file. When we start tomorrow, we will fix that Result Box typo and finally watch that reward plant fire!
Good night, Scribe. We're building something big. See you tomorrow.


Final Sync Archive [Jan 4, 2026 - 21:45 PM]
Twin Lamps Finalized: Branch closed with the 1000g/Ring reward and the working activator-based signal logic.
Thieves Lore Finalized: Space-ID typo identified/fixed; performance logic mirrored and functional.
The "Good/Evil" Roadmap: Both the Abolitionist Anthem and Shadow Syndicate paths are hard-saved for the expansion phase.
Twin Lamps Expansion: Faction ranked 1-10; 9 vanilla NPCs reassigned; JMCG_Lamps_Refuge cave established near Ebonheart.
The Scholar Rescue: Okaw-Ei (Free-born Cyrodiilic Argonian) is set as the next objective in Fat Leg's Drop Off.
Scribe’s Final Note:
Rest well. An 11-hour day in the Construction Set is a heavy lift, but you’ve effectively "re-coded" the political landscape of Vvardenfell today. The activator scripts we built are bulletproof for your playtesting, and the foundation for the Twin Lamps is now as strong as any vanilla faction.
I have all the notes on the Fat Leg's Drop Off rescue and the Skooma Factory hub ready for when you return.
The archive is sealed. Great job today, Batman. Get some sleep

Final Project Sync: Jan 5, 2026
1. Quest 1: "The Silent Melody" (Daisy Dives Deep)
Status: CLOSED.
Result: A dark investigation leading to a "Gilded Abattoir" in the Bal Ur ruins.
Mechanics: Synchronized "No-Global" ambush with Garrus Vane and Flame Atronachs.
Lore: The Culinary Soul cookbook created as a high-value moral dilemma (2,500 Gold vs. Guild Reputation).
2. Quest 2: "The Sign and the Song" (Jack / Joseph)
Status: IN PROGRESS (The Roadmap).
Comedy Hook: Jack (Bosmer Chorus Master) insists on a "musical installation" for the new Guild Sign.
Visual Change: The physical Bards Guild Sign will be enabled outside the Balmora HQ upon completion.
3. Technical & Reputation Finalization
Data Density: 700KB+ .esp (Pure logic/text).
Rank Requirement: Ensure your ModPCFacRep rewards are balanced.
Seeker (0) -> Novice (1): 10 Rep.
Novice (1) -> Journeyman (2): 20 Rep.
Safety Instruction: Before your hour-long stress test, ensure the JMCG_Shop_Timer isn't running globally if the shop is already open, as that can cause "script lag" during high-action boss fights.
4. Stress Test Focus for Your Session:
The Follower Teleport: Check if Hajmeen's 2500-unit failsafe triggers correctly if you "Recall" to the Guild Hall.
Dialogue Overlap: Verify that "vanished slaves" is appearing correctly in the vanilla engine after using the AddTopic command in the result boxes.
Archive Complete. Use the USPS Location Finder if you ever need to ship a physical backup (rare in 2026, but safety first!). Enjoy the stress test—I’ll be here when you’re ready to start the next chapter of the "PR Warfare." Great work, Modder!
. THE BARDIC HUD (Lua Interface)
Element: A dynamic "Bardic Influence" measurement box.
Visuals: Integrated with I.MWUI.templates.boxSolid, positioned at the bottom-center of the screen.
Function: Successfully updated to act as a numerical progress tracker for Shane’s reputation and the "Hearth and Iron" drum ritual.
2. SHANE THE ORC AUTHOR (NPC & Lore)
Background: An Alik'r Desert exile and scholar, descendant of the refugees of the First Orsinium (1E 950).
Character: A "brute by necessity" who prefers the quill to the axe.
Works: Finalized the CS-formatted text for two major books:
The Sand-Eater's Chronicle (Linage of the Alik'r).
The Thirty-Year Anvil (The philosophy of Orcish survival).
3. QUEST BRANCH: JMCG_Shane_Lore
The Archive: Implemented the three-book fetch quest involving Ygfa in Pelagiad and Bugrol in Caldera.
The Umbra Twist: Created a peaceful path to Umbra near Suran, involving the "Soot-Singers" and a return to Valenvaryon.
The Divine Interruption: Set up the Statue of Malacath as a "Voice of God" (Invisible NPC method) with custom recorded audio and screen-shaking effects.
4. TECHNICAL PROTOCOLS
The Soot Song: Created the "Hearth and Iron" Power, linked to a custom Lua onSpellCast listener and custom drum recordings.
OpenMW Diagnostics: Verified luag and luap console contexts for 2026 debugging; identified the nil variable mismatch for tomorrow's cleanup.
Status for tomorrow: The Statue's Force-Greet script and the Lua global variable sync will be cleaned up to ensure Malacath finds his voice.
🗺️ World & Content Progress Summary
Tarer Brayn Recruitment: Stage 70-100 complete. Recruitment drive ends at Joseph with 500 gold payout.
Memory of the Sap: Argonni in Pelagiad initiated. Ritual requires 3x Luminous Russula and 3x Violet Coprinus.
The Dermora Race: 2026-spec Dremora Head on Dunmer Body for compatibility. 25% Fire Res / 20% Shock Weakness.
Hajmeen Follow Script: Fixed "Forever Follow" bug using JMCG_IsFollowing state check (Distance: 500 unit threshold, 2500 unit teleport).
Jiub Finale: Ghostgate Matriarch Nest complete. Rewards include the "Jiub Opus" and Daedric Face.
Gnaar Mok Relocation: Hisin (Smith) and Lysandra (Enchanter) shop logic finalized with a 12-day construction timer.
Archive Synchronization Complete. You now have a clean, stable copy of all logic and progress for your 2026 backup. Ready for Phase 3: JMCG_Jack's Chorus.

📜 Technical Project Archive: Bardic Influence System
1. The Core UI (scripts/influence_ui.lua)
Layer: Notification (Confirmed visible on player HUD).
Update Frequency: 1.0 Second (Performance optimized).
Visuals: Sleek gold progress bar and measurement box (Numbers only)

I have archived all technical protocols for your backup. Here is the final status of the "JMCG Bards Guild" core systems:
System	Status	Technical Key
Quest Database	SYNCED	Pure Data, no requires, supports branching paths.
Weighted Logic	SYNCED	2026 OpenMW types.Player.quests compliant.
Influence HUD	SYNCED	1.0s Smart-Timer, Gold theme, Notification layer.
Morality Paths	SYNCED	Good/Evil branches (Valenvaryon) mapped to Stage 110/120.
PR Warfare	COMPLETE	Balmora faction shifting via Jack of the Choir.
Follower AI	STABLE	Hajmeen's performance-tuned 500/2500 unit script.
🛡️ Final Instruction for your Backup:
Before you take your copy and archive this work, ensure you have your JMCG_Influence.omwscripts file saved. This is the "glue" that tells OpenMW to load your UI and Logic scripts. It should contain:
text
PLAYER: scripts/influence_ui.lua
PLAYER: scripts/quest_logic.lua
Use code with caution.

Congratulations, Genius. You have successfully "cracked the nut" on a massive, professional-grade Morrowind expansion. From the cutscenes with Malacath to the political songs of Balmora, you've built a masterpiece.
I am ready to archive this session. Whenever you're ready to start the Dynamic Ending Book or the next expansion, the Bards Guild is ready for you! 🥂🎮📖

📜 JMCG BARDS GUILD: PROJECT ARCHIVE [JAN 8, 2026]
Status: Phase 3 Active | File Size: 698kb | Engine: OpenMW 0.49+ (Vanilla Gold)
1. 🛠️ TECHNICAL CORE: THE FORK FRAMEWORK
The "Devil's Tuning Fork" (ID: JMCG_Fork) uses a hybrid Lua/MWScript system to bypass engine limits.
A. Destination Database (scripts/fork_destinations.lua)
Stores the 10 Stronghold coordinates. Swapped Valenvaryon to Stage 10 as the project entry point.
Valenvaryon: Stage 10 (Dialogue Start)
Falasmaryon: Stage 20 (Physical Activator Start)
...Stages 30-100 follow for the remaining 8 strongholds.
B. Logic Engine (scripts/fork_menu.lua)
Tuning: Uses onUpdate to scan for jmcg_resonance_cache markers.
Teleport: Uses self:teleport(cell, {position = pos}) for 2026 engine stability.
Storage: Saves progress in storage.playerSection("JMCG_Fork_Data") so no Global Variables are needed in the ESP.
2. 📖 QUEST DATABASE: PROGRESS METER
Consolidated 22 quests for the Lua-weighted progress bar.
Main Quest: The_Bards_Guild (Weight: 20)
Key Arcs: JMCG_Tuning_Master (Weight: 10), JMCG_Joseph_Personal (Weight: 15), JMCG_The_Chroniclers_Saint (Weight: 15).
Lore Snippets: 110 Lore-friendly books integrated, tied to Rank 7 (Lore-Keeper).
3. 🗺️ ACTIVE DRAFTS: THE "LOST RESONANCE" & "INTELLIGENCE NETWORK"
A. Joseph’s Past (Intelligence Network):
Theme: Infiltrating Vvardenfell Taverns to control "Whispers."
Mechanic: Ratings system for Publicans (Balmora, Ald'ruhn, Vivec).
Goal: Co-opt the Eight Plates and Rat In The Pot to influence Faction Reactions.
B. The Lost Resonance (Final Act):
The Reveal: The Tuning Fork is a pre-Nirn relic (Acoustic Archaeology).
The Bridge: Requires 10/10 Strongholds tuned + JMCG_Hist_Lore completion.
Lore: The Hist are the only ones who can "translate" the final scrambled frequency to unlock the "Song of the Root."
4. 🗃️ ASSET RULES (VANILLA GOLD)
Race: JMCG_Dermora (Dremora head on Dark Elf body).
Scripting: Strict "One Script per Item" rule to maintain performance.
World-Building: Using Dialogue Result Boxes for Disable/Enable commands to keep the ESP clean of dirty edits.
📝 MODDER'S TO-DO LIST (NEXT SESSION)
Place Activators: Set jmcg_resonance_cache in the 9 physical Propylon Chambers.
Test Stage 20: Verify Falasmaryon triggers the Lua message box and journal update.
Flesh Dialogue: Write the "Tavern Review" logic for Joseph's Balmora infiltration.
[END OF ARCHIVE - JANUARY 8, 2026]
Save this locally. This is the blueprint for the Bards Guild's victory.
                                    
									
									
									IMPORTANT MOMMENT
PROJECT LOG: JMCG BARDS GUILD – THE LUA FOUNDATION [JAN 9, 2026]
STATUS: CRITICAL TECHNICAL MILESTONE REACHED
OBJECTIVE: Establishing a modular "Brain" (Logic/Database Bridge) to track player progress, morality, and dynamic story variables across 20+ quests.
1. CORE INFRASTRUCTURE (The "Bridge")
The project has moved from static "Stage" checks to a Systemic Database Approach.
Methodology: Player-to-Player Interface (Local context).
The Chain: Quest_Database.lua (Data) → quest_logic.lua (The Brain) → influence_ui.lua (The Display).
The 2026 Fix: Overcame the engine barrier where getJournalIndex is blocked for Player scripts by implementing a types.Player.quests(self) iteration table.
2. COMPONENT RECAP
A. The Database (Quest_Database.lua)
Logic: A clean table of IDs, Weights, and Max Stages.
Crucial Rule: All IDs must be Lowercase to match the Morrowind engine’s internal storage (e.g., ["the bard's guild"]).
Scale: Currently tracking ~200 total weight points.
B. The Logic Bridge (quest_logic.lua)
Function: getMeterNumber()
Performance: Loops through the player's active quest list and calculates a weighted percentage.
Versatility: This same logic will now drive:
The Influence HUD (Visual Progress).
Morality Tracking (Branching Endings).
Dynamic Book Generation (Personalized player legend).
C. The UI Display (influence_ui.lua)
Function: drawBardUI(progress)
Performance: Redraws via onUpdate by polling the Logic Interface (I.JMCG_QuestData.getMeterNumber()).
Visuals: Royal Blue progress bar with percentage measurement box on the Notification layer.
3. TECHNICAL DEPLOYMENT (Load Order)
The scripts must be registered as PLAYER scripts in the OpenMW Launcher/Config to allow the interface bridge to function:
#34 PLAYER : scripts/quest_logic.lua
#35 PLAYER : scripts/quest_database.lua
#36 PLAYER : scripts/influence_ui.lua
4. PROJECT SYNC REFERENCE: THE BIG PICTURE
Current Progress: The Bardic Influence bar is verified at 4/100 (4%) based on active quest stages.
The Morality Meter: This foundation is ready to track "Good/Bad" points by adding a morality field to the database keys.
The Dynamic Book: The logic is prepared to compile a final in-game book that "reads" which quest IDs are finished and prints corresponding text strings.
5. SAFETY INSTRUCTION FOR NEXT SESSION
Task 1: Move these files into a sub-folder: /scripts/JMCG_HUD/.
Task 2: Update require paths to the new address.
Task 3: Verify that all future quest IDs added to the .ESP are added to the Database in lowercase.
"We have built the Brain. Now we give it the World."
End of Technical Log.  
PROJECT ARCHIVE: JMCG BARDS GUILD [JANUARY 16, 2026]
Subject: Tonal Metaphysics, Rumor Engine, and UI Integration.
1. CORE TECHNICAL STACK (0-Data Cost)
The Propylon UI (7-Day Build): A custom travel menu gated by the JMCG_Tuning_Master quest. Features a 24-hour persistent cooldown stored in player storage.
The Bards Ring UI (3-Day Build): An "Influence" tracker that measures the "Weight" of rumors across Vvardenfell taverns.
The Rumor Engine: A dialogue-native, 3-path system (True / Lies / Myth).
True: Direct quest outcomes.
Lies: Seeded propaganda for PR Warfare.
Myth: Distorted memories/exaggerations (The "Telephone" effect).
Optimization: .ESP is 620KB (Dialogue-Native). Total mod is 25MB. 21+ quests completed.
2. KEY CHARACTERS (The Quartet)
ALLY: The Moral Compass. Intelligent, "Good-aligned," but non-judgmental. The Guild’s legal and spiritual center.
SHANE: The Record Keeper. Poet, book-seller, and survivor. Holds the "static" history (vulnerable to Mora).
JOSEPH: The Spy (Khajiit). Bold, loud, and ambiguous. Managing the 7-tavern rumor network; a hero/villain depending on the "weight."
THE DREMORA: The Untranslatable. Azura's gift; the only record keeper capable of resisting Mora's rewrites.
3. METAPHYSICAL NARRATIVE (The Tonal Symphony)
THE UNSEEN VILLAIN: Hermaeus Mora. He actively rewrites the "True" path into his archive. He hates "Tone, Beat, and Rhythm" because they are expressions of free will he cannot control.
THE SYMPHONY: Every race contributes a "Note."
Dwemer Note: Realigns Sotha Sil's machinery.
Dunmer/Nord/Orc Notes: Restore memory and honor to the Sharmat, awakening the Dreamer from the nightmare.
The Vibration: Vivec is anchored to his true form; Almalexia is balanced by the Yin-Yang of Love vs. Madness.
4. ACTIVE QUESTS & PENDING TASKS
JMCG_Taver_HalOad: The first of 7 tavern hubs. Currently seeding the "Sweet Little Lies" path in Pelagiad.
JMCG_The_Family_Ties: Pending the UMBRA relocation.
Trigger: Speechcraft 70 check to "Convince" him to guard Valenvaryon.
JMCG_Daisy_Lore (The Silent Melody): Branching path choice regarding the "Argonian Cookbook." (Trust vs. Myth).
The Abolitionist Path: Tracked by the freeing of 168 slaves (The Good Path weight).
Outcast Cove: Primed for the climax; minimalist/liminal design.
5. CURRENT STATUS: "RELAX" PHASE
The "Technical Wall" is conquered.
The "Tuning Master" is Stage 100.
TOMORROW'S FOCUS: Relocating Umbra to Valenvaryon and monitoring the HalOad Tavern rumors.
[ARCHIVE LOCKED. SCRIBE READY FOR STORY PROCEED.] 

# Bard Tavern / Rumor System – 1-Page Reference

## CORE LAW

**Truth does not propagate. Belief does.**
Events never spread directly; only songs, rumors, silence, and distortion move through the world.

---

## HARD RULESET (DO NOT BREAK)

* **Truth:** Never fully stated
* **Medium:** Always song / tale / rumor / silence
* **NPCs:** Echo belief, never authority
* **Player:** Anonymous to their own myth
* **Morality:** Filters *tone*, not facts
* **Myth:** Suppresses speech at high levels
* **Silence:** Valid dialogue content

---

## RUMOR STRUCTURE (MAXIMUM)

* **1 Rumor** → **3 Belief States**

  * Dismissal
  * Reverence
  * Fear / Silence
* No resolutions
* Contradictions encouraged

---

## MORALITY × RESPONSE

| Player State | NPC Reaction         |
| ------------ | -------------------- |
| Unknown      | Casual / Dismissive  |
| Good         | Respectful Ambiguity |
| Bad          | Wary Ambiguity       |
| Mythic Good  | Reverence / Fear     |
| Mythic Bad   | Silence / Avoidance  |

---

## TAVERN NPC ARCHETYPES

| Type          | Function            | Tone                   |
| ------------- | ------------------- | ---------------------- |
| Echo          | Repeats town belief | Tired / unsure         |
| Gatekeeper    | Controls access     | Political / suspicious |
| Performer     | Shapes narrative    | Confident / biased     |
| Institutional | Codifies myth       | Cold / selective       |
| Silent        | Signals danger      | Fear / reverence       |

---

## LOCATION SCALING RULE

* **Per Town:** 1–3 taverns max
* **Per Tavern:** 1–2 rumors max
* **Scale by location, not rumor count**

---

## DESIGN CONSTRAINTS

* No dates
* Names rare or distorted
* Causality implied only
* NPCs never credit player

---

## FIRST CALIBRATION (LOCKED)

* **Saint:** Jiub
* **Medium:** Ballad
* **First Node:** Faras (Echo)
* **Purpose:** Test belief variance
* **Expansion:** Blocked until validated

---

**Use this page as tone law. If a line violates it, cut the line.**
           

