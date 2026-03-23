<script lang="ts">
  import { goto } from "$app/navigation";
  import icon from "$lib/assets/favicon.svg";
  import Button from "$lib/assets/ui/components/button.svelte";
  import Icon from "@iconify/svelte";
  let menuOpen = false;
</script>

<div class="h-18 flex items-center justify-between px-10 z-50">
  <a href="/" class="flex items-center text-2xl gap-3 text-primary font-semibold">
    <img src={icon} alt="" class="h-10" /> Hana ERP
  </a>

  <div class="relative flex items-center">
    <ul class="flex z-50 items-center max-md:{menuOpen ? "": "hidden"} max-md:items-start  md:gap-5 max-md:absolute max-md:top-8 max-md:right-0 max-md:min-w-45 max-md:border rounded-md max-md:border-gray-300 md:p-3 bg-white max-md:flex-col max-md:shadow-md">
      <li class="w-full"><a class="hover:text-primary block px-3 py-1 max-md:py-2 hover:bg-primary/20 md:rounded-md" href="/about">About</a></li>
      <li class="w-full"><a class="hover:text-primary block px-3 py-1 max-md:py-2 hover:bg-primary/20 md:rounded-md" href="/learn">Learn</a></li>
      <li class="w-full"><a class="hover:text-primary block px-3 py-1 max-md:py-2 hover:bg-primary/20 md:rounded-md" href="/pricing">Pricing</a></li>
      <li class="w-full md:hidden px-3"><hr class="my-1 mb-3 border-gray-300 w-full"></li>
      <li class="w-full max-md:px-3 max-md:pb-3"><Button className="w-full" onclick={()=>goto('/login')}>Login</Button></li>
    </ul>
    <button onclick={()=>menuOpen=!menuOpen} class="md:hidden">
      <Icon icon="humbleicons:bars" width="24" height="24" />
    </button>
  </div>
</div>
