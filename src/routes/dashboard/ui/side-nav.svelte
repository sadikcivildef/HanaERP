<script lang="ts">
  import icon from "$lib/assets/favicon.svg";
  import Icon from "@iconify/svelte";
</script>

<div class="w-64 flex flex-col bg-primary/3 border-r border-gray-300">
  <div class="h-12 border-b ps-4 border-gray-300">
    <a href="/" class="flex items-center h-12 text-lg gap-3 text-primary">
      <img src={icon} alt="" class="h-5" /> Hana ERP
    </a>
  </div>
  <div class="flex-1 py-3 flex flex-col gap-5">
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
  <div class="text-xs text-gray-500 pt-10">
    <ul class="text-sm text-black px-2 flex flex-col pt-2.5 gap-2">
      <li>
        <a
          href="/dashboard"
          class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
          ><Icon icon="lets-icons:setting-line" width="16" height="16" /> Settings</a
        >
      </li>
      <li>
        <a
          href="/dashboard"
          class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
          ><Icon icon="gridicons:help-outline" width="16" height="16" /> Get Help</a
        >
      </li>
      <li>
        <a
          href="/dashboard"
          class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
          ><Icon
            icon="material-symbols:search-rounded"
            width="16"
            height="16"
          /> Search</a
        >
      </li>
    </ul>
    <div class="px-2 py-4">
      <div
        class="px-2 flex cursor-default hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
      >
        <img src="/shadcn.jpg" alt="" class="w-8 h-8 rounded-lg" />
        <div class="flex-1 flex flex-col text-start justify-start">
          <div class="text-sm text-black font-semibold">shadcn</div>
          m@example.com
        </div>
        <div class="ps-2 text-black"><Icon
            icon="pepicons-pencil:dots-y"
            width="16"
            height="16"
          /></div>
      </div>
    </div>
  </div>
</div>
