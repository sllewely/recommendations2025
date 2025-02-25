<script lang="ts">
    import Header from './Header.svelte';
    import Footer from './Footer.svelte';
    import '../../app.css';

    let { children } = $props();
</script>

<div class="flex flex-col h-screen justify-between">
    <Header />

    <main>
        {@render children()}
    </main>

    <Footer />
</div>


