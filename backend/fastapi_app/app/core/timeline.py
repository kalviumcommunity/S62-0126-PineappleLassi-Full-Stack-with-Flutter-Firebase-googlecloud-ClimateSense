from app.core.stress import calculate_stress


def build_hourly_timeline(weather_hours: list, aqi_forecast: dict):
    timeline = []

    for index, hour in enumerate(weather_hours):
        ts = hour["timestamp"]

        aqi = aqi_forecast.get(ts, 100)  # fallback if AQI missing

        stress = calculate_stress(
            temp=hour["temp"],
            humidity=hour["humidity"],
            aqi=aqi
        )

        timeline.append({
            "time": "Now" if index == 0 else f"+{index}h",
            "temp": hour["temp"],
            "aqi": aqi,
            "stress": stress["value"],
            "icon": hour["icon"],
            "is_now": index == 0
        })

    return timeline
