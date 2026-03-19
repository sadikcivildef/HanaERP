<script lang="ts">
  import { navBtn, navBtnLink, navTitle } from "$lib/navStore";
  import { onMount } from "svelte";

  onMount(() => {
    $navTitle = "Dashboard";
    $navBtn = "";
    $navBtnLink = "";
  });
</script>

Dashboard and all the summary will be added soon.
