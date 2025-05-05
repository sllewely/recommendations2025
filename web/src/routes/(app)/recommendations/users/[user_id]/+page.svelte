<script>
    import H1 from '$lib/components/text/H1.svelte';
    import H2 from '$lib/components/text/H2.svelte';
    import LinkButton from '$lib/components/text/LinkButton.svelte';
    import FeedItem from "$lib/components/posts/FeedItem.svelte";
    import DateHeader from "$lib/components/posts/DateHeader.svelte";
    import EventFeedItem from "$lib/components/posts/EventFeedItem.svelte";


    import {current_user} from '$lib/state/current_user.svelte.js';

    import * as Table from "$lib/components/ui/table";
    // import Link from "$lib/components/text/Link.svelte";
    import * as Pagination from "$lib/components/ui/pagination";
    import {
        Book,
        Clapperboard,
        Gamepad2,
        Link,
        MonitorPlay,
        Soup,
        Star,
        BookmarkPlus,
        MessageCircleHeart
    } from "@lucide/svelte";


    let {data} = $props();

    const user = data.user;
    const recommendations = data.recommendations;

</script>

<div>
    <H1>{user.name}'s saved recommendations</H1>
    <p>&nbsp;</p>


    <p>Save the things you love, track what you want to enjoy next, share interests with your friends</p>

    <div>
        <!--        <Link url="/recommendations/create">Create a new recommendation</Link>-->

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
                    <Table.Head class="w-[60px]">Status</Table.Head>
                    <Table.Head class="w-[100px]">Rating</Table.Head>
                    <Table.Head class="w-[60px]">Type</Table.Head>
                    <Table.Head>Recommendation</Table.Head>
                    <Table.Head class="w-[100px]">who recommended?</Table.Head>
                    <Table.Head class="w-[100px] text-right">tags</Table.Head>
                </Table.Row>
            </Table.Header>
            <Table.Body>
                {#each recommendations as rec}

                    <Table.Row>

                        <Table.Cell class="font-medium">
                            {#if rec.status === 'interested'}
                                <BookmarkPlus/>
                            {/if}
                        </Table.Cell>
                        <Table.Cell>
                            <div class="flex flex-row">
                                <Star fill={ rec.rating >= 1 ? 'yellow' : 'white' }/>
                                <Star fill={ rec.rating >= 2 ? 'yellow' : 'white' }/>
                                <Star fill={ rec.rating >= 3 ? 'yellow' : 'white' }/>
                                <Star fill={ rec.rating >= 4 ? 'yellow' : 'white' }/>
                                <Star fill={ rec.rating >= 5 ? 'yellow' : 'white' }/>
                            </div>
                        </Table.Cell>
                        <Table.Cell>
                            {#if rec.media_type === 'book'}
                                <Book/>
                            {:else if rec.media_type === 'movie'}
                                <Clapperboard/>
                            {:else if rec.media_type === 'tv_show'}
                                <MonitorPlay/>
                            {:else if rec.media_type === 'video_game'}
                                <Gamepad2/>
                            {:else if rec.media_type === 'restaurant'}
                                <Soup/>
                            {:else if rec.media_type === 'url'}
                                <Link/>
                            {:else}
                                {rec.media_type}
                            {/if}
                        </Table.Cell>
                        <Table.Cell>{rec.title}</Table.Cell>
                        <Table.Cell class="text-right">{rec.who_recommended}</Table.Cell>
                        <Table.Cell class="text-right">#TODO</Table.Cell>
                    </Table.Row>

                {/each}
            </Table.Body>
        </Table.Root>
        <Pagination.Root count={100} perPage={10} let:pages let:currentPage>
            <Pagination.Content>
                <Pagination.Item>
                    <Pagination.PrevButton/>
                </Pagination.Item>
                {#each pages as page (page.key)}
                    {#if page.type === "ellipsis"}
                        <Pagination.Item>
                            <Pagination.Ellipsis/>
                        </Pagination.Item>
                    {:else}
                        <Pagination.Item isVisible={currentPage == page.value}>
                            <Pagination.Link {page} isActive={currentPage == page.value}>
                                {page.value}
                            </Pagination.Link>
                        </Pagination.Item>
                    {/if}
                {/each}
                <Pagination.Item>
                    <Pagination.NextButton/>
                </Pagination.Item>
            </Pagination.Content>
        </Pagination.Root>

    </div>

</div>