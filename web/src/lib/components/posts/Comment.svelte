<script lang="ts">
	import type { User } from "$lib/api_calls/types";
	import { cn } from "$lib/utils.js";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";

	interface Props {
		user: User;
		body: string;
		caption?: string;
		offset?: boolean;
		class?: string;
	}

	let { user, body, caption, offset = true, class: className }: Props = $props();
</script>

<div class={cn("flex items-stretch", offset && "-translate-x-4.5", className)}>
	<div
		class="mt-3 h-8 w-3 shrink-0 rounded-l-lg border-2 border-r-0 border-dotted border-zinc-500 dark:border-zinc-400"
	></div>
	<article class="flex min-w-0 flex-col gap-1 pl-1.5">
		<div class="flex flex-row flex-wrap items-center gap-1.5 text-sm">
			<UserCard {user} size="xs" />
			{#if caption}
				<span class="text-zinc-500 dark:text-zinc-400">{caption}</span>
			{/if}
		</div>
		<MarkedDownPost captured_text={body} />
	</article>
</div>
