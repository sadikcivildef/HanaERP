<script lang="ts">
  import icon from "$lib/assets/favicon.svg";
  import Icon from "@iconify/svelte";
</script>

<div class="w-64 h-screen bg-primary/3 border-r border-gray-300">
  <div class="">
    <a
      href="/"
      class="flex items-center h-12 border-b ps-4 border-gray-300 text-lg gap-3 text-primary"
    >
      <img src={icon} alt="" class="h-5" /> Hana ERP
    </a>
  </div>
  <div class="h-full py-3 flex flex-col gap-5">
    <div class="text-xs text-gray-500">
      <div class="px-4">Home</div>
      <ul class="text-sm text-black px-2 flex flex-col pt-2.5 gap-2">
        <li>
          <a href="/dashboard" class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:dashboard" width="17" height="17" /> Dashboard</a
          >
        </li>
      </ul>
    </div>
  </div>
</div>
