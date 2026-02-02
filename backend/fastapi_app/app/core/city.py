def compute_city_stress(grid_stresses: list[int]):
    if not grid_stresses:
        return None

    avg = sum(grid_stresses) / len(grid_stresses)

    return round(avg)

def detect_trend(previous: int, current: int) -> str:
    if current > previous + 2:
        return "rising"
    if current < previous - 2:
        return "falling"
    return "stable"