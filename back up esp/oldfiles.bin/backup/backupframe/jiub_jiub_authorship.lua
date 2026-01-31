return {
    JIUB_SAINTING = {
        id = "JIUB_SAINTING",

        -- TEMP PLACEHOLDER TEXT (can be flavored later)
        context = "A song must be carried forward. How will it be remembered?",
        question = "How do you shape the telling?",

        options = {
            {
                key = "good",
                label = "Preserve the truth",
                result = [[
The Scribe witnessed the golden burst,
In the Palace where the Living Gods dwell.
The curse of the wings is finally dispersed,
And the silence of the Ashlands is well.

No verse was bent by mortal will,
No shadow crept into the rite.
Truth alone was set to song,
And carried forward in honest light.
]],
                outcome = {
                    weatherEvent = {
                        regionName = "Ascadian Isles Region",
                        weatherID = 5
                    }
                }
            },

            {
                key = "distort",
                label = "Shape the tale",
                result = [[
The Scribe witnessed the golden burst,
In the Palace where the Living Gods dwell.
The curse of the wings is finally dispersed,
And the silence of the Ashlands is well.

Details soften as the song is sung,
Names fade, motives blur.
What was seen becomes what is told,
And memory learns to stir.
]],
                outcome = {
                    weatherEvent = {
                        regionName = "Ascadian Isles Region",
                        weatherID = 5
                    }
                }
            },

            {
                key = "myth",
                label = "Let legend grow",
                result = [[
The Scribe witnessed the golden burst,
In the Palace where the Living Gods dwell.
The curse of the wings was shattered by fate,
And the gods themselves rang the bell.

Jiub struck as heaven watched,
Gold fell where his shadow stood.
Thus began the age of Saint Jiub,
Born of song, blood, and godhood.
]],
                outcome = {
                    weatherEvent = {
                        regionName = "Ascadian Isles Region",
                        weatherID = 5
                    }
                }
            }
        }
    }
}