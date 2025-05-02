<script lang="ts">
  import "@fontsource/ibm-plex-mono";

  import MachineTable from "./MachineTable.svelte";
    import Canvas from './Canvas.svelte';
</script>

<svelte:head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>IBM Ponder This January 2021 Visualization</title>
  <link rel="icon" href="/favicon.png" type="image/png" />
  <meta
    name="description"
    content="IBM Ponder This January 2021 Visualization"
  />
  <meta name="author" content="Patsagorn Yuenyong" />
  <meta
    name="keywords"
    content="IBM, Ponder This, January 2021, Visualization"
  />
  <meta name="theme-color" content="#000000" />
  <meta name="og:title" content="IBM Ponder This January 2021 Visualization" />
  <meta
    name="og:description"
    content="IBM Ponder This January 2021 Visualization"
  />
  <meta name="og:image" content="/favicon.png" />
  <meta name="og:url" content="https://ponderthis-jan21.ptsgrn.dev/" />
  <meta name="og:type" content="website" />
  <meta name="og:site_name" content="IBM Ponder This January 2021" />
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="IBM Ponder This January 2021" />
  <meta
    name="twitter:description"
    content="IBM Ponder This January 2021 Visualization"
  />
</svelte:head>

<main class="container m-auto my-5 p-5">
  <h1 class="font-bold text-xl">
    IBM Ponder This <a
      class="link"
      href="https://research.ibm.com/haifa/ponderthis/challenges/January2021.html"
      >January 2021</a
    > Visualization
  </h1>

  <div class="my-4">
    <!-- <MachineTable /> -->
     <Canvas />
  </div>
</main>

<footer class="text-xs footer bg-base-200 text-base-content footer-center">
  <div class="container m-auto p-5">
    Created by <a class="link" href="https://www.ptsgrn.dev"
      >Patsagorn Yuenyong</a
    >
  </div>
  <a
    href="https://github.com/ptsgrn/cscu-programming-materials/tree/main/2301220-math-model-reason/ponder-this-jan2021"
  >
    GitHub
  </a>
</footer>
