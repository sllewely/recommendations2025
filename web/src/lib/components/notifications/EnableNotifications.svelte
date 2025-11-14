<script lang="ts">
	import { Button } from "$lib/components/ui/button";
	import { toast } from "svelte-sonner";

	// Save the subscription to the backend
	let create_subscription = async (subscription: PushSubscription) => {
		// Must toJSON otherwise keys are lost for some reason
		const subscription_json = subscription.toJSON();
		console.log("subscription_json", subscription_json);
		const response = await fetch("/api/web_push/subscribe", {
			method: "POST",
			body: JSON.stringify({
				endpoint: subscription.endpoint,
				expires_at: subscription.expirationTime,
				p256dh: subscription_json.keys.p256dh,
				auth: subscription_json.keys.auth,
			}),
			headers: {
				"Content-Type": "application/json",
			},
		});
		if (response.ok) {
			toast.success("For friendship!");
		} else {
			toast.error("Error saving the subscription in the db.");
			await subscription.unsubscribe();
		}
	};

	// Subscribe to push notifications onclick action
	const click_subscribe = async () => {
		console.log("click subscribe");
		toast.info("this subscribes only this device/browser for notifications");
		// move to env variable
		const vapidPublicKey =
			"BH8dvS4Eim2vVNWFxSyAnUVo8yk89iVhd4HFEz5G_AHFc7B0lfpDisAdUDf7gNlAr-o_5fhUz7SMF6TCZqecNPQ";

		const registration = await navigator.serviceWorker.ready;

		let subscription = await registration.pushManager.getSubscription();

		subscription = await registration.pushManager.subscribe({
			userVisibleOnly: true,
			applicationServerKey: vapidPublicKey,
		});
		if (!subscription) {
			console.log("error subscribing to push manager");
			toast.error("failed to subscribe to push notifications");
		} else {
			await create_subscription(subscription);
		}

		return subscription;
	};
</script>

<div class="flex justify-center mb-2 font-bold">
	<Button onclick={click_subscribe}>Web notifications not enabled. Subscribe!!</Button>
</div>
<div class="flex justify-center p-2 mb-2 font-bold border-gray-800 rounded-sm border-1">
	I worked hard on web push notifications, so please enable them!!
</div>
