<script lang="ts">
    import {enhance} from '$app/forms';
    import FormButton from '$lib/components/FormButton.svelte';


    let {data, form} = $props();

    let name="Roonie";

    console.log(form);

    let creating = $state(false);
    // async function submitSignin(event: Event) {}

</script>
<div>

<h1>{name.toUpperCase()}!  Are you a kitty cat???</h1>

<h2>Create account</h2>

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
    <label for="name">Name:
        <input
                type="text"
                name="name"
                value="{form?.username ?? ''}"
                id="name"
                autocomplete="off"
                required/>
    </label><br />
    <label for="username">Username:
        <input
                type="text"
                name="username"
                value="{form?.username ?? ''}"
                id="username"
                autocomplete="off"
                required/>
    </label><br />
    <label for="email">E-mail:
        <input
                type="text"
                name="email"
                value="{form?.email ?? ''}"
                id="email"
                autocomplete="off"
                required/>
    </label><br />
    <label for="password">Password:
        <input type="password" name="password" id="password" autocomplete="off" required/>
    </label><br />
    <FormButton>Create account</FormButton>

</form>
</div>