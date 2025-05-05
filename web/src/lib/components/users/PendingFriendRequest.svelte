<script lang="ts">
    import {enhance} from '$app/forms';
    import Link from "$lib/components/text/Link.svelte";
    import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import Form from "$lib/components/form/Form.svelte";
    import {rails_date_pretty} from "$lib/utils/dates.svelte";
    import {goto} from "$app/navigation";
    import {friends_map, fetch_friends_map} from "$lib/state/friends_map.svelte";

    let {pending_friend} = $props();

    let updating = $state(false);

    // TODO: show date
    // const date = rails_datetime_pretty(pending)


</script>

<div class="p-4 border-1 border-gray-200 rounded-sm flex flex-row justify-between">
    <div>
        <Link url="/users/{pending_friend.id}"><p>{pending_friend.name}</p></Link>
    </div>
    <div>

    </div>
    <div>
        <form
                method="POST"
                action="?/accept_friend_request"
                use:enhance={() => {
            updating = true;
            return async ({update, result}) => {
                await update();
                updating = false;
            let res = result.data;
                    if (res.success) {
                    toasts.toast = newToast("Accepted friend request");
                    await fetch_friends_map();
                    } else {
                        toasts.toast = newToast("Error accepting friend request: " + res.message, ToastType.Error);
                    }
                    await goto("/friends");
            };
        }}
        >
            <input type="hidden" name="user_id" value={pending_friend.id}/>
            <FormButton>Accept friend request</FormButton>
        </form>
    </div>
</div>