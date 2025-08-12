<script lang="ts">
	import pkg from "mapbox-gl";
	import "mapbox-gl/dist/mapbox-gl.css";
	import { onMount, onDestroy } from "svelte";

	const { Map } = pkg;

	let map;
	let mapContainer;
	let lng, lat, zoom;

	lng = -71.224518;
	lat = 42.213995;
	zoom = 9;

	let initialState = { lng, lat, zoom };

	onMount(() => {
		map = new Map({
			container: mapContainer,
			accessToken: "",
			center: [initialState.lng, initialState.lat],
			zoom: initialState.zoom,
		});
	});

	onDestroy(() => {
		if (map) {
			map.remove();
		}
	});
</script>

<div>
	<div>Map!!</div>
	<div>
		<div class="w-full h-full min-h-300" bind:this={mapContainer} />
	</div>
</div>

<style>
	/*.map {*/
	/*	position: absolute;*/
	/*	width: 100%;*/
	/*	height: 100%;*/
	/*}*/
</style>
