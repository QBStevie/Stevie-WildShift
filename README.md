# Animal Transformation Resource

# I have not tested this Was just fucking around <3>

If you wanna know why i did not test it was watching 
https://www.youtube.com/watch?v=YR65AvfELwI

This FiveM resource lets players use potions to transform into animals with advanced features:

- **Multiple animal forms** (wolf, husky, cat), each configurable with:
  - **Duration** (seconds before auto-revert)
  - **Speed multiplier**
  - **Sound effect**
- **Human Potion** to explicitly revert early
- **Cooldown** between potion uses to prevent abuse
- **Drink animation**, **progress bar**, and **particle FX** on use
- **HUD timer** showing remaining transformation time
- **Server-side logging** of transform/revert actions

- https://ko-fi.com/irishstevie
- 

## Installation

1. Place this folder in your `resources/[local]/` directory.
2. Add to your `server.cfg`:
   ```cfg
   ensure Stevie-WildShift
   ```
3. Install **ox_inventory** or **qb-inventory** and ensure it is started.
4. Install dependencies **illenium-appearance** and **qb-clothing**.

## Configuration

Edit `config.lua` to adjust transformations and settings.

## Inventory Item Setup

### ox_inventory

In `metadata/items.lua`, add entries for each potion:

```lua
['wolf_transform'] = {
  name = 'wolf_transform',
  label = 'Wolf Potion',
  weight = 100,
  stack = false,
  close = true,
},
['human_potion'] = {
  name = 'human_potion',
  label = 'Human Potion',
  weight = 100,
  stack = false,
  close = true,
},
```

### QBCore (qb-inventory)

In `shared_items.lua` or your database:

```lua
['wolf_transform'] = {
  name = 'wolf_transform',
  label = 'Wolf Potion',
  weight = 100,
  type = 'item',
  image = 'wolf_potion.png',
  unique = false,
  useable = true,
  shouldClose = true,
},
['human_potion'] = {
  name = 'human_potion',
  label = 'Human Potion',
  weight = 100,
  type = 'item',
  image = 'human_potion.png',
  unique = false,
  useable = true,
  shouldClose = true,
},
```

Reload your items after changes.

## Usage

- Use an animal potion to transform (consumes potion, grants Human Potion).
- Auto-revert after configured duration.
- Use Human Potion to revert early.

## Server Logging

Transforms and reverts are logged in the server console via:

```lua
RegisterNetEvent('transform:server:Log', function(src, action, item)
    print(('[transform] Player %s performed %s with %s'):format(src, action, item))
end)
```
