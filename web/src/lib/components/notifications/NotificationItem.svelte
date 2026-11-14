<script lang="ts" module>
	import {
		Bell,
		BookMarked,
		CalendarPlus,
		HeartHandshake,
		MessageCirclePlus,
		NotebookPen,
	} from "@lucide/svelte";
	import type { Component } from "svelte";

	import { ACCENTS, type Accent as Tone } from "$lib/components/posts/FeedBadge.svelte";

	// the server sends whole sentences; these are its templates (Notification model) with the
	// parts that change — who, and what kind of thing — captured, so only those are bright
	const TEMPLATES = [
		/^(.+) (commented on your) (\w+)$/,
		/^(.+) (commented on a) (\w+) (you're following)$/,
		/^(.+) ((?:made|created|shared) a new) (\w+)$/,
		/^(.+) (invited you to an event)$/,
		/^(.+) (rsvp'd to your event)$/,
		/^(.+) (is now your friend!)$/,
	];
	// which capture groups are fixed wording (the rest are dynamic)
	const FIXED = [[2], [2, 4], [2], [2], [2], [2]];

	// [text, dynamic?] pieces of a message; unknown messages come back as one fixed piece
	function splitMessage(message: string): [string, boolean][] {
		for (const [i, re] of TEMPLATES.entries()) {
			const m = re.exec(message);
			if (!m) continue;
			return m.slice(1).map((part, g) => [part, !FIXED[i].includes(g + 1)]);
		}
		return [[message, false]];
	}
</script>

<script lang="ts">
	import { onMount } from "svelte";
	import type { Notification } from "$lib/api_calls/types";
	import { cn } from "$lib/utils.js";
	import { formatWhen } from "$lib/format_date";
	import { refresh_unread } from "$lib/state/unread_notifications.svelte";
	import FeedBadge from "$lib/components/posts/FeedBadge.svelte";

	interface Props {
		notification: Notification;
	}

	let { notification }: Props = $props();

	// unread until clicked (dims right away) or until the page marks everything read
	let cleared = $state(false);
	let active = $derived(notification.active && !cleared);
	let parts = $derived(splitMessage(notification.message));

	// formatted in the browser so it uses the viewer's timezone
	let when = $state("");
	onMount(() => {
		when = formatWhen(notification.created_at);
	});

	// the post/event/recommendation a notification is about
	const feedable = (
		extras: Notification["extras"],
		icons: { post: Component; event: Component; recommendation: Component },
	): { icon: Component; tone: Tone; link: string } => {
		if (extras.event_id)
			return { icon: icons.event, tone: "lime", link: `/events/${extras.event_id}` };
		if (extras.recommendation_id)
			return {
				icon: icons.recommendation,
				tone: "fuchsia",
				link: `/recommendations/${extras.recommendation_id}`,
			};
		return { icon: icons.post, tone: "sky", link: `/posts/${extras.post_id}` };
	};

	let fields = $derived.by((): { icon: Component; tone: Tone; link?: string } => {
		const { extras } = notification;
		switch (notification.notif_type) {
			case "accepted_friend_request":
				return { icon: HeartHandshake, tone: "yellow", link: `/users/${extras.user_id}` };
			case "commented_on_your_commentable":
			case "commented_on_a_commentable_you_are_following":
				return feedable(extras, {
					post: MessageCirclePlus,
					event: MessageCirclePlus,
					recommendation: MessageCirclePlus,
				});
			case "created_a_feedable":
				return feedable(extras, {
					post: NotebookPen,
					event: CalendarPlus,
					recommendation: BookMarked,
				});
			case "event_rsvp":
			case "event_invitation":
				return { icon: CalendarPlus, tone: "lime", link: `/events/${extras.event_id}` };
			default:
				return { icon: Bell, tone: "zinc" };
		}
	});

	let tone = $derived<Tone>(fields.tone);

	const clear_notif = () => {
		if (!active) return;
		cleared = true;
		fetch("/api/clear_notification", {
			method: "POST",
			body: JSON.stringify({ id: notification.id }),
			headers: { "Content-Type": "application/json" },
		}).then(refresh_unread);
	};
</script>

<svelte:element
	this={fields.link ? "a" : "button"}
	href={fields.link}
	type={fields.link ? undefined : "button"}
	onclick={clear_notif}
	class={cn(
		"flex w-full cursor-pointer flex-row items-start gap-3 p-4 text-left",
		"focus-visible:outline-2 focus-visible:outline-amber-400",
		"border border-dashed border-transparent",
		active
			? cn("border-l-2 [border-left-style:solid]", ACCENTS[tone].bar, ACCENTS[tone].border)
			: cn("pl-[calc(--spacing(4)+1px)]", ACCENTS.zinc.border),
	)}
>
	<FeedBadge icon={fields.icon} accent={tone} />
	<div class="flex min-w-0 flex-col gap-1">
		<span class="leading-tight text-zinc-500 dark:text-zinc-400">
			{#each parts as [text, dynamic], i}{i > 0 ? " " : ""}{#if dynamic}<span
						class="text-zinc-900 dark:text-zinc-100">{text}</span
					>{:else}{text}{/if}{/each}
		</span>
		<span class="text-sm leading-none text-zinc-500 dark:text-zinc-400">{when}</span>
	</div>
	{#if active}
		<span class="sr-only">(unread)</span>
	{/if}
</svelte:element>
