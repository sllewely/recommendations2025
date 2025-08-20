<script>
	import H1 from "$lib/components/text/H1.svelte";
	import { enhance } from "$app/forms";

	import { current_user } from "$lib/state/current_user.svelte.ts";

	import * as Table from "$lib/components/ui/table/index.js";
	// import Link from "$lib/components/text/Link.svelte";
	import * as Pagination from "$lib/components/ui/pagination/index.js";
	import {
		Book,
		Clapperboard,
		Gamepad2,
		Link,
		MonitorPlay,
		Soup,
		Star,
		BookmarkPlus,
		MessageCircleHeart,
	} from "@lucide/svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.ts";

	let { data } = $props();
	let myPage = $state(1);

	const user = data.user;
	let recommendations = $state(data.recommendations_response["recommendations"]);
	const pagy = data.recommendations_response["pagy"];

	let updating = $state(false);
</script>

{console.log(recommendations)}

<div>
	<H1>{user.name}'s saved recommendations</H1>
	<p>&nbsp;</p>

	<p>
		Save the things you love, track what you want to enjoy next, share interests with your friends
	</p>

	<div>
		<!--        <Link url="/recommendations/create">Create a new recommendation</Link>-->
	</div>
	<hr />

	<div></div>

	<hr />

	<div>List of recommendations you've saved</div>

	<div>
		<Table.Root>
			<Table.Caption>Your saved recommendations</Table.Caption>
			<Table.Header>
				<Table.Row>
					<Table.Head class="w-[60px]">Status</Table.Head>
					<Table.Head class="w-[100px]">Rating</Table.Head>
					<Table.Head class="w-[60px]">Type</Table.Head>
					<Table.Head>Recommendation</Table.Head>
					<Table.Head class="w-[100px]">who recommended?</Table.Head>
					<Table.Head class="w-[100px] text-right">tags</Table.Head>
				</Table.Row>
			</Table.Header>
			<Table.Body>
				{#each recommendations as rec}
					{console.log(rec)}
					<Table.Row>
						<Table.Cell class="font-medium">
							{#if rec.status === "interested"}
								<BookmarkPlus />
							{/if}
						</Table.Cell>
						<Table.Cell>
							<div class="flex flex-row">
								<Star fill={rec.rating >= 1 ? "yellow" : "white"} />
								<Star fill={rec.rating >= 2 ? "yellow" : "white"} />
								<Star fill={rec.rating >= 3 ? "yellow" : "white"} />
								<Star fill={rec.rating >= 4 ? "yellow" : "white"} />
								<Star fill={rec.rating >= 5 ? "yellow" : "white"} />
							</div>
						</Table.Cell>
						<Table.Cell>
							{#if rec.media_type === "book"}
								<Book />
							{:else if rec.media_type === "movie"}
								<Clapperboard />
							{:else if rec.media_type === "tv_show"}
								<MonitorPlay />
							{:else if rec.media_type === "video_game"}
								<Gamepad2 />
							{:else if rec.media_type === "restaurant"}
								<Soup />
							{:else if rec.media_type === "url"}
								<Link />
							{:else}
								{rec.media_type}
							{/if}
						</Table.Cell>
						<Table.Cell>{rec.title}</Table.Cell>
						<Table.Cell class="text-right">{rec.who_recommended}</Table.Cell>
						<Table.Cell class="text-right">#TODO</Table.Cell>
					</Table.Row>
				{/each}
			</Table.Body>
		</Table.Root>
		{#if updating}
			searching...
		{/if}
		<form
			method="POST"
			action="?/fetch_recommendation_page"
			id="fetch_recommendations"
			use:enhance={() => {
				updating = true;
				return async ({ update, result }) => {
					// Do not clear form on success
					await update({ reset: false });
					updating = false;
					let res = result.data;
					if (res.success) {
						recommendations = res["res"]["recommendations"];
					} else {
						newToast("Error searching: " + res.message, ToastType.Error);
					}
				};
			}}
		>
			<input type="hidden" name="user_id" id="user_id" value={user.id} />
			<input type="hidden" name="page" id="page" value={myPage - 1} />
			<!--			<Pagination.Root count={pagy["count"]} perPage={pagy["limit"]} let:pages bind:page={myPage}>-->
			<!--				<Pagination.Content>-->
			<!--					<Pagination.Item>-->
			<!--						<Pagination.PrevButton-->
			<!--							on:click={() => {-->
			<!--								document.getElementById("page").value = myPage - 1;-->
			<!--								document.getElementById("fetch_recommendations").requestSubmit();-->
			<!--							}}-->
			<!--						/>-->
			<!--					</Pagination.Item>-->
			<!--					{#each pages as page (page.key)}-->
			<!--						{#if page.type === "ellipsis"}-->
			<!--							<Pagination.Item>-->
			<!--								<Pagination.Ellipsis />-->
			<!--							</Pagination.Item>-->
			<!--						{:else}-->
			<!--							<Pagination.Item isVisible={myPage == page.value}>-->
			<!--								<Pagination.Link-->
			<!--									{page}-->
			<!--									isActive={myPage == page.value}-->
			<!--									on:click={() => {-->
			<!--										document.getElementById("page").value = page.value;-->
			<!--										document.getElementById("fetch_recommendations").requestSubmit();-->
			<!--									}}-->
			<!--								>-->
			<!--									{page.value}-->
			<!--								</Pagination.Link>-->
			<!--							</Pagination.Item>-->
			<!--						{/if}-->
			<!--					{/each}-->
			<!--					<Pagination.Item>-->
			<!--						<Pagination.NextButton-->
			<!--							on:click={() => {-->
			<!--								document.getElementById("page").value = myPage + 1;-->
			<!--								document.getElementById("fetch_recommendations").requestSubmit();-->
			<!--							}}-->
			<!--						/>-->
			<!--					</Pagination.Item>-->
			<!--				</Pagination.Content>-->
			<!--			</Pagination.Root>-->
		</form>
	</div>
</div>
