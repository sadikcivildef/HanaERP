<script>
  import SideNav from "./ui/side-nav.svelte";
  import TopNav from "./ui/top-nav.svelte";
</script>

<div class="flex">
  <div class="w-fit">
    <SideNav />
  </div>
  <div class="flex-1">
    <TopNav/>

    <div class="p-4">
      <slot/>
    </div>
  </div>
</div>
