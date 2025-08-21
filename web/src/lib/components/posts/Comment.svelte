<script lang="ts">
	import { friends_map } from "$lib/state/friends_map.svelte";
	import { rails_datetime_pretty } from "$lib/utils/dates.svelte";
	import Link from "$lib/components/text/Link.svelte";

	const { comment } = $props();
	// TODO: this is bad because it assumes I'm seeing content by people I'm friends with
	const author = $derived(friends_map.friends_map[comment.user_id] ?? {});
</script>

{console.log(comment)}

<div class="flex justify-left">
	<article class="p-2 text-base bg-white rounded-lg dark:bg-gray-900">
		<div class="flex justify-between items-center">
			<div class="flex items-center">
				<p
					class="inline-flex items-center mr-3 text-sm text-gray-900 dark:text-white font-semibold"
				>
					<Link url="/users/{comment.user_id}">{author.name}</Link>
				</p>
				<p class="text-sm text-gray-600 dark:text-gray-400">
					{rails_datetime_pretty(comment.created_at)}
				</p>
			</div>
		</div>
		<div class="text-left">
			<p class="text-gray-500 dark:text-gray-400">
				{comment.body}
			</p>
		</div>
	</article>
</div>
