<script lang="ts">
  import { enhance } from "$app/forms";
  import { clickOutside } from "$lib/actions/click-outside";
  import icon from "$lib/assets/favicon.svg";
  import Icon from "@iconify/svelte";
  import { fly } from "svelte/transition";
  let userMenuOpen = false;
  export let data;
  
</script>

<div class="w-64 flex flex-col h-screen bg-primary/3 border-r border-gray-300">
  <div class="h-12 flex items-center border-b px-1 border-gray-300">
    <a href="/" class="flex w-full items-center h-10 gap-3 font-light px-2 text-primary hover:bg-primary/3 rounded-md">
      <img src={icon} alt="" class="h-7.5" />
      <div class="flex flex-col">
        <div class="text-sm font-medium">Hana ERP</div>
        <div class="text-xs text-gray-500">{data.companyName}</div>
      </div>
    </a>
  </div>
  <div
    class="flex-1 py-3 flex flex-col gap-5 h-screen overflow-y-auto mask-[linear-gradient(to_bottom,black_95%,transparent_100%)]
            [-webkit-mask-image:linear-gradient(to_bottom,black_95%,transparent_100%)] custom-scroll"
  >
    <div class="text-xs text-gray-500">
      <div class="px-4">HRMS</div>
      <ul class="text-sm text-black px-2 flex flex-col pt-2.5 gap-2">
        <li>
          <a
            href="/dashboard"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:dashboard" width="16" height="16" /> Home</a
          >
        </li>
        <li>
          <a
            href="/dashboard/people"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon
              icon="tabler:users"
              width="16"
              height="16"
            /> People</a
          >
        </li>
        <li>
          <a
            href="/lifecycle"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:clock-2" width="16" height="16" /> Time &
            Leave</a
          >
        </li>
        <li>
          <a
            href="/lifecycle"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:credit-card" width="16" height="16" /> Pay & Benefits</a
          >
        </li>
        <li>
          <a
            href="/lifecycle"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:building-burj-al-arab" width="16" height="16" /> Performance
            & Talent</a
          >
        </li>
        <li>
          <a
            href="/lifecycle"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:report" width="16" height="16" /> Insights</a
          >
        </li>
        <li>
          <a
            href="/lifecycle"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:users-group" width="16" height="16" /> Engagement</a
          >
        </li>
        <li>
          <a
            href="/lifecycle"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:wheat" width="16" height="16" /> Support</a
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
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5 group"
            ><Icon icon="tabler:database" width="16" height="16" />
            <div class="flex-1">Data Library</div>
            <div
              class="invisible group-hover:visible opacity-0 group-hover:opacity-100 transition-opacity"
            >
              <Icon icon="tabler:dots" width="16" height="16" />
            </div></a
          >
        </li>
      </ul>
    </div>
    <div class="text-xs text-gray-500">
      <ul class="text-sm text-black px-2 flex flex-col pt-2.5 gap-2">
        <li>
          <a
            href="/dashboard"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5 group"
            ><Icon icon="tabler:report" width="16" height="16" />
            <div class="flex-1">Reports</div>
            <div
              class="invisible group-hover:visible opacity-0 group-hover:opacity-100 transition-opacity"
            >
              <Icon icon="tabler:dots" width="16" height="16" />
            </div></a
          >
        </li>
      </ul>
    </div>
    <div class="text-xs text-gray-500">
      <ul class="text-sm text-black px-2 flex flex-col pt-2.5 gap-2">
        <li>
          <a
            href="/dashboard"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5 group"
            ><Icon icon="tabler:file-word" width="16" height="16" />
            <div class="flex-1">Word Assistant</div>
            <div
              class="invisible group-hover:visible opacity-0 group-hover:opacity-100 transition-opacity"
            >
              <Icon icon="tabler:dots" width="16" height="16" />
            </div></a
          >
        </li>
      </ul>
    </div>
    <div class="text-xs text-gray-500">
      <ul class="text-sm hover:text-black px-2 flex flex-col pt-2.5 gap-2">
        <li>
          <a
            href="/dashboard"
            class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
            ><Icon icon="tabler:dots" width="16" height="16" /> More</a
          >
        </li>
      </ul>
    </div>
  </div>
  <div class="text-xs text-gray-500 pt-5">
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
    <div class="px-2 py-4 relative" use:clickOutside={() => (userMenuOpen = false)}>
      {#if userMenuOpen}
        <div
          in:fly={{ x: -5, y: 5, duration: 50 }}
          out:fly={{ x: -5, y: 5, duration: 50 }}
          class="absolute z-50 pointer-events-auto font-medium text-base bottom-4 -right-63 bg-white w-64 rounded-lg border border-gray-300 shadow-md"
        >
          <div
            class="px-2 flex cursor-default border-b border-gray-300 text-xs items-center gap-2 py-2"
          >
            <img src="/shadcn.jpg" alt="" class="w-8 h-8 rounded-lg" />
            <div class="flex-1 flex flex-col text-start justify-start">
              <div class="text-sm text-black font-semibold">{data.user.name}</div>
              {data.user.email}
            </div>
          </div>
          <div class="text-xs text-gray-500">
            <ul class="text-sm text-black px-1 flex flex-col py-1.5 gap-1">
              <li>
                <a
                  href="/dashboard"
                  class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
                  ><Icon
                    class="text-gray-500"
                    icon="tabler:user-circle"
                    width="16"
                    height="16"
                  /> Account</a
                >
              </li>
              <li>
                <a
                  href="/dashboard"
                  class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
                  ><Icon
                    class="text-gray-500"
                    icon="tabler:credit-card"
                    width="16"
                    height="16"
                  /> Billing</a
                >
              </li>
              <li>
                <a
                  href="/dashboard"
                  class="flex px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
                  ><Icon
                    class="text-gray-500"
                    icon="tabler:notification"
                    width="16"
                    height="16"
                  /> Notifications</a
                >
              </li>
            </ul>
          </div>
          <div class=" px-1 border-t border-gray-300 py-1.5">
            <ul class="text-sm text-black flex flex-col gap-1">
              <li>
                <form method="post" action="?/signOut" use:enhance>
                  <button
                    class="flex w-full cursor-pointer px-2 hover:bg-primary/5 rounded-md items-center gap-2 py-1.5"
                    ><Icon
                      class="text-gray-500"
                      icon="tabler:logout"
                      width="16"
                      height="16"
                    /> Log out</button
                  >
                </form>
              </li>
            </ul>
          </div>
        </div>
      {/if}
      <button
        onclick={() => (userMenuOpen = !userMenuOpen)}
        class={`px-2 w-full flex cursor-default ${userMenuOpen ? "bg-primary/5" : ""} hover:bg-primary/5 rounded-md items-center gap-2 py-1.5`}
      >
        <img src="/shadcn.jpg" alt="" class="w-8 h-8 rounded-lg" />
        <div class="flex-1 flex flex-col text-start justify-start">
          <div class="text-sm text-black font-semibold">{data.user.name}</div>
          <div>{data.user.email}</div>
          <!-- <div>{data.companyName}</div> -->
        </div>
        <div class="ps-2 text-black">
          <Icon icon="pepicons-pencil:dots-y" width="16" height="16" />
        </div>
      </button>
    </div>
  </div>
</div>
