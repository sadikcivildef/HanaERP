<script lang="ts">
  export let variant: "primary" | "outline" | "danger" = "primary";
  export let onclick: (() => void | Promise<void> | boolean) = () => {};
  export let className = "";
</script>

<button
  on:click={onclick}
  class={`${className} py-1 px-4 cursor-pointer ring-0 ring-primary/10 hover:ring-1 transition-all duration-100 rounded-md ${variant === "primary" ? "text-white  bg-primary hover:bg-primary/80" : variant === "outline" ? "border border-gray-400 hover:border-primary hover:text-primary" : "bg-default"}`}
  ><slot /></button
>
