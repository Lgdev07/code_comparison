# classic for
a = 1
for i in range(1, 11):
    a += i
    print(a)

# while
i = 1
while i <= 10:
    print(i)
    i += 1

# range
best_games = ["Tetris", "Pacman", "Mario"]
for index, value in enumerate(best_games):
    print(f"{index + 1}. {value}")
# 1. Tetris
# 2. Pacman
# 3. Mario
