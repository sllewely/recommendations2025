<script lang="ts">
    import {fly} from 'svelte/transition';
    import {toasts, ToastType} from "$lib/state/toast.svelte";

    let show_toast =  $derived(toasts.toast.message !== '');
    let toast_color = $derived(toasts.toast.type === ToastType.Error ? 'bg-orange-200' : 'bg-teal-200')

    console.log(toasts.toast.message)

</script>

{#if show_toast}
<header class="{toast_color} text-black py-4 px-3" transition:fly={{x: 200, duration: 2000}}>
    <div class="container mx-auto flex items-center justify-between">
        <div>
        <p>{toasts.toast.message}</p>
        </div>
        <div>
            <button class="hover:text-orange-500 text-xl" onclick={() => {toasts.toast.message=''}}>x</button>
        </div>
    </div>
</header>
{/if}

