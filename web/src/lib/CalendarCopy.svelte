<script lang="ts">
	import { global } from "$lib/state/global.svelte";
	import { Button, buttonVariants } from "$lib/components/ui/button";

	let copied = $state(false);

	let clickCopy = () => {
		navigator.clipboard.writeText(global.calendarUrl);
		copied = true;
	};
</script>

{#if global.calendarUrl}
	<div
		class="flex flex-col gap-2 bg-pink-300 border-1 border-black rounded-lg p-4 text-center text-black"
	>
		<span class="font-bold">You can now import bumblebeans events in your calendar!</span>
		<div>
			<span class="text-sm">Copy this url into your calendar app: </span>
			<Button onclick={clickCopy}>
				{#if copied}
					Copied!
				{:else}
					Copy calendar url
				{/if}
			</Button>
		</div>
	</div>
{/if}
