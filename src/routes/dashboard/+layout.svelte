<script>
  import SideNav from "./ui/side-nav.svelte";
  import TopNav from "./ui/top-nav.svelte";
</script>

<div class="flex">
  <div class="w-fit">
    <SideNav />
  </div>
  <div class="flex-1 h-screen overflow-hidden">
    <TopNav/>

    <div class="p-4 h-[calc(100vh-3rem)] custom-scroll overflow-y-scroll">
      <slot/>
    </div>
  </div>
</div>
