<script lang="ts">
	import EnableNotifications from "$lib/components/notifications/EnableNotifications.svelte";
	import { web_push_notifs_enabled } from "$lib/utils/web_push_notifs";
	import { onMount } from "svelte";

	let showSubscribeButton = $state(false);

	onMount(async () => {
		showSubscribeButton = !(await web_push_notifs_enabled());
	});
</script>

{#if showSubscribeButton}
	<EnableNotifications />
{/if}
