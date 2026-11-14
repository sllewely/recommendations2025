<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import SectionHeading from "$lib/components/text/SectionHeading.svelte";
	import type { Group, Feedable, Event, Post, Recommendation } from "$lib/api_calls/types";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import * as Collapsible from "$lib/components/ui/collapsible";
	import Link from "$lib/components/text/Link.svelte";
	import Button from "$lib/components/Button.svelte";
	import { Spinner } from "$lib/components/ui/spinner";
	import { enhance } from "$app/forms";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte";
	import Feed from "$lib/components/posts/Feed.svelte";
	import PostCard from "$lib/components/posts/PostCard.svelte";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";
	import { feedCard, feedKey } from "$lib/feed";

	interface Props {
		data: {
			group: Group;
			feed_items: Feedable[];
		};
	}

	// TODO: pagination

	let { data }: Props = $props();

	let joining = $state(false);
	let is_member = $derived(data.group.users.some((user) => user.id === current_user.id));
</script>

<SubHeader>
	<SubHeaderTitle title="group" />
</SubHeader>

<div>
	<div class="flex flex-row justify-between items-center">
		<SectionHeading>{data.group.name}</SectionHeading>

		{#if is_member}
			<Button variant="filled" disabled>member</Button>
		{:else}
			<form
				method="POST"
				action="?/join"
				use:enhance={() => {
					joining = true;
					return async ({ update, result }) => {
						await update();
						joining = false;
						console.log("response", result.data);
						if (result.data.success) {
							newToast("Joined group!", ToastType.Success);
						} else {
							newToast("Error joining group: " + result.data.message, ToastType.Error);
						}
					};
				}}
			>
				<input type="hidden" name="group_id" value={data.group.id} />
				<Button type="submit" disabled={joining}>
					{#if joining}
						<Spinner />
					{/if}
					Join
				</Button>
			</form>
		{/if}
	</div>

	<Collapsible.Root>
		<Collapsible.Trigger>
			<Link>
				<SectionHeading>{data.group.users.length} members...</SectionHeading>
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

	<SectionHeading>posts</SectionHeading>

	<Feed items={data.feed_items.map((item) => item.feedable)} key={feedKey} card={feedCard}>
		{#snippet content(item)}
			{#if item.class_name === "Event"}
				<EventCard feed_item={item as Event} />
			{:else if item.class_name === "Recommendation"}
				<RecommendationCard feed_item={item as Recommendation} />
			{:else}
				<PostCard feed_item={item as Post} />
			{/if}
		{/snippet}
	</Feed>
</div>
