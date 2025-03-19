<script lang="ts">
    import {enhance} from '$app/forms';

    import H1 from '$lib/components/text/H1.svelte'
    import Card from "$lib/components/Card.svelte";
    import Input from "$lib/components/form/Input.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import { current_user } from '$lib/state/current_user.svelte';

    let {data, form} = $props();
    let creating = $state(false);

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
            return async ({update}) => {
                await update();
                creating = false;
            };
        }}
            >
                <div class="flex flex-col">

                    <input type="hidden" name="user_id" value={current_user.id} />
                    <input type="hidden" name="auth_token" value={current_user.auth_token} />
                    <Input name="name" label="Name:" value={form?.name ?? user.name}/>
                    <FormButton>
                        Update
                    </FormButton>

                </div>

            </form>

        </Card>

    </div>

</div>

