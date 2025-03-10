<script lang="ts">
	import Link from '$lib/components/text/Link.svelte';
	import H1 from '$lib/components/text/H1.svelte';

</script>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="Svelte demo app" />
</svelte:head>

<section>

		<div>
	<H1>
		Recommendations by Celery
	</H1>

	<h2 class="text-md">
		welcome to my app!!!
	</h2>
			<p></p>
			<p><a href="/create_account">Create an account</a></p>
			<p><Link url="/create_account" >Create an account</Link></p>
		</div>
</section>


