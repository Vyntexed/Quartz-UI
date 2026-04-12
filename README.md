# Quartz UI

## Loading the library

```lua
local Quartz = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vyntexed/Quartz-UI/refs/heads/main/src.lua"))()
```

## Init

Using secure is highly recommended read the section about [secure mode](#Secure)
```lua
Quartz:init({
  secure = true
})
```

## new_window

This function can take a configuration table (if provided) and modifiers like [Flags](#Flags) and [Styles](#Styles)

```lua
local window = Quartz:new_window()
```

If a configuration table is provided, it must always be the first argument.

If no configuration table is provided, all arguments are treated as unordered modifiers (e.g. flags and styles) and can be placed in any position.

Flags and styles are effectively simple strings that are compared from tables like `Quartz.Flags` and `Quartz.Styles`

```lua
Quartz:new_window(
  {
    loadingWindow = {
      Enabled = true,
    
      Title = "Title",
      Subtitle = "Subtitle",
      Version = "V1.0.0",

      minLoadTime = 3
    }
  }
)
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

Flag Usage:
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

Style Usage:
```lua
Quartz:new_window(
  Quartz.Styles.Dashboard
)
```
Please note that if you put in multiple styles it will default to the first style given and throw a warning. You can only use 1 style per window.

## Secure

Secure is designed to make this library completely undetectable and minimally invasive in any game.

| Feature | With secure | Without Secure |
|--------|------------|----------------|
| BackgroundBlur | No | Yes |
| CoreGui | Mandatory | Preferred | 
