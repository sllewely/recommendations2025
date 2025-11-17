<script lang="ts">
	import { Button } from "$lib/components/ui/button/index.js";
	import type { User } from "$lib/api_calls/types";

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

<li class="flex gap-2 mb-2">
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
