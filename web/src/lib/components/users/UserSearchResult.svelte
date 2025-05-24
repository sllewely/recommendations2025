<script lang="ts">
	import { enhance } from "$app/forms";
	import Link from "$lib/components/text/Link.svelte";
	import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import Form from "$lib/components/form/Form.svelte";
	import { Button } from "$lib/components/ui/button";

	let { user, is_friend, is_pending } = $props();

	let updating = $state(false);
</script>

<div
	class="p-2 my-2 border-1 border-gray-200 rounded-sm flex flex-row justify-between items-center"
>
	<span>
		<Link url="/users/{user.id}"><p>{user.name}</p></Link>
	</span>
	{#if !is_friend}
		<div>
			<form
				method="POST"
				action="?/add_friend"
				use:enhance={() => {
					updating = true;
					return async ({ update, result }) => {
						await update();
						updating = false;
						let res = result.data;
						if (res.success) {
							newToast("Sent a new friend request");
						} else {
							newToast("Error sending friend request: " + res.message, ToastType.Error);
						}
					};
				}}
			>
				<input type="hidden" name="user_id" value={user.id} />
				{#if is_pending}
					<Button type="button" disabled>Friend request pending</Button>
				{:else}
					<Button type="submit">Add friend</Button>
				{/if}
			</form>
		</div>
	{:else}
		<div><p>Friend!</p></div>
	{/if}
</div>
