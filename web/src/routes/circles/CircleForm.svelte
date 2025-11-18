<script lang="ts">
	import { enhance } from "$app/forms";
	import * as Form from "$lib/components/ui/form";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { Input } from "$lib/components/ui/input";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { type CircleFormSchema, circleFormSchema } from "./schema";
	import { Button } from "$lib/components/ui/button/index.js";
	import * as Card from "$lib/components/ui/card/index.js";
	import FriendItem from "./FriendItem.svelte";

	let { data }: { data: { form: SuperValidated<Infer<CircleFormSchema>>; event: any } } = $props();

	const form = superForm(data.form, {
		validators: zodClient(circleFormSchema),
	});

	const { form: formData } = form;

	let creating = $state(false);
	let friend_results = $state([]);
	let friends_to_add = $state([]);

	let member_ids = $derived(friends_to_add.map((friend) => friend.id));

	$effect(() => {
		$formData.member_ids = member_ids;
	});
</script>

<div>
	<Card.Root>
		<Card.Header>
			<Card.Title>Add a new Circle</Card.Title>
			<Card.Description>Circles are a way to organize your friends</Card.Description>
		</Card.Header>
		<Card.Content>
			{#if creating}
				<p>creating...</p>
			{/if}
			<form
				method="POST"
				action="?/create_circle"
				use:enhance={() => {
					creating = true;
					return async ({ update, result }) => {
						await update();
						creating = false;
						let res = result.data;
						if (res.success) {
							console.log("success create circle");
							newToast("You have successfully created a circle!!");
						} else {
							newToast("Error creating circle: " + res.message, ToastType.Error);
						}
					};
				}}
			>
				<Form.Field {form} name="name">
					<Form.Control let:attrs>
						<Form.Label>Name</Form.Label>
						<Input {...attrs} bind:value={$formData.name} />
					</Form.Control>
					<Form.Control let:attrs>
						<Form.Label>Friends</Form.Label>
						<div class="flex gap-2">
							<Input {...attrs} id="search" name="search" />
							<Button
								type="button"
								class="rounded hover:bg-orange-500 text-teal-700 font-semibold hover:text-white py-2 px-4 h-9 border border-teal-500 hover:border-transparent"
								variant="outline"
								onclick={async () => {
									// call search_friends to populate potential friends
									const name = document.getElementById("search").value;
									console.log("searching for", name);
									const response = await fetch(`api/friends/search?search=${name}`, {
										method: "GET",
										headers: { "Content-Type": "application/json" },
									});
									friend_results = await response.json();
									console.log("friends", friend_results);
								}}
								>Search
							</Button>
						</div>
						<ul id="potential_friends">
							{#each friend_results as friend}
								<FriendItem
									{friend}
									buttonLabel={"+"}
									buttonAriaLabel={"add to circle"}
									onclick={() => {
										friends_to_add = [...friends_to_add, friend];
										friend_results = friend_results.filter((f) => f.id !== friend.id);
									}}
								/>
							{/each}
						</ul>
						<div>friends slated for the circle</div>
						<ul>
							{#each friends_to_add as friend}
								<FriendItem
									{friend}
									buttonLabel={"-"}
									buttonAriaLabel={"remove from circle"}
									onclick={() => {
										friends_to_add = friends_to_add.filter((f) => f.id !== friend.id);
									}}
								/>
							{/each}
						</ul>
						<div>{member_ids}</div>
					</Form.Control>
					<Form.FieldErrors />
				</Form.Field>
				<Form.Field {form} name="member_ids">
					<input hidden value={$formData.member_ids} name="member_ids" />
				</Form.Field>
				<Form.Button>Submit</Form.Button>
			</form>
		</Card.Content>
	</Card.Root>
</div>
