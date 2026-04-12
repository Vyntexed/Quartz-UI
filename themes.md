---
description: Quartz supports light, dark and custom themes.
---

# Themes

### Changing themes

Usage:

```luau
Quartz.theme = Quartz.themes.ThemeName
```

{% hint style="warning" %}
Make sure to not confuse `Quartz.theme` with `Quartz.themes`
{% endhint %}

| Theme                 | Description             |
| --------------------- | ----------------------- |
| `Quartz.themes.dark`  | The default dark theme. |
| `Quartz.themes.light` | The default light theme |

***

### Custom themes

You can create custom themes by copying this template

```luau
library.themes.Theme1 = {
		bg_primary = {11, 15, 26,0.2},
		bg_secondary = {24, 28, 45, 0.45},
		bg_tertiary = {30, 35, 55, 0.55},
		
		-- buttons
		
		button_primary = {0, 122, 255, 0.18},
		button_primary_hover = {0, 122, 255, 0.10},
		button_primary_pressed = {0, 102, 215, 0.05},

		button_primary_stroke = {255, 255, 255, 0.65},
		button_primary_highlight = {255, 255, 255, 0.80},
		
		stroke_primary = {255, 255, 255, 0.88},
		
		-- text
		text_primary = {255, 255, 255, 0},
		text_secondary = {235, 235, 245, 0.4},
		text_tertiary = {235, 235, 245, 0.7},
		text_disabled = {235,235, 245, 0.82}
		
	}
```

You can change `Theme1` with any Theme Name just remember to Change the Themes.

```luau
text_primary = {r,g,b,a}
```

`a` stands for alpha, it's simply transparency, 0 is fully visible, 1 is fully invisible.
