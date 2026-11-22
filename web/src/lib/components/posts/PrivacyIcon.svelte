<script lang="ts">
	import * as Tooltip from "$lib/components/ui/tooltip";
	import type { Visibility } from "$lib/api_calls/types";
	import { Globe, Lock, Users } from "@lucide/svelte";

	interface Props {
		// missing for older responses; nothing is shown
		visibility?: Visibility;
		class?: string;
	}

	let { visibility, class: className = "" }: Props = $props();

	const privacy = {
		public: { icon: Globe, label: "Public to Bumblebeans" },
		friends: { icon: Users, label: "Public to friends only" },
		specific: { icon: Lock, label: "Private to only specified people" },
	};

	let current = $derived(visibility ? privacy[visibility] : null);
</script>

{#if current}
	<Tooltip.Provider delayDuration={200}>
		<Tooltip.Root>
			<Tooltip.Trigger>
				{#snippet child({ props })}
					<span
						{...props}
						role="img"
						aria-label={current.label}
						class="inline-flex text-gray-500 dark:text-gray-400 {className}"
					>
						<current.icon class="size-3.5" />
					</span>
				{/snippet}
			</Tooltip.Trigger>
			<Tooltip.Content>{current.label}</Tooltip.Content>
		</Tooltip.Root>
	</Tooltip.Provider>
{/if}
