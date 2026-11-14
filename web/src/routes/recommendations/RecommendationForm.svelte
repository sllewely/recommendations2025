<script lang="ts">
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";
	import {
		Book,
		Clapperboard,
		Gamepad2,
		MonitorPlay,
		Link,
		Soup,
		Star,
		MessageCircleHeart,
	} from "@lucide/svelte";
	import type { Recommendation } from "$lib/api_calls/types";
	import { RecommendationStatus } from "$lib/enums";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { cn } from "$lib/utils.js";
	import Button from "$lib/components/Button.svelte";
	import TextField from "$lib/components/TextField.svelte";
	import FormRow from "$lib/components/form/FormRow.svelte";
	import RadioGroup, { type RadioOption } from "$lib/components/form/RadioGroup.svelte";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import FeedBadge, { CARD } from "$lib/components/posts/FeedBadge.svelte";
	import { Spinner } from "$lib/components/ui/spinner";

	interface Props {
		recommendation?: Recommendation;
		form?: Record<string, any> | null;
	}

	let { recommendation, form }: Props = $props();

	const MEDIA_TYPES = [
		{ value: "book", label: "book", icon: Book },
		{ value: "movie", label: "movie", icon: Clapperboard },
		{ value: "tv_show", label: "tv show", icon: MonitorPlay },
		{ value: "video_game", label: "video game", icon: Gamepad2 },
		{ value: "url", label: "web article", icon: Link },
		{ value: "restaurant", label: "restaurant", icon: Soup },
	] as const satisfies RadioOption[];

	const STATUSES = [
		{ value: String(RecommendationStatus.Recommend), label: "recommending", saved: "recommend" },
		{ value: String(RecommendationStatus.Interested), label: "interested in", saved: "interested" },
	] as const;

	let editing = !!recommendation;
	let creating = $state(false);
	let status = $state<string>(
		String(
			recommendation?.status === "interested"
				? RecommendationStatus.Interested
				: recommendation?.status === "watching"
					? RecommendationStatus.Watching
					: RecommendationStatus.Recommend,
		),
	);
	let title = $state<string>(form?.title ?? recommendation?.title ?? "");
	let notes = $state<string>(form?.notes ?? recommendation?.notes ?? "");
	let url = $state<string>(form?.url ?? recommendation?.url ?? "");
	let who_recommended = $state<string>(
		form?.who_recommended ?? recommendation?.who_recommended ?? "",
	);
	let rating = $state<number>(Number(form?.rating ?? recommendation?.rating ?? 0));

	let media_type = $state<string>(form?.media_type ?? recommendation?.media_type ?? "book");
	let type_name = $derived(
		MEDIA_TYPES.find((t) => t.value === media_type)?.label ?? media_type.trim(),
	);
	let status_name = $derived(STATUSES.find((s) => s.value === status)?.saved ?? "");

	let stars = $derived(rating > 0 ? "★".repeat(rating) + "☆".repeat(5 - rating) : "");
	let attributes = $derived(
		[
			{ label: "am", value: status_name },
			{ label: "from", value: who_recommended.trim() },
			{ label: "is", value: type_name },
			{ label: "see", value: url.trim(), link: true },
			{ label: "give it a", value: stars },
		].filter((attribute) => attribute.value),
	);
</script>

<form
	id="recommendation_form"
	method="POST"
	action={editing ? "?/edit_recommendation" : "?/create_recommendation"}
	class="flex flex-col gap-3"
	use:enhance={() => {
		creating = true;
		return async ({ update, result }) => {
			await update();
			creating = false;
			if (result.type !== "success") return;
			const res = result.data;
			if (res?.success) {
				newToast(
					editing
						? "Updated your recommendation"
						: "You have successfully created a recommendation",
					ToastType.Success,
				);
				goto("/");
			} else {
				newToast("Error saving recommendation: " + res?.message, ToastType.Error);
			}
		};
	}}
>
	{#if recommendation}
		<input type="hidden" name="id" value={recommendation.id} />
	{/if}
	<input type="hidden" name="media_type" value={media_type.trim() || "other"} />
	<input type="hidden" name="rating" value={rating} />

	<section aria-label="preview" class={cn("mb-7 flex flex-col gap-5", CARD)}>
		<div class="flex flex-row items-center gap-3">
			<FeedBadge icon={MessageCircleHeart} accent="fuchsia" />
			{#if title.trim()}
				<h3 class="mt-1 text-lg font-semibold leading-tight">{title}</h3>
			{:else}
				<h3 class="mt-1 text-lg italic leading-tight text-zinc-500 dark:text-zinc-400">
					your recommendation
				</h3>
			{/if}
		</div>
		{#if attributes.length > 0}
			<ul
				class="flex min-w-0 flex-col gap-1 text-sm text-zinc-500 dark:text-zinc-400 [&>li]:truncate [&_.value]:text-zinc-700 dark:[&_.value]:text-zinc-300"
			>
				{#each attributes as attribute}
					<li>
						{attribute.label}
						<span class={["value", attribute.link && "underline"]}>{attribute.value}</span>
					</li>
				{/each}
			</ul>
		{/if}
		{#if notes.trim()}
			<MarkedDownPost captured_text={notes} />
		{/if}
	</section>

	<FormRow label="title" for="title">
		<TextField id="title" name="title" bind:value={title} />
	</FormRow>

	<FormRow label="status">
		<RadioGroup label="status" name="status" options={STATUSES} bind:value={status} />
	</FormRow>

	<FormRow label="rating">
		<div class="flex h-8.5 flex-row items-center gap-1">
			{#each [1, 2, 3, 4, 5] as star}
				<button
					type="button"
					class="cursor-pointer"
					aria-label="{star} star{star === 1 ? '' : 's'}"
					aria-pressed={rating >= star}
					onclick={() => (rating = rating === star ? 0 : star)}
				>
					<Star
						class={cn(
							"size-5",
							rating >= star
								? "fill-yellow-400 text-yellow-400"
								: "text-zinc-400 dark:text-zinc-500",
						)}
					/>
				</button>
			{/each}
		</div>
	</FormRow>

	<FormRow label="type">
		<RadioGroup label="type" options={MEDIA_TYPES} other="other" bind:value={media_type} />
	</FormRow>

	<FormRow label="notes" for="notes">
		<TextField
			id="notes"
			name="notes"
			multiline
			bind:value={notes}
			placeholder="what do you think???"
		/>
	</FormRow>

	<FormRow label="link" for="url">
		<TextField id="url" name="url" bind:value={url} />
	</FormRow>

	<FormRow
		label="who recommended it to you?"
		for="who_recommended"
		description="useful for remembering"
	>
		<TextField
			id="who_recommended"
			name="who_recommended"
			autocomplete="off"
			bind:value={who_recommended}
		/>
	</FormRow>

	<FormRow>
		<Button type="submit" disabled={creating} class="self-start">
			{#if creating}
				<Spinner />
			{/if}
			{"save"}
		</Button>
	</FormRow>
</form>
