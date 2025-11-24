<script lang="ts">
	import { service_worker_missing } from "$lib/utils/web_push_notifs";
	const show = $state(service_worker_missing());
</script>

{#if show}
	<div>Are you using an iphone? You will need to download the PWA</div>
{/if}
