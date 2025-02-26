<script lang="ts">
    import {enhance} from '$app/forms';
    import FormButton from '$lib/components/FormButton.svelte';
    import Input from '$lib/components/Input.svelte';
    import PageTitle from "$lib/components/text/PageTitle.svelte";


    let {data, form} = $props();

    let name="Roonie";

    console.log(form);

    let creating = $state(false);
    // async function submitSignin(event: Event) {}

</script>
<div>

<PageTitle>{name.toUpperCase()}!  Are you a kitty cat???</PageTitle>

<PageTitle>Create account</PageTitle>

    <p>todo: if form fails, keep values</p>

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