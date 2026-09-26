<script lang="ts">
	import { enhance } from "$app/forms";

	import H1 from "$lib/components/text/H1.svelte";
	import Card from "$lib/components/Card.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { Input } from "$lib/components/ui/input";
	import { Label } from "$lib/components/ui/label";
	import { Button } from "$lib/components/ui/button";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import UserSearchResult from "$lib/components/users/UserSearchResult.svelte";
	import PendingFriendRequest from "$lib/components/users/PendingFriendRequest.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import type { User, FriendStatus, FriendsMap, Circle } from "$lib/api_calls/types";
	import Link from "$lib/components/text/Link.svelte";
	import FriendStatusButton from "$lib/components/users/FriendStatusButton.svelte";
	import bblogo from "$lib/assets/android-launchericon-72-72.png";

	interface Props {
		data: {
			my_user: User;
			friends_map: FriendsMap;
			friend_requests_response: any;
			friends_response: any;
			circles_response: any;
			outgoing_friend_request_map: Map<string, any>;
		};
		form: any;
	}

	let { data, form }: Props = $props();

	let my_user = data.my_user;

	let pending_friends = $state(
		data.friend_requests_response["res"]["incoming_friend_requests"] ?? [],
	);
	$effect(() => {
		pending_friends = data.friend_requests_response["res"]["incoming_friend_requests"] ?? [];
	});

	let show_search = $state(false);

	let creating = $state(false);
	let searching = $state(false);

	let searchResultUsers = $state([]);

	let friends = $state(data.friends_response["res"] ?? []);
	$effect(() => {
		friends = data.friends_response["res"] ?? [];
	});

	let circles = $state<Circle[]>(data.circles_response?.["res"] ?? []);
	$effect(() => {
		circles = data.circles_response?.["res"] ?? [];
	});

	let new_circle_name = $state("");

	let selected_circle_id = $state<string | null>(null);

	let selected_circle = $derived(circles.find((c) => c.id === selected_circle_id) ?? null);

	let circle_member_ids = $derived(
		new Set((selected_circle?.members ?? []).map((m: User) => m.id)),
	);

	let sorted_friends = $derived(
		selected_circle
			? [...friends].sort((a: User, b: User) => {
					const a_in = circle_member_ids.has(a.id) ? 0 : 1;
					const b_in = circle_member_ids.has(b.id) ? 0 : 1;
					if (a_in !== b_in) return a_in - b_in;
					return (a.name ?? "").localeCompare(b.name ?? "");
				})
			: friends,
	);

	function toggle_circle(circle_id: string) {
		selected_circle_id = selected_circle_id === circle_id ? null : circle_id;
	}

	function update_circle(updated: Circle) {
		circles = circles.map((c) => (c.id === updated.id ? updated : c));
	}

	function debounce(func, timeout = 300) {
		let timer;
		return (...args) => {
			clearTimeout(timer);
			timer = setTimeout(() => {
				func.apply(this, args);
			}, timeout);
		};
	}

	function submitForm() {
		<HTMLFormElement>document.getElementById("search_form").requestSubmit();
	}
</script>

