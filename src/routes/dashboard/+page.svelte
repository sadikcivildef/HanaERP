<script lang="ts">
  import { navTitle } from "$lib/navStore";
  import { onMount } from "svelte";

  // When this specific page loads, change the title
  onMount(() => {
    $navTitle = "Dashboard";
  });
</script>
Dashboard and all the summary will be added soon.