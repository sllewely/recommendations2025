<script lang="ts">
    import {enhance} from '$app/forms';
    import FormButton from '$lib/components/form/FormButton.svelte';
    import Input from '$lib/components/form/Input.svelte';
    import H1 from "$lib/components/text/H1.svelte";


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
            return async ({update}) => {
                await update();
                creating = false;
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