<script lang="ts">
    import {enhance} from '$app/forms';
    import Input from "$lib/components/form/Input.svelte";
    import InputCheckbox from "$lib/components/form/InputCheckbox.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H1 from '$lib/components/text/H1.svelte'
    import Link from '$lib/components/text/Link.svelte'
    import ToggleButton from '$lib/components/form/ToggleButton.svelte'
    import Card from '$lib/components/Card.svelte';
    import LinkButton from "$lib/components/text/LinkButton.svelte";

    import {RecommendationStatus} from "$lib/enums";
    import {current_user} from "$lib/state/current_user.svelte";
    import {goto} from "$app/navigation";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";

    let {data, form} = $props();

    let creating = $state(false);
    let status = $state(RecommendationStatus.Interested);

    // TODO:
    // List of types, one can be selected
    // One selected: interested, watching, recommend
    // who recommended appears if interested
    // rating appears if recommend or watching


</script>

<div>

<H1>Create a recommendation post</H1>

{#if creating }
    <p>signing in...</p>
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

        <div class="flex flex-col">
            <InputCheckbox name="recommendation_only" label="Don't post publicly, just save for me (TODO: not implemented):" />
            <Card>
                <Input name="title" label="Title:" value={form?.title}/>
                <H1>Recommendation</H1>
                <Input name="media_type" label="Type:" placeholder="book, movie, other" value={form?.media_type} list="mediaTypeList"/>
                <datalist id="mediaTypeList">
                    <option value="book" />
                    <option value="tv show" />
                    <option value="movie" />
                    <option value="video game" />
                    <option value="board game" />
                    <option value="artist" />
                    <option value="artist, music" />
                    <option value="theatre" />
                    <option value="food" />
                    <option value="article" />
                    <option value="author" />

                </datalist>
                <input type="hidden" name="status" value={status} />
                <div>
                    <span onclick={() => status = RecommendationStatus.Interested}><ToggleButton color="yellow" selected={status === RecommendationStatus.Interested}>&#10133; Interested</ToggleButton></span>
                    <span onclick={() => status = RecommendationStatus.Watching}><ToggleButton color="orange" selected={status === RecommendationStatus.Watching}>&#10133; Watching</ToggleButton></span>
                    <span onclick={() => status = RecommendationStatus.Recommend}><ToggleButton color="blue" selected={status === RecommendationStatus.Recommend}>&#10133; Recommend</ToggleButton></span>
                </div>

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
