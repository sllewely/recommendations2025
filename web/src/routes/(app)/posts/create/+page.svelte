<script lang="ts">
    import {enhance} from '$app/forms';
    import Input from "$lib/components/form/Input.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H1 from '$lib/components/text/H1.svelte'
    import Link from '$lib/components/text/Link.svelte'
    import Card from '$lib/components/Card.svelte';

    let {data, form} = $props();

    let creating = $state(false);


</script>

<div>

<H1>Create a post</H1>

{#if creating }
    <p>signing in...</p>
{/if}
<Card>
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
            <Input name="post_title" label="Post Title:" value={form?.title} />
            <Card>
                <H1>Recommendation</H1>
                <Input name="title" label="Title:" />
                <Input name="type" label="Type:" placeholder="book, movie, other"/>
                <p>TODO: Should be text area</p>
                <Input name="notes" label="Notes:" />
                <Card>

                    <H1>Extras</H1>
                    <Input name="author" label="Author/Artist/Creator:" />
                    <Input name="rating" label="Rating:" placeholder="1-5"/>
                    <Input name="completed" label="Completed?" placeholder="yes/no" />
                    <Input name="who_recommended" label="Who recommended?:" />
                </Card>



            </Card>
        </div>
        <FormButton>Create post</FormButton>
    </form>
</Card>

</div>
