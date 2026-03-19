<script lang="ts">
 export let align: "left" | "center" | "right" = "left";
 const alignmentClasses = {
    left: "text-left",
    center: "text-center",
    right: "text-right",
 }
</script>
<td class="px-4 py-2 {alignmentClasses[align]} align-middle font-medium"><slot /></td>
<!-- <tr class="border-b border-b-gray-300 transition-colors hover:bg-primary/3">
        <td class="px-4 py-2 align-middle font-medium">101</td>
        <td class="px-4 py-2 align-middle">Rahim Mia</td>
        <td class="px-4 py-2 align-middle">Sewing</td>
        <td class="px-4 py-2 align-middle">A1</td>
        <td class="px-4 py-2 align-middle">Operator</td>
        <td class="px-4 py-2 align-middle">18-03-2026</td>
        <td class="px-4 py-2 align-middle text-right">Absent</td>
      </tr>
      <tr class="border-b border-b-gray-300 transition-colors hover:bg-primary/3">
        <td class="px-4 py-2 align-middle font-medium">102</td>
        <td class="px-4 py-2 align-middle">Fatima Begum</td>
        <td class="px-4 py-2 align-middle">Cutting</td>
        <td class="px-4 py-2 align-middle">-</td>
        <td class="px-4 py-2 align-middle">Assistant Operator</td>
        <td class="px-4 py-2 align-middle">10-12-2025</td>
        <td class="px-4 py-2 align-middle text-right">Active</td>
      </tr> -->
