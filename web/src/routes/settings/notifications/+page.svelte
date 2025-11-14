<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import { Button } from "$lib/components/ui/button";
	import EnableNotifications from "$lib/components/notifications/EnableNotifications.svelte";
	import { onMount } from "svelte";
	import { toast } from "svelte-sonner";
	import * as Card from "$lib/components/ui/card/index.js";
	import { Separator } from "$lib/components/ui/separator/index.js";
	import { CircleCheckBig, CircleX } from "lucide-svelte";
	import { web_push_notifs_enabled } from "$lib/utils/web_push_notifs";

	let notifs_enabled = $state(false);

	let service_worker_found = $state(false);

	let current_subscription = $state({});

	let saved_registrations = $state([]);

	let has_matching_endpoint = $state(false);

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

		has_matching_endpoint = saved_registrations.find(
			(reg) => reg.endpoint === subscription?.endpoint,
		);
		try {
			notifs_enabled = await web_push_notifs_enabled();
		} catch (error) {
			console.error(error);
		}
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
			<div class="flex flex-row gap-4">
				{#if notifs_enabled}
					<CircleCheckBig color="#88aa99" /> Everything looks good
				{:else}
					<CircleX color="#ff2277" /> See problems below
				{/if}
			</div>
			<Separator class="my-4" />
			<div class="flex flex-row gap-4">
				{#if service_worker_found}
					<CircleCheckBig color="#88aa99" /> Service worker found
				{:else}
					<CircleX color="#ff2277" /> Service worker not found
				{/if}
			</div>
			<Separator class="my-4" />
			<div class="flex flex-row gap-4">
				{#if current_subscription.endpoint !== undefined}
					<CircleCheckBig color="#88aa99" /> Current subscription found for browser.
				{:else}
					<CircleX color="#ff2277" /> No current subscription. Please click the subscribe button to get
					notifications.
				{/if}
			</div>
			<Separator class="my-4" />
			<div class="flex flex-row gap-4">
				{#if has_matching_endpoint}
					<CircleCheckBig color="#88aa99" /> Subscription registration saved.
				{:else}
					<CircleX color="#ff2277" /> Please click the subscribe button to save the subscription registration.
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
						{#if registration.endpoint === current_subscription.endpoint}
							- <span class="font-bold">{registration.endpoint}</span>
						{:else}
							- {registration.endpoint}
						{/if}
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
