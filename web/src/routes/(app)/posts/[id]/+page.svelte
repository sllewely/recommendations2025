<script lang="ts">
    import LinkButton from "$lib/components/text/LinkButton.svelte";
    import EventCard from "$lib/components/posts/EventCard.svelte";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import {goto} from "$app/navigation";
    import PostCard from "$lib/components/posts/PostCard.svelte";
    import {MessageCircleMore} from "@lucide/svelte";
    import Comment from "$lib/components/posts/Comment.svelte";
    import {Button} from "$lib/components/ui/button";
    import {Textarea} from "$lib/components/ui/textarea";
    import SubmitComment from "$lib/components/posts/SubmitComment.svelte";

    let {data} = $props();
    // let user = data.user;
    let my_user_id = data.my_user_id;
    let post = data.post;

    // let rsvp = event.current_user_rsvp;


    // let creating = $state(false);

    let num_comments = post.comments?.length;


</script>


<div>
    {#if my_user_id.toString() === post.creator_id.toString()}
        <div class="float-right relative">
            <LinkButton url="/posts/{post.id}/edit">Edit</LinkButton>
            <LinkButton url="/posts/{post.id}/delete">Delete</LinkButton>

        </div>
    {/if}
    <PostCard feed_item={post}/>

    <div>
        <div class="flex">
            {num_comments} Comments
            <MessageCircleMore/>
        </div>
        <div>
            {#each post.comments as comment}
                <Comment {comment}/>
            {/each}
        </div>

        <SubmitComment feed_item={post}/>

    </div>


</div>