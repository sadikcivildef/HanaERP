<script lang="ts">
  import type { LayoutServerData } from "../$types";
  import SideNav from "./ui/side-nav.svelte";
  import TopNav from "./ui/top-nav.svelte";
  import { startLoading } from "$lib/stores/loading";
  import { onMount } from "svelte";

	let { data, children }: { data: LayoutServerData, children: any } = $props();

  // Start loading when entering dashboard
  onMount(() => {
    startLoading();
  });
</script>

<div class="flex">
  <div class="w-fit">
    <SideNav {data}/>
  </div>
  <div class="flex-1 h-screen overflow-hidden relative">
    <TopNav/>

    <div class="p-6 h-[calc(100vh-3rem)] custom-scroll overflow-y-auto">
      {@render children()}
    </div>
  </div>
</div>
