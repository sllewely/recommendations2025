<script lang="ts">
	// Dashed button that turns web push notifications on or off for this device/browser.
	import { onMount } from "svelte";
	import { toast } from "svelte-sonner";
	import Button from "$lib/components/Button.svelte";
	import { web_push_notifs_enabled } from "$lib/utils/web_push_notifs";

	// move to env variable
	const VAPID_PUBLIC_KEY =
		"BH8dvS4Eim2vVNWFxSyAnUVo8yk89iVhd4HFEz5G_AHFc7B0lfpDisAdUDf7gNlAr-o_5fhUz7SMF6TCZqecNPQ";

	let { onchange }: { onchange?: () => void } = $props();

	// null until we know (checked in the browser)
	let enabled = $state<boolean | null>(null);
	let busy = $state(false);

	onMount(async () => {
		try {
			enabled = !!(await web_push_notifs_enabled());
		} catch (error) {
			console.error(error);
			enabled = false;
		}
	});

	// save the subscription to the backend
	const save = async (subscription: PushSubscription) => {
		// must toJSON, otherwise the keys are lost
		const json = subscription.toJSON();
		const response = await fetch("/api/web_push/subscribe", {
			method: "POST",
			body: JSON.stringify({
				endpoint: subscription.endpoint,
				expires_at: subscription.expirationTime,
				p256dh: json.keys?.p256dh,
				auth: json.keys?.auth,
			}),
			headers: { "Content-Type": "application/json" },
		});
		if (!response.ok) {
			await subscription.unsubscribe();
			throw new Error("error saving the subscription");
		}
	};

	const enable = async () => {
		const registration = await navigator.serviceWorker.ready;
		const subscription = await registration.pushManager.subscribe({
			userVisibleOnly: true,
			applicationServerKey: VAPID_PUBLIC_KEY,
		});
		await save(subscription);
		toast.success("notifications on for this device. for friendship!");
	};

	const disable = async () => {
		const registration = await navigator.serviceWorker.ready;
		const subscription = await registration.pushManager.getSubscription();
		await subscription?.unsubscribe();
		toast.success("notifications off for this device");
	};

	const toggle = async () => {
		busy = true;
		try {
			if (enabled) {
				await disable();
				enabled = false;
			} else {
				await enable();
				enabled = true;
			}
		} catch (error) {
			console.error(error);
			toast.error(`couldn't turn notifications ${enabled ? "off" : "on"}`);
		} finally {
			busy = false;
			onchange?.();
		}
	};
</script>

{#if enabled !== null}
	<Button onclick={toggle} disabled={busy}>
		{enabled ? "turn off web notifs" : "turn on web notifs"}
	</Button>
{/if}
