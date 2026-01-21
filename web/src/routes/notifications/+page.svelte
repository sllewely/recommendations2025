<script lang="ts">
	import type { Notification } from "$lib/api_calls/types";
	import * as Item from "$lib/components/ui/item/index.js";
	import { Button } from "$lib/components/ui/button";
	import { ContactRound } from "@lucide/svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";

	interface Props {
		data: {
			notifications: Notification[];
		};
	}

	let { data }: Props = $props();

	const formatDate = (datetime: string) => {
		const localizedCreateTime = parseAbsoluteToLocal(datetime);

		return new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedCreateTime.toDate());
	};
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
				<Item.Content>
					<Item.Title>{notification.message}</Item.Title>
					<Item.Description>{formatDate(notification.created_at)}</Item.Description>
				</Item.Content>
				<Item.Actions>
					<Button variant="ghost" size="sm">take some action</Button>
				</Item.Actions>
			</Item.Root>
		{/each}
	</Item.Group>
</div>
