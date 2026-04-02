<script lang="ts">
	import type { Group } from "$lib/api_calls/types";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import * as Collapsible from "$lib/components/ui/collapsible";
	import Link from "$lib/components/text/Link.svelte";

	interface Props {
		data: {
			group: Group;
		};
	}

	let { data }: Props = $props();
</script>

<div>
	<h1 class="text-2xl font-bold">{data.group.name}</h1>

	<Collapsible.Root>
		<Collapsible.Trigger>
			<Link>
				<h2 class="text-xl font-bold">{data.group.users.length} Members...</h2>
			</Link>
		</Collapsible.Trigger>
		<Collapsible.Content>
			<div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
				{#each data.group.users as user}
					<UserCard {user} />
				{/each}
			</div>
		</Collapsible.Content>
	</Collapsible.Root>

	<h2>Posts</h2>
</div>
