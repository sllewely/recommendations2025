<script lang="ts">
    import {enhance} from '$app/forms';
    import H1 from "$lib/components/text/H1.svelte";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import {goto} from "$app/navigation";
    import Card from "$lib/components/Card.svelte";
    import Input from "$lib/components/form/Input.svelte";
    import InputDateTime from "$lib/components/form/InputDateTime.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import moment from 'moment';

    const {data, form} = $props();
    const event = data.event;

    let updating = $state(false);

    let datetime_string = moment(event.start_date_time, moment.ISO_8601);
    let date_string = datetime_string.format('YYYY-MM-DD');
    let time_string = datetime_string.format('hh:mm');


</script>

<div>
    <H1>Edit Event {event.title}</H1>

    <div>

        <Card>
            <form
                    method="POST"
                    action="?/update_event"
                    use:enhance={() => {
            updating = true;
            return async ({update, result}) => {
                await update();
                updating = false;
                let res = result.data;
                if (res.success) {
                    console.log("success update event")
                    toasts.toast = newToast("You have successfully updated an event!!");
                    goto("/posts")
                } else {
                    toasts.toast = newToast("Error updating an event: " + res.message, ToastType.Error);
                }
            };

        }}

            >

                <div class="flex flex-col">
                    <Card>
                        <input type="hidden" name="event_id" value={event.id}/>
                        <Input name="title" label="Title:" value={form?.title ?? event.title}/>
                        <InputDateTime date_value={form?.date_input ?? date_string}
                                       time_value="{form?.time_input ?? time_string}"/>
                        <Input name="description" label="Description:" value={form?.description ?? event.description}/>
                        <Input name="address" label="Address:" value={form?.address ?? event.address}/>
                        <Input name="url" label="URL:" value={form?.url ?? event.url}/>
                        <Input name="event_type" label="Event Type:" value={form?.event_type ?? event.event_type}/>
                    </Card>
                </div>
                <FormButton>Update event</FormButton>
            </form>
        </Card>
    </div>

</div>