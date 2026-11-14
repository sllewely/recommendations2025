<script lang="ts">
	import { enhance } from "$app/forms";
	import type {
		User,
		FriendStatus,
		Feedable,
		Event,
		Post,
		Recommendation,
	} from "$lib/api_calls/types";
	import Feed from "$lib/components/posts/Feed.svelte";
	import PostCard from "$lib/components/posts/PostCard.svelte";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";
	import { feedCard, feedKey, feedPageLoader } from "$lib/feed";
	import UserList from "$lib/components/users/UserList.svelte";
	import FriendRequest, { acceptFriendRequest } from "$lib/components/users/FriendRequest.svelte";
	import { Plus } from "@lucide/svelte";
	import SectionHeading from "$lib/components/text/SectionHeading.svelte";
	import Button from "$lib/components/Button.svelte";
	import TextField from "$lib/components/TextField.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";

	interface Props {
		data: {
			user: User;
			friend_status: { status: FriendStatus };
			feed: { feed_items: Feedable[]; pagy: any };
			friends: User[];
			is_me: boolean;
			mine: {
				friends_map: Record<string, FriendStatus>;
			} | null;
		};
	}

	let { data }: Props = $props();

	let friends = $derived(data.friends);

	// --- finding friends (your own profile): the friends section turns into a search
	let finding = $state(false);
	let query = $state("");
	let search_results = $state<User[]>([]);
	let search_form = $state<HTMLFormElement>();
	let search_input = $state<HTMLInputElement | HTMLTextAreaElement | null>(null);
	// friendship status per user; updated as you send/accept so the subtitle changes right away
	let statuses = $state<Record<string, FriendStatus>>({ ...(data.mine?.friends_map ?? {}) });

	const start_finding = () => {
		finding = true;
		setTimeout(() => search_input?.focus(), 0);
	};
	const stop_finding = () => {
		finding = false;
		query = "";
		search_results = [];
	};

	let friend_status = $state<FriendStatus>(data.friend_status.status);
	let add_friend_open = $state(false);
	const accept = async () => {
		if (await acceptFriendRequest(data.user)) friend_status = "friends";
	};

	// clicking someone opens the friend request dialog (unless you already asked them)
	let requesting = $state<User | null>(null);
	let request_open = $state(false);
	const pick = (person: User) => {
		if (statuses[person.id] === "sent_friend_request") return;
		requesting = person;
		request_open = true;
	};
</script>

{#snippet request_status(person: User)}
	{#if statuses[person.id] === "sent_friend_request"}
		<span class="font-bold">requested!</span>
	{:else}
		<span class="text-zinc-500 dark:text-zinc-400">send request</span>
	{/if}
{/snippet}

{#if requesting}
	<FriendRequest
		user={requesting}
		bind:open={request_open}
		onsent={(s) => {
			if (!requesting) return;
			statuses[requesting.id] = s;
		}}
	/>
{/if}

<SubHeader>
	<SubHeaderTitle>
		<UserCard user={data.user} size="lg" />
	</SubHeaderTitle>
	{#if friend_status === "self"}
		<Button variant="filled" disabled class="font-bold">it's you!</Button>
	{:else if friend_status === "friends"}
		<Button variant="filled" disabled>friends</Button>
	{:else if friend_status === "pending_friend_request"}
		<Button onclick={accept}>accept friend request</Button>
	{:else if friend_status === "sent_friend_request"}
		<Button variant="filled" color="zinc" disabled>request sent</Button>
	{:else}
		<Button onclick={() => (add_friend_open = true)}>add friend</Button>
		<FriendRequest
			user={data.user}
			bind:open={add_friend_open}
			onsent={(s) => (friend_status = s)}
		/>
	{/if}
</SubHeader>

{#if data.user.blurb?.trim()}
	<p class="mb-10 whitespace-pre-line">{data.user.blurb}</p>
{/if}

<div class="flex flex-col gap-10 md:grid md:grid-cols-3 md:gap-5">
	<section class="order-2 flex min-w-0 flex-col gap-5 md:order-1 md:col-span-2">
		<SectionHeading>feed</SectionHeading>
		<Feed
			items={(data.feed?.feed_items ?? []).map((item) => item.feedable)}
			key={feedKey}
			card={feedCard}
			next_page={data.feed?.pagy?.next ?? null}
			load_page={feedPageLoader({ user_id: String(data.user.id) })}
		>
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
	</section>

	<aside class="order-1 flex min-w-0 flex-col gap-10 md:order-2">
		<section class="flex flex-col gap-3">
			{#if finding}
				<!-- finding friends: heading, search box, then people you might add -->
				<SectionHeading>find friends</SectionHeading>
				<form
					class="flex flex-row items-stretch gap-2"
					bind:this={search_form}
					method="POST"
					action="?/search_users"
					use:enhance={() =>
						async ({ result }) => {
							const res = result.type === "success" ? result.data : null;
							if (res?.success) search_results = res["res"] ?? [];
							else newToast("Error searching: " + res?.message, ToastType.Error);
						}}
				>
					<TextField
						name="search"
						placeholder="search by name"
						autocomplete="off"
						bind:value={query}
						bind:ref={search_input}
						oninput={() => {
							if (query.trim()) search_form?.requestSubmit();
							else search_results = [];
						}}
					/>
					<Button onclick={stop_finding}>done</Button>
				</form>
				{#if query.trim() && search_results.length > 0}
					<UserList users={search_results} onselect={pick} user_subtitle={request_status} />
				{:else if query.trim()}
					<p class="text-sm text-zinc-500 dark:text-zinc-400">no one found</p>
				{/if}
			{:else}
				<SectionHeading>friends</SectionHeading>

				{#if data.is_me}
					<UserList users={friends}>
						{#snippet leading()}
							<button
								type="button"
								onclick={start_finding}
								class="group flex w-fit cursor-pointer flex-row items-center gap-2.5 text-zinc-500 hover:text-zinc-300 dark:text-zinc-400 dark:hover:text-zinc-200"
							>
								<span class="relative grid aspect-[0.8660254] h-12 shrink-0 place-items-center">
									<svg
										aria-hidden="true"
										class="absolute inset-0 size-full overflow-visible"
										viewBox="0 0 86.60254 100"
									>
										<polygon
											points="43.30127,1.5 85.10254,25.75 85.10254,74.25 43.30127,98.5 1.5,74.25 1.5,25.75"
											class="fill-zinc-100 stroke-zinc-400 group-hover:stroke-zinc-600 dark:fill-zinc-700/50 dark:stroke-zinc-500 dark:group-hover:stroke-zinc-300"
											stroke-width="1"
											stroke-dasharray="4 3"
											vector-effect="non-scaling-stroke"
										/>
									</svg>
									<Plus class="relative size-4" />
								</span>
								<span>add friends</span>
							</button>
						{/snippet}
					</UserList>
				{:else if friends.length === 0}
					<p class="text-sm text-zinc-500 dark:text-zinc-400">no friends yet</p>
				{:else}
					<UserList users={friends} />
				{/if}
			{/if}
		</section>
	</aside>
</div>
