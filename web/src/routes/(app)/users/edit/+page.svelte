<script lang="ts">
    import {enhance} from '$app/forms';

    import H1 from '$lib/components/text/H1.svelte'
    import Card from "$lib/components/Card.svelte";
    // import Input from "$lib/components/form/Input.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import {current_user} from '$lib/state/current_user.svelte';

    import {Input} from "$lib/components/ui/input/index.js";
    import {Label} from "$lib/components/ui/label/index.js";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import {goto} from "$app/navigation";

    let {data, form} = $props();
    let creating = $state(false);

    let user = data.user;

</script>
<div>
    <p>your info</p>
    <H1>{user.name}</H1>

    {#if creating }
        <p>creating...</p>
    {/if}

    <div>
        <Card>
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
                    <FormButton>
                        Update
                    </FormButton>

                </div>

            </form>

        </Card>

    </div>

</div>