<div class="grid grid-cols-3">
	<div class="flex flex-col col-span-2 p-2">
		<H1>Friends!</H1>

		{#if pending_friends.length > 0}
			<div>
				<H2>Pending friend requests</H2>

				{#each pending_friends as pending_friend_request}
					<PendingFriendRequest {pending_friend_request} />
				{/each}
			</div>
		{/if}

		<div class="flex">
			<div class="flex-auto">
				<button
					type="button"
					class="text-sm font-semibold text-teal-400 hover:text-orange-400 hover:underline inline-block my-2 focus:outline-none cursor-pointer"
					onclick={() => {
						show_search = !show_search;
						if (show_search) {
							setTimeout(() => document.getElementById("search")?.focus(), 0);
						}
					}}
				>
					{show_search ? "hide" : "add friends..."}
				</button>

				{#if show_search}
					<Card>
						<H2>Search for a user</H2>

						{#if searching}
							<p>searching...</p>
						{/if}
						<form
							id="search_form"
							method="POST"
							action="?/search_users"
							bind:this={form}
							use:enhance={() => {
								creating = true;
								return async ({ update, result }) => {
									// Do not clear form on success
									await update({ reset: false });
									creating = false;
									let res = result.data;
									if (res.success) {
										searchResultUsers = res["res"].filter((user) => {
											return user.id !== my_user.res.id;
										});
									} else {
										newToast("Error searching: " + res.message, ToastType.Error);
									}
								};
							}}
						>
							<div class="flex flex-col sm:flex-row justify-between sm:space-x-4">
								<div class="flex-auto">
									<Label for="search">by name:</Label>
									<Input
										id="search"
										name="search"
										placeholder="sarah"
										autocomplete="off"
										onkeyup={() => {
											document.getElementById("search_form").requestSubmit();
										}}
									/>
								</div>
								<div class="flex-1">
									<Label for="tag">by tag:</Label>
									<Input id="tag" name="tag" placeholder="nyc" autocomplete="off" />
								</div>
							</div>
							<div class="flex row gap-2">
								<div class="my-6">
									<Button
										type="submit"
										class="rounded hover:bg-orange-500 text-teal-700 font-semibold hover:text-white py-2 px-4 border border-teal-500 hover:border-transparent"
										variant="outline"
										>Search
									</Button>
								</div>
								<div class="my-6">
									<Button
										type="button"
										class="rounded hover:bg-red-500 text-red-700 font-semibold hover:text-white py-2 px-4 border border-red-500 hover:border-transparent"
										variant="outline"
										on:click={() => {
											document.getElementById("search_form").reset();
											searchResultUsers = [];
											document.getElementById("search").focus();
										}}
										>Clear
									</Button>
								</div>
							</div>
						</form>

						<div>
							{#each searchResultUsers as user}
								<div
									class="p-2 my-2 border-1 border-gray-200 rounded-sm flex flex-row justify-between items-center"
								>
									<div class="flex flex-row items-center">
										<div class="rounded-full w-10 h-10 overflow-hidden mr-2 shrink-0">
											{#if user.profile_photo_url}
												<img src={"https://" + user.profile_photo_url} alt="profile picture" />
											{:else}
												<img src={bblogo} alt="profile picture" />
											{/if}
										</div>
										<span>
											<Link url="/users/{user.id}"><p>{user.name}</p></Link>
										</span>
									</div>

									<div>
										<FriendStatusButton
											{user}
											friend_status_prop={data.friends_map[user.id] ?? "none"}
										/>
									</div>
								</div>
							{/each}
						</div>
					</Card>
				{/if}
			</div>
		</div>

		<div class="pt-4">
			<H2>Your friends</H2>
			{#if friends.length === 0}
				<p>You have no friends yet! Make some new ones :)</p>
			{/if}
			{#if selected_circle}
				<p class="text-sm text-gray-500 pb-2">
					Editing members of <span class="font-semibold">{selected_circle.name}</span>
				</p>
			{/if}
			<div class="grid grid-cols-2 gap-2">
				{#each sorted_friends as friend (friend.id)}
					<div class="flex flex-row items-center gap-2">
						{#if selected_circle}
							{#if circle_member_ids.has(friend.id)}
								<form
									method="POST"
									action="?/remove_from_circle"
									use:enhance={() => {
										return async ({ result }) => {
											const res = result.data;
											if (res?.success) {
												update_circle(res["res"]);
											} else {
												newToast("Error removing from circle: " + res?.message, ToastType.Error);
											}
										};
									}}
								>
									<input type="hidden" name="circle_id" value={selected_circle.id} />
									<input type="hidden" name="user_id" value={friend.id} />
									<button
										type="submit"
										title={"Remove from " + selected_circle.name}
										aria-label={"Remove from " + selected_circle.name}
										class="w-6 h-6 shrink-0 rounded-full border border-red-500 text-red-600 hover:bg-red-500 hover:text-white font-bold leading-none cursor-pointer"
										>&minus;</button
									>
								</form>
							{:else}
								<form
									method="POST"
									action="?/add_to_circle"
									use:enhance={() => {
										return async ({ result }) => {
											const res = result.data;
											if (res?.success) {
												update_circle(res["res"]);
											} else {
												newToast("Error adding to circle: " + res?.message, ToastType.Error);
											}
										};
									}}
								>
									<input type="hidden" name="circle_id" value={selected_circle.id} />
									<input type="hidden" name="user_id" value={friend.id} />
									<button
										type="submit"
										title={"Add to " + selected_circle.name}
										aria-label={"Add to " + selected_circle.name}
										class="w-6 h-6 shrink-0 rounded-full border border-teal-500 text-teal-600 hover:bg-teal-500 hover:text-white font-bold leading-none cursor-pointer"
										>+</button
									>
								</form>
							{/if}
						{/if}
						<div
							class={selected_circle && !circle_member_ids.has(friend.id)
								? "opacity-40 grayscale"
								: ""}
						>
							<UserCard user={friend} />
						</div>
					</div>
				{/each}
			</div>
		</div>
	</div>
	<div class="flex flex-col p-2">
		<H1>Circles</H1>
		Create groups for tagging or privacy

		<form
			method="POST"
			action="?/create_circle"
			class="flex flex-row gap-2 pt-2"
			use:enhance={() => {
				return async ({ result }) => {
					const res = result.data;
					if (res?.success) {
						circles = [...circles, res["res"]];
						new_circle_name = "";
					} else {
						newToast("Error creating circle: " + res?.message, ToastType.Error);
					}
				};
			}}
		>
			<Input
				id="circle_name"
				name="name"
				placeholder="close friends"
				autocomplete="off"
				bind:value={new_circle_name}
			/>
			<Button type="submit" disabled={!new_circle_name.trim()}>Add</Button>
		</form>

		{#if circles.length === 0}
			<p class="pt-2">You have no circles yet!</p>
		{:else}
			<div class="flex flex-col gap-1 pt-2">
				{#each circles as circle (circle.id)}
					<div class="flex flex-row items-baseline gap-2">
						<button
							type="button"
							class="font-semibold text-teal-400 hover:text-orange-400 hover:underline focus:outline-none cursor-pointer {selected_circle_id ===
							circle.id
								? 'underline text-orange-400'
								: ''}"
							onclick={() => toggle_circle(circle.id)}
						>
							{circle.name}
						</button>
						<span class="text-sm text-gray-500">
							{circle.members?.length ?? 0}
							{(circle.members?.length ?? 0) === 1 ? "member" : "members"}
						</span>
					</div>
				{/each}
			</div>
		{/if}
	</div>
</div>
