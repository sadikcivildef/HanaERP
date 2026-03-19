<script lang="ts">
  export let loading = false;
  export let progress = 0; // 0-100
  export let height = "2px";
  export let color = "bg-primary";
</script>

{#if loading}
  <div class="fixed top-0 left-0 right-0 z-50">
    <div class="h-0.5 bg-gray-200 overflow-hidden" style="height: {height}">
      <div
        class="h-full transition-all duration-300 ease-out"
        class:bg-primary={color === "bg-primary"}
        class:bg-blue-500={color === "bg-blue-500"}
        class:bg-green-500={color === "bg-green-500"}
        style="width: {progress}%"
      ></div>
    </div>
  </div>
{/if}