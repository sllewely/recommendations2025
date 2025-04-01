<script lang="ts">
    import {fly} from 'svelte/transition';
    import { toast_message} from "$lib/state/toast.svelte";
    let show_toast =  $derived((toast_message.message === '') ? false : true);


    $inspect(toast_message.message);
    $inspect(show_toast)
</script>

{#if show_toast}
<header class="bg-teal-200 text-black py-4 px-3" transition:fly={{x: 200, duration: 2000}}>
    <div class="container mx-auto flex items-center justify-between">
        <div>
        <p>{toast_message.message}</p>
        </div>
        <div>
            <button class="hover:text-orange-500 text-xl" on:click={() => {toast_message.message=''}}>x</button>
        </div>
    </div>
</header>
{/if}

