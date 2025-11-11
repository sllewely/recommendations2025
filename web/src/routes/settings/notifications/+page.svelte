<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import { Button } from "$lib/components/ui/button";
	import EnableNotifications from "$lib/components/notifications/EnableNotifications.svelte";
</script>

<div class="flex flex-col">
	<H1>Notifications</H1>
	<div>
		Web push notifications must be enabled on each device you want to receive notifications.
	</div>
	<div>
		<EnableNotifications />
	</div>
	<div>
		<Button>Unsubscribe</Button>
	</div>
</div>
