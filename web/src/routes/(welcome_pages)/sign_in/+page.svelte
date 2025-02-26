<script lang="ts">
    import {enhance} from '$app/forms';
    import Input from "$lib/components/Input.svelte";
    import FormButton from "$lib/components/FormButton.svelte";
    import PageTitle from "$lib/components/text/PageTitle.svelte";


    let {data, form} = $props();

    let name="Roonie";

    console.log(form);

    let creating = $state(false);
    // async function submitSignin(event: Event) {}

</script>
<div>

<PageTitle>{name.toUpperCase()}!  Are you a kitty cat???</PageTitle>

<PageTitle>Sign in</PageTitle>

{#if creating }
    <p>signing in...</p>
{/if}

<form
        method="POST"
        action="?/signin"
        use:enhance={() => {
            creating = true;
            return async ({update}) => {
                await update();
                creating = false;
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