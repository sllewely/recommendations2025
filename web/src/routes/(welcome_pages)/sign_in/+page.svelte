<script lang="ts">
    import {enhance} from '$app/forms';
    import {goto} from '$app/navigation';
    import Input from "$lib/components/form/Input.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H1 from "$lib/components/text/H1.svelte";

    import { current_user } from '$lib/state/current_user.svelte';
    import { toast_message} from "$lib/state/toast.svelte";


    let {data, form} = $props();


    let creating = $state(false);

</script>
<div>

<H1>Sign in</H1>

{#if creating }
    <p>signing in...</p>
{/if}

<form
        method="POST"
        action="?/signin"
        use:enhance={() => {
            creating = true;
            return async ({update, result}) => {
                await update();
                creating = false;
                console.log(result)
                let res = result.data
                if (res.success) {
                    current_user.auth_token = res['auth_token'];
                    current_user.id = res['user_id'];
                    console.log(res);
                    goto("/posts");
                    toast_message.message = "You have successfully signed in";
                } else {
                    // make toast
                    console.log(res);
                    toast_message.message = "Error signing in: " + res.message;
                    console.log(toast_message.message)
                    console.log('sarah')
                }
            };

        }}

>

    <div class="flex flex-col">
        <Input name="email" label="E-mail:" value={form?.email} required=true />
        <Input name="password" label="Password:" input_type="password" required=true />

    </div>
    <FormButton>Sign in</FormButton>
</form>
</div>