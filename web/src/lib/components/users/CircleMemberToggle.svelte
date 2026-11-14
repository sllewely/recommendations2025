<script lang="ts">
	// add/remove a friend from a circle (used next to each friend while editing a circle)
	import { enhance } from "$app/forms";
	import type { Circle, User } from "$lib/api_calls/types";
	import Button from "$lib/components/Button.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";

	interface Props {
		user: User;
		circle: Circle | null;
		// called with the circle after it changes
		onchange: (circle: Circle) => void;
	}

	let { user, circle, onchange }: Props = $props();

	let member = $derived(!!circle?.members?.some((m) => m.id === user.id));
</script>

{#if circle}
	<form
		method="POST"
		action={member ? "?/remove_from_circle" : "?/add_to_circle"}
		use:enhance={() =>
			async ({ result }) => {
				const res = result.type === "success" ? result.data : null;
				if (res?.success) onchange(res["res"]);
				else newToast("Error updating circle: " + res?.message, ToastType.Error);
			}}
	>
		<input type="hidden" name="circle_id" value={circle.id} />
		<input type="hidden" name="user_id" value={user.id} />
		<Button type="submit" color={member ? "red" : "yellow"} class="px-2 py-0.5">
			{member ? "remove" : "add"}
		</Button>
	</form>
{/if}
