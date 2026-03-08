<script lang="ts">
    import icon from '$lib/assets/favicon.svg';
  import Button from '$lib/components/ui/button.svelte';
</script>
<div class="h-20 flex items-center justify-between px-10">
    <div class="flex items-center text-2xl gap-3 text-amber-900">
        <img src={icon} alt="" class="h-10"> Hana ERP
    </div>

    <ul class="flex items-center gap-8">
        <li><a href="/about">About</a></li>
        <li><a href="/learn">Learn</a></li>
        <li><a href="/pricing">Pricing</a></li>
        <li><Button>Login</Button></li>
    </ul>
</div>

<div class="p-15 h-120 flex flex-col gap-10 items-center justify-center">
    <div class=" text-6xl font-mono text-primary">Welcome to Hana ERP</div>
    <div class="text-center max-w-270 leading-loose text-2xl text-gray-500">Hana ERP (SAP S/4HANA) leverages in-memory computing to deliver real-time data processing, streamlining complex business operations through an integrated, modern interface.</div>
    <div class="flex items-center gap-5 text-xl">
        <Button variant="outline">Learn</Button>
        <Button>Login</Button>
    </div>
</div>