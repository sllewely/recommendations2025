<script lang="ts">
	import type { Notification } from "$lib/api_calls/types";
	import * as Item from "$lib/components/ui/item/index.js";
	import { ContactRound } from "@lucide/svelte";
	import { Button } from "$lib/components/ui/button";
	import { parseAbsoluteToLocal } from "@internationalized/date";

	interface Props {
		notification: Notification;
	}

	let { notification }: Props = $props();

	const formatDate = (datetime: string) => {
		const localizedCreateTime = parseAbsoluteToLocal(datetime);

		return new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedCreateTime.toDate());
	};
</script>

<Item.Root
	variant={notification.active ? "default" : "muted"}
	size="sm"
	class="border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800"
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
