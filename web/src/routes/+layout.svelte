<script lang="ts">
	import Header from "$lib/components/Header.svelte";
	import Footer from "$lib/components/Footer.svelte";
	import { createSubheaderSlot } from "$lib/state/subheader.svelte";
	import { page } from "$app/state";
	import "../app.css";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte.js";
	import { onMount } from "svelte";
	import { afterNavigate } from "$app/navigation";
	import { checkAndShowPendingToasts } from "$lib/state/toast.svelte.js";
	import { Toaster } from "$lib/components/ui/sonner";
	import { global } from "$lib/state/global.svelte";
	import { faro } from "@grafana/faro-web-sdk";

	let { children, data } = $props();

	const subheader = createSubheaderSlot();

	if (data.current_user_id) {
		current_user.id = data.current_user_id;
	}

	global.groups = data.groups;

	onMount(() => {});

	// Keep the Faro user in sync with sign in / sign out
	$effect(() => {
		if (isSignedIn()) {
			faro.api?.setUser({
				id: String(current_user.id),
				fullName: data.current_name ?? undefined,
			});
		} else {
			faro.api?.resetUser();
		}
	});

	afterNavigate(({ to }) => {
		// Tag Faro signals with the route pattern (e.g. /events/[id]) instead of the raw URL
		faro.api?.setView({ name: to?.route?.id ?? to?.url?.pathname ?? "" });
		checkAndShowPendingToasts();
	});
</script>

<svelte:head>
	<title>Bumblebeans</title>
</svelte:head>

<div class="app dark:bg-zinc-800 dark:text-zinc-100">
	<div class="order-1"><Header /></div>

	<Toaster closeButton={true} richColors={true} />
	<main class="order-3">
		{#key page.url.pathname}
			{@render children()}
		{/key}
	</main>
	<div class="order-2">
		{#if subheader.content}
			<div class="bg-zinc-700/50">
				<div
					class="mx-auto flex min-h-26 max-w-[52rem] items-center justify-between gap-4 px-4 py-5"
				>
					{@render subheader.content()}
				</div>
			</div>
		{/if}
	</div>
	<div class="order-4"><Footer /></div>
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
		padding: 2.5rem 1rem; /* py-10 px-4 */
		width: 100%;
		max-width: 52rem;
		margin: 0 auto;
		box-sizing: border-box;
	}
</style>
