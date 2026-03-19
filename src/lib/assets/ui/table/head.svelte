<script lang="ts">
 export let align: "left" | "center" | "right" = "left";
 const alignmentClasses = {
    left: "text-left",
    center: "text-center",
    right: "text-right"
    
 }
</script>
<th class="h-10 px-4
{alignmentClasses[align]}
 align-middle font-medium text-primary/90">
    <slot />
</th>


