<script lang="ts">
    import {enhance} from '$app/forms';
    import {goto} from '$app/navigation';

    import FormButton from '$lib/components/form/FormButton.svelte';
    import Input from '$lib/components/form/Input.svelte';
    import H1 from "$lib/components/text/H1.svelte";
    import { toast_message} from "$lib/state/toast.svelte";


    let {data, form} = $props();

    console.log(form);

    let creating = $state(false);

</script>
<div>

<H1>Create account</H1>

    <p>todo: if form fails, keep values</p>
    <p>Sorry, for now you must have both a name and username, but name will be shown to your friends</p>

{#if creating }
    <p>creating...</p>
{/if}



<form
        method="POST"
        action="?/create"
        use:enhance={() => {
            creating = true;
            return async ({update, result}) => {
                await update();
                creating = false;
                let res = result.data;
            if (res.success) {
                toast_message.message = "You have successfully created an account!!!!"
                goto("/sign_in")
            } else {
                toast_message.message = "Error creating an account: " + res.message;
            }
            };


        }}

>
    <div class="flex flex-col">
        <Input name="name" input_type="text" label="Name:" value="{form?.name}" required=true />
        <Input name="username" label="Username:" value={form?.username} required=true />
        <Input name="email" label="E-mail:" value={form?.email} required=true />
        <Input name="password" label="Password:" input_type="password" required=true />

    </div>
    <FormButton>Create account</FormButton>

</form>
</div>