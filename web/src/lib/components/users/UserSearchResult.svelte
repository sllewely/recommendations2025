<script lang="ts">
    import {enhance} from '$app/forms';
    import Link from "$lib/components/text/Link.svelte";
    import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import Form from "$lib/components/form/Form.svelte";

    let {user, is_friend} = $props();

    let updating = $state(false);

</script>

<div class="p-4 border-1 border-gray-200 rounded-sm flex flex-row justify-between">
    <div>
        <Link url="/users/{user.id}"><p>{user.name}</p></Link>
    </div>
    {#if (!is_friend)}

        <div>
            <form
                    method="POST"
                    action="?/add_friend"
                    use:enhance={() => {
            updating = true;
            return async ({update, result}) => {
                await update();
                updating = false;
                let res = result.data;
                        if (res.success) {
                            toasts.toast = newToast("Sent a new friend request");
                        } else {
                            toasts.toast = newToast("Error sending friend request: " + res.message, ToastType.Error);
                        }
            };
        }}
            >
                <input type="hidden" name="user_id" value={user.id}/>
                <FormButton>Add friend</FormButton>
            </form>
        </div>
    {:else }
        <div><p>Friend!</p></div>
    {/if}
</div>