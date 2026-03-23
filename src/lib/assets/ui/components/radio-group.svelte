<script lang="ts">
  interface Props {
    options: Record<string, string>;
    selectedOption?: string | null;
    label?: string;
    name?: string;
  }

  let { 
    options = {}, 
    selectedOption = $bindable(null), 
    label = "Select an option", 
    name = "radio-group" 
  }: Props = $props();
</script>

<fieldset class="space-y-3">
  <legend class="text-sm font-medium text-gray-700">{label}</legend>

  <div class="flex flex-wrap gap-4">
    {#each Object.entries(options) as [value, labelText]}
      <label class="inline-flex items-center gap-2 cursor-pointer">
        <input
          type="radio"
          {name}
          value={value} 
          bind:group={selectedOption} 
          class="w-4 h-4 text-blue-600"
        />
        <span class="text-sm text-gray-700">{labelText}</span>
      </label>
    {/each}
  </div>
</fieldset>