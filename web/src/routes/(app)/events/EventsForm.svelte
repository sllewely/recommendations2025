<script lang="ts">
    import {enhance} from '$app/forms';
    import {newToast, ToastType} from "$lib/state/toast.svelte.js";
    import {goto} from "$app/navigation";
    import H1 from "$lib/components/text/H1.svelte";
    import Card from "$lib/components/Card.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import InputDateTime from "$lib/components/form/InputDateTime.svelte";
    import {type Infer, superForm, type SuperValidated} from "sveltekit-superforms";
    import {eventsFormSchema, type EventsFormSchema} from "./schema";
    import {zodClient} from "sveltekit-superforms/adapters";
    import {Input} from "$lib/components/ui/input";
    import * as Form from "$lib/components/ui/form";

    interface Props {
        form_data: SuperValidated<Infer<EventsFormSchema>>;
    }


    let {form_data}: Props = $props();

    $inspect(form_data);

    const form = superForm(form_data, {
        validators: zodClient(eventsFormSchema),
    });

    const {form: formData} = form;


    let creating = $state(false);
</script>

<div>

    <H1>Create an event post</H1>

    {#if creating }
        <p>creating...</p>
    {/if}
    <Card>
        <form
                method="POST"
                action="?/create_event"
                use:enhance={() => {
            creating = true;
            return async ({update, result}) => {
                await update();
                creating = false;
                let res = result.data;
                if (res.success) {
                    console.log("success create event")
                    newToast("You have successfully created an event!!");
                    goto("/posts")
                } else {
                    newToast("Error creating an event: " + res.message, ToastType.Error);
                }
            };

        }}

        >

            <div class="flex flex-col">
                <Card>
                    <Form.Field {form} name="title">
                        <Form.Control let:attrs>
                            <Form.Label>Title</Form.Label>
                            <Input {...attrs} bind:value={$formData.title}/>
                        </Form.Control>
                        <Form.Description>Name of the event</Form.Description>
                        <Form.FieldErrors/>
                    </Form.Field>
                    <!--                    <Input name="title" label="Title:" value={form?.title}/>-->
                    <!--                    <InputDateTime date_value={form?.date_input} time_value="{form?.time_input}"/>-->
                    <!--                    <Input name="description" label="Description:"/>-->
                    <!--                    <Input name="address" label="Address:" value={form?.address}/>-->
                    <!--                    <Input name="url" label="URL:" value={form?.url}/>-->
                    <!--                    <Input name="event_type" label="Event Type:" value={form?.event_type}/>-->
                </Card>
            </div>
            <FormButton>Create event</FormButton>
        </form>
    </Card>

</div>