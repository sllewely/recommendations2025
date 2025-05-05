<script>
    import H1 from '$lib/components/text/H1.svelte';
    import H2 from '$lib/components/text/H2.svelte';
    import LinkButton from '$lib/components/text/LinkButton.svelte';
    import FeedItem from "$lib/components/posts/FeedItem.svelte";
    import DateHeader from "$lib/components/posts/DateHeader.svelte";
    import EventFeedItem from "$lib/components/posts/EventFeedItem.svelte";


    import {current_user} from '$lib/state/current_user.svelte.js';

    import * as Table from "$lib/components/ui/table";
    import Link from "$lib/components/text/Link.svelte";

    let {data} = $props();

    const user = data.user;
    const recommendations = data.recommendations;

</script>

<div>
    <H1>{user.name}'s saved recommendations</H1>
    <p>&nbsp;</p>
    

    <p>Save the things you love, track what you want to enjoy next, share interests with your friends</p>

    <div>
        <Link url="/recommendations/create">Create a new recommendation</Link>

    </div>
    <hr/>

    <div>

    </div>

    <hr/>

    <div>List of recommendations you've saved</div>

    <div>
        <Table.Root>

            <Table.Caption>Your saved recommendations</Table.Caption>
            <Table.Header>
                <Table.Row>
                    <Table.Head class="w-[100px]">Status</Table.Head>
                    <Table.Head>Type</Table.Head>
                    <Table.Head>Recommendation</Table.Head>
                    <Table.Head class="w-[100px]">who recommended?</Table.Head>
                    <Table.Head class="w-[100px] text-right">tags</Table.Head>
                </Table.Row>
            </Table.Header>
            <Table.Body>
                {#each recommendations as rec}

                    <Table.Row>

                        <Table.Cell class="font-medium">{rec.status}</Table.Cell>
                        <Table.Cell>{rec.media_type}</Table.Cell>
                        <Table.Cell>{rec.title}</Table.Cell>
                        <Table.Cell class="text-right">{rec.who_recommended}</Table.Cell>
                        <Table.Cell class="text-right">not implemented</Table.Cell>
                    </Table.Row>

                {/each}
            </Table.Body>
        </Table.Root>

    </div>

</div>