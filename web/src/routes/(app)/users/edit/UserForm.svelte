<script lang="ts">
    import * as Form from "$lib/components/ui/form";
    import {Input} from "$lib/components/ui/input";
    import {profileFormSchema, type FormSchema} from "./schema";
    import {
        type SuperValidated,
        type Infer,
        superForm,
    } from "sveltekit-superforms";
    import {zodClient} from "sveltekit-superforms/adapters";
    import {Badge} from "$lib/components/ui/badge";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H1 from "$lib/components/text/H1.svelte";
    import {Label} from "$lib/components/ui/label";
    import {Textarea} from "$lib/components/ui/textarea";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import * as Tabs from "$lib/components/ui/tabs";
    import * as Card from "$lib/components/ui/card";

    interface Props {
        form_data: SuperValidated<Infer<FormSchema>>;
    }

    let {form_data}: Props = $props();

    const form = superForm(form_data, {
        validators: zodClient(profileFormSchema),
    });

    const {form: formData, enhance} = form;

    let creating = $state(false);
</script>

{#if creating }
    <p>creating...</p>
{/if}

<form
        method="POST"
        action="?/update_user"
        use:enhance={() => {
            creating = true;
            return async ({update, result}) => {
                await update({reset: false});
                creating = false;
                let res = result.data;
                if (res.success) {
                    toasts.toast = newToast("You have successfully updated your user");
                } else {
                    toasts.toast = newToast("Error updating " + res.message, ToastType.Error);
                }
            };
        }}
>
    <Tabs.Root value="profile" class="">
        <Tabs.List class="grid w-full grid-cols-2">
            <Tabs.Trigger value="profile">Profile</Tabs.Trigger>
            <Tabs.Trigger value="account">Account</Tabs.Trigger>
        </Tabs.List>
        <Tabs.Content value="profile">
            <Card.Root>
                <Card.Header>
                    <H1>Edit your profile</H1>
                </Card.Header>
                <Card.Content>
                    <Form.Field {form} name="name">
                        <Form.Control let:attrs>
                            <Form.Label>Name</Form.Label>
                            <Input {...attrs} bind:value={$formData.name}/>
                        </Form.Control>
                        <Form.Description>This is your public display name.</Form.Description>
                        <Form.FieldErrors/>
                    </Form.Field>

                    <Form.Field {form} name="blurb">
                        <Form.Control let:attrs>
                            <Form.Label>Blurb</Form.Label>
                            <Textarea {...attrs} bind:value={$formData.blurb}/>
                        </Form.Control>
                        <Form.Description>This is your public display name.</Form.Description>
                        <Form.FieldErrors/>
                    </Form.Field>


                    <div class="flex flex-col space-y-2">
                        <!--                        <Label for="name">Name:</Label>-->
                        <!--                        <Input id="name" name="name" value={form?.name ?? user.name} autocomplete="off"/>-->
                        <!--                        <Label for="blurb">About me:</Label>-->
                        <!--                        <Textarea id="blurb" name="blurb" value={form?.blurb ?? user.blurb}-->
                        <!--                                  placeholder="What do you want to share?"/>-->
                        <!--                        <Label for="tags">Tags (to help people search for you):</Label>-->
                        <!--                        <Input id="tags" name="tags"-->
                        <!--                               placeholder="examples are the name of your town, college, or friend group"-->
                        <!--                               value={form?.tags ?? user.tags.join(", ")} autocomplete="off"/>-->
                        <!--                        <div class="space-x-2">-->
                        <!--                            {#each tags as tag}-->
                        <!--                                <Badge>{tag}</Badge>-->
                        <!--                            {/each}-->
                        <!--                        </div>-->
                        <FormButton>
                            Update
                        </FormButton>

                    </div>

                </Card.Content>
            </Card.Root>
        </Tabs.Content>
        <Tabs.Content value="account">

            <Card.Root>
                <Card.Header>
                    <H1>Edit your account details</H1>
                </Card.Header>
                <Card.Content>

                </Card.Content>
            </Card.Root>

        </Tabs.Content>

    </Tabs.Root>
</form>