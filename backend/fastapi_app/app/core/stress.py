def calculate_stress(temp: int, humidity: int, aqi: int) -> dict:
    """
    Returns stress value + breakdown.
    Scale: 0 (low) → 100 (extreme)
    """

    score = 0
    reasons = []

    # 🌡️ Temperature
    if temp > 30:
        impact = min((temp - 30) * 2, 30)
        score += impact
        reasons.append({
            "type": "temperature",
            "value": temp,
            "impact": impact,
            "message": "High temperature increases physical stress"
        })

    # 💧 Humidity
    if humidity > 60:
        impact = min((humidity - 60) * 0.5, 20)
        score += impact
        reasons.append({
            "type": "humidity",
            "value": humidity,
            "impact": impact,
            "message": "High humidity reduces heat tolerance"
        })

    # 🌫️ AQI
    if aqi > 50:
        impact = min((aqi - 50) * 0.2, 40)
        score += impact
        reasons.append({
            "type": "air_quality",
            "value": aqi,
            "impact": impact,
            "message": "Poor air quality affects breathing and fatigue"
        })

    return {
        "value": min(int(score), 100),
        "reasons": reasons,
        "version": "v1"
    }
