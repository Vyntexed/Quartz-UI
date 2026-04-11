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
<details>
  <summary>Window hooks</summary>

  Window hooks are designed to help developers integrate custom code easier. That is the reason why we are too lazy to pre-program `close_btn` but other buttons are pre-programmed and their functionality can be disconnected and replaced with your own

  ### Disconnecting default functionality
  maximize_btn:
  ```lua
  window.hooks.buttons.maximize_btn:Disconnect("default")
  ```
  minimize_btn:
  ```lua
  window.hooks.buttons.minimize_btn:Disconnect("default")
  ```

</details>



## Flags

| Flag | Description       |
|--------|---------------------|
| `Quartz.Flags.NoResize` | Prevents the user from resizing a window |

## Styles

| Style | Description        |
|--------|---------------------|
| `Quartz.Styles.Dashboard` | Uses a dashboard style with a panel on the left side and content on the right, everything here is pre-programmed to fit and look nice |
| `Quartz.Styles.Custom` | No style, you can make the window look however you see fit |

