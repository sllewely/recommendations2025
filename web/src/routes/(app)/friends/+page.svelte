<script lang="ts">
    import {enhance} from '$app/forms';

import H1 from "$lib/components/text/H1.svelte";
import Card from "$lib/components/Card.svelte";
import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import Input from "$lib/components/form/Input.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";

    let {data, form} = $props();

    let my_user = data.my_user;

    let creating = $state(false);
</script>

<div>
<H1>Friends!</H1>
<Card>
    <p>Presently you can add someone as a friend using a friend code.</p>
    <p>Your friend code is: <span>{data.my_user.friend_code}</span></p>

    {#if creating }
        <p>updating...</p>
    {/if}
    <form
            method="POST"
            action="?/add_friend"
            use:enhance={() => {
                    creating = true;
                    return async ({update, result}) => {
                        await update();
                        creating = false;
                        console.log('sarah beep')
                        let res = result.data;
                        if (res.success) {
                            toasts.toast = newToast("Success updating your rsvp");
                        } else {
                            toasts.toast = newToast("Error updating rsvp: " + res.message, ToastType.Error);
                        }
                    };

        }}

    >

        <Input name="friend_code" label="Your new friend's code:" value={form?.friend_code}/>
        <FormButton>Add friend</FormButton>

    </form>

</Card>

</div>