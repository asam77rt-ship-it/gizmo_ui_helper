# Digital Clock - Multi-Timezone Display

A comprehensive digital clock system for FiveM that displays current time across multiple timezones with support for 40+ timezone codes.

## 🕐 Features

### Core Features
- ✅ **40+ Timezones**: All major world timezones supported
- ✅ **Real-Time Updates**: Live clock with 100ms refresh rate
- ✅ **Multiple Formats**: 24-hour, 12-hour (AM/PM), date, full datetime
- ✅ **Timezone Groups**: Predefined groups (worldwide, americas, europe, asia, business)
- ✅ **Custom Sets**: Create your own timezone combinations
- ✅ **UTC Offset Display**: Shows UTC offset for each timezone
- ✅ **12-Hour Format**: AM/PM support for all timezones

## 📦 Installation

1. **Add files to your resource**:
   ```
   gizmo_ui_helper/
   ├── digital_clock.lua
   └── digital_clock_client.lua
   ```

2. **Update fxmanifest.lua**:
   ```lua
   files {
       'digital_clock.lua',
       'digital_clock_client.lua',
   }
   ```

3. **Start the resource**:
   ```
   start gizmo_ui_helper
   ```

## 🎮 Commands

### `/clock [timezone]`
Display current time in a specific timezone.

**Examples:**
```
/clock                  -- Show UTC time
/clock PST             -- Show Pacific Standard Time
/clock EST             -- Show Eastern Standard Time
/clock JST             -- Show Japan Standard Time
/clock GMT             -- Show Greenwich Mean Time
```

### `/worldclock [group]`
Display time in multiple predefined timezone groups.

**Available Groups:**
- `business` (default) - PST, EST, GMT, JST
- `worldwide` - UTC, EST, PST, GMT, JST, IST, AEST
- `americas` - PST, MST, CST, EST, BRT, ART
- `europe` - GMT, CET, EET, MSK
- `asia` - IST, JST, SGT, PHT, AEST

**Examples:**
```
/worldclock           -- Show business timezones
/worldclock asia      -- Show Asian timezones
/worldclock americas  -- Show Americas timezones
```

### `/clockset [tz1] [tz2] [tz3] ...`
Set a custom list of timezones to display.

**Examples:**
```
/clockset PST EST JST IST      -- Custom 4-timezone combo
/clockset GMT CET EET MSK      -- European timezones
/clockset AEST NZST PHT        -- Pacific timezones
```

### `/clockgroup [group]`
Display a specific timezone group.

**Examples:**
```
/clockgroup worldwide
/clockgroup business
/clockgroup europe
```

### `/clocktoggle`
Enable/disable live clock display (updates every second).

```
/clocktoggle          -- Start live display
/clocktoggle          -- Stop live display
```

### `/clockhelp`
Display help information and command list.

### `/clocktz`
List all 40+ available timezones.

## 🌍 Supported Timezones

### North America
- **EST** (Eastern Standard Time) - UTC-5
- **EDT** (Eastern Daylight Time) - UTC-4
- **CST** (Central Standard Time) - UTC-6
- **CDT** (Central Daylight Time) - UTC-5
- **MST** (Mountain Standard Time) - UTC-7
- **MDT** (Mountain Daylight Time) - UTC-6
- **PST** (Pacific Standard Time) - UTC-8
- **PDT** (Pacific Daylight Time) - UTC-7
- **AKST** (Alaska Standard Time) - UTC-9
- **AKDT** (Alaska Daylight Time) - UTC-8
- **HST** (Hawaii Standard Time) - UTC-10
- **HDT** (Hawaii Daylight Time) - UTC-9

### Europe
- **GMT** (Greenwich Mean Time) - UTC+0
- **UTC** (Coordinated Universal Time) - UTC+0
- **WET** (Western European Time) - UTC+0
- **WEST** (Western European Summer Time) - UTC+1
- **CET** (Central European Time) - UTC+1
- **CEST** (Central European Summer Time) - UTC+2
- **EET** (Eastern European Time) - UTC+2
- **EEST** (Eastern European Summer Time) - UTC+3
- **MSK** (Moscow Standard Time) - UTC+3

