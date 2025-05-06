<script lang="ts">
    import Header from '$lib/components/Header.svelte';
    import Footer from '$lib/components/Footer.svelte';
    import '../../app.css';
    import Toast from "$lib/components/Toast.svelte";
    import {current_user} from "$lib/state/current_user.svelte";

    let { children, data } = $props();

    current_user.id = data.current_user_id;

</script>
<div class="bg-teal-100"></div>

<div class="flex flex-col h-screen justify-between">
    <div>
    <Header />
    <Toast />
    </div>

    <main>
        <div class="flex items-center justify-center">
        {@render children()}
        </div>
    </main>

    <Footer />
</div>


