<script lang="ts">
    import {enhance} from '$app/forms';

    import H1 from '$lib/components/text/H1.svelte'
    import * as Card from "$lib/components/ui/card";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import {Input} from "$lib/components/ui/input/index.js";
    import {Label} from "$lib/components/ui/label/index.js";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import {Textarea} from "$lib/components/ui/textarea";
    import {Badge} from "$lib/components/ui/badge/index.js";

    import * as Tabs from "$lib/components/ui/tabs";

    let {data, form} = $props();
    let creating = $state(false);

    let user = data.user;

    let tags = $state(user.tags);
    $effect(() => {
        tags = data.user.tags;
    })

</script>
<div>
    <p>#TODO page needs a fun background!!</p>
    <H1>{user.name}</H1>

    {#if creating }
        <p>creating...</p>
    {/if}

    <div>
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
                            <div class="flex flex-col space-y-2">
                                <Label for="name">Name:</Label>
                                <Input id="name" name="name" value={form?.name ?? user.name} autocomplete="off"/>
                                <Label for="blurb">About me:</Label>
                                <Textarea id="blurb" name="blurb" value={form?.blurb ?? user.blurb}
                                          placeholder="What do you want to share?"/>
                                <Label for="tags">Tags (to help people search for you):</Label>
                                <Input id="tags" name="tags"
                                       placeholder="examples are the name of your town, college, or friend group"
                                       value={form?.tags ?? user.tags.join(", ")} autocomplete="off"/>
                                <div class="space-x-2">
                                    {#each tags as tag}
                                        <Badge>{tag}</Badge>
                                    {/each}
                                </div>
                                <FormButton>
                                    Update
                                </FormButton>

                            </div>

                        </form>
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

    </div>

</div>

