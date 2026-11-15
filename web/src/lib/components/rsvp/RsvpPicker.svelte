<script lang="ts">
	import { page } from "$app/state";
	import { Popover } from "bits-ui";
	import { type Rsvp, type RsvpStatus, type User, RSVP_STATUSES } from "$lib/api_calls/types";
	import { RSVP_LABELS } from "$lib/components/rsvp/RsvpStatusText.svelte";
	import { current_user } from "$lib/state/current_user.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { cn } from "$lib/utils.js";

	interface Props {
		event_id: string;
		rsvps: Rsvp[];
		align?: "start" | "end";
		class?: string;
	}

	let { event_id, rsvps = $bindable([]), align = "end", class: className }: Props = $props();

	let picking = $state(false);
	let sending = $state(false);

	let mine = $derived(rsvps.find((r) => r.user?.id === current_user.id));
	let me = $derived<User>(
		mine?.user ??
			({
				id: current_user.id,
				name: page.data.current_name ?? "you",
				profile_photo_url: page.data.current_photo ?? undefined,
			} as User),
	);

	const rsvp = async (status: RsvpStatus) => {
		picking = false;
		if (sending || status === mine?.status) return;
		sending = true;
		const before = rsvps;
		rsvps = [
			...before.filter((r) => r.user?.id !== current_user.id),
			{ event_id, status, user: me },
		];
		try {
			const response = await fetch("/api/rsvp/update", {
				method: "POST",
				headers: { "Content-Type": "application/json" },
				body: JSON.stringify({ event_id, status }),
			});
			const json = await response.json().catch(() => null);
			if (!response.ok || !json || json["errors"] || json["error"]) {
				rsvps = before;
				newToast("Couldn't rsvp: " + (json?.["errors"] ?? json?.["error"] ?? ""), ToastType.Error);
			}
		} finally {
			sending = false;
		}
	};

	// h-7 (28px): the popover's sideOffset pulls it back over the chip by this much
	const chip =
		"inline-flex h-7 shrink-0 items-center border border-dashed border-zinc-500 text-sm dark:border-zinc-400";
</script>

<Popover.Root bind:open={picking}>
	<Popover.Trigger
		class={cn(
			chip,
			"cursor-pointer px-2.5 hover:border-solid",
			mine ? "text-zinc-700 dark:text-zinc-200" : "text-zinc-500 dark:text-zinc-400",
			className,
		)}
		aria-label={mine ? `your rsvp: ${RSVP_LABELS[mine.status]}, change it` : "rsvp"}
		disabled={sending}
	>
		{mine ? RSVP_LABELS[mine.status] : "rsvp?"}
	</Popover.Trigger>
	<Popover.Portal>
		<!-- anchored to the chip's bottom corner: it opens over the chip and grows up. a column of
		     choices, dashed lines between; each is pulled up 1px so neighbours share one line, and
		     the hovered one goes solid above the rest -->
		<Popover.Content
			side="top"
			{align}
			sideOffset={-28}
			class="z-50 flex flex-col bg-zinc-100 pt-px outline-hidden dark:bg-zinc-800"
			role="menu"
			aria-label="your rsvp"
		>
			{#each RSVP_STATUSES as status}
				<button
					type="button"
					role="menuitem"
					class={cn(
						chip,
						"relative -mt-px cursor-pointer px-2.5 hover:z-10 hover:border-solid",
						align === "end" ? "justify-end" : "justify-start",
						"text-zinc-700 dark:text-zinc-200",
					)}
					onclick={() => rsvp(status)}
				>
					{RSVP_LABELS[status]}
				</button>
			{/each}
		</Popover.Content>
	</Popover.Portal>
</Popover.Root>
