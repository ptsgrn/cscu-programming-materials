<script lang="ts">
  class StateTable {
    #step = $state(0);
    #x: number = $state(0);
    #y: number = $state(0);
    #facing: number = $state(0);
    #board: (number | string)[][] = $state([]);
    facing_labels: string[] = $state([]);
    facing_deltas: number[][] = $state([]);
    #max_fillable_cells: number = $state(0);
    #number_of_twos: number = $state(0);
    #size: number = $state(0);
    #cellSize: number = $state(0);
    #isAutoPlay: boolean = $state(false);
    #timeInterval: number = $state(200);
    #bspos: number[][] = $state([]);
    #timeStart: Date = $state(new Date());
    #timeEnd: Date = $state(new Date());

    constructor(size: number) {
      this.#step = 0;
      this.#x = 0;
      this.#y = 0;
      this.#facing = 0;
      this.#size = size;
      this.#board = Array.from({ length: size }, () => Array(size).fill(0));
      this.facing_labels = ["up ↑", "right →", "down ↓", "← left"];
      this.facing_deltas = [
        [-1, 0], // up
        [0, 1], // right
        [1, 0], // down
        [0, -1], // left
      ];
      this.#max_fillable_cells = size * size;
      this.#number_of_twos = 0;
      this.#cellSize = 100; // Default cell size
      this.#isAutoPlay = false;
      this.#timeInterval = 100; // Default time interval for auto play
    }

    isFullTable(): boolean {
      // return this.#number_of_twos === this.#max_fillable_cells;
      return false; // กุ ขก ละ
    }

    at(x: number, y: number) {
      return this.#board[y][x];
    }

    currentPos(): [number, number] {
      return [this.#x, this.#y];
    }

    turnClockwise(): StateTable {
      this.log(
        `Turning clockwise from ${this.facing_labels[this.#facing]} to ${this.facing_labels[(this.#facing + 1) % 4]}`,
      );
      this.#facing = (this.#facing + 1) % 4;
      return this;
    }

    turnCounterclockwise(): StateTable {
      this.log(
        `Turning counterclockwise from ${this.facing_labels[this.#facing]} to ${this.facing_labels[(this.#facing + 3) % 4]}`,
      );
      this.#facing = (this.#facing + 3) % 4;
      return this;
    }

    moveStraight(step: number = 1): StateTable {
      const [dx, dy] = this.facing_deltas[this.#facing];
      let x = (this.#x + dx * step + this.#size) % this.#size;
      let y = (this.#y + dy * step + this.#size) % this.#size;
      this.log(`Moving from (${this.#x}, ${this.#y}) to (${x}, ${y})`);
      this.#x = x;
      this.#y = y;
      return this;
    }

    setAt(x: number, y: number, value: number | string): StateTable {
      if (x < 0 || x >= this.#size || y < 0 || y >= this.#size) {
        throw new Error("Coordinates out of bounds");
      }
      if (![0, 1, 2, "B"].includes(value)) {
        throw new Error("Invalid value. Only 0, 1, 2, or 'B' are allowed.");
      }
      this.#board[y][x] = value;
      if (value === "B") {
        this.#max_fillable_cells -= 1;
      }
      return this;
    }

    currentPosState() {
      return this.at(this.#x, this.#y);
    }

    nextStep(): StateTable {
      if (this.currentPosState() === 0) {
        this.setAt(this.#x, this.#y, 1);
        this.turnClockwise();
        this.moveStraight();
      } else if (this.currentPosState() === 1) {
        this.turnCounterclockwise();
        this.setAt(this.#x, this.#y, 2);
        this.moveStraight();
        this.#number_of_twos += 1;
      } else if (this.currentPosState() === 2) {
        this.moveStraight();
      } else if (this.currentPosState() === "B") {
        this.turnCounterclockwise();
        this.moveStraight();
      }
      this.#step += 1;
      return this;
    }

    isColumnCyclic(col: number): boolean {
      if (this.#facing === 1 || this.#facing === 3) {
        return false;
      }
      for (let row = 0; row < this.#size; row++) {
        if (this.#board[row][col] !== 2) {
          return false;
        }
      }
      return true;
    }

    isRowCyclic(row: number): boolean {
      if (this.#facing === 0 || this.#facing === 2) {
        return false;
      }
      for (let col = 0; col < this.#size; col++) {
        if (this.#board[row][col] !== 2) {
          return false;
        }
      }
      return true;
    }

    inspect(): void {
      console.log(this.toString());
    }

    log(text: string): void {
      console.log(`[${this.step.toString().padStart(5)}] ${text}`);
    }

    toString(): string {
      let output = `Step: ${this.#step}\nPosition: ${this.#x}, ${this.#y}\nFacing: ${this.facing_labels[this.#facing]}\nBoard:\n`;
      for (let i = 0; i < this.#size; i++) {
        for (let j = 0; j < this.#size; j++) {
          const cell = this.#board[i][j];
          let text = "";
          if (cell === 0) {
            text = "0";
          } else if (cell === 1) {
            text = "1";
          } else if (cell === 2) {
            text = "2";
          } else if (cell === "B") {
            text = "B";
          }
          output += ` ${text} `;
        }
        output += "\n";
      }
      return output;
    }

    beautifyFacing(facing: number, text: boolean = false): string {
      return text
        ? this.facing_labels[facing] || this.facing_labels[this.#facing]
        : this.facing_labels[facing] || this.facing_labels[this.#facing];
    }

    toggleAutoPlay(): void {
      this.#isAutoPlay = !this.#isAutoPlay;
      if (this.#isAutoPlay) {
        this.#timeStart = new Date();
      }
      let interval: number | null = null;
      if (this.#isAutoPlay) {
        interval = setInterval(() => {
          if (this.isFullTable()) {
            this.#isAutoPlay = false;
            if (interval) {
              clearInterval(interval);
              this.#timeEnd = new Date();
              const timeDiff =
                this.#timeEnd.getTime() - this.#timeStart.getTime();
              this.log(`Full table reached in ${timeDiff}ms`);
            }
            return;
          }
          if (!this.#isAutoPlay) {
            if (interval) {
              clearInterval(interval);
              this.log("Auto play stopped");
              this.#timeEnd = new Date();
              const timeDiff =
                this.#timeEnd.getTime() - this.#timeStart.getTime();
              this.log(`Auto play stopped after ${timeDiff}ms`);
            }
            return;
          }
          this.nextStep();
        }, this.#timeInterval);
      } else {
        if (interval) {
          clearInterval(interval);
          this.log("Auto play stopped");
          this.#timeEnd = new Date();
          const timeDiff = this.#timeEnd.getTime() - this.#timeStart.getTime();
          this.log(`Auto play stopped after ${timeDiff}ms`);
        }
      }
    }

    reset() {
      this.#step = 0;
      this.#x = 0;
      this.#y = 0;
      this.#facing = 0;
      this.#board = Array.from({ length: this.#size }, () =>
        Array(this.#size).fill(0),
      );
      for (const pos of this.#bspos) {
        this.setAt(pos[0], pos[1], "B");
      }
      this.#max_fillable_cells = this.#size * this.#size;
      this.#number_of_twos = 0;
      this.#isAutoPlay = false;
    }

    get autoPlayState(): boolean {
      return this.#isAutoPlay;
    }

    get currentFacing(): number {
      return this.#facing;
    }

    set currentFacing(value: number) {
      this.#facing = value;
    }

    get size(): number {
      return this.#size;
    }

    set size(value: number) {
      this.reset();
      this.#size = value;
      this.#board = Array.from({ length: value }, () => Array(value).fill(0));
      this.#max_fillable_cells = value * value;
    }

    set cellSize(value: number) {
      this.#cellSize = value;
    }

    get cellSize(): number {
      return this.#cellSize;
    }

    get cellSizePx(): string {
      return `${this.#cellSize}px`;
    }

    get board(): (number | string)[][] {
      return this.#board;
    }

    get step(): number {
      return this.#step;
    }
    get x(): number {
      return this.#x;
    }
    get y(): number {
      return this.#y;
    }
    set x(value: number) {
      this.#x = value;
    }
    set y(value: number) {
      this.#y = value;
    }
    get max_fillable_cells(): number {
      return this.#max_fillable_cells;
    }
    get facing(): number {
      return this.#facing;
    }
    get number_of_twos(): number {
      return this.#number_of_twos;
    }

    addBPossition(x: number, y: number): StateTable {
      if (x < 0 || x >= this.#size || y < 0 || y >= this.#size) {
        throw new Error("Coordinates out of bounds");
      }
      this.setAt(x, y, "B");
      this.#bspos.push([x, y]);
      this.#max_fillable_cells -= 1;
      return this;
    }

    toggleCharAtPosition(
      char: string | number,
      x: number,
      y: number,
    ): StateTable {
      if (this.at(x, y) === char) {
        if (char === "B") {
          this.removeBPossition(x, y);
        } else {
          this.setAt(x, y, 0);
        }
      } else if (char === "B") {
        this.addBPossition(x, y);
      } else {
        this.setAt(x, y, char);
      }
      return this;
    }

    removeBPossition(x: number, y: number): StateTable {
      this.setAt(x, y, 0);
      this.#bspos = this.#bspos.filter((pos) => pos[0] !== x || pos[1] !== y);
      this.#max_fillable_cells += 1;
      return this;
    }

    get bspos(): number[][] {
      return this.#bspos;
    }

    get timeInterval(): number {
      return this.#timeInterval;
    }
    set timeInterval(value: number) {
      this.#timeInterval = value;
    }

    debug() {
      return {
        step: this.#step,
        x: this.#x,
        y: this.#y,
        facing: this.#facing,
        board: this.#board,
        max_fillable_cells: this.#max_fillable_cells,
        number_of_twos: this.#number_of_twos,
        size: this.#size,
        cellSize: this.#cellSize,
        isAutoPlay: this.#isAutoPlay,
        timeInterval: this.#timeInterval,
        bspos: this.#bspos,
      };
    }
  }

  let tempBPos = [0, 0];

  const tableState = new StateTable(4);
</script>

<!-- 
<pre>
  {JSON.stringify(tableState.debug(), null, 2)}
</pre> -->

<div class="flex flex-col lg:flex-row gap-4">
  <div
    class="my-5 flex flex-col lg:min-w-1/2 gap-3 items-center justify-center h-full"
  >
    <div class="max-w-full overflow-x-auto lg:max-h-[85vh] p-2">
      <div class="flex flex-col">
        {#each tableState.board as row, rowIndex}
          <div class="flex">
            {#each row as cell, colIndex}
              <div
                style="width: {tableState.cellSizePx}; 
              height: {tableState.cellSizePx}; font-size: {tableState.cellSize /
                  2}px;
                border-radius: {tableState.cellSize / 10}px;"
                class="flex shrink-0 group hover:border-2 hover:border-base-content select-none cursor-pointer items-center justify-center border border-gray-300/10 relative text-base-content/50"
                class:text-grey-700={cell === 0}
                class:bg-red-500={cell === 1}
                class:bg-green-500={cell === 2}
                class:bg-blue-500={cell === "B"}
                class:border-base-200={cell === "B"}
              >
                <div
                  class="absolute z-50 flex-row text-xs left-2 bottom-2 group-hover:flex hidden"
                >
                  <span class="input input-xs join-item w-max">
                    {colIndex},{rowIndex}
                  </span>
                  <button
                    onclick={() => {
                      tableState.x = colIndex;
                      tableState.y = rowIndex;
                    }}
                    class="btn btn-xs"
                  >
                    *
                  </button>
                  <button
                    onclick={() => {
                      tableState.toggleCharAtPosition(0, colIndex, rowIndex);
                    }}
                    class="btn btn-xs"
                  >
                    0
                  </button>
                  <button
                    onclick={() => {
                      tableState.toggleCharAtPosition("B", colIndex, rowIndex);
                    }}
                    class="btn btn-xs"
                  >
                    B
                  </button>
                  <button
                    onclick={() => {
                      tableState.toggleCharAtPosition(1, colIndex, rowIndex);
                    }}
                    class="btn btn-xs"
                  >
                    1
                  </button>
                  <button
                    onclick={() => {
                      tableState.toggleCharAtPosition(2, colIndex, rowIndex);
                    }}
                    class="btn btn-xs"
                  >
                    2
                  </button>
                </div>
                {#if tableState.x === colIndex && tableState.y === rowIndex}
                  {#key tableState.facing}
                    <div
                      class="absolute rotate-45 border-t-2 border-l-2 border-blue-500 transition-transform duration-150"
                      style="height: {tableState.cellSize * 0.5}px; 
                      width: {tableState.cellSize * 0.5}px;"
                      style:transform="rotate({tableState.facing * 90}deg);"
                    ></div>
                  {/key}
                {/if}
                {cell}
              </div>
            {/each}
          </div>
        {/each}
      </div>
    </div>

    <div class="flex gap-2">
      <button
        class="btn btn-primary btn-sm"
        onclick={() => {
          tableState.nextStep();
        }}
      >
        Next Step
      </button>
      <button
        class="btn btn-sm"
        class:btn-secondary={tableState.autoPlayState}
        onclick={(e) => {
          e.preventDefault();
          tableState.toggleAutoPlay();
        }}
      >
        {tableState.autoPlayState ? "Stop" : "Start"} Auto Play
      </button>
      <button class="btn btn-sm" onclick={() => tableState.reset()}
        >Reset</button
      >
    </div>
  </div>

  <div class="flex items-center justify-center flex-col gap-3 p-5 min-w-1/3">
    <div
      class="overflow-x-auto rounded-box border border-base-content/5 bg-base-100"
    >
      <table class="table table-zebra w-full">
        <tbody>
          <tr>
            <th> Dimension (N) </th>
            <td>
              <input
                type="number"
                class="input input-sm"
                bind:value={tableState.size}
              />
            </td>
          </tr>
          <tr>
            <th> Step </th>
            <td>
              #{tableState.step}
            </td>
          </tr>
          <tr>
            <th> Current Position </th>
            <td>
              <div class="join-horizontal join">
                <label class="input input-sm join-item">
                  x
                  <input
                    type="number"
                    class="min-w-max text-end"
                    bind:value={tableState.x}
                    min="0"
                    max={tableState.size - 1}
                  />
                </label>
                <label class="input input-sm join-item">
                  y
                  <input
                    type="number"
                    class="min-w-max text-end"
                    bind:value={tableState.y}
                    min="0"
                    max={tableState.size - 1}
                  />
                </label>
              </div></td
            >
          </tr>
          <tr>
            <th> Facing </th>
            <td>
              <div class="join join-vertical">
                <button
                  class="btn btn-sm join-item"
                  class:btn-active={tableState.facing === 0}
                  onclick={() => {
                    tableState.currentFacing = 0;
                  }}
                >
                  {tableState.beautifyFacing(0)}
                </button>

                <div class="">
                  <button
                    class="btn btn-sm join-item"
                    class:btn-active={tableState.facing === 3}
                    onclick={() => {
                      tableState.currentFacing = 3;
                    }}
                  >
                    {tableState.beautifyFacing(3)}
                  </button>
                  <button
                    class="btn btn-sm"
                    class:btn-active={tableState.facing === 1}
                    onclick={() => {
                      tableState.currentFacing = 1;
                    }}
                  >
                    {tableState.beautifyFacing(1)}
                  </button>
                </div>
                <button
                  class="btn btn-sm join-item"
                  class:btn-active={tableState.facing === 2}
                  onclick={() => {
                    tableState.currentFacing = 2;
                  }}
                >
                  {tableState.beautifyFacing(2)}
                </button>
              </div>
            </td>
          </tr>
          <tr>
            <th> Current State </th>
            <td>
              {tableState.currentPosState()}
            </td>
          </tr>
          <tr>
            <th> Cell Size </th>
            <td>
              <label class="input input-sm">
                <input
                  type="number"
                  class=""
                  bind:value={tableState.cellSize}
                />
                px
              </label>
              <input
                type="range"
                id="cellSize"
                name="cellSize"
                class="range lg:hidden"
                min="2"
                max="200"
                bind:value={tableState.cellSize}
              />
            </td>
          </tr>
          <tr>
            <th>
              Time Interval (ms)
              <span
                class="tooltip tooltip-bottom"
                data-tip="Time difference between each step in auto play mode"
              >
                ?
              </span>
            </th>
            <td>
              <label class="input input-sm">
                <input
                  type="number"
                  class=""
                  bind:value={tableState.timeInterval}
                />
                ms
              </label>
            </td>
          </tr>
          <tr>
            <th> B positions </th>
            <td class="flex flex-col gap-2">
              <div class="gap-2 my-2 rounded-md border-dashed flex flex-wrap">
                {#each tableState.bspos as pos, i}
                  <!-- <input class="w-full">{pos[0]}, {pos[1]}</input> -->
                  <div class="join-horizontal join flex flex-row text-xs">
                    <span class="input join-item input-xs">
                      {pos[0]}
                    </span>
                    <span class="input join-item input-xs">
                      {pos[1]}
                    </span>
                    <button
                      class="btn btn-xs join-item"
                      onclick={() => {
                        tableState.removeBPossition(pos[0], pos[1]);
                      }}
                    >
                      <span class="sr-only"> Remove </span>
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        class="lucide lucide-minus-icon lucide-minus size-3"
                        ><path d="M5 12h14" /></svg
                      >
                    </button>
                  </div>
                {:else}
                  <span class="text-xs text-base-content/40"
                    >No B positions rn</span
                  >
                {/each}
              </div>
              <div class="join-horizontal join">
                <input
                  type="number"
                  class="input input-sm join-item min-w-max"
                  bind:value={tempBPos[0]}
                  min="0"
                  max={tableState.size - 1}
                /><input
                  type="number"
                  class="input input-sm join-item min-w-max"
                  bind:value={tempBPos[1]}
                  min="0"
                  max={tableState.size - 1}
                />
                <button
                  class="btn btn-sm join-item"
                  onclick={() => {
                    tableState.addBPossition(tempBPos[0], tempBPos[1]);
                  }}
                >
                  Add B
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>
