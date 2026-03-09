<script lang="ts">
  import Button from "$lib/assets/ui/components/button.svelte";
  import Header from "$lib/assets/ui/sections/header.svelte";
  </script>

<Header/>


<div
  class="p-15 min-h-120 flex flex-col gap-10 items-center justify-center bg-[url(bg.svg)] bg-cover"
>
  <div class="text-center  text-6xl font-mono text-primary">Welcome <span class="max-md:hidden">to Hana ERP</span></div>
  <div class="text-center max-w-270 leading-loose text-2xl text-gray-500">
    Hana ERP (EXA 4HANA) leverages in-memory computing to deliver real-time data
    processing, streamlining complex business operations through an integrated,
    modern interface.
  </div>
  <div class="flex items-center gap-5 text-xl">
    <Button variant="outline">Learn</Button>
    <Button>Login</Button>
  </div>
</div>
