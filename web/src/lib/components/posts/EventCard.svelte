<script lang="ts">
	import Card from "$lib/components/Card.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { isSignedIn } from "$lib/state/current_user.svelte";

	let { feed_item } = $props();

	if (feed_item.class_name !== "Event") {
		console.error("not an event feed item");
	}

	let signed_in = isSignedIn();
</script>

<div>
	<div class="flex flex-row justify-between">
		<!--        <svelte:boundary>-->
		<div>
			<span class="font-bold">
				<!-- I just broke this for the feed TODO SARAH -->
				<Link url="/users/{feed_item.user.id}">{feed_item.user.name}</Link>
			</span> posted an upcoming event
		</div>
		<!--        <div><span class="font-bold"><a class="text-teal-400 hover:text-orange-400" href="/users/{feed_item.creator_id}">{feed_item.creator_name}</a></span> posted an upcoming event</div>-->
		<!--        </svelte:boundary>-->
		<div>
			<span class="text-sm">at {feed_item.create_date_string} {feed_item.create_time_string}</span>
		</div>
	</div>
	<div class="p-2">
		<a href="/events/{feed_item.id}">
			<Card border_color="border-lime-500" hover_color="hover:bg-lime-100">
				<H2>{feed_item.title}</H2>
				{#if feed_item.description}
					<p>{feed_item.description}</p>
				{/if}
				{#if feed_item.start_date_string}
					<p>Happening {feed_item.start_date_string} - {feed_item.start_time_string}</p>
				{/if}
				{#if feed_item.address}
					<p>at {feed_item.address}</p>
				{/if}

				<p class="text-sm">rsvp: {feed_item.current_user_rsvp ?? "not rsvp'd"}</p>
			</Card>
		</a>
	</div>
</div>
