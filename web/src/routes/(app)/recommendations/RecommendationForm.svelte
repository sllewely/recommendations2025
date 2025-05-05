<script lang="ts">
    import {enhance} from '$app/forms';
    import {Input} from "$lib/components/ui/input/index.js";
    import H1 from '$lib/components/text/H1.svelte'
    import Card from '$lib/components/Card.svelte';
    import {Label} from "$lib/components/ui/label/index.js";
    import {Button} from "$lib/components/ui/button/index.js";
    import {Textarea} from "$lib/components/ui/textarea/index.js";


    import {MediaType, RecommendationStatus} from "$lib/enums";
    import {current_user} from "$lib/state/current_user.svelte";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import {
        Book,
        Clapperboard,
        Gamepad2,
        MonitorPlay,
        Link,
        Soup,
        Star,
        BookmarkPlus,
        MessageCircleHeart
    } from "@lucide/svelte";
    import {Badge} from "$lib/components/ui/badge";
    import * as Tooltip from "$lib/components/ui/tooltip";

    let {data, form} = $props();

    let creating = $state(false);
    let status = $state(RecommendationStatus.Interested);

    // TODO: save & remember the user's last selection
    let media_type = $state(form?.media_type ?? 'book');

    let tags = $state([]);
    // $effect(() => {
    //     tags = data.user.tags;
    // })

    let rating = $state(form?.rating ?? 0);

    function setStar(set_rating) {

        return () => {
            if (rating === set_rating) {
                rating = 0;
            } else {
                rating = set_rating;
            }
        }
    }

    function submitWithStatus(set_status) {
        return () => {
            if (set_status === 'interested_in') {
                status = RecommendationStatus.Interested;
            } else {
                status = RecommendationStatus.Recommend;
            }
            document.getElementById("recommendation_form").requestSubmit();

        }
    }


</script>

<div>

    <H1>Save a recommendation</H1>
    <span class="text-cyan-800">Save your favorites, save what you want to remember for the future, or share what you're reading or watching
        right now with your friends</span>

    {#if creating }
        <p>creating in...</p>
    {/if}
    <Card>
        <form
                id="recommendation_form"
                method="POST"
                action="?/create_recommendation"
                use:enhance={() => {
            creating = true;
            return async ({update, result}) => {
                await update();
                creating = false;
                let res = result.data
                if (res.success) {
                    current_user.auth_token = res['auth_token'];
                    current_user.id = res['user_id'];
                    toasts.toast = newToast("You have successfully created a recommendation");
                } else {
                    toasts.toast = newToast("Error creating recommendation: " + res.message, ToastType.Error);
                }
            };
        }}
        >

            <div class="flex flex-col space-y-2">

                <Label for="title">Title:</Label>
                <Input name="title" value={form?.title}/>

                <Label for="media_type">Media type:</Label>
                <input type="hidden" name="media_type" value={media_type}/>
                <div>
                    <Tooltip.Root>
                        <Tooltip.Trigger>
                            <Button
                                    onclick={() => media_type = 'book'}
                                    variant={media_type === 'book' ? 'secondary' : "outline" }
                                    aria-label="book">
                                <Book/>
                            </Button>
                        </Tooltip.Trigger>
                        <Tooltip.Content><p>Book</p></Tooltip.Content>
                    </Tooltip.Root>
                    <Tooltip.Root>
                        <Tooltip.Trigger>
                            <Button
                                    onclick={() => media_type = 'movie'}
                                    variant={media_type === 'movie' ? 'secondary' : "outline" }
                                    aria-label="movie">
                                <Clapperboard/>
                            </Button>
                        </Tooltip.Trigger>
                        <Tooltip.Content><p>Movie</p></Tooltip.Content>
                    </Tooltip.Root>
                    <Tooltip.Root>
                        <Tooltip.Trigger>
                            <Button
                                    onclick={() => media_type = 'tv_show'}
                                    variant={media_type === 'tv_show' ? 'secondary' : "outline" }
                                    aria-label="tv show">
                                <MonitorPlay/>
                            </Button>
                        </Tooltip.Trigger>
                        <Tooltip.Content><p>Tv show</p></Tooltip.Content>
                    </Tooltip.Root>
                    <Tooltip.Root>
                        <Tooltip.Trigger>
                            <Button
                                    onclick={() => media_type = 'video_game'}
                                    variant={media_type === 'video_game' ? 'secondary' : "outline" }
                                    aria-label="video game">
                                <Gamepad2/>
                            </Button>
                        </Tooltip.Trigger>
                        <Tooltip.Content><p>Video game</p></Tooltip.Content>
                    </Tooltip.Root>
                    <Tooltip.Root>
                        <Tooltip.Trigger>
                            <Button
                                    onclick={() => media_type = 'url'}
                                    variant={media_type === 'url' ? 'secondary' : "outline" }
                                    aria-label="web page">
                                <Link/>
                            </Button>
                        </Tooltip.Trigger>
                        <Tooltip.Content><p>Web article</p></Tooltip.Content>
                    </Tooltip.Root>
                    <Tooltip.Root>
                        <Tooltip.Trigger>
                            <Button
                                    onclick={() => media_type = 'restaurant'}
                                    variant={media_type === 'restaurant' ? 'secondary' : "outline" }
                                    aria-label="restaurant">
                                <Soup/>
                            </Button>
                        </Tooltip.Trigger>
                        <Tooltip.Content><p>Restaurant</p></Tooltip.Content>
                    </Tooltip.Root>
                    <Tooltip.Root>
                        <Tooltip.Trigger>
                            <Button
                                    onclick={() => media_type = 'other'}
                                    variant={media_type === 'other' ? 'secondary' : "outline" }
                                    aria-label="other"><Input name="other_media_type" placeholder="other..." class=""/>
                            </Button>
                        </Tooltip.Trigger>
                        <Tooltip.Content><p>Other</p></Tooltip.Content>
                    </Tooltip.Root>

                </div>

                <Label for="notes">Notes:</Label>
                <Textarea name="notes" value={form?.notes} placeholder="What do you think???"/>
                <Label for="url">Link:</Label>
                <Input name="url" value={form?.url}/>
                <div class="flex flex-row justify-between items-center">
                    <div>
                        <Label for="tags">Tags: #TODO not implemented</Label>
                        <Input id="tags" name="tags"
                               placeholder="scifi, nyc, storyrich"
                               value={form?.tags} autocomplete="off"/>
                        <div class="space-x-2">
                            {#each tags as tag}
                                <Badge>{tag}</Badge>
                            {/each}
                        </div>
                    </div>
                    <div class="flex flex-row">
                        <input type="hidden" name="rating" value={rating}/>
                        <Star fill={ rating >= 1 ? 'yellow' : 'white' } onclick={setStar(1)}/>
                        <Star fill={ rating >= 2 ? 'yellow' : 'white' } onclick={setStar(2)}/>
                        <Star fill={ rating >= 3 ? 'yellow' : 'white' } onclick={setStar(3)}/>
                        <Star fill={ rating >= 4 ? 'yellow' : 'white' } onclick={setStar(4)}/>
                        <Star fill={ rating >= 5 ? 'yellow' : 'white' } onclick={setStar(5)}/>
                    </div>
                    <div>

                        <Label for="who_recommended">Who recommended to you?:</Label>
                        <Input id="who_recommended" name="who_recommended"
                               placeholder="useful for remembering"
                               value={form?.who_recommended} autocomplete="off"/>
                    </div>
                </div>
                <hr/>


                <div class="flex flex-row justify-center space-x-4">
                    <input type="hidden" name="status" value={status}/>
                    <Button onclick={submitWithStatus('recommend')}>
                        <MessageCircleHeart/> &nbsp; Share a review
                    </Button>
                    <Button onclick={submitWithStatus('interested_in')}>
                        <BookmarkPlus/>
                        &nbsp; Interested in
                    </Button>

                </div>


            </div>
        </form>
    </Card>

</div>
