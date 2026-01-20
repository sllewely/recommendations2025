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
	<Item.Group class="flex flex-col gap-6">
		{#each data.notifications as notification}
			<Item.Root variant="outline">
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
