<script lang="ts">
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import {
		type Rsvp,
		RSVP_STATUSES,
		type RsvpStatus,
		rsvpStatusToText,
		type RsvpVariant,
	} from "$lib/api_calls/types";
	import { Button } from "$lib/components/ui/button";
	import RsvpButton from "$lib/components/rsvp/RsvpButton.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";

	interface Props {
		rsvp: Rsvp | null;
		event_id: string;
	}

	let { rsvp, event_id }: Props = $props();

	let open_choices = $state(false);

	const update_rsvp = async (status: String) => {
		console.log("update_rsvp", status);
		const response = await fetch("/api/rsvp/update", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				event_id: event_id,
				status: status,
			}),
		});
		const json = await response.json();
		console.log("update_rsvp response", json);
		if (json["errors"]) {
			newToast("Error:" + json["errors"], ToastType.Error);
		} else {
			window.location.reload();
			newToast("Updated rsvp", ToastType.Success);
		}
	};
</script>

<div class="relative">
	<div class={"flex flex-row gap-2 absolute -top-10" + (open_choices ? "" : " hidden")}>
		{#each RSVP_STATUSES as status}
			<RsvpButton
				rsvp_status={status}
				click_handler={() => {
					update_rsvp(status);
					open_choices = false;
				}}
				selected={rsvp?.status === status}
			/>
		{/each}
	</div>

	<RsvpButton
		rsvp_status={rsvp?.status ?? null}
		click_handler={() => (open_choices = !open_choices)}
	/>
</div>
