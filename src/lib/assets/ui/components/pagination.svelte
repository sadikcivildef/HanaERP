<script lang="ts">
  import Button from "./button.svelte";
  import Icon from "@iconify/svelte";

  interface PaginationItem {
    [key: string]: any;
  }

  export let items: PaginationItem[] = [];
  export let itemsPerPage = 10;

  let currentPage = 1;

  $: totalPages = Math.ceil(items.length / itemsPerPage);
  $: paginatedItems = items.slice(
    (currentPage - 1) * itemsPerPage,
    currentPage * itemsPerPage
  );

  function goToPage(page: number) {
    if (page >= 1 && page <= totalPages) {
      currentPage = page;
    }
  }
</script>

<div class="flex flex-col gap-4">
  <slot {paginatedItems} />

  <div class="flex justify-between items-center gap-4">
    <div class="text-sm text-gray-600">
      Showing {(currentPage - 1) * itemsPerPage + 1} to {Math.min(
        currentPage * itemsPerPage,
        items.length
      )} of {items.length}
    </div>
    <div class="flex gap-2">
      <Button variant="ghost" onclick={() => goToPage(currentPage - 1)} disabled={currentPage === 1}>
        <Icon icon="tabler:chevron-left" class="my-0.5 w-4 h-4" /> <div class="text-[0.9rem]">Previous</div>
      </Button>

      {#each Array.from({ length: totalPages }, (_, i) => i + 1) as page}
        {#if page === 1 || page === totalPages || (page >= currentPage - 1 && page <= currentPage + 1)}
          {#if page > 1 && page > currentPage + 2}
            <span class="px-2 py-1">...</span>
          {/if}
          <Button
            onclick={() => goToPage(page)}
            variant={currentPage === page ? "outline" : "ghost"}
          >
            <div class="-mx-2">{page}</div>
          </Button>
        {/if}
      {/each}

      <Button variant="ghost" onclick={() => goToPage(currentPage + 1)} disabled={currentPage === totalPages}>
         <div class="text-[0.9rem]">Next</div><Icon icon="tabler:chevron-right" class=" my-0.5 w-4 h-4" />
      </Button>
    </div>
  </div>
</div>
