<script lang="ts">
	import { Button } from "$lib/components/ui/button";

	const subscribe = async () => {
		console.log("click");

		// move to env variable
		const vapidPublicKey =
			"BGtPz389bxcjj5vlNZ4_9sFLJJ1ilZJl0eyVi7UcinYXIPJ-J02EDgemuvDwTHQTJmuZWGQtflLiXT1cFIZSMeI";

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

		return subscription;
	};
</script>

<Button onclick={subscribe}>let me push you</Button>
