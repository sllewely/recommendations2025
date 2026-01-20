<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import { Badge } from "$lib/components/ui/badge";
	import type { Notification } from "$lib/api_calls/types";
	import FriendStatusButton from "$lib/components/users/FriendStatusButton.svelte";
	import FeedItem from "$lib/components/posts/FeedItem.svelte";
	import { Spinner } from "$lib/components/ui/spinner/index.js";
	import { onMount } from "svelte";
	import bblogo from "$lib/assets/android-launchericon-72-72.png";

	interface Props {
		data: {
			notification: Notification;
		};
	}

	let { data }: Props = $props();
	let user = data.user;
	const tags = user.tags;
</script>

<div>
	{#each notifications as notification}{/each}
</div>
