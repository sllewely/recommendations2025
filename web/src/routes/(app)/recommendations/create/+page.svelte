<script lang="ts">
    import {enhance} from '$app/forms';
    import {Input} from "$lib/components/ui/input/index.js";
    import InputCheckbox from "$lib/components/form/InputCheckbox.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H1 from '$lib/components/text/H1.svelte'
    import ToggleButton from '$lib/components/form/ToggleButton.svelte'
    import Card from '$lib/components/Card.svelte';
    import LinkButton from "$lib/components/text/LinkButton.svelte";
    import {Label} from "$lib/components/ui/label/index.js";
    import {Button} from "$lib/components/ui/button/index.js";
    import {Textarea} from "$lib/components/ui/textarea/index.js";


    import {MediaType, RecommendationStatus} from "$lib/enums";
    import {current_user} from "$lib/state/current_user.svelte";
    import {goto} from "$app/navigation";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import {Book, Clapperboard, Gamepad2, MonitorPlay, Link, Soup} from "@lucide/svelte";
    import {Badge} from "$lib/components/ui/badge";

    let {data, form} = $props();

    let creating = $state(false);
    let status = $state(RecommendationStatus.Interested);

    // TODO: save & remember the user's last selection
    let media_type = $state('book');

    let tags = $state([]);
    // $effect(() => {
    //     tags = data.user.tags;
    // })

    // TODO:
    // List of types, one can be selected
    // One selected: interested, watching, recommend
    // who recommended appears if interested
    // rating appears if recommend or watching


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
                    console.log(res);
                    goto("/posts");
                    toasts.toast = newToast("You have successfully created a recommendation");
                } else {
                    toasts.toast = newToast("Error creating recommendation: " + res.message, ToastType.Error);
                }
            };
        }}
        >

            <div class="flex flex-col space-y-2">

                <Label for="title">Title:</Label>
                <Input name="title" label="Title:" value={form?.title}/>

                <Label for="media_type">Media type:</Label>
                <input type="hidden" name="media_type" value={media_type}/>
                <div>
                    <Button
                            onclick={() => media_type = 'book'}
                            variant={media_type === 'book' ? 'secondary' : "outline" }
                            aria-label="book">
                        <Book/>
                    </Button>
                    <Button
                            onclick={() => media_type = 'movie'}
                            variant={media_type === 'movie' ? 'secondary' : "outline" }
                            aria-label="movie">
                        <Clapperboard/>
                    </Button>
                    <Button
                            onclick={() => media_type = 'tv_show'}
                            variant={media_type === 'tv_show' ? 'secondary' : "outline" }
                            aria-label="tv show">
                        <MonitorPlay/>
                    </Button>
                    <Button
                            onclick={() => media_type = 'video_game'}
                            variant={media_type === 'video_game' ? 'secondary' : "outline" }
                            aria-label="video game">
                        <Gamepad2/>
                    </Button>
                    <Button
                            onclick={() => media_type = 'url'}
                            variant={media_type === 'url' ? 'secondary' : "outline" }
                            aria-label="web page">
                        <Link/>
                    </Button>
                    <Button
                            onclick={() => media_type = 'restaurant'}
                            variant={media_type === 'restaurant' ? 'secondary' : "outline" }
                            aria-label="restaurant">
                        <Soup/>
                    </Button>
                    <Button
                            onclick={() => media_type = 'other'}
                            variant={media_type === 'other' ? 'secondary' : "outline" }
                            aria-label="other"><Input name="other_media_type" placeholder="other" class=""/>
                    </Button>

                </div>

                <Label for="notes">Notes:</Label>
                <Textarea name="notes" value={form?.title} placeholder="What do you think???"/>
                <div class="flex flex-row justify-between">
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
                    <div>
                        <Label for="who_recommended">Who recommended?:</Label>
                        <Input id="who_recommended" name="who_recommended"
                               placeholder="sarah"
                               value={form?.who_recommended} autocomplete="off"/>
                    </div>
                </div>


                <FormButton>Save recommendation</FormButton>

            </div>
        </form>
    </Card>

</div>
