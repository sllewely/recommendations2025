<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import { Button } from "$lib/components/ui/button";
	import EnableNotifications from "$lib/components/notifications/EnableNotifications.svelte";
	import { onMount } from "svelte";
	import { toast } from "svelte-sonner";
	import * as Card from "$lib/components/ui/card/index.js";
	import { Separator } from "$lib/components/ui/separator/index.js";
	import { CircleCheckBig, CircleX } from "lucide-svelte";

	let service_worker_found = $state(false);

	let current_subscription = $state({});

	let saved_registrations = $state([]);

	let get_my_saved_registrations = async () => {
		// show my saved registrations?
		const response = await fetch("/api/web_push/get_registrations");
		const res = await response.json();
		saved_registrations = res;

		// check if any endpoints match my current subscription

		// always show subscribe button
	};

	onMount(async () => {
		const registration = await navigator.serviceWorker.ready;
		const subscription = await registration.pushManager.getSubscription();
		if (subscription) {
			current_subscription = subscription;
			console.log("subscription", subscription);
		} else {
			console.log("no subscription");
		}
		service_worker_found = registration.active !== null;

		await get_my_saved_registrations();
	});

	let click_unsubscribe = async () => {
		const registration = await navigator.serviceWorker.ready;

		let subscription = await registration.pushManager.getSubscription();
		if (subscription) {
			await subscription.unsubscribe();
			toast.success("unsubscribed from notifications");
		} else {
			toast.error("dont have an active subscription");
		}
		toast.info("refresh the page to subscribe");
	};

	let click_send_notif = async () => {
		const response = await fetch("/api/web_push/send_test_notification", {
			method: "POST",
			body: JSON.stringify({}),
			headers: {
				"Content-Type": "application/json",
			},
		});
		if (response.ok) {
			toast.success("check ur notifs");
		} else {
			toast.error("hmm problem.");
		}
	};
</script>

<div class="flex flex-col gap-y-4">
	<H1>Notifications</H1>
	<div>
		Web push notifications must be enabled on each device you want to receive notifications.
	</div>
	<Card.Root>
		<Card.Header>
			<Card.Title>Notifications debug info</Card.Title>
			<Card.Description>
				Notifications must be enabled on each device cuz I implemented this with web push
				notifications. You need permission from each browser you visit Bumblebeans on.
			</Card.Description>
		</Card.Header>
		<Card.Content>
			<Separator class="my-4" />
			<div class="flex flex-row gap-4">
				{#if service_worker_found}
					Service worker found <CircleCheckBig color="#88aa99" />
				{:else}
					Service worker not found <CircleX color="#ff2277" />
				{/if}
			</div>
			<Separator class="my-4" />
			<div class="flex flex-col gap-y-4">
				{#if saved_registrations.length > 0}
					Saved Registrations
				{:else}
					No saved registrations. Please click the subscribe button to get notifications to this
					device.
				{/if}
				{#each saved_registrations as registration}
					<div class="text-sm truncate">
						- {registration.endpoint}
					</div>
				{/each}
			</div>
		</Card.Content>
	</Card.Root>

	<div>
		<EnableNotifications />
	</div>
	<div>
		<Button onclick={click_unsubscribe}>Unsubscribe</Button>
	</div>
	<div><Button variant="destructive" onclick={click_send_notif}>Send yourself a notif</Button></div>
</div>
