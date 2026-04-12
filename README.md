# Getting Started

### Initialization

```luau
local Quartz = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vyntexed/Quartz-UI/refs/heads/main/src.lua"))()

Quartz:init({
    secure = true
})
```

***

### Secure Mode

When enabled the library tries to be as minimally invasive in a game as possible, meaning detection becomes much harder

| Feature         | With secure | Without secure |
| --------------- | ----------- | -------------- |
| Background Blur | No          | Yes            |
| CoreGui         | Mandatory   | Preferred      |

{% hint style="warning" %}
With secure, if it fails to place the gui into `CoreGui` it will silently fail
{% endhint %}
