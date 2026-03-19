<script lang="ts">
    export let variant: "primary"| "danger" = "primary";
    export let type: "text" | "email" = "text";
    export let className = "";
    export let name;
    export let placeholder;
</script>

<label class="flex flex-col gap-1 w-full">
  <input
    class={`px-4 py-1 rounded-md text-[0.9rem] shadow-xs border 
    ${variant === "primary" 
    
    ? "border-gray-300 ring-primary/20 focus:border-primary/70"
    : "border-red-500/70 ring-red-500/20 focus:border-ring-red-500/70" }
    outline-none ring-0  focus:ring-3 transition-all ease-in-out ${className}`}
    type={type}
    name={name}
    placeholder={placeholder}
  />
</label>
