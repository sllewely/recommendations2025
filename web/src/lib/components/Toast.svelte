<script lang="ts">
    import { toast_message} from "$lib/state/toast.svelte";
    let show_toast =  $derived((toast_message.message === '') ? 'hidden' : 'visible');


    $inspect(toast_message.message);
</script>

<header class="bg-teal-200 text-black py-4 px-3 {show_toast}">
    <div class="container mx-auto flex items-center justify-between">
        <p>{toast_message.message}</p>
    </div>
</header>

