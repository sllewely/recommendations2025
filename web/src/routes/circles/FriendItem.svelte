<script lang="ts">
	import { Button } from "$lib/components/ui/button/index.js";
	import type { User } from "$lib/api_calls/types";
	import bblogo from "$lib/assets/android-launchericon-72-72.png";

	let {
		friend,
		onclick,
		buttonAriaLabel,
		buttonLabel,
	}: {
		friend: User;
		onclick: () => void;
		buttonAriaLabel: string;
		buttonLabel: string;
	} = $props();
</script>

<li class="flex items-center gap-2 mb-2">
	<div class="rounded-full w-8 h-8 overflow-hidden mr-1 shrink-0">
		{#if friend.profile_photo_url}
			<img src={"https://" + friend.profile_photo_url} alt="profile picture" />
		{:else}
			<img src={bblogo} alt="profile picture" />
		{/if}
	</div>
	<p>{friend.name}</p>
	<Button
		type="button"
		class="rounded hover:bg-orange-500 text-teal-700 font-semibold hover:text-white py-2 px-1 h-6 border border-teal-500 hover:border-transparent"
		variant="outline"
		aria-label={buttonAriaLabel}
		{onclick}
		>{buttonLabel}
	</Button>
</li>
