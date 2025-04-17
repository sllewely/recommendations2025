<script lang="ts">
    import {enhance} from '$app/forms';
    import LinkButton from "$lib/components/text/LinkButton.svelte";
    import EventCard from "$lib/components/posts/EventCard.svelte";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import {goto} from "$app/navigation";

    let {data} = $props();
    // let user = data.user;
    let my_user_id = data.my_user_id;
    let event = data.event;

    let rsvp = event.current_user_rsvp;


    let creating = $state(false);

</script>


<div>
    {#if my_user_id.toString() === event.creator_id.toString()}
        <div class="float-right relative">
            <LinkButton url="/events/{event.id}/edit">Edit</LinkButton>
            <LinkButton url="/events/{event.id}/delete">Delete</LinkButton>

        </div>
    {/if}
    <EventCard feed_item={event}/>
    <div>
        <div>
            {#if creating }
                <p>updating...</p>
            {/if}
            <form
                    method="POST"
                    action="?/update_rsvp"
                    use:enhance={() => {
                    creating = true;
                    return async ({update, result}) => {
                        await update();
                        creating = false;
                        let res = result.data;
                        if (res.success) {
                            toasts.toast = newToast("Success updating your rsvp");
                        } else {
                            toasts.toast = newToast("Error updating rsvp: " + res.message, ToastType.Error);
                        }
                    };

        }}

            >
                <input type="hidden" name="event_id" value={event.id}/>
                <input type="hidden" name="user_id" value={my_user_id}/>
                <label for="rsvp_status">Your rsvp:</label> <select name="rsvp_status" id="rsvp_status"
                                                                    onchange={(event) => event.target.form.requestSubmit()}>
                <option value="not_selected" selected={rsvp === null}>not rsvp'd</option>
                <option value="going" selected={rsvp === 'going'}>going</option>
                <option value="interested" selected={rsvp === 'interested'}>interested</option>
                <option value="cant_go" selected={rsvp === 'cant_go'}>can't go</option>
                <option value="not_interested" selected={rsvp === 'not_interested'}>not interested</option>
            </select>
            </form>

        </div>
        <div>
            rsvps
            <div>
                {#each event.rsvps as rsvp}
                    {rsvp.status}
                {/each}
            </div>
        </div>
    </div>
</div>