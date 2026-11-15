<script lang="ts">
	import UserCard from "$lib/components/users/UserCard.svelte";
	import Button from "$lib/components/Button.svelte";
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import type { Recommendation, User } from "$lib/api_calls/types";
	import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { goto } from "$app/navigation";

	interface Props {
		data: {
			recommendation: Recommendation;
			my_user_id: string;
		};
	}

	let { data }: Props = $props();

	let delete_recommendation = async () => {
		const response = await fetch("/api/recommendations/delete", {
			method: "POST",
			body: JSON.stringify({ id: data.recommendation.id }),
			headers: {
				"Content-Type": "application/json",
			},
		});
		let res = await response.json();
		if (res.success) {
			newToast("Successfully deleted recommendation");
			goto("/");
		} else {
			newToast("Error deleting a recommendation: " + res.message, ToastType.Error);
		}
	};
</script>

<SubHeader>
	<SubHeaderTitle title={data.recommendation.title || "recommendation"}>
		{#snippet caption()}
			by <UserCard user={data.recommendation.user} size="sm" />
		{/snippet}
	</SubHeaderTitle>
	{#if data.my_user_id.toString() === data.recommendation.user.id.toString()}
		<div class="flex flex-row gap-5">
			<Button href="/recommendations/{data.recommendation.id}/edit">edit</Button>
			<Button color="red" onclick={delete_recommendation}>delete</Button>
		</div>
	{/if}
</SubHeader>

<div class="flex flex-col gap-5">
	<RecommendationCard feed_item={data.recommendation} truncate={false} />
</div>
