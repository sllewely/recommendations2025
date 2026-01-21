<script lang="ts">
	import Header from "$lib/components/Header.svelte";
	import Footer from "$lib/components/Footer.svelte";
	import "../app.css";
	import { current_user } from "$lib/state/current_user.svelte.js";
	import { onMount } from "svelte";
	import { afterNavigate } from "$app/navigation";
	import { checkAndShowPendingToasts } from "$lib/state/toast.svelte.js";
	import { Toaster } from "$lib/components/ui/sonner";

	let { children, data } = $props();

	if (data.current_user_id) {
		current_user.id = data.current_user_id;
	}

	onMount(() => {});

	afterNavigate(() => {
		checkAndShowPendingToasts();
	});
</script>

<div class="app dark:bg-gray-900 dark:text-gray-200">
	<Header />
	<Toaster closeButton={true} richColors={true} />
	<main>
		{@render children()}
	</main>
	<Footer />
</div>

<style>
	.app {
		display: flex;
		flex-direction: column;
		min-height: 100vh;
	}

	main {
		flex: 1;
		display: flex;
		flex-direction: column;
		padding: 1rem;
		width: 100%;
		max-width: 64rem;
		margin: 0 auto;
		box-sizing: border-box;
	}
</style>
