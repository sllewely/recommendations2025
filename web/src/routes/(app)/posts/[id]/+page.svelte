<script lang="ts">
    import {enhance} from '$app/forms';
    import LinkButton from "$lib/components/text/LinkButton.svelte";
    import EventCard from "$lib/components/posts/EventCard.svelte";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import {goto} from "$app/navigation";
    import PostCard from "$lib/components/posts/PostCard.svelte";

    let {data} = $props();
    // let user = data.user;
    let my_user_id = data.my_user_id;
    let post = data.post;

    // let rsvp = event.current_user_rsvp;


    // let creating = $state(false);



</script>


<div>
    {#if my_user_id.toString() === post.creator_id.toString()}
        <div class="float-right relative">
            <LinkButton url="/posts/{post.id}/edit">Edit</LinkButton>
            <LinkButton url="/posts/{post.id}/delete">Delete</LinkButton>

        </div>
    {/if}
    <PostCard feed_item={post} />


</div>