<script lang="ts">
    import {enhance} from '$app/forms';

    import H1 from "$lib/components/text/H1.svelte";
    import Card from "$lib/components/Card.svelte";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import Input from "$lib/components/form/Input.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H2 from "$lib/components/text/H2.svelte";
    import UserSearchResult from "$lib/components/users/UserSearchResult.svelte";

    let {data, form} = $props();

    let my_user = data.my_user;

    let creating = $state(false);
    let searching = $state(false);

    let users = $state([]);
</script>

<div>
    <H1>Friends!</H1>

    <div class="flex">
        <div class="flex-auto">
            <Card>
                <H2>Search for a user</H2>


                {#if searching }
                    <p>searching...</p>
                {/if}
                <form
                        method="POST"
                        action="?/search_users"
                        use:enhance={() => {
                    creating = true;
                    return async ({update, result}) => {
                        // Do not clear form on success
                        await update({reset: false});
                        creating = false;
                        let res = result.data;
                        if (res.success) {
                            //toasts.toast = newToast("Success updating your rsvp");
                            users = res['res'];
                            console.log(res['res']);
                        } else {
                            toasts.toast = newToast("Error searching: " + res.message, ToastType.Error);
                        }
                    };

        }}
                >

                    <Input name="search" label="by name:" value={form?.search} placeholder="sarah"/>
                    <div class="mb-6">
                        <FormButton>Search</FormButton>
                    </div>

                </form>

                <div>
                    {#each users as user}
                        <div>
                            <UserSearchResult {user}/>


                        </div>


                    {/each}
                </div>

            </Card>
        </div>
        <!--        <div class="row-span-1">-->
        <!--            <Card>-->
        <!--                <H2>Friend by friend code</H2>-->
        <!--                <p>Presently you can add someone as a friend using a friend code.</p>-->
        <!--                <p>Your friend code is: <span>{data.my_user.friend_code}</span></p>-->

        <!--                {#if creating }-->
        <!--                    <p>updating...</p>-->
        <!--                {/if}-->
        <!--                <form-->
        <!--                        method="POST"-->
        <!--                        action="?/add_friend"-->
        <!--                        use:enhance={() => {-->
        <!--                    creating = true;-->
        <!--                    return async ({update, result}) => {-->
        <!--                        await update();-->
        <!--                        creating = false;-->
        <!--                        let res = result.data;-->
        <!--                        if (res.success) {-->
        <!--                            toasts.toast = newToast("Success updating your rsvp");-->
        <!--                        } else {-->
        <!--                            toasts.toast = newToast("Error updating rsvp: " + res.message, ToastType.Error);-->
        <!--                        }-->
        <!--                    };-->

        <!--        }}-->
        <!--                >-->

        <!--                    <Input name="friend_code" label="Your new friend's code:" value={form?.friend_code}/>-->
        <!--                    <FormButton>Add friend</FormButton>-->

        <!--                </form>-->

        <!--            </Card>-->
        <!--        </div>-->
    </div>
</div>