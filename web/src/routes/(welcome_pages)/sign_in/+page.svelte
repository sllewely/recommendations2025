<script lang="ts">
    import {enhance} from '$app/forms';
    import {goto} from '$app/navigation';
    import Input from "$lib/components/form/Input.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H1 from "$lib/components/text/H1.svelte";
    import Link from '$lib/components/text/Link.svelte'

    import {current_user} from '$lib/state/current_user.svelte';
    import {toasts, newToast, ToastType} from "$lib/state/toast.svelte";


    let {data, form} = $props();


    let creating = $state(false);

</script>
<div>

    <H1>Sign in</H1>
    <Link url="/create_account">Or create an account</Link>

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
                let res = result.data
                if (res.success) {
                    current_user.auth_token = res['auth_token'];
                    current_user.id = res['user_id'];
                    goto("/posts");
                    toasts.toast = newToast("You have successfully signed in");
                } else {
                    toasts.toast = newToast("Error signing in: " + res.message, ToastType.Error);
                }
            };

        }}

    >

        <div class="flex flex-col">
            <Input name="email" label="E-mail:" value={form?.email} required=true/>
            <Input name="password" label="Password:" input_type="password" required=true/>

        </div>
        <FormButton>Sign in</FormButton>
    </form>
</div>