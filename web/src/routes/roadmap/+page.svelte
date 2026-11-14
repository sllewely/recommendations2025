<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import Link from "$lib/components/text/Link.svelte";
</script>

<SubHeader>
	<SubHeaderTitle title="roadmap" />
</SubHeader>

<div>
	<p>I'm just one unpaid developer :') but all of your feedback is appreciated</p>
	<p>
		<Link
			url="https://docs.google.com/document/d/1AgK534T8KpFDt5CUouzuQY8Eq1XPpF0EkMRq0xPP3to/edit?usp=sharing"
			>Roadmap</Link
		>
	</p>
	<p>
		<Link
			url="https://docs.google.com/forms/d/e/1FAIpQLSd_eaVSWDhCnIDbLFhf3OHO2qtQvwoYifKL1KJoPi71fTjIUw/viewform?usp=sharing"
			>Submit a feature request!</Link
		>
	</p>
</div>
