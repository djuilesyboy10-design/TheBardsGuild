-- publican_content_data.lua
-- Data table for Publican Class dialogue content

local publicanContent = {
    [1] = {
        title = "Local Rumors",
        content = [[
The whispers in Balmora's streets tell tales,
you know, of merchants rich and ancient trails.

The Telvanni wizards in their towers high,
they keep secrets that touch the sky, really.

In Ald'ruhn's shell where Redorans dwell,
the gossip flows like a magic spell.
Of Temple priests and dark cults hidden,
of prophecies long forbidden.

Listen close, but speak with care,
in Morrowind, words have power rare, you see?
]]
    },
    [2] = {
        title = "Business Opportunities",
        content = [[
The trade routes through Vvardenfell,
they bring fortunes that merchants tell, you know.

From ebony to glass, from kwama eggs,
to exotic goods from foreign legs.

The East Empire Company's might,
controls the trade with all their might.
But local merchants still find ways,
to profit through these troubled days.

Invest wisely, friend, I say,
for fortune turns like night to day, really.
]],
        effects = {
            {
                type = "reputation",
                data = { effectId = "imperial_favor" }
            }
        }
    },
    [3] = {
        title = "Room Services",
        content = [[
Our rooms are clean, our beds are soft,
a traveler's comfort, held aloft.

For just ten coins, you can rest,
and put your weary mind to test, you know?

The common room is warm and bright,
with fellow travelers each night.
Share stories, songs, and ale so fine,
until the morning sun does shine.

We've rooms for all, from rich to poor,
just ask me friend, I'll show you more.
]]
    },
    [4] = {
        title = "Local Entertainment",
        content = [[
The bards who play here every night,
they fill hearts with joy and pure delight, you know?

Their songs of heroes, love, and war,
echo through our tavern door.

Some nights we have a poet speak,
who makes the strongest grown men weep.
Other nights, a minstrel plays,
and brightens up these dreary days.

The patrons love the lively scene,
the best entertainment you've seen, really.
]]
    },
    [5] = {
        title = "Strange Weather",
        content = [[
You know, traveler, the weather's been odd lately.
Storms appear from nowhere, skies clear just as fast.
Some say it's the old magic stirring again,
Others blame the Red Mountain's restless heart.

I've seen rain fall when skies were clear,
And thunder boom without a cloud.
The old ones say it's omens, you see,
Signs of things to come, or things that be.

Be careful what you wish for in this land,
For the weather itself has a hand to play.
]],
        effects = {
            {
                weatherEvent = {
                    regionName = "West Gash Region",
                    weatherID = 5
                }
            }
        }
    },
    [6] = {
        title = "Just Chat",
        content = [[
Ah, welcome traveler, take a seat,
rest your weary, tired feet.

I've seen many faces pass through here,
some full of joy, some full of fear, you know?

This tavern has stood for many years,
through laughter, tears, and silent cheers.
It's more than just a place to drink,
it's where life's stories interlink.

So tell me friend, what brings you here?
to Vvardenfell, this land so dear?
]]
    }
}

return publicanContent
