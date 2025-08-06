Config = {
    Transformations = {
        wolf_transform = { label = 'Wolf Potion', model = 'a_c_wolf', duration = 300, speedMultiplier = 1.3, sound = { dict = 'DLC_MPHEIST\\HEIST_FLEECA_SOUNDSET', name = 'PML_LOW' } },
        husky_transform = { label = 'Husky Potion', model = 'a_c_husky', duration = 180, speedMultiplier = 1.2, sound = { dict = 'DLC_MPHEIST\\HEIST_FLEECA_SOUNDSET', name = 'PML_MED' } },
        cat_transform   = { label = 'Cat Potion',   model = 'a_c_cat_01', duration = 120, speedMultiplier = 1.1, sound = { dict = 'DLC_MPHEIST\\HEIST_FLEECA_SOUNDSET', name = 'PML_HIGH' } },
    },
    RevertItem   = 'human_potion',
    Cooldown     = 60,
    DrinkAnim    = { dict = 'mp_suicide', name = 'pill' },
    Progress     = { duration = 2000, label = 'Drinking Potion...' },
    Particle     = { asset = 'core', name = 'ent_amb_smoke' },
    HUD          = { enabled = true, x = 0.5, y = 0.95, scale = 0.35, font = 0, color = {r=255,g=255,b=255,a=200} }
}
