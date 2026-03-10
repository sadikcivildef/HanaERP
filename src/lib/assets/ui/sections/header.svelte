<script lang="ts">
  import icon from "$lib/assets/favicon.svg";
  import Button from "$lib/assets/ui/components/button.svelte";
  import Icon from "@iconify/svelte";
  let menuOpen = false;
</script>

<div class="h-18 flex items-center justify-between px-10 z-50">
  <a href="/" class="flex items-center text-2xl gap-3 text-amber-900">
    <img src={icon} alt="" class="h-10" /> Hana ERP
  </a>

  <div class="relative flex items-center">
    <ul class="flex items-center max-md:{menuOpen ? "": "hidden"} max-md:items-start max-md:gap-4  gap-5 max-md:absolute max-md:top-8 max-md:right-0 max-md:min-w-45 max-md:border rounded-md max-md:border-gray-300 max-md:p-3 bg-white max-md:flex-col max-md:shadow-md">
      <li class="w-full"><a class="hover:text-primary block px-3 py-1 hover:bg-primary/20 rounded-md" href="/about">About</a></li>
      <li class="w-full"><a class="hover:text-primary block px-3 py-1 hover:bg-primary/20 rounded-md" href="/learn">Learn</a></li>
      <li class="w-full"><a class="hover:text-primary block px-3 py-1 hover:bg-primary/20 rounded-md" href="/pricing">Pricing</a></li>
      <li class="w-full"><Button className="w-full">Login</Button></li>
    </ul>
    <button onclick={()=>menuOpen=!menuOpen} class="md:hidden cursor-pointer">
      <Icon icon="humbleicons:bars" width="24" height="24" />
    </button>
  </div>
</div>
