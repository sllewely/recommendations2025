<script lang="ts">
    import {enhance} from '$app/forms';

    import H1 from "$lib/components/text/H1.svelte";
    import Card from "$lib/components/Card.svelte";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import {Input} from "$lib/components/ui/input/index.js";
    import {Label} from "$lib/components/ui/label/index.js";
    import {Button} from "$lib/components/ui/button/index.js";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import H2 from "$lib/components/text/H2.svelte";
    import UserSearchResult from "$lib/components/users/UserSearchResult.svelte";
    import PendingFriendRequest from "$lib/components/users/PendingFriendRequest.svelte";
    import Friend from "$lib/components/users/Friend.svelte";
    import {friends_map, fetch_friends_map} from "$lib/state/friends_map.svelte";

    let {data, form} = $props();

    let my_user = data.my_user;

    let pending_friends = $state(data.friend_requests_response['res']['incoming_friend_requests'] ?? []);
    $effect(() => {
        pending_friends = data.friend_requests_response['res']['incoming_friend_requests'] ?? [];
    })

    let creating = $state(false);
    let searching = $state(false);

    let users = $state([]);

    let friends = $state(data.friends_response['res'] ?? []);
    $effect(() => {
        friends = data.friends_response['res'] ?? [];
    })

    function debounce(func, timeout = 300) {
        let timer;
        return (...args) => {
            clearTimeout(timer);
            timer = setTimeout(() => {
                func.apply(this, args);
            }, timeout);
        };
    }

    function submitForm() {
        document.getElementById('search_form').requestSubmit();
    }

</script>

<div>
    <H1>Friends!</H1>

    {#if pending_friends.length > 0}

        <div>
            <H2>Pending friend requests</H2>

            {#each pending_friends as pending_friend}
                <PendingFriendRequest {pending_friend}/>
            {/each}
        </div>
    {/if}


    <div class="flex">
        <div class="flex-auto">
            <Card>
                <H2>Search for a user</H2>

                {#if searching }
                    <p>searching...</p>
                {/if}
                <form
                        id="search_form"
                        method="POST"
                        action="?/search_users"
                        bind:this={form}
                        use:enhance={() => {
                            creating = true;
                            return async ({update, result}) => {
                            // Do not clear form on success
                            await update({reset: false});
                            creating = false;
                            let res = result.data;
                            if (res.success) {
                                users = res['res'].filter(user => {
                                    return user.id !== my_user.res.id;
                                });
                            } else {
                                toasts.toast = newToast("Error searching: " + res.message, ToastType.Error);
                            }
                        };

                    }}
                >
                    <div class="flex flex-col sm:flex-row justify-between sm:space-x-4">
                        <div class="flex-auto">
                            <Label for="search">by name:</Label>
                            <Input id="search" name="search" placeholder="sarah"
                                autofocus
                                autocomplete="off"
                                on:keyup={() => {document.getElementById("search_form").requestSubmit()}}/>
                        </div>
                        <div class="flex-1">
                            <Label for="tag">by tag:</Label>
                            <Input id="tag" name="tag" placeholder="nyc"
                                autofocus
                                autocomplete="off"
                            />
                        </div>
                    </div>
                    <div class="flex row gap-2">
                        <div class="my-6">
                            <Button type="submit" class="rounded hover:bg-orange-500 text-teal-700 font-semibold hover:text-white py-2 px-4 border border-teal-500 hover:border-transparent" variant="outline">Search</Button>
                        </div>
                        <div class="my-6">
                            <Button 
                                type="button" 
                                class="rounded hover:bg-red-500 text-red-700 font-semibold hover:text-white py-2 px-4 border border-red-500 hover:border-transparent" 
                                variant="outline" 
                                on:click={() => {
                                    document.getElementById("search_form").reset();
                                    users = [];
                                    document.getElementById("search").focus();
                                }}>Clear</Button>
                        </div>
                    </div>

                </form>

                <div>
                    {#each users as user}
                        <div class="">
                            <UserSearchResult {user} is_friend={user.id in friends_map.friends_map}
                                is_pending="{data.outgoing_friend_request_map.has(user.id.toString())}"/>
                        </div>
                    {/each}
                </div>

            </Card>
        </div>

    </div>

    <div class="pt-4">
        <H2>Your friends</H2>
        {#if friends.length === 0}
            <p>You have no friends yet! Make some new ones :)</p>
        {/if}
        <div>
            {#each friends as friend}
                <Friend user={friend}/>
            {/each}
        </div>
    </div>
</div>