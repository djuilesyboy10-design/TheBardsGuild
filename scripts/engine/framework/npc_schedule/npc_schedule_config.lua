return {
    -- Time settings
    hours = {
        dayStart = 7.5,    -- 7:30 AM
        nightStart = 20.5, -- 8:30 PM
    },

    -- Weather triggers (disables NPCs during these weather types)
    badWeather = {
        [4] = "Rain",
        [5] = "Thunderstorm",
        [6] = "Ashstorm",
        [7] = "Blight",
        [9] = "Blizzard"
    },

    -- Cell Filtering (only these cells get scheduling)
    -- If empty, applies to all exterior/quasi-exterior cells
    enabledCells = {
        "Balmora",
        "Seyda Neen",
        "Ald-ruhn",
        "Sadrith Mora",
        "Vivec",
        "Pelagiad",
        "Suran",
        "Gnisis",
        "Caldera",
        "Gnaar Mok",
        "Hla Oad",
        "Khuul",
        "Maar Gan",
        "Dagon Fel",
        "Vos",
        "Tel Vos",
        "Tel Mora",
        "Tel Aruhn",
        "Tel Branora"
    },

    -- Blacklist (specific record IDs that NEVER go home/disable)
    blacklist = {
        ["fargoth"] = true, -- Always out for his quest
        ["ajira"] = true,
        ["habasi"] = true,
        ["caius cosades"] = true
    },

    -- Whitelisted classes (these NPCs NEVER go home/disable)
    whitelistedClasses = {
        ["guard"] = true,
        ["ordinator"] = true,
        ["buoyant armiger"] = true,
        ["imperial guard"] = true,
        ["high ordinator"] = true,
        ["royal guard"] = true,
        ["nord guard"] = true,
        ["her hand"] = true
    },

    -- Quest-based disabling (NPCs that should be hidden during specific quest stages)
    -- Format: [questId] = { [stageStart] = { endStage = X, npcs = { "id1", "id2" } } }
    questDisables = {
        -- Example: Hidden during stage 10-20
        -- ["jmcg_shane_lore"] = {
        --     [10] = { endStage = 20, npcs = { "fargoth" } }
        -- }
    }
}
