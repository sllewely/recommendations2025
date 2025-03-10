<script>
    import H1 from '$lib/components/text/H1.svelte';
    import Link from '$lib/components/text/Link.svelte';
    import LinkButton from '$lib/components/text/LinkButton.svelte';

    let { data } = $props();
</script>


<H1>Posts</H1>
<div>
    <LinkButton color="yellow" url="/posts/create">&#10133; Recommendation</LinkButton>
    <LinkButton color="orange" url="/posts/create">&#10133; Event</LinkButton>
    <LinkButton color="blue" url="/posts/create">&#10133; Post</LinkButton>
</div>
<h2><Link url="/posts/create">create a post</Link></h2>

<h1>res:</h1>
<h2>{data.jwt}</h2>