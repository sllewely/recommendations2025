<script lang="ts">
	import { enhance } from "$app/forms";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { Input } from "$lib/components/ui/input";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { type CircleFormSchema, circleFormSchema } from "./schema";
	import { Button } from "$lib/components/ui/button/index.js";
	import * as Card from "$lib/components/ui/card/index.js";
	import FriendItem from "./FriendItem.svelte";
	import { Field, Control } from "formsnap";
	import FormLabel from "$lib/components/form/FormLabel.svelte";
	import FormFieldErrors from "$lib/components/form/FormFieldErrors.svelte";
	import type { User } from "$lib/api_calls/types";

	let { data }: { data: { form: SuperValidated<Infer<CircleFormSchema>> } } = $props();

	const form = superForm(data.form, {
		validators: zodClient(circleFormSchema),
	});

	const { form: formData } = form;

	let creating = $state(false);
	let friend_results = $state<User[]>([]);
	let friends_to_add = $state<User[]>([]);

	let member_ids = $derived(friends_to_add.map((friend) => friend.id).filter(Boolean));

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
						let res = (result as any).data;
						if (res?.success) {
							console.log("success create circle");
							newToast("You have successfully created a circle!!");
							friends_to_add = [];
							friend_results = [];
						} else {
							newToast(
								"Error creating circle: " + (res?.message ?? "Unknown error"),
								ToastType.Error,
							);
						}
					};
				}}
			>
				<Field {form} name="name">
					<Control>
						{#snippet children({ props })}
							<FormLabel>Name</FormLabel>
							<Input {...props} bind:value={$formData.name} />
						{/snippet}
					</Control>
					<FormFieldErrors />
				</Field>

				<div class="mt-4">
					<label
						for="search"
						class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
					>
						Friends
					</label>
					<div class="flex gap-2 mt-2">
						<Input id="search" name="search" />
						<Button
							type="button"
							class="rounded hover:bg-orange-500 text-teal-700 font-semibold hover:text-white py-2 px-4 h-9 border border-teal-500 hover:border-transparent"
							variant="outline"
							onclick={async () => {
								const searchEl = document.getElementById("search") as HTMLInputElement;
								const name = searchEl ? searchEl.value : "";
								console.log("searching for", name);
								const response = await fetch(
									`/api/friends/search?search=${encodeURIComponent(name)}`,
									{
										method: "GET",
										headers: { "Content-Type": "application/json" },
									},
								);
								friend_results = await response.json();
								console.log("friends", friend_results);
							}}
						>
							Search
						</Button>
					</div>
					<ul id="potential_friends" class="mt-2">
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
					{#if friends_to_add.length > 0}
						<div class="font-medium text-sm mt-4">friends slated for the circle</div>
						<ul class="mt-2">
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
					{/if}
				</div>

				<Field {form} name="member_ids">
					<Control>
						{#snippet children({ props })}
							{#each friends_to_add as friend}
								<input type="hidden" name="member_ids" value={friend.id} />
							{/each}
						{/snippet}
					</Control>
					<FormFieldErrors />
				</Field>
				<div class="pt-4">
					<Button type="submit">Submit</Button>
				</div>
			</form>
		</Card.Content>
	</Card.Root>
</div>
