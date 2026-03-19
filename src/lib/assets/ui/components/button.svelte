<script lang="ts">
  import Icon from "@iconify/svelte";

  export let variant: "primary" | "outline" | "danger" | "ghost" = "primary";
  export let onclick: () => void | Promise<void> | boolean = () => {};
  export let disabled = false;
  export let className = "";
  export let type: "button" | "submit" | "reset" = "button";
  export let isLoading = false;
  export let loadingMessage = "Loading...";
  const variants = {
    primary: "text-white bg-primary hover:bg-primary/80",
    outline: "border border-gray-300 hover:border-primary hover:text-primary",
    danger: "text-white bg-red-500 hover:bg-red-500/80",
    ghost: "hover:bg-gray-100",
  };
</script>

<button
  on:click={onclick}
  {disabled}
  {type}
  class={`flex gap-2 justify-center items-center py-1 px-4 cursor-pointer focus:outline-none focus:ring-0 active:outline-none active:ring-0 ring-0 hover:ring-0 hover:ring-primary/20 transition-colors duration-100 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed ${variants[variant]} ${className} `}
>
  {#if isLoading}
    <Icon class="opacity-80" icon="line-md:loading-loop" width="18" height="18" />
    <span class="opacity-80">{loadingMessage}</span>
  {:else}
    <slot />
  {/if}
</button>
