<script lang="ts">
	import type { Notification } from "$lib/api_calls/types";
	import * as Item from "$lib/components/ui/item/index.js";
	import {
		Bell,
		ContactRound,
		Handshake,
		NotebookPen,
		CalendarPlus,
		BookMarked,
		MessageCirclePlus,
	} from "@lucide/svelte";
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
			case "commented_on_your_commentable":
			case "commented_on_a_commentable_you_are_following":
				if (notification.extras.event_id) {
					return {
						icon: MessageCirclePlus,
						link: "/events/" + notification.extras.event_id,
					};
				}
				if (notification.extras.recommendation_id) {
					return {
						icon: MessageCirclePlus,
						link: "/recommendations/" + notification.extras.recommendation_id,
					};
				} else {
					return {
						icon: MessageCirclePlus,
						link: "/posts/" + notification.extras.post_id,
					};
				}
			case "created_a_feedable":
				if (notification.extras.event_id) {
					return {
						icon: CalendarPlus,
						link: "/events/" + notification.extras.event_id,
					};
				}
				if (notification.extras.recommendation_id) {
					return {
						icon: BookMarked,
						link: "/recommendations/" + notification.extras.recommendation_id,
					};
				} else {
					return {
						icon: NotebookPen,
						link: "/posts/" + notification.extras.post_id,
					};
				}
			case "event_rsvp":
			case "event_invitation":
				return {
					icon: CalendarPlus,
					link: "/events/" + notification.extras.event_id,
				};
			default:
				return {
					icon: Bell,
				};
		}
	})();

	let clear_notif = async () => {
		await fetch("/api/clear_notification", {
			method: "POST",
			body: JSON.stringify({ id: notification.id }),
			headers: {
				"Content-Type": "application/json",
			},
		});
	};
</script>

<a href={notifFields.link}>
	<Item.Root
		variant={notification.active ? "default" : "muted"}
		size="sm"
		class="border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800"
		onclick={() => {
			if (notification.active) clear_notif();
		}}
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
