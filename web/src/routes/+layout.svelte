<script lang="ts">
	import Header from "$lib/components/Header.svelte";
	import Footer from "$lib/components/Footer.svelte";
	import "../app.css";
	import { current_user } from "$lib/state/current_user.svelte.js";
	import { notifs } from "$lib/state/notifications.svelte.js";
	import { fetch_notifs } from "$lib/utils/notifs";
	import { friends_map, fetch_friends_map } from "$lib/state/friends_map.svelte.js";
	import { onMount } from "svelte";
	import BannerNotifications from "$lib/components/notifications/BannerNotifications.svelte";
	import { afterNavigate } from "$app/navigation";
	import { checkAndShowPendingToasts } from "$lib/state/toast.svelte.js";
	import { Toaster } from "$lib/components/ui/sonner";

	let { children, data } = $props();

	$effect(() => {
		if (data.current_user_id) {
			current_user.id = data.current_user_id;
		}
	});

	// every 10 seconds, poll notifications
	onMount(() => {
		fetch_friends_map();
		fetch_notifs();
		// const interval = setInterval(
		// 	() => {
		// 		fetch_notifs();
		// 	},
		// 	1000 * 60 * 5,
		// ); // 5 minutes
		//
		// return () => {
		// 	clearInterval(interval);
		// };
	});

	afterNavigate(() => {
		checkAndShowPendingToasts();
	});
</script>

<div class="app">
	<Header />
	<BannerNotifications />
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
