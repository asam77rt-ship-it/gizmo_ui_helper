-- Weather API Module
-- Fetches real-time weather data from Open-Meteo API (no API key required)
-- https://open-meteo.com/

local WeatherAPI = {}

-- Open-Meteo API endpoints
local GEOCODING_API = "https://geocoding-api.open-meteo.com/v1/search"
local WEATHER_API = "https://api.open-meteo.com/v1/forecast"

-- Weather code descriptions
local WEATHER_CODES = {
    [0] = "Clear sky",
    [1] = "Mainly clear",
    [2] = "Partly cloudy",
    [3] = "Overcast",
    [45] = "Foggy",
    [48] = "Depositing rime fog",
    [51] = "Light drizzle",
    [53] = "Moderate drizzle",
    [55] = "Dense drizzle",
    [61] = "Slight rain",
    [63] = "Moderate rain",
    [65] = "Heavy rain",
    [71] = "Slight snow",
    [73] = "Moderate snow",
    [75] = "Heavy snow",
    [77] = "Snow grains",
    [80] = "Slight rain showers",
    [81] = "Moderate rain showers",
    [82] = "Violent rain showers",
    [85] = "Slight snow showers",
    [86] = "Heavy snow showers",
    [95] = "Thunderstorm",
    [96] = "Thunderstorm with slight hail",
    [99] = "Thunderstorm with heavy hail",
}

-- Get weather emoji based on weather code
local function getWeatherEmoji(code)
    if code == 0 then return "☀️"
    elseif code == 1 or code == 2 then return "⛅"
    elseif code == 3 then return "☁️"
    elseif code == 45 or code == 48 then return "🌫️"
    elseif code >= 51 and code <= 55 then return "🌧️"
    elseif code >= 61 and code <= 65 then return "🌧️"
    elseif code >= 71 and code <= 77 then return "❄️"
    elseif code >= 80 and code <= 82 then return "🌧️"
    elseif code >= 85 and code <= 86 then return "🌨️"
    elseif code >= 95 and code <= 99 then return "⛈️"
    else return "🌡️"
    end
end

-- Geocode location name to coordinates
function WeatherAPI.geocodeLocation(location, callback)
    local url = string.format("%s?name=%s&count=1&language=en&format=json", 
        GEOCODING_API, location:gsub(" ", "+"))
    
    PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local success, result = pcall(json.decode, resultData)
            if success and result.results and #result.results > 0 then
                local place = result.results[1]
                callback(true, {
                    name = place.name,
                    latitude = place.latitude,
                    longitude = place.longitude,
                    country = place.country,
                    state = place.admin1
                })
            else
                callback(false, "Location not found")
            end
        else
            callback(false, "API request failed: " .. errorCode)
        end
    end, "GET")
end

-- Fetch current weather data
function WeatherAPI.getCurrentWeather(latitude, longitude, callback)
    local url = string.format(
        "%s?latitude=%.4f&longitude=%.4f&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,wind_direction_10m&temperature_unit=fahrenheit&wind_speed_unit=mph&timezone=auto",
        WEATHER_API, latitude, longitude)
    
    PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local success, result = pcall(json.decode, resultData)
            if success and result.current then
                local current = result.current
                callback(true, {
                    temperature = current.temperature_2m,
                    feels_like = current.apparent_temperature,
                    humidity = current.relative_humidity_2m,
                    weather_code = current.weather_code,
                    weather_description = WEATHER_CODES[current.weather_code] or "Unknown",
                    weather_emoji = getWeatherEmoji(current.weather_code),
                    wind_speed = current.wind_speed_10m,
                    wind_direction = current.wind_direction_10m,
                    timezone = result.timezone
                })
            else
                callback(false, "Failed to parse weather data")
            end
        else
            callback(false, "API request failed: " .. errorCode)
        end
    end, "GET")
end

-- Fetch hourly forecast
function WeatherAPI.getHourlyForecast(latitude, longitude, callback)
    local url = string.format(
        "%s?latitude=%.4f&longitude=%.4f&hourly=temperature_2m,weather_code,relative_humidity_2m,wind_speed_10m&temperature_unit=fahrenheit&wind_speed_unit=mph&timezone=auto&forecast_days=1",
        WEATHER_API, latitude, longitude)
    
    PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local success, result = pcall(json.decode, resultData)
            if success and result.hourly then
                local hourly = result.hourly
                local forecast = {}
                for i = 1, math.min(24, #hourly.time) do
                    table.insert(forecast, {
                        time = hourly.time[i],
                        temperature = hourly.temperature_2m[i],
                        weather_code = hourly.weather_code[i],
                        weather_description = WEATHER_CODES[hourly.weather_code[i]] or "Unknown",
                        weather_emoji = getWeatherEmoji(hourly.weather_code[i]),
                        humidity = hourly.relative_humidity_2m[i],
                        wind_speed = hourly.wind_speed_10m[i]
                    })
                end
                callback(true, forecast)
            else
                callback(false, "Failed to parse forecast data")
            end
        else
            callback(false, "API request failed: " .. errorCode)
        end
    end, "GET")
end

-- Fetch daily forecast
function WeatherAPI.getDailyForecast(latitude, longitude, days, callback)
    days = days or 7
    local url = string.format(
        "%s?latitude=%.4f&longitude=%.4f&daily=temperature_2m_max,temperature_2m_min,weather_code,wind_speed_10m_max&temperature_unit=fahrenheit&wind_speed_unit=mph&timezone=auto&forecast_days=%d",
        WEATHER_API, latitude, longitude, days)
    
    PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local success, result = pcall(json.decode, resultData)
            if success and result.daily then
                local daily = result.daily
                local forecast = {}
                for i = 1, #daily.time do
                    table.insert(forecast, {
                        date = daily.time[i],
                        temp_max = daily.temperature_2m_max[i],
                        temp_min = daily.temperature_2m_min[i],
                        weather_code = daily.weather_code[i],
                        weather_description = WEATHER_CODES[daily.weather_code[i]] or "Unknown",
                        weather_emoji = getWeatherEmoji(daily.weather_code[i]),
                        wind_speed = daily.wind_speed_10m_max[i]
                    })
                end
                callback(true, forecast)
            else
                callback(false, "Failed to parse daily forecast data")
            end
        else
            callback(false, "API request failed: " .. errorCode)
        end
    end, "GET")
end

-- Get complete weather dashboard data
function WeatherAPI.getFullDashboard(location, callback)
    WeatherAPI.geocodeLocation(location, function(success, geoData)
        if not success then
            callback(false, geoData)
            return
        end
        
        WeatherAPI.getCurrentWeather(geoData.latitude, geoData.longitude, function(success, currentData)
            if not success then
                callback(false, currentData)
                return
            end
            
            WeatherAPI.getHourlyForecast(geoData.latitude, geoData.longitude, function(success, hourlyData)
                if not success then
                    callback(false, hourlyData)
                    return
                end
                
                WeatherAPI.getDailyForecast(geoData.latitude, geoData.longitude, 7, function(success, dailyData)
                    if not success then
                        callback(false, dailyData)
                        return
                    end
                    
                    callback(true, {
                        location = geoData,
                        current = currentData,
                        hourly = hourlyData,
                        daily = dailyData
                    })
                end)
            end)
        end)
    end)
end

return WeatherAPI
