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

This function can take a lot of different settings like [Flags](#Flags) and [Styles](#Styles)

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
| `Quartz.Flags.NoDrag` | Removes window dragging effectively making the window locked in place |
| `Quartz.Flags.NoAnimations` | Disables all animations to improve performance |

Here's an example of how to use Flags
```lua
Quartz:new_window(
  Quartz.Flags.NoResize,
  Quartz.Flags.NoDrag,
  Quartz.Flags.NoAnimations
)
```
You can add any amount of flags, just make sure you don't repeat the same flags otherwise you might lose performance at your own cost.

## Styles

| Style | Description        |
|--------|---------------------|
| `Quartz.Styles.Dashboard` | Uses a dashboard style with a panel on the left side and content on the right, everything here is pre-programmed to fit and look nice |
| `Quartz.Styles.Custom` | No style, you can make the window look however you see fit |

