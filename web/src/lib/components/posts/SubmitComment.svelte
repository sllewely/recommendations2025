<script lang="ts">
    import {enhance} from '$app/forms';
    import {Button} from "$lib/components/ui/button";
    import {Textarea} from "$lib/components/ui/textarea";
    import {newToast, ToastType} from "$lib/state/toast.svelte";
    import {MessageCirclePlus} from "@lucide/svelte";

    let {feed_item} = $props();

    let posting = $state(false);
</script>

<div class="mt-2">
    {#if posting}
        ...posting
    {/if}
    <form
            method="POST"
            action="?/submit_comment"
            use:enhance={() => {
            posting = true;
            return async ({update, result}) => {
                await update();
                posting = false;
                let res = result.data;
                if (res.success) {
                    newToast("You have successfully created a comment ~~!", ToastType.Success);
                } else {
                    newToast("Error creating a comment: " + res.message, ToastType.Error);
                }
            };
        }}
    >
        <input type="hidden" name="commentable_id" value={feed_item.id}/>
        <input type="hidden" name="commentable_type" value={feed_item.class_name}/>
        <Textarea name="body" placeholder="I was thinking..."/>
        <div class="flex justify-center pt-2">
            <Button type="submit" className="bg-lime-200">
                <MessageCirclePlus/> &nbsp; Submit Comment
            </Button>
        </div>
    </form>
</div>