<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import SectionHeading from "$lib/components/text/SectionHeading.svelte";
	import Link from "$lib/components/text/Link.svelte";
</script>

<SubHeader>
	<SubHeaderTitle title="report a bug" />
</SubHeader>

<div>
	<SectionHeading>submit a bug!</SectionHeading>
	<p>Thanks for helping me improve</p>
	<p>
		<Link
			url="https://docs.google.com/forms/d/e/1FAIpQLSd4BWndu-Tjcslx43rUKy7bAHJr1HnzbKvPQ66lk8Pfw85s1w/viewform?usp=sharing"
			>Bug report link</Link
		>
	</p>
</div>
