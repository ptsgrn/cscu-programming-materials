<script lang="ts">
  import { onMount } from "svelte";

  class StateTable {
    // State variables
    #step = $state(0);
    #x = $state(0);
    #y = $state(0);
    #facing = $state(0);
    #board: (number | string)[][] = $state([]);
    facing_labels = ["up ↑", "right →", "down ↓", "← left"];
    facing_deltas = [
      [-1, 0], // up
      [0, 1], // right
      [1, 0], // down
      [0, -1], // left
    ];
    #size = $state(4);
    #cellSize = $state(50); // Default cell size
    #bpos: number[][] = $state([]); // B positions
    tempBPos = $state([0, 0]);
    #fps = $state(60);
    #canvas: HTMLCanvasElement | null = $state(null);
    #isAnimating = $state(false);

    constructor(size: number) {
      this.#size = size;
      this.#board = Array.from({ length: size }, () => Array(size).fill(0));
    }

    at(x: number, y: number) {
      return this.#board[y][x];
    }

    setAt(x: number, y: number, value: number | string) {
      if (x < 0 || x >= this.#size || y < 0 || y >= this.#size) {
        throw new Error("Coordinates out of bounds");
      }
      this.#board[y][x] = value;
    }

    currentPosState() {
      return this.at(this.#x, this.#y);
    }

    nextStep() {
      if (this.currentPosState() === 0) {
        this.setAt(this.#x, this.#y, 1);
        this.turnClockwise();
        this.moveStraight();
      } else if (this.currentPosState() === 1) {
        this.turnCounterclockwise();
        this.setAt(this.#x, this.#y, 2);
        this.moveStraight();
      } else if (this.currentPosState() === 2) {
        this.moveStraight();
      } else if (this.currentPosState() === "B") {
        this.turnCounterclockwise();
        this.moveStraight();
      }
      this.#step += 1;
      this.updateCanvas();
    }

    turnClockwise() {
      this.#facing = (this.#facing + 1) % 4;
    }

    turnCounterclockwise() {
      this.#facing = (this.#facing + 3) % 4;
    }

    moveStraight() {
      const [dx, dy] = this.facing_deltas[this.#facing];
      this.#x = (this.#x + dx + this.#size) % this.#size;
      this.#y = (this.#y + dy + this.#size) % this.#size;
    }

    drawBoard() {
      if (!this.#canvas) return;

      const ctx = this.#canvas.getContext("2d");
      if (!ctx) return;

      const width = this.#canvas.width;
      const height = this.#canvas.height;

      // Clear the canvas
      ctx.clearRect(0, 0, width, height);

      // Draw the grid
      for (let i = 0; i < this.#size; i++) {
        for (let j = 0; j < this.#size; j++) {
          const cell = this.#board[i][j];
          const x = j * this.#cellSize;
          const y = i * this.#cellSize;

          // Draw cell background
          if (cell === 0) {
            ctx.fillStyle = "#e0e0e0"; // Grey for 0
          } else if (cell === 1) {
            ctx.fillStyle = "#ffcccc"; // Red for 1
          } else if (cell === 2) {
            ctx.fillStyle = "#ccffcc"; // Green for 2
          } else if (cell === "B") {
            ctx.fillStyle = "#ccccff"; // Blue for "B"
          }
          ctx.fillRect(x, y, this.#cellSize, this.#cellSize);

          // Draw cell border
          ctx.strokeStyle = "#000";
          ctx.strokeRect(x, y, this.#cellSize, this.#cellSize);
          ctx.fillStyle = "#000"; // Text color
          ctx.font = `${this.#cellSize / 3}px IBM Plex Mono`;
          ctx.fillText(
            `${cell}`,
            x + this.#cellSize / 2,
            y + this.#cellSize / 2,
          );
          ctx.textAlign = "center";
          ctx.textBaseline = "middle";

          // Draw the current position
          if (i === this.#y && j === this.#x) {
            ctx.beginPath();
            const centerX = x + this.#cellSize / 2;
            const centerY = y + this.#cellSize / 2;

            // Define the triangle points relative to the center
            const triangle = [
              [0, -this.#cellSize / 4], // Top point
              [-this.#cellSize / 4, this.#cellSize / 4], // Bottom-left
              [this.#cellSize / 4, this.#cellSize / 4], // Bottom-right
            ];

            // Rotate the triangle based on the facing direction
            const angle = (Math.PI / 2) * this.#facing; // 90 degrees per direction
            const rotatedTriangle = triangle.map(([dx, dy]) => {
              const rotatedX = dx * Math.cos(angle) - dy * Math.sin(angle);
              const rotatedY = dx * Math.sin(angle) + dy * Math.cos(angle);
              return [centerX + rotatedX, centerY + rotatedY];
            });

            // Draw the triangle
            ctx.moveTo(rotatedTriangle[0][0], rotatedTriangle[0][1]);
            rotatedTriangle.slice(1).forEach(([px, py]) => {
              ctx.lineTo(px, py);
            });
            ctx.closePath();
            ctx.fillStyle = "#ff0000"; // Red for current position
            ctx.fill();
          }
        }
      }

      if (this.#isAnimating) {
        requestAnimationFrame(() => this.drawBoard());
      }
    }

    toggleAnimation() {
      this.#isAnimating = !this.#isAnimating;
      this.drawBoard();
    }

    setCanvas(canvas: HTMLCanvasElement) {
      this.#canvas = canvas;
      this.#canvas.width = this.#size * this.#cellSize;
      this.#canvas.height = this.#size * this.#cellSize;
      this.drawBoard();
    }

    updateCanvas() {
      this.drawBoard();
    }

    reset() {
      this.#step = 0;
      this.#x = 0;
      this.#y = 0;
      this.#facing = 0;
      this.#board = Array.from({ length: this.#size }, () =>
        Array(this.#size).fill(0),
      );
      for (const pos of this.#bpos) {
        this.setAt(pos[0], pos[1], "B");
      }
      this.updateCanvas();
    }

    get step() {
      return this.#step;
    }

    get size() {
      return this.#size;
    }

    set size(value: number) {
      this.#size = value;
      if (this.#canvas) {
        this.#canvas.width = this.#size * this.#cellSize;
        this.#canvas.height = this.#size * this.#cellSize;
      }
      this.reset();
    }

    get cellSize() {
      return this.#cellSize;
    }

    set cellSize(value: number) {
      this.#cellSize = value;
      if (this.#canvas) {
        this.#canvas.width = this.#size * this.#cellSize;
        this.#canvas.height = this.#size * this.#cellSize;
      }
      this.updateCanvas();
    }

    get x() {
      return this.#x;
    }

    set x(value: number) {
      this.#x = value;
      this.updateCanvas();
    }

    get y() {
      return this.#y;
    }

    set y(value: number) {
      this.#y = value;
      this.updateCanvas();
    }
    get facing() {
      return this.#facing;
    }
    set facing(value: number) {
      this.#facing = value;
      this.updateCanvas();
    }
    get fps() {
      return this.#fps;
    }
    set fps(value: number) {
      this.#fps = value;
      this.updateCanvas();
    }
    get timeInterval() {
      return 1 / this.#fps;
    }
    set timeInterval(value: number) {
      this.#fps = 1 / value;
      this.updateCanvas();
    }

    get currentFacing() {
      return this.#facing;
    }
    set currentFacing(value: number) {
      this.#facing = value;
      this.updateCanvas();
    }
    beautifyFacing(facing: number) {
      return this.facing_labels[facing];
    }
    get bspos() {
      return this.#bpos;
    }

    removeBPossition(x: number, y: number) {
      this.#bpos = this.#bpos.filter((pos) => pos[0] !== x || pos[1] !== y);
      this.setAt(x, y, 0);
      this.updateCanvas();
    }
    addBPossition(x: number, y: number) {
      if (this.#bpos.some((pos) => pos[0] === x && pos[1] === y)) {
        return;
      }
      this.#bpos.push([x, y]);
      this.setAt(x, y, "B");
      this.updateCanvas();
    }
  }

  let tableState = new StateTable(4);

  onMount(() => {
    tableState.setCanvas(
      document.getElementById("boardCanvas") as HTMLCanvasElement,
    );
  });
</script>

<div class="flex flex-col items-center gap-4">
  <canvas id="boardCanvas" class="border border-gray-300"></canvas>

  <div class="flex gap-2">
    <button
      class="btn btn-primary btn-sm"
      onclick={() => tableState.nextStep()}
    >
      Next Step
    </button>
    <button class="btn btn-sm" onclick={() => tableState.reset()}>Reset</button>
  </div>

  <div class="flex flex-col gap-2">
    <label>
      Grid Size:
      <input type="number" bind:value={tableState.size} min="2" max="50" />
    </label>
    <label>
      Cell Size:
      <input
        type="number"
        bind:value={tableState.cellSize}
        min="10"
        max="100"
      />
    </label>
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
                  class="btn btn-sm btn-accent join-item"
                  class:btn-outline={tableState.facing === 0}
                  class:btn-active={tableState.facing === 0}
                  onclick={() => {
                    tableState.currentFacing = 0;
                  }}
                >
                  {tableState.beautifyFacing(0)}
                </button>

                <div class="">
                  <button
                    class="btn btn-sm btn-accent join-item"
                    class:btn-outline={tableState.facing === 3}
                    class:btn-active={tableState.facing === 3}
                    onclick={() => {
                      tableState.currentFacing = 3;
                    }}
                  >
                    {tableState.beautifyFacing(3)}
                  </button>
                  <button
                    class="btn btn-sm btn-accent join-item"
                    class:btn-outline={tableState.facing === 1}
                    class:btn-active={tableState.facing === 1}
                    onclick={() => {
                      tableState.currentFacing = 1;
                    }}
                  >
                    {tableState.beautifyFacing(1)}
                  </button>
                </div>
                <button
                  class="btn btn-sm btn-accent join-item"
                  class:btn-outline={tableState.facing === 2}
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
                  bind:value={tableState.tempBPos[0]}
                  min="0"
                  max={tableState.size - 1}
                /><input
                  type="number"
                  class="input input-sm join-item min-w-max"
                  bind:value={tableState.tempBPos[1]}
                  min="0"
                  max={tableState.size - 1}
                />
                <button
                  class="btn btn-sm join-item"
                  onclick={() => {
                    tableState.addBPossition(
                      tableState.tempBPos[0],
                      tableState.tempBPos[1],
                    );
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

<style>
  canvas {
    display: block;
  }
</style>