### Asia
- **IST** (Indian Standard Time) - UTC+5:30
- **PKT** (Pakistan Standard Time) - UTC+5
- **BDT** (Bangladesh Time) - UTC+6
- **ICT** (Indochina Time) - UTC+7
- **PHT** (Philippine Time) - UTC+8
- **SGT** (Singapore Time) - UTC+8
- **JST** (Japan Standard Time) - UTC+9
- **AEST** (Australian Eastern Standard Time) - UTC+10
- **AEDT** (Australian Eastern Daylight Time) - UTC+11

### Pacific
- **NZST** (New Zealand Standard Time) - UTC+12
- **NZDT** (New Zealand Daylight Time) - UTC+13

### South America
- **BRT** (Brasília Time) - UTC-3
- **BRST** (Brasília Summer Time) - UTC-2
- **ART** (Argentina Time) - UTC-3
- **ARST** (Argentina Summer Time) - UTC-2

## 💻 API Usage

### Get Current UTC Time
```lua
local DigitalClock = require 'digital_clock'
local utcTime = DigitalClock.getCurrentUTC()
print(DigitalClock.formatTime(utcTime))  -- Output: 14:30:45
```

### Get Time in Timezone
```lua
local timeTable = DigitalClock.getTimeInTimezone("PST")
print(DigitalClock.formatTime12Hour(timeTable))  -- Output: 06:30:45 AM
```

### Get Multiple Timezones
```lua
local times = DigitalClock.getMultipleTimezones({"PST", "EST", "GMT", "JST"})
for tz, timeTable in pairs(times) do
    print(tz .. ": " .. DigitalClock.formatTime(timeTable))
end
```

### Format Options
```lua
local t = DigitalClock.getTimeInTimezone("EST")

-- 24-hour format with seconds
DigitalClock.formatTime(t)          -- 14:30:45

-- 24-hour format without seconds
DigitalClock.formatTimeShort(t)     -- 14:30

-- 12-hour format with AM/PM
DigitalClock.formatTime12Hour(t)    -- 02:30:45 PM

-- Full date
DigitalClock.formatDate(t)          -- 2026-05-09

-- Full datetime
DigitalClock.formatFullDateTime(t)  -- Sat, May 09 2026 14:30:45

-- Timezone display
DigitalClock.formatTimezoneDisplay("EST", t)  -- 🕐 EST (UTC-5): 02:30:45 PM
```

### Validate Timezones
```lua
local valid, err = DigitalClock.validateTimezone("PST")
if valid then
    print("Valid timezone")
else
    print("Error: " .. err)
end
```

## 📊 Output Examples

### Single Timezone
```
🕐 CLOCK: 🕐 PST (UTC-8): 06:30:45 AM
```

### Multiple Timezones
```
⏰ WORLD CLOCK: ━━━━━━━━━━━━━━━━━━
🕐 PST (UTC-8): 06:30:45 AM
🕑 EST (UTC-5): 09:30:45 AM
🕒 GMT (UTC+0): 02:30:45 PM
🕓 JST (UTC+9): 11:30:45 PM
━━━━━━━━━━━━━━━━━━
```

## ⚙️ Customization

### Add New Timezone
Edit `digital_clock.lua` and add to the `TIMEZONES` table:
```lua
TIMEZONES["CUSTOM"] = -5  -- UTC-5 offset
```

### Add New Timezone Group
Edit `digital_clock_client.lua` and add to `TIMEZONE_GROUPS`:
```lua
TIMEZONE_GROUPS["mycustom"] = {"PST", "EST", "JST"}
```

### Change Update Interval
Edit `digital_clock_client.lua` and modify:
```lua
local updateInterval = 100  -- Change to desired milliseconds
```

## 🐛 Troubleshooting

### "Timezone not found"
- Check spelling (case-insensitive but be consistent)
- Use `/clocktz` to see all available timezones
- Daylight saving variants have different codes (e.g., PST vs PDT)

### Live clock not updating
- Use `/clocktoggle` to enable it
- Check that `updateInterval` is set correctly
- Verify no console errors

### Wrong time displayed
- Verify timezone code is correct
- Remember DST variants are separate (PST vs PDT)
- Check local system time is correct

## 📝 License

This digital clock is provided as-is for use in FiveM servers.

## 🔗 Related Resources

- [FiveM Client Functions](https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/)
- [Lua Date/Time Functions](https://www.lua.org/pil/22.1.html)
- [Timezone Database](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
