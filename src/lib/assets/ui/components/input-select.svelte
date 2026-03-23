<script lang="ts">
  import { clickOutside } from "$lib/actions/click-outside";
  import Icon from "@iconify/svelte";

  type Item = { id: number; text: string };

  interface Props {
    variant?: "primary" | "danger";
    items: Item[];
    label?: string;
    placeholder?: string; // Added a placeholder prop for flexibility
    selected?: Item | undefined; // Allow it to be undefined
  }

  let { 
    variant = "primary", 
    label, 
    placeholder = "Select an option", 
    items = [],
    selected = $bindable(undefined) // Start as undefined by default
  }: Props = $props();

  let isOpen = $state(false);

  const variantStyles = {
    primary: "border-gray-300 ring-primary/20 focus:border-primary/70",
    danger: "border-red-500/70 ring-red-500/20 focus:border-red-500/70",
  };
  
  const baseClasses =
    "px-4 py-2 rounded-md text-[0.9rem] shadow-xs border outline-none ring-0 focus:ring-3 transition-all ease-in-out";

  function handleSelect(items: Item) {
    selected = items;
    isOpen = false;
  }
</script>

<div class="flex gap-1.5 flex-col w-full">
  {#if label}
    <label for="input-select" class="text-sm font-medium text-gray-700">{label}</label>
  {/if}

  <div class="relative w-full" use:clickOutside={() => (isOpen = false)}>
    <button
      type="button"
      onclick={() => (isOpen = !isOpen)}
      class="w-full flex items-center justify-between {baseClasses} bg-white {variantStyles[variant]}"
    >
      <span class="truncate pr-2 {selected ? 'text-gray-900' : 'text-gray-400'}">
        {selected?.text || placeholder}
      </span>
      
      <Icon
        icon="tabler:chevron-down"
        class="shrink-0 transition-transform duration-200 {isOpen ? 'rotate-180 text-primary' : 'text-gray-400'}"
        width="18"
      />
    </button>

    {#if isOpen}
      <div
        class="absolute z-50 w-full mt-1.5 p-1 bg-white border border-gray-200 rounded-lg shadow-xl max-h-60 overflow-y-auto custom-scroll"
      >
        {#each items as item}
          <button
            type="button"
            onclick={() => handleSelect(item)}
            class="w-full text-left flex items-center gap-2 px-3 py-2 rounded-md text-[0.9rem] transition-colors
              {selected?.id === item.id
                ? 'bg-gray-100 text-gray-900'
                : 'text-gray-700 hover:bg-gray-50'}"
          >
            <span class="truncate">{item.text}</span>
            {#if selected?.id === item.id}
              <Icon icon="tabler:check" width="16" class="ml-auto shrink-0" />
            {/if}
          </button>
        {/each}
      </div>
    {/if}
  </div>
</div>