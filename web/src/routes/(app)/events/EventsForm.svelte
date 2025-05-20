<script lang="ts">
    import {enhance} from '$app/forms';
    import {newToast, ToastType} from "$lib/state/toast.svelte.js";
    import {goto} from "$app/navigation";
    import H1 from "$lib/components/text/H1.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import InputDateTime from "$lib/components/form/InputDateTime.svelte";
    import {type Infer, superForm, type SuperValidated} from "sveltekit-superforms";
    import {eventsFormSchema, type EventsFormSchema} from "./schema";
    import {zodClient} from "sveltekit-superforms/adapters";
    import {Input} from "$lib/components/ui/input";
    import * as Form from "$lib/components/ui/form";
    import {Card} from "$lib/components/ui/card";

    import type {DateRange} from "bits-ui";
    import {
        CalendarDate,
        DateFormatter,
        type DateValue,
        getLocalTimeZone, today
    } from "@internationalized/date";
    import {cn} from "$lib/utils.js";
    import {Button, buttonVariants} from "$lib/components/ui/button/index.js";
    import {RangeCalendar} from "$lib/components/ui/range-calendar/index.js";
    import * as Popover from "$lib/components/ui/popover/index.js";
    import {CalendarRange} from "lucide-svelte";

    interface Props {
        form_data: SuperValidated<Infer<EventsFormSchema>>;
    }


    let {form_data}: Props = $props();

    const form = superForm(form_data, {
        validators: zodClient(eventsFormSchema),
    });

    const {form: formData} = form;


    let creating = $state(false);

    const df = new DateFormatter("en-US", {
        dateStyle: "medium"
    });

    let value: DateRange = $state({
        start: today("America/New_York").add({days: 1}),
        end: undefined,
    });

    let startValue: DateValue | undefined = $state(undefined);
</script>

<div>


    {#if creating }
        <p>creating...</p>
    {/if}
    <Card class="p-4">
        <H1>Create an event post</H1>

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
                <Form.Field {form} name="title">
                    <Form.Control let:attrs>
                        <Form.Label>Title</Form.Label>
                        <Input {...attrs} bind:value={$formData.title}/>
                    </Form.Control>
                    <Form.Description>Name of the event</Form.Description>
                    <Form.FieldErrors/>
                </Form.Field>

                <div class="flex justify-between space-x-4">
                    <div class="flex-1">
                        <Form.Field {form} name="start_date" class="flex flex-col">
                            <Form.Control let:attrs>
                                <Form.Label>Date</Form.Label>
                                <Popover.Root>
                                    <Popover.Trigger
                                            class={cn(
        buttonVariants({ variant: "outline" }),
        !value && "text-muted-foreground"
      )}
                                    >
                                        <CalendarRange/>
                                        {#if value && value.start}
                                            {#if value.end && !(value.start.toString() === value.end.toString())}
                                                {df.format(value.start.toDate(getLocalTimeZone()))} - {df.format(
                                                value.end.toDate(getLocalTimeZone())
                                            )}
                                            {:else}
                                                {df.format(value.start.toDate(getLocalTimeZone()))}
                                            {/if}
                                        {:else if startValue}
                                            {df.format(startValue.toDate(getLocalTimeZone()))}
                                        {:else}
                                            Pick a date
                                        {/if}
                                    </Popover.Trigger>
                                    <Popover.Content class="w-auto p-0" align="start">
                                        <RangeCalendar
                                                bind:value
                                                onStartValueChange={(v) => {
                                                    $formData.start_date = v.toString();
                                                      startValue = v;
                                                    }}
                                                onEndValueChange={(v) => {
                                                    $formData.end_date = v.toString();
                                                    }}
                                                numberOfMonths={2}
                                        />
                                    </Popover.Content>
                                </Popover.Root>
                                <Form.FieldErrors/>
                                <input hidden value={$formData.start_date} name="start_date"/>
                                <!--                                <input hidden value={value.end ?? value.end.toString()} name="end_date"/>-->
                            </Form.Control>
                        </Form.Field>
                    </div>
                    <div class="flex-1">
                        <Form.Field {form} name="start_date" class="flex flex-col">
                            <Form.Control let:attrs>
                                <Form.Label>Time</Form.Label>
                                <input
                                        type="time"
                                        name="time_input"
                                        id="time_input"
                                        class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                                        value={$formData.time ? $formData.time : "15:00"}
                                        required
                                />
                                <Form.FieldErrors/>
                            </Form.Control>
                        </Form.Field>
                    </div>
                </div>


                <!--                    <Input name="title" label="Title:" value={form?.title}/>-->
                <!--                    <InputDateTime date_value={form?.date_input} time_value="{form?.time_input}"/>-->
                <!--                    <Input name="description" label="Description:"/>-->
                <!--                    <Input name="address" label="Address:" value={form?.address}/>-->
                <!--                    <Input name="url" label="URL:" value={form?.url}/>-->
                <!--                    <Input name="event_type" label="Event Type:" value={form?.event_type}/>-->
            </div>
            <FormButton>Create event</FormButton>
        </form>
    </Card>

</div>