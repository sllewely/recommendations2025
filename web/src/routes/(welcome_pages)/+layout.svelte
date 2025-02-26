<script lang="ts">
    import Header from './Header.svelte';
    import Footer from './Footer.svelte';
    import '../../app.css';

    let { children } = $props();
</script>

<div class="flex flex-col h-screen justify-between">
    <Header />

    <main>
        <div class="flex items-center justify-center">
        {@render children()}
        </div>
    </main>

    <Footer />
</div>


