<script lang="ts">
	import './layout.css';
	import favicon from '$lib/assets/favicon.svg';
	import ProgressBar from '$lib/assets/ui/components/progress-bar.svelte';
	import { loadingStore } from '$lib/stores/loading';

	let { children } = $props();
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
	<title>Hana ERP</title>
</svelte:head>

<ProgressBar loading={$loadingStore.isLoading} progress={$loadingStore.progress} />

{@render children()}
