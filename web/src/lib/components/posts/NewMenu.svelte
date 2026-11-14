<script lang="ts">
	import { Popover } from "bits-ui";
	import Button from "$lib/components/Button.svelte";

	const KINDS = [
		{ href: "/posts/create", label: "post" },
		{ href: "/events/create", label: "event" },
		{ href: "/recommendations/create", label: "recommendation" },
	];

	let open = $state(false);
</script>

<Popover.Root bind:open>
	<Popover.Trigger>
		{#snippet child({ props })}
			<Button {...props} class="h-8 py-0">new</Button>
		{/snippet}
	</Popover.Trigger>
	<Popover.Portal>
		<Popover.Content
			side="bottom"
			align="end"
			sideOffset={-32}
			class="z-50 flex flex-col bg-zinc-100 pt-px outline-hidden dark:bg-zinc-800"
			aria-label="new"
		>
			{#each KINDS as kind}
				<Button
					href={kind.href}
					class="relative -mt-px h-8 justify-end py-0 hover:z-10"
					onclick={() => (open = false)}
				>
					new {kind.label}
				</Button>
			{/each}
		</Popover.Content>
	</Popover.Portal>
</Popover.Root>
