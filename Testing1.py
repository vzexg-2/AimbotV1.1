import time
import math

class Player:
    def __init__(self, name, position):
        self.name = name
        self.position = position
        self.highlight = False

class Camera:
    def __init__(self, position):
        self.position = position

    def lerp(self, target_position, t):
        self.position = (
            self.position[0] + (target_position[0] - self.position[0]) * t,
            self.position[1] + (target_position[1] - self.position[1]) * t,
            self.position[2] + (target_position[2] - self.position[2]) * t
        )

def distance(p1, p2):
    return math.sqrt((p1[0] - p2[0]) ** 2 + (p1[1] - p2[1]) ** 2 + (p1[2] - p2[2]) ** 2)

def find_closest_player(local_player, players):
    closest_player = None
    shortest_distance = float('inf')

    for player in players:
        if player != local_player:
            dist = distance(local_player.position, player.position)
            if dist < shortest_distance:
                shortest_distance = dist
                closest_player = player

    return closest_player

def highlight_player(player):
    player.highlight = True

def remove_highlight(player):
    player.highlight = False

def main():
    local_player = Player("LocalPlayer", (0, 0, 0))
    camera = Camera((0, 0, 0))
    players = [
        Player("Player1", (10, 0, 10)),
        Player("Player2", (20, 0, 20)),
        Player("Player3", (30, 0, 30))
    ]

    aimbot_enabled = True

    while True:
        if aimbot_enabled:
            closest_player = find_closest_player(local_player, players)

            if closest_player:
                highlight_player(closest_player)
                target_position = closest_player.position
                camera.lerp(target_position, 0.1)
                print(f"Aiming at {closest_player.name} at position {target_position}")
            else:
                print("No players to aim at")

        time.sleep(1)

if __name__ == "__main__":
    main()
