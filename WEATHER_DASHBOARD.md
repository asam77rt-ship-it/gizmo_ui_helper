# Weather Dashboard

A comprehensive real-time weather dashboard system for FiveM that fetches live weather data from the **Open-Meteo API**.

## 🌍 Features

### Data & Information
- ✅ **Current Weather**: Temperature, feels-like, humidity, wind, conditions
- ✅ **Hourly Forecast**: Next 3 hours with temperature, humidity, wind
- ✅ **7-Day Forecast**: Daily highs/lows, conditions, wind speeds
- ✅ **Geolocation**: Automatically geocode location names to coordinates
- ✅ **Weather Emojis**: Visual weather indicators (☀️ ⛅ 🌧️ ❄️ ⛈️ etc.)
- ✅ **Wind Direction**: Cardinal directions (N, NE, E, etc.)

### Technical
- 🔌 **No API Key Required**: Uses Open-Meteo (free tier, no authentication)
- ⚡ **Non-Blocking**: Async HTTP requests don't freeze game
- 🎯 **Modular**: Separate API module and client for easy customization
- 📍 **Timezone-Aware**: Automatically detects and uses local timezone
- 🌡️ **Metric & Imperial**: Supports Fahrenheit/Celsius, mph/kmh

## 📥 Installation

1. **Add to your resource folder**:
   ```
   gizmo_ui_helper/
   ├── weather_api.lua
   ├── weather_dashboard_client.lua
   └── fxmanifest.lua
   ```

2. **Update fxmanifest.lua**:
   ```lua
   files {
       'weather_api.lua',
       'weather_dashboard_client.lua',
   }
   ```

3. **Start the resource**:
   ```
   start gizmo_ui_helper
   ```

## 🎮 Commands

### `/weather [location]`
Fetch weather for a location. If no location is specified, defaults to "New York".

**Examples:**
```
/weather                    -- Fetch weather for New York
/weather London             -- Fetch weather for London
/weather Los Angeles        -- Fetch weather for Los Angeles
/weather Tokyo              -- Fetch weather for Tokyo
```

### `/weathertoggle`
Toggle the weather dashboard display on/off.

### `/weatherhelp`
Display help information about available commands.

## 📊 Display Format

The dashboard displays information organized in sections:

```
🌦️  WEATHER DASHBOARD
📍 Location: New York, NY, United States
Current Conditions
  Temperature: ☀️ 72°F (Feels like 70°F)
  Conditions: Clear sky
  Humidity: 💧 55%
  Wind: 💨 8 mph NW
7-Day Forecast
  2026-05-09: ☀️ 75°F / 62°F | Wind 10 mph
  2026-05-10: ⛅ 73°F / 65°F | Wind 12 mph
  2026-05-11: ☁️ 70°F / 63°F | Wind 8 mph
  2026-05-12: 🌧️ 68°F / 60°F | Wind 15 mph
  2026-05-13: 🌧️ 69°F / 61°F | Wind 14 mph
Next 3 Hours
  15:30: ☀️ 72°F | Humidity 54%
  16:30: ⛅ 71°F | Humidity 56%
  17:30: ☀️ 70°F | Humidity 58%
```

## 💻 API Module Usage

### Get Current Weather
```lua
local WeatherAPI = require 'weather_api'

WeatherAPI.getCurrentWeather(40.7128, -74.0060, function(success, data)
    if success then
        print("Temperature: " .. data.temperature .. "°F")
        print("Conditions: " .. data.weather_description)
        print("Wind: " .. data.wind_speed .. " mph " .. data.wind_direction .. "°")
    end
end)
```

### Get Hourly Forecast
```lua
WeatherAPI.getHourlyForecast(40.7128, -74.0060, function(success, forecast)
    if success then
        for i, hour in ipairs(forecast) do
            print(hour.time .. ": " .. hour.temperature .. "°F")
        end
    end
end)
```

### Get Daily Forecast
```lua
WeatherAPI.getDailyForecast(40.7128, -74.0060, 7, function(success, forecast)
    if success then
        for i, day in ipairs(forecast) do
            print(day.date .. ": " .. day.temp_max .. "°F / " .. day.temp_min .. "°F")
        end
    end
end)
```

### Geocode Location
```lua
WeatherAPI.geocodeLocation("London", function(success, data)
    if success then
        print("Found: " .. data.name .. " at " .. data.latitude .. ", " .. data.longitude)
    end
end)
```

### Get Full Dashboard
```lua
WeatherAPI.getFullDashboard("Paris", function(success, data)
    if success then
        print("Location: " .. data.location.name)
        print("Current: " .. data.current.temperature .. "°F")
        print("Hourly: " .. #data.hourly .. " hours")
        print("Daily: " .. #data.daily .. " days")
    end
end)
```

## 🌡️ Weather Codes

The dashboard includes descriptions for all WMO weather codes:

| Code | Description | Emoji |
|------|-------------|-------|
| 0 | Clear sky | ☀️ |
| 1-2 | Mainly/Partly cloudy | ⛅ |
| 3 | Overcast | ☁️ |
| 45-48 | Foggy | 🌫️ |
| 51-65 | Rain/Drizzle | 🌧️ |
| 71-77 | Snow | ❄️ |
| 80-82 | Rain showers | 🌧️ |
| 85-86 | Snow showers | 🌨️ |
| 95-99 | Thunderstorm | ⛈️ |

## 🔧 Customization

### Change Temperature Units
Edit `weather_api.lua` and replace `temperature_unit=fahrenheit` with `temperature_unit=celsius` in the API URLs.

### Change Wind Speed Units
Edit `weather_api.lua` and replace `wind_speed_unit=mph` with `wind_speed_unit=kmh` in the API URLs.

### Add More Forecast Days
```lua
WeatherAPI.getDailyForecast(lat, lon, 14, function(success, data) -- 14 days instead of 7
    -- ...
end)
```

### Custom Dashboard Display
Modify the `drawDashboard()` function in `weather_dashboard_client.lua` to customize the chat message format or integrate with custom UI.

## 📡 API Details

**Provider**: [Open-Meteo](https://open-meteo.com/)

**Endpoints Used**:
- `https://geocoding-api.open-meteo.com/v1/search` - Location geocoding
- `https://api.open-meteo.com/v1/forecast` - Weather data

**Rate Limits**:
- Free tier: 10,000 requests/day per IP
- No authentication required
- No API key needed

**Response Time**: Typically 200-500ms per request

## 🐛 Troubleshooting

### "Location not found"
- Check spelling and spacing
- Try with country name: `/weather London, UK`
- Try city, state: `/weather Los Angeles, CA`

### No data displayed
- Check internet connection
- Verify Open-Meteo API is accessible
- Check FiveM server console for errors
- API might be rate-limited if making many requests

### Data seems outdated
- Weather data is updated every 15-60 minutes depending on API
- Try fetching again with `/weather <location>`

## 📝 License

This weather dashboard is provided as-is for use in FiveM servers.

## 🔗 Related Resources

- [Open-Meteo API Docs](https://open-meteo.com/en/docs)
- [FiveM Client Functions](https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/)
- [Gizmo UI Helper](https://github.com/FiveM-Resources/gizmo_ui_helper)
