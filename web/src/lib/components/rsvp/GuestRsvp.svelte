<script lang="ts">
	import { Button } from "$lib/components/ui/button";
	import RsvpButton from "$lib/components/rsvp/RsvpButton.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import GuestRsvpDialog, { type GuestDetails } from "$lib/components/rsvp/GuestRsvpDialog.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { invalidateAll } from "$app/navigation";
	import type { Guest, GuestRsvp } from "$lib/api_calls/types";

	let {
		event_id,
		guest,
		guest_rsvps,
	}: {
		event_id: string;
		// the guest remembered in this browser, if any
		guest: Guest | null;
		guest_rsvps: GuestRsvp[];
	} = $props();

	let open = $state(false);
	let my_rsvp = $derived(guest ? guest_rsvps.find((r) => r.guest_id === guest.id) : undefined);

	const rsvp = async ({ name, email, status }: GuestDetails): Promise<boolean> => {
		const response = await fetch("/api/guest/rsvp", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ event_id, status, name, email }),
		});
		const res = await response.json();
		if (!res.success) {
			newToast("Error rsvping: " + res.message, ToastType.Error);
			return false;
		}
		newToast("Thanks for rsvping!", ToastType.Success);
		await invalidateAll();
		return true;
	};
</script>

<div class="flex flex-row flex-wrap items-center gap-2">
	{#if my_rsvp}
		<RsvpButton rsvp_status={my_rsvp.status} click_handler={() => (open = true)} />
	{:else}
		<Button size="sm" onclick={() => (open = true)}>RSVP</Button>
	{/if}
	{#if guest}
		<span class="text-xs text-muted-foreground">
			RSVPing as {guest.name}
		</span>
	{/if}
	<span class="text-xs"><Link url="/sign_in">Sign in</Link></span>
</div>

<GuestRsvpDialog bind:open {guest} current_status={my_rsvp?.status ?? null} onSubmit={rsvp} />
