<script lang="ts">
	import type { Notification } from "$lib/api_calls/types";
	import * as Item from "$lib/components/ui/item/index.js";
	import { Bell, ContactRound, Handshake } from "@lucide/svelte";
	import { Button } from "$lib/components/ui/button";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import type { Component } from "svelte";

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

	const notifFields: { icon: Component; link?: string } = (() => {
		switch (notification.notif_type) {
			case "pending_friend_request":
				return {
					icon: ContactRound,
					link: "/friends",
				};
			case "accepted_friend_request":
				return {
					icon: Handshake,
					link: "/users/" + notification.extras.user_id,
				};
			default:
				return {
					icon: Bell,
				};
		}
	})();

	const link = () => {
		switch (notification.notif_type) {
		}
	};
</script>

{console.log("notification", notification)}

<a href={notifFields.link}>
	<Item.Root
		variant={notification.active ? "default" : "muted"}
		size="sm"
		class="border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800"
	>
		<Item.Media>
			<notifFields.icon />
		</Item.Media>
		<Item.Content>
			<Item.Title>{notification.message}</Item.Title>
			<Item.Description>{formatDate(notification.created_at)}</Item.Description>
		</Item.Content>
	</Item.Root>
</a>
