<script lang="ts">
    import {enhance} from '$app/forms';
    import Input from "$lib/components/form/Input.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H1 from '$lib/components/text/H1.svelte'
    import Link from '$lib/components/text/Link.svelte'

    let {data, form} = $props();

    let creating = $state(false);


</script>

<div>

<H1>Create a post</H1>

{#if creating }
    <p>signing in...</p>
{/if}

    <form
            method="POST"
            action="?/create_post"
            use:enhance={() => {
            creating = true;
            return async ({update}) => {
                await update();
                creating = false;
            };

        }}

    >

        <div class="flex flex-col">
            <Input name="title" label="Title:" value={form?.title} required=true />
            <p>TODO: Should be text area</p>
            <Input name="description" label="Description:" required=true />
            <Input name="who_recommended" label="Who recommended?:" required=true />
        </div>
        <FormButton>Create post</FormButton>
    </form>


</div>
