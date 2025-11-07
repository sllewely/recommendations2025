<script lang="ts">
	import { Button } from "$lib/components/ui/button";

	const subscribe = async () => {
		console.log("click");

		// move to env variable
		const vapidPublicKey =
			"BH8dvS4Eim2vVNWFxSyAnUVo8yk89iVhd4HFEz5G_AHFc7B0lfpDisAdUDf7gNlAr-o_5fhUz7SMF6TCZqecNPQ";

		const registration = await navigator.serviceWorker.ready;

		let subscription = await registration.pushManager.getSubscription();

		if (!subscription) {
			subscription = await registration.pushManager.subscribe({
				userVisibleOnly: true,
				applicationServerKey: vapidPublicKey,
			});

			if (!subscription) {
				console.error("Web push subscription failed");
			}
		}

		console.log("subscription:", subscription.toJSON());
		// TODO: save this in db for user, they will have multiple per user.

		return subscription;
	};
</script>

<Button onclick={subscribe}>let me push you</Button>

<Button onclick={subscribe}>send myself a notification</Button>
