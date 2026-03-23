<script lang="ts">
    export let variant: "primary"| "danger" = "primary";
    export let type: "text" | "email" | "date" = "text";
    export let className = "";
    export let name;
    export let value="";
    export let placeholder;
    export let label = "";
</script>

<label class="flex flex-col gap-1 w-full">
  {#if label}
    <div class="text-sm font-medium text-gray-700">{label}</div>
  {/if}
  <input
    class={`px-4 py-1 rounded-md text-[0.9rem] shadow-xs border 
    ${variant === "primary" 
    
    ? "border-gray-300 ring-primary/20 focus:border-primary/70"
    : "border-red-500/70 ring-red-500/20 focus:border-ring-red-500/70" }
    outline-none ring-0  focus:ring-3 transition-all ease-in-out ${className}`}
    type={type}
    name={name}
    bind:value={value}
    placeholder={placeholder}
  />
</label>
