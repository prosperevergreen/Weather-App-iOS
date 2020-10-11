# Weather App

<img src="https://github.com/prosperevergreen/Weather-App-iOS/blob/master/Documentation/WeatherApp.gif" align="right" width="400" />

A beautiful, dark-mode enabled weather app to check the weather for the current location based on the GPS data from the iPhone as well as by searching for a city manually.


## Setup:

1. Clone project

2. Go to [Open Weather Map API](https://openweathermap.org/api) to get an API key

3. Replace the <Your API Key> with your API key in the **WeatherEngine.swift** file

```swift
    let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather?appid=<Your API Key>&units=metric"
```

4. Run app

## Technology implemented:

- UIStoryboard
- Struct
- Protocols and Delegate
- Codable
- MVC Design Architecture
- Networking
- GPS data
