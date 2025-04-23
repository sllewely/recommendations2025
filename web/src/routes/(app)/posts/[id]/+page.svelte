<script lang="ts">
    import LinkButton from "$lib/components/text/LinkButton.svelte";
    import PostCard from "$lib/components/posts/PostCard.svelte";
    import {MessageCircleMore} from "@lucide/svelte";
    import Comment from "$lib/components/posts/Comment.svelte";
    import SubmitComment from "$lib/components/posts/SubmitComment.svelte";

    let {data} = $props();
    let my_user_id = data.my_user_id;

    // Svelte pitfall.  Page updates are not triggered by load data prop change!!
    // This is the workaround
    let post = $state(data.post);
    $effect(() => {
        post = data.post;
    })

    let comments = $derived(post.comments);

    let num_comments = $derived(comments.length);


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
            {#each comments as comment}
                <Comment {comment}/>
            {/each}
        </div>

        <SubmitComment feed_item={post}/>

    </div>


</div>