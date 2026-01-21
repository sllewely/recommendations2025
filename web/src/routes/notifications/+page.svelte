<script lang="ts">
	import type { Notification } from "$lib/api_calls/types";
	import * as Item from "$lib/components/ui/item/index.js";

	import NotificationItem from "$lib/components/notifications/NotificationItem.svelte";

	interface Props {
		data: {
			notifications: Notification[];
		};
	}

	let { data }: Props = $props();
</script>

<div>
	<span>this page is a work in progress!! lmk what notif features you want</span>
	<Item.Group>
		{#each data.notifications as notification}
			<NotificationItem {notification} />
		{/each}
	</Item.Group>
</div>
