-- Weather Dashboard Client
-- FiveM integration for weather dashboard with chat commands

local WeatherAPI = require 'weather_api'
local dashboardActive = false

-- Get cardinal direction from degrees
local function getCardinalDirection(degrees)
    local directions = {"N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"}
    local index = math.floor((degrees + 11.25) / 22.5) % 16 + 1
    return directions[index]
end

-- Format time from ISO format
local function formatTime(isoTime)
    return isoTime:sub(12, 16)
end

-- Format date from ISO format
local function formatDate(isoDate)
    return isoDate:sub(6, 10)
end

-- Draw weather dashboard in chat
local function drawDashboard(data)
    local location = data.location
    local current = data.current
    local hourly = data.hourly
    local daily = data.daily
    
    local locationStr = location.name
    if location.state then
        locationStr = locationStr .. ", " .. location.state
    end
    if location.country then
        locationStr = locationStr .. ", " .. location.country
    end
    
    TriggerEvent('chat:addMessage', {
        color = {0, 150, 255},
        multiline = true,
        args = {"WEATHER", "🌦️  WEATHER DASHBOARD"}
    })
    
    TriggerEvent('chat:addMessage', {
        color = {100, 200, 255},
        args = {"", "📍 Location: " .. locationStr}
    })
    
    TriggerEvent('chat:addMessage', {
        color = {255, 200, 100},
        args = {"", "━━━━━━━━ Current Conditions ━━━━━━━━"}
    })
    
    TriggerEvent('chat:addMessage', {
        color = {150, 220, 255},
        args = {"", current.weather_emoji .. " " .. current.temperature .. "°F (Feels like " .. current.feels_like .. "°F)"}
    })
    
    TriggerEvent('chat:addMessage', {
        color = {150, 220, 255},
        args = {"", "Conditions: " .. current.weather_description}
    })
    
    TriggerEvent('chat:addMessage', {
        color = {150, 220, 255},
        args = {"", "💧 Humidity: " .. current.humidity .. "%"}
    })
    
    TriggerEvent('chat:addMessage', {
        color = {150, 220, 255},
        args = {"", "💨 Wind: " .. current.wind_speed .. " mph " .. getCardinalDirection(current.wind_direction)}
    })
    
    -- 7-Day Forecast
    TriggerEvent('chat:addMessage', {
        color = {255, 200, 100},
        args = {"", "━━━━━━━━ 7-Day Forecast ━━━━━━━━"}
    })
    
    for i = 1, math.min(7, #daily) do
        local day = daily[i]
        local dayStr = formatDate(day.date)
        local forecast = string.format("%s %s %d°F / %d°F | Wind %.0f mph",
            day.weather_emoji,
            dayStr,
            day.temp_max,
            day.temp_min,
            day.wind_speed
        )
        TriggerEvent('chat:addMessage', {
            color = {150, 220, 255},
            args = {"", forecast}
        })
    end
    
    -- Hourly Forecast
    TriggerEvent('chat:addMessage', {
        color = {255, 200, 100},
        args = {"", "━━━━━━━━ Next 3 Hours ━━━━━━━━"}
    })
    
    for i = 1, math.min(3, #hourly) do
        local hour = hourly[i]
        local timeStr = formatTime(hour.time)
        local forecast = string.format("%s %s: %s %d°F | Humidity %d%%",
            hour.weather_emoji,
            timeStr,
            hour.weather_description,
            hour.temperature,
            hour.humidity
        )
        TriggerEvent('chat:addMessage', {
            color = {150, 220, 255},
            args = {"", forecast}
        })
    end
    
    TriggerEvent('chat:addMessage', {
        color = {100, 200, 255},
        args = {"", "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"}
    })
end

-- Command: /weather [location]
TriggerEvent('chat:addSuggestion', '/weather', 'Fetch weather for a location', {
    {name="location", help="City name (default: New York)"}
})

RegisterCommand('weather', function(source, args, rawCommand)
    local location = args[1] and table.concat(args, " ") or "New York"
    
    TriggerEvent('chat:addMessage', {
        color = {200, 100, 255},
        args = {"WEATHER", "Fetching weather for " .. location .. "..."}
    })
    
    WeatherAPI.getFullDashboard(location, function(success, data)
        if success then
            drawDashboard(data)
        else
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                args = {"WEATHER ERROR", "Failed to fetch weather: " .. tostring(data)}
            })
        end
    end)
end, false)

-- Command: /weathertoggle
TriggerEvent('chat:addSuggestion', '/weathertoggle', 'Toggle weather dashboard display')

RegisterCommand('weathertoggle', function(source, args, rawCommand)
    dashboardActive = not dashboardActive
    local status = dashboardActive and "enabled" or "disabled"
    TriggerEvent('chat:addMessage', {
        color = {0, 150, 255},
        args = {"WEATHER", "Dashboard " .. status}
    })
end, false)

-- Command: /weatherhelp
TriggerEvent('chat:addSuggestion', '/weatherhelp', 'Display weather dashboard help')

RegisterCommand('weatherhelp', function(source, args, rawCommand)
    TriggerEvent('chat:addMessage', {
        color = {0, 150, 255},
        multiline = true,
        args = {"WEATHER HELP", "Available Commands:"}
    })
    
    TriggerEvent('chat:addMessage', {
        color = {150, 220, 255},
        args = {"", "/weather [location] - Fetch weather (default: New York)"}
    })
    
    TriggerEvent('chat:addMessage', {
        color = {150, 220, 255},
        args = {"", "/weathertoggle - Toggle dashboard display"}
    })
    
    TriggerEvent('chat:addMessage', {
        color = {150, 220, 255},
        args = {"", "/weatherhelp - Show this help message"}
    })
    
    TriggerEvent('chat:addMessage', {
        color = {150, 220, 255},
        multiline = true,
        args = {"", "Examples:\n/weather London\n/weather Los Angeles\n/weather Tokyo"}
    })
end, false)

print("^2[Weather Dashboard] ^7Client loaded successfully!")
