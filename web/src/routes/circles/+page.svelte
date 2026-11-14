<script lang="ts">
	import type { PageData } from "./$types.js";
	import H1 from "$lib/components/text/H1.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import CircleForm from "./CircleForm.svelte";
	import Card from "$lib/components/Card.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import type { Circle } from "$lib/api_calls/types";

	let { data }: { data: PageData } = $props();

	let circles = $state<Circle[]>(data.circles_response["res"] ?? []);
	$effect(() => {
		circles = data.circles_response["res"] ?? [];
	});
</script>

<div>
	<H1>Circles!</H1>

	<div class="flex">
		<CircleForm {data} />
	</div>

	<div class="pt-4">
		<H2>Your Circles</H2>
		{#if circles.length === 0}
			<p>You have no circles yet! Create a new one above :)</p>
		{/if}
		<div class="flex flex-col gap-4">
			{#each circles as circle (circle.id)}
				<Card>
					<div class="flex flex-row items-baseline gap-2">
						<span class="font-bold">{circle.name}</span>
						<span class="text-sm text-gray-500">
							{circle.members?.length ?? 0}
							{(circle.members?.length ?? 0) === 1 ? "member" : "members"}
						</span>
					</div>
					{#if circle.members && circle.members.length > 0}
						<div class="grid md:grid-cols-4 grid-cols-2 gap-2 pt-2">
							{#each circle.members as member (member.id)}
								<UserCard user={member} show_friendship_status={false} />
							{/each}
						</div>
					{:else}
						<p class="text-sm text-gray-500 pt-2">No members in this circle yet.</p>
					{/if}
				</Card>
			{/each}
		</div>
	</div>
</div>
