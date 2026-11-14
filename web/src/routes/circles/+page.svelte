<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import SectionHeading from "$lib/components/text/SectionHeading.svelte";
	import type { PageData } from "./$types.js";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import type { Circle } from "$lib/api_calls/types";
	import { enhance } from "$app/forms";
	import { superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { FieldErrors, Field } from "formsnap";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { circleFormSchema } from "./schema";
	import FormField from "$lib/components/form/FormField.svelte";
	import FormRow from "$lib/components/form/FormRow.svelte";
	import Button from "$lib/components/Button.svelte";
	import PeoplePicker, { type PickedPerson } from "$lib/components/users/PeoplePicker.svelte";
	import { Spinner } from "$lib/components/ui/spinner";

	let { data }: { data: PageData } = $props();

	let circles = $state<Circle[]>(data.circles_response["res"] ?? []);
	$effect(() => {
		circles = data.circles_response["res"] ?? [];
	});

	const form = superForm(data.form, {
		validators: zodClient(circleFormSchema),
	});

	const { form: formData } = form;

	let creating = $state(false);
	let members = $state<PickedPerson[]>([]);

	$effect(() => {
		$formData.member_ids = members.map((friend) => friend.id).filter(Boolean);
	});
</script>

<SubHeader>
	<SubHeaderTitle title="circles" />
</SubHeader>

<div>
	<div class="flex">
		<form
			method="POST"
			action="?/create_circle"
			class="flex w-full flex-col gap-3"
			use:enhance={() => {
				creating = true;
				return async ({ update, result }) => {
					await update();
					creating = false;
					let res = (result as any).data;
					if (res?.success) {
						newToast("You have successfully created a circle!!");
						members = [];
					} else {
						newToast(
							"Error creating circle: " + (res?.message ?? "Unknown error"),
							ToastType.Error,
						);
					}
				};
			}}
		>
			<div class="flex flex-col gap-1">
				<SectionHeading>new circle</SectionHeading>
				<p class="text-sm text-zinc-500 dark:text-zinc-400">
					circles are a way to organize your friends
				</p>
			</div>

			<FormField {form} name="name" label="name" bind:value={$formData.name} />

			<FormRow label="friends" for="circle_members">
				<PeoplePicker
					id="circle_members"
					name="member_ids"
					picked_subtitle="in the circle"
					bind:picked={members}
				>
					<Field {form} name="member_ids">
						<FieldErrors class="text-sm text-red-600 dark:text-red-400" />
					</Field>
				</PeoplePicker>
			</FormRow>

			<FormRow>
				<Button type="submit" disabled={creating} class="self-start">
					{#if creating}
						<Spinner />
					{/if}
					create
				</Button>
			</FormRow>
		</form>
	</div>

	<div class="pt-4">
		<SectionHeading>your circles</SectionHeading>
		{#if circles.length === 0}
			<p>You have no circles yet! Create a new one above :)</p>
		{/if}
		<div class="flex flex-col gap-4">
			{#each circles as circle (circle.id)}
				<div class="flex flex-col">
					<div class="flex flex-row items-baseline gap-2">
						<span class="font-bold">{circle.name}</span>
						<span class="text-sm text-zinc-500">
							{circle.members?.length ?? 0}
							{(circle.members?.length ?? 0) === 1 ? "member" : "members"}
						</span>
					</div>
					{#if circle.members && circle.members.length > 0}
						<div class="grid md:grid-cols-4 grid-cols-2 gap-2 pt-2">
							{#each circle.members as member (member.id)}
								<UserCard user={member} />
							{/each}
						</div>
					{:else}
						<p class="text-sm text-zinc-500 pt-2">No members in this circle yet.</p>
					{/if}
				</div>
			{/each}
		</div>
	</div>
</div>
