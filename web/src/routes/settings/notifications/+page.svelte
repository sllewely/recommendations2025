<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import { Button } from "$lib/components/ui/button";
	import EnableNotifications from "$lib/components/notifications/EnableNotifications.svelte";
	import { onMount } from "svelte";
	import { toast } from "svelte-sonner";

	let service_worker_found = $state(false);

	onMount(async () => {
		const registration = await navigator.serviceWorker.ready;
		const subscription = await registration.pushManager.getSubscription();
		if (subscription) {
			console.log("subscription", subscription);
		} else {
			console.log("no subscription");
		}
		service_worker_found = registration.active !== null;
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
	<div>
		{#if service_worker_found}
			Service worker found
		{:else}
			Service worker not found
		{/if}
	</div>
	<div>
		<EnableNotifications />
	</div>
	<div>
		<Button onclick={click_unsubscribe}>Unsubscribe</Button>
	</div>
	<div><Button variant="destructive" onclick={click_send_notif}>Send yourself a notif</Button></div>
</div>
