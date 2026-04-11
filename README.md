# Quartz UI

## Loading the library

```lua
local Quartz = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vyntexed/Quartz-UI/refs/heads/main/src.lua"))()
```

## Init

Using secure removes the background blur due to being  easily detected, I will try to fix this in the future.

```lua
Quartz:init({
  secure = true
})
```

## new_window

You can pass flags to `new_window` using `Quartz.flags.FlagName` you can find all the flags [here](#Flags)

```lua
local window = Quartz:new_window()
```

## Flags

| Flag | What it does        |
|--------|---------------------|
| `Quartz.Flags.NoResize` | Prevents the user from resizing a window |
