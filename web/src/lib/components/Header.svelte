<script lang="ts">
    import {goto} from '$app/navigation';
    import {current_user, isSignedIn} from '$lib/state/current_user.svelte.js';

    let user_id = current_user.id;

    let signed_in = $derived(current_user.id !== '');

    let log_out = async () => {
        const response = await fetch('/api/log_out', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });
        current_user.id = '';
        current_user.auth_token = '';
        await goto('/');
    }

</script>

<header class="text-white p-0">
    <div class="m-0 w-full flex items-center justify-between  py-4 bg-gray-800 ">
        <div class="w-full  md:text-center md:mb-0 mb-8">
            <a href="/"><p class="text-gray-400 text-xl">Recommendations and Events</p></a>
        </div>
        <div class="w-full md:text-center md:mb-0 mb-8">
            <ul class="list-reset flex justify-center flex-wrap text-xs md:text-sm gap-3">
                {#if signed_in}
                    <li><a href="/posts" class="text-gray-400 hover:text-white">Posts</a></li>
                    <li><a href="/users/{user_id}" class="text-gray-400 hover:text-white">My profile</a></li>
                {/if}
                <li><a href="/events" class="text-gray-400 hover:text-white">Events</a></li>
                <li><a href="/roadmap" class="text-gray-400 hover:text-white">Roadmap</a></li>
                <li><a href="/about" class="text-gray-400 hover:text-white">About</a></li>

                {#if !signed_in}
                    <li><a href="/create_account" class="text-gray-400 hover:text-white">Sign up</a></li>
                {/if}
            </ul>
        </div>
        <div class="w-full  md:text-center md:mb-0 mb-8 justify-end">
            <a class="text-sm/6 font-semibold text-gray-400 hover:text-orange-400" href="/bug_report">Report a bug</a>
            |
            {#if signed_in}
                <a class="text-sm/6 font-semibold text-gray-400 hover:text-orange-400" href="/users/edit">
                    &#9881;
                </a>
                |
                <a class="text-sm/6 font-semibold text-gray-400 hover:text-orange-400" onclick={log_out}>Log out <span
                        aria-hidden="true">&rarr;</span></a>
            {:else}
                <a href="/sign_in" class="text-sm/6 font-semibold text-gray-400 hover:text-orange-400">Log in <span
                        aria-hidden="true">&rarr;</span></a>
            {/if}
        </div>
    </div>
    {#if signed_in}
        <div class="mx-auto flex items-center justify-between  py-2 px-3 bg-gray-600 ">
            <div></div>
            <div>
                <ul class="list-reset flex justify-center flex-wrap text-xs md:text-sm gap-3">
                    <li><a href="/friends" class="text-gray-400 hover:text-white">Friends</a></li>
                    <li><a href="/recommendations/users/{user_id}"
                           class="text-gray-400 hover:text-white">Recommendations</a></li>
                </ul>
            </div>
            <div></div>
        </div>
    {/if}
</header>


