<script lang="ts">
	import type { Notification } from "$lib/api_calls/types";
	import * as Item from "$lib/components/ui/item/index.js";
	import { Button } from "$lib/components/ui/button";
	import { ContactRound } from "@lucide/svelte";

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
			<Item.Root
				variant={notification.active ? "default" : "muted"}
				size="sm"
				class="border border-gray-200 dark:border-gray-700"
			>
				<Item.Media>
					<ContactRound />
				</Item.Media>
				<Item.Content>{notification.message}</Item.Content>
				<Item.Actions>
					<Button variant="ghost" size="sm">take some action</Button>
				</Item.Actions>
			</Item.Root>
		{/each}
	</Item.Group>
</div>
