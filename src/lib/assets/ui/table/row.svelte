<script lang="ts">
  export let className="";
</script>
<tr
  class="border-b border-b-gray-300 transition-colors hover:bg-primary/3 data-[state=selected]:bg-slate-100 {className}"
 >
<slot/>
</tr>
