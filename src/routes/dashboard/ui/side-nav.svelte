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
          <a
            href="/dashboard"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:dashboard" width="16" height="16" /> Dashboard</a
          >
        </li>
        <li>
          <a
            href="/lifecycle"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon
              icon="carbon:ai-governance-lifecycle"
              width="16"
              height="16"
            /> Lifecycle</a
          >
        </li>
        <li>
          <a
            href="/lifecycle"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="boxicons:bar-chart-big" width="16" height="16" /> Analytics</a
          >
        </li>
        <li>
          <a
            href="/lifecycle"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="ic:outline-folder" width="16" height="16" /> Projects</a
          >
        </li>
        <li>
          <a
            href="/lifecycle"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="radix-icons:people" width="16" height="16" /> Projects</a
          >
        </li>
      </ul>
    </div>
    <div class="text-xs text-gray-500">
      <div class="px-4">Documents</div>
      <ul class="text-sm text-black px-2 flex flex-col pt-2.5 gap-2">
        <li>
          <a
            href="/dashboard"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="bx:data" width="16" height="16" /> Data Library</a
          >
        </li>
      </ul>
    </div>
    <div class="text-xs text-gray-500">
      <ul class="text-sm text-black px-2 flex flex-col pt-2.5 gap-2">
        <li>
          <a
            href="/dashboard"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="clarity:clipboard-line" width="16" height="16" /> Reports</a
          >
        </li>
      </ul>
    </div>
    <div class="text-xs text-gray-500">
      <ul class="text-sm text-black px-2 flex flex-col pt-2.5 gap-2">
        <li>
          <a
            href="/dashboard"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:file-word" width="16" height="16" /> Word Assistant</a
          >
        </li>
      </ul>
    </div>
  </div>
</div>
