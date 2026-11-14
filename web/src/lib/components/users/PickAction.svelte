<script lang="ts">
	import type { User } from "$lib/api_calls/types";
	import { cn } from "$lib/utils.js";

	interface Props {
		user: User;
		is_picked: (user: User) => boolean;
		add_label: string;
		onadd: (user: User) => void;
		onremove: (user: User) => void;
	}

	let { user, is_picked, add_label, onadd, onremove }: Props = $props();

	let picked = $derived(is_picked(user));
	let label = $derived(picked ? "remove" : add_label);
</script>

<button
	type="button"
	class={cn(
		"shrink-0 cursor-pointer text-sm text-zinc-500 underline-offset-2 hover:underline dark:text-zinc-400",
		picked
			? "hover:text-red-600 dark:hover:text-red-400"
			: "hover:text-yellow-600 dark:hover:text-yellow-400",
	)}
	aria-label="{label} {user.name}"
	onclick={() => (picked ? onremove(user) : onadd(user))}
>
	{label}
</button>
