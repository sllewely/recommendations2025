<script>
    import H1 from '$lib/components/text/H1.svelte'
    import Link from '$lib/components/text/Link.svelte'

    let { data } = $props();
</script>


<H1>Posts</H1>
<h2><Link url="/posts/create">create a post</Link></h2>

<h1>res:</h1>
<h2>{data.jwt}</h2>