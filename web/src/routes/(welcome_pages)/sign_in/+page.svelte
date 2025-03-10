<script lang="ts">
    import {enhance} from '$app/forms';
    import Input from "$lib/components/form/Input.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H1 from "$lib/components/text/H1.svelte";


    let {data, form} = $props();

    let name="Roonie";

    console.log(form);

    let creating = $state(false);
    // async function submitSignin(event: Event) {}

</script>
<div>

<H1>{name.toUpperCase()}!  Are you a kitty cat???</H1>

<H1>Sign in</H1>

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