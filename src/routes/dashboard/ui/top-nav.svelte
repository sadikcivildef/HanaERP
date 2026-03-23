<script lang="ts">
  // import { goto } from "$app/navigation";
  // import Button from "$lib/assets/ui/components/button.svelte";
  // import {navBtn, navBtnLink, navTitle } from "$lib/navStore";
  // $: hasNavBtn = $navBtn && $navBtn.trim().length > 0;
</script>

<div
  class="h-12 border-b border-gray-300 flex items-center justify-between px-6"
>
  <!-- <div class="">{$navTitle}</div>
{#if hasNavBtn}
<Button className="text-[0.95rem]" onclick={()=>goto(`/${$navBtnLink}`)}>{$navBtn}</Button>
{/if} -->
  <slot />
</div>
