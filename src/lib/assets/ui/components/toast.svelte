<script lang="ts">
  import Icon from "@iconify/svelte";
  import { onDestroy } from "svelte";
  import { fly } from "svelte/transition";

  interface Props {
    show?: boolean;
    type?: "success" | "error";
    message?: string;
    duration?: number;
    onDismiss?: () => void;
  }

  let {
    show = $bindable(false),
    type = "success",
    message = "",
    duration = 10000,
    onDismiss = () => {},
  }: Props = $props();

  let timer: string | number | NodeJS.Timeout | undefined;

  $effect(() => {
    if (show) {
      clearTimeout(timer);
      timer = setTimeout(() => {
        show = false;
        onDismiss();
      }, duration);
    }
  });

  onDestroy(() => clearTimeout(timer));
</script>

{#if show}
  <div
    class={`fixed bottom-5 right-5 rounded-xl px-6 py-3 flex items-center gap-3 shadow-lg bg-white ${
      type === "success"
        ? "border border-green-300 text-green-700"
        : "border border-red-300 text-red-700"
    }`}
    in:fly={{ x: 120, duration: 250 }}
    out:fly={{ x: -120, duration: 350 }}
  >
    <Icon
      icon={type === "success" ? "akar-icons:check" : "wordpress:caution"}
      width="24"
      height="24"
    />
    <p>{message}</p>
  </div>
{/if}
