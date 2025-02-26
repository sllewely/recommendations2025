<script lang="ts">
	import Link from '$lib/components/text/Link.svelte';
	import PageTitle from '$lib/components/text/PageTitle.svelte';

</script>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="Svelte demo app" />
</svelte:head>

<section>

		<div>
	<PageTitle>
		Recommendations by Celery
	</PageTitle>

	<h2 class="text-md">
		welcome to my app!!!
	</h2>
			<p></p>
			<p><a href="/create_account">Create an account</a></p>
			<p><Link url="/create_account" >Create an account</Link></p>
		</div>
</section>


