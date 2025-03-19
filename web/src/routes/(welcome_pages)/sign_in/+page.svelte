<script lang="ts">
    import {enhance} from '$app/forms';
    import {goto} from '$app/navigation';
    import Input from "$lib/components/form/Input.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H1 from "$lib/components/text/H1.svelte";
    import { current_user } from '$lib/state/current_user.svelte';


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
                    //token.jwt = result['res']['auth_token'];
                    //token.my_user_id = result['res']['user_id'];
                    current_user.auth_token = res['auth_token'];
                    current_user.id = res['user_id'];
                    console.log(res);
                    goto("/posts");
                } else {
                    // make toast
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