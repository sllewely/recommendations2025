<script lang="ts">
    import {enhance} from '$app/forms';
    import Input from "$lib/components/form/Input.svelte";
    import InputDateTime from "$lib/components/form/InputDateTime.svelte";
    import InputCheckbox from "$lib/components/form/InputCheckbox.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H1 from '$lib/components/text/H1.svelte'
    import EventFeedItem from "$lib/components/posts/EventFeedItem.svelte";

    import Card from '$lib/components/Card.svelte';

    import {newToast, ToastType} from "$lib/state/toast.svelte";
    import {goto} from "$app/navigation";
    import DateHeader from "$lib/components/posts/DateHeader.svelte";

    let {data, form} = $props();

    let creating = $state(false);

    // TODO:
    // Privacy


</script>

<div>
    <div class="flex justify-center">
        <H1>Community Events</H1>
    </div>
    <div>
        <div class="grid grid-cols-3">
            <div>

                {#if creating }
                    <p>creating...</p>
                {/if}
                <form
                        method="POST"
                        action="?/create_event"
                        use:enhance={() => {
            creating = true;
            return async ({update, result}) => {
                await update({reset: false});
                creating = false;
                let res = result.data;
                if (res.success) {
                    console.log("success create event")
                    newToast("You have successfully created an event!!");
                    goto("/events")
                } else {
                    newToast("Error creating an event: " + res.message, ToastType.Error);
                }
            };

        }}

                >

                    <div class="flex flex-col">
                        <Card>
                            <H1>Create an event</H1>
                            <p class="text-xs">You'll need to be logged in to make an event!</p>
                            <InputCheckbox name="public" label="Public event" value="true"/>

                            <Input name="title" label="Title:" value={form?.title}/>
                            <InputDateTime date_value={form?.date_input} time_value={form?.time_input}/>
                            <!--                            <InputDateTime name="end" date_value={form?.date_input} time_value="{form?.time_input}" />-->
                            <Input name="description" label="Description:"/>
                            <Input name="address" label="Address:" value={form?.address}/>
                            <Input name="url" label="URL:" value={form?.url}/>
                            <Input name="event_type" label="Event Type:" value={form?.event_type}/>
                        </Card>
                    </div>
                    <FormButton>Create event</FormButton>
                </form>
            </div>

            <div class="col-span-2">
                <H1>Events</H1>
                {#each data.events as event_item}
                    {#if !!event_item['date_header']}
                        <DateHeader event_item={event_item}/>
                    {:else}
                        <EventFeedItem event_item={event_item}/>
                    {/if}
                {/each}

            </div>


        </div>

    </div>

</div>
