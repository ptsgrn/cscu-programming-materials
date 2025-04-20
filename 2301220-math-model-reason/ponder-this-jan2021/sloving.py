#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import time
from typing import Literal
import os


class Colors:
    grey = "\033[90m"
    red = "\033[91m"
    green = "\033[92m"
    bgRed = "\033[41m"
    bgGreen = "\033[42m"
    reset = "\033[0m"

class State:
    step: int = 0
    x: int = 0
    y: int = 0
    facing: int = 0
    board: list[list[Literal[0, 1, 2, "B"]]] = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
    ]
    facing_labels: list[str] = ["↑ up", "right →", "down ↓", "← left"]
    facing_symbols: list[str] = ["↑", "→", "↓", "←"]
    max_fillable_cells = 0
    number_of_twos: int = 0
    n: int = 4
    is_check_cyclic: bool = False

    def is_full_table(self) -> bool:
      return self.number_of_twos == self.max_fillable_cells

    def __init__(self, step=0, x=0, y=0, facing=0, n=4):
        self.step = step
        self.x = x
        self.y = y
        self.facing = facing
        self.n = n
        self.board = [[0 for _ in range(n)] for _ in range(n)]
        self.facing_labels = ["up ↑", "right →", "down ↓", "← left"]
        self.facing_symbols = ["↑", "→", "↓", "←"]
        self.max_fillable_cells = n * n

    def __sizeof__(self) -> int:
        return len(self.board)

    def at(self, x, y) -> Literal[0, 1, 2]:
        return self.board[y][x]

    def current_pos(self) -> tuple[int, int]:
        return (self.x, self.y)

    def turn_clockwise(self):
        self.facing = (self.facing + 1) % 4
        return self

    def turn_counterclockwise(self):
        self.facing = (self.facing + 3) % 4
        return self

    def move_straight(self, step=1):
        # up
        if self.facing == 0:
            self.y = (self.y - step) % len(self.board)
            if self.is_column_cyclic(self.y) and self.is_check_cyclic:
                raise RuntimeError("Unreslovable state")
        # right
        elif self.facing == 1:
            self.x = (self.x + step) % len(self.board[0])
            if self.is_row_cyclic(self.x) and self.is_check_cyclic:
                raise RuntimeError("Unreslovable state")
        # down
        elif self.facing == 2:
            self.y = (self.y + step) % len(self.board)
            if self.is_column_cyclic(self.y) and self.is_check_cyclic:
                raise RuntimeError("Unreslovable state")
        # left
        elif self.facing == 3:
            self.x = (self.x - step) % len(self.board[0])
            if self.is_row_cyclic(self.x) and self.is_check_cyclic:
                raise RuntimeError("Unreslovable state")
        else:
            raise ValueError("Invalid facing direction")
        return self

    def display_board(self):
        output = ""
        for i in range(self.n):
            for j in range(self.n):
                if self.board[i][j] == 0:
                    text = Colors.grey + "0" + Colors.reset
                elif self.board[i][j] == 1:
                    text = Colors.bgRed + "1" + Colors.reset
                elif self.board[i][j] == 2:
                    text = Colors.bgGreen + "2" + Colors.reset
                elif self.board[i][j] == "B":
                    text = Colors.bgRed + "B" + Colors.reset
                    
                if i == self.y and j == self.x:
                    output += f"[{text}]"
                else:
                    output += f" {text} "
            output += "\n"
        return output
    def __str__(self) -> str:
        return f"Step: {self.step}\nPosition: {self.x}, {self.y}\n\
Facing: {self.beautify_facing(self.facing)}\nBoard:\n{self.display_board()}"

    def __repr__(self) -> str:
        return f"State(step={self.step}, x={self.x}, y={self.y}, facing={self.beautify_facing(self.facing, text=True)})"

    def beautify_facing(self, facing, text=False) -> str:
        return f"{self.facing_labels[facing or self.facing]}" if text else self.facing_labels[facing or self.facing]

    def set_at(self, x, y, value):
        if x < 0 or x >= self.n or y < 0 or y >= self.n:
            raise IndexError("Coordinates out of bounds")
        if value not in [0, 1, 2, "B"]:
            raise ValueError("Invalid value. Only 0, 1, 2, or 'B' are allowed.")
        self.board[y][x] = value
        if value == "B":
            self.max_fillable_cells -= 1
        return self

    def current_pos_state(self):
        return self.at(self.x, self.y)

    def next_step(self):
        if self.current_pos_state() == 0:
            self.set_at(self.x, self.y, 1)
            self.inspect()
            self.turn_clockwise()
            self.inspect()
            self.move_straight()
        elif self.current_pos_state() == 1:
            self.turn_counterclockwise()
            self.inspect()
            self.set_at(self.x, self.y, 2)
            self.inspect()
            self.move_straight()
            self.number_of_twos += 1
        elif self.current_pos_state() == 2:
            self.move_straight()
        elif self.current_pos_state() == "B":
            self.turn_counterclockwise()
            self.inspect()
            self.move_straight()
        self.inspect()
        self.step += 1
        return self

    def is_column_cyclic(self, col):
        if self.facing == 1 or self.facing == 3:
            return False
        for row in range(self.n):
            if self.board[row][col] != 2:
                return False
        return True

    def is_row_cyclic(self, row):
        if self.facing == 0 or self.facing == 2:
            return 

    def inspect(self):
      print(self.__str__())
      return self

# state = State(n=4)
# state.set_at(1, 2, "B")
# state.set_at(0, 2, "B")

state = State(n=50)
# [(0,34) , (48,1)]
state.set_at(0, 34, "B")
state.set_at(48, 1, "B")

while True:
    # clear screen
    os.system('cls' if os.name == 'nt' else 'clear')
    if state.next_step().inspect().is_full_table():
        break
    # time.sleep(0.25)

print("Final State:")
print(state.__str__())
print("Final Board:")
print(state.display_board())
print("Final Step:", state.step)
