<script lang="ts" module>
	import type { GuestRsvpStatus } from "$lib/api_calls/types";

	export type GuestDetails = { name: string; email: string; status: GuestRsvpStatus | null };
</script>

<script lang="ts">
	import * as Dialog from "$lib/components/ui/dialog/index.js";
	import { Button } from "$lib/components/ui/button";
	import { Input } from "$lib/components/ui/input";
	import { Label } from "$lib/components/ui/label";
	import { Spinner } from "$lib/components/ui/spinner";
	import Link from "$lib/components/text/Link.svelte";
	import RsvpButton from "$lib/components/rsvp/RsvpButton.svelte";
	import { GUEST_RSVP_STATUSES, type Guest } from "$lib/api_calls/types";

	let {
		open = $bindable(false),
		guest = null,
		current_status = null,
		require_status = true,
		title = "RSVP",
		description = "No account needed.",
		submit_label = "RSVP",
		onSubmit,
	}: {
		open: boolean;
		// prefills a returning guest
		guest?: Guest | null;
		current_status?: GuestRsvpStatus | null;
		// false when the dialog is just asking a guest's name, e.g. before voting
		require_status?: boolean;
		title?: string;
		description?: string;
		submit_label?: string;
		// returns true when it worked, which closes the dialog
		onSubmit: (details: GuestDetails) => Promise<boolean>;
	} = $props();

	let name = $state("");
	let email = $state("");
	let status = $state<GuestRsvpStatus | null>(null);
	let submitting = $state(false);

	// refill whenever the dialog opens
	$effect(() => {
		if (open) {
			name = guest?.name ?? "";
			email = guest?.email ?? "";
			status = current_status;
		}
	});

	let can_submit = $derived(name.trim().length > 0 && (!require_status || status !== null));

	const submit = async (e: SubmitEvent) => {
		e.preventDefault();
		if (!can_submit) return;
		submitting = true;
		const ok = await onSubmit({ name: name.trim(), email: email.trim(), status });
		submitting = false;
		if (ok) open = false;
	};
</script>

<Dialog.Root bind:open>
	<Dialog.Content class="sm:max-w-md">
		<Dialog.Header>
			<Dialog.Title>{title}</Dialog.Title>
			<Dialog.Description>{description}</Dialog.Description>
		</Dialog.Header>
		<form class="flex flex-col gap-4" onsubmit={submit}>
			<div class="flex flex-col gap-2">
				<Label for="guest_name">Name</Label>
				<Input id="guest_name" bind:value={name} maxlength={60} required autocomplete="name" />
			</div>
			<div class="flex flex-col gap-2">
				<span class="text-sm font-medium">
					Are you coming?{#if !require_status}
						<span class="font-light">(optional)</span>{/if}
				</span>
				<div class="flex flex-row flex-wrap gap-2">
					{#each GUEST_RSVP_STATUSES as option}
						<RsvpButton
							rsvp_status={option}
							selected={status === option}
							click_handler={() => (status = status === option ? null : option)}
						/>
					{/each}
				</div>
			</div>
			<div class="flex flex-col gap-2">
				<Label for="guest_email">Email <span class="font-light">(optional)</span></Label>
				<Input id="guest_email" type="email" bind:value={email} autocomplete="email" />
				<p class="text-xs font-light">Only the host sees this.</p>
			</div>
			<Dialog.Footer class="flex flex-row items-center justify-between gap-2 sm:justify-between">
				<span class="text-xs">Have an account? <Link url="/sign_in">Sign in</Link></span>
				<Button type="submit" disabled={!can_submit || submitting}>
					{#if submitting}
						<Spinner />
					{/if}
					{submit_label}
				</Button>
			</Dialog.Footer>
		</form>
	</Dialog.Content>
</Dialog.Root>
