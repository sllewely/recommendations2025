// Use npx pwa-asset-generator logo.png icons

// import workbox from a cdn

/// <reference types="@sveltejs/kit" />
import { build, files, version } from "$service-worker";

// Create a unique cache name for this deployment
const CACHE = `cache-${version}`;

const ASSETS = [
	...build, // the app itself
	...files, // everything in `static`
];

// This code executes in its own worker or thread
self.addEventListener("install", (event) => {
	console.log("Service worker installed");

	// Create a new cache and add all files to it
	async function addFilesToCache() {
		const cache = await caches.open(CACHE);
		await cache.addAll(ASSETS);
	}

	event.waitUntil(addFilesToCache());

	console.log("install service worker - cached");
});
self.addEventListener("activate", (event) => {
	console.log("Service worker activated");

	// Remove previous cached data from disk
	async function deleteOldCaches() {
		for (const key of await caches.keys()) {
			if (key !== CACHE) await caches.delete(key);
		}
	}

	event.waitUntil(deleteOldCaches());

	console.log("active service worker - clear cache");
});

// self.addEventListener('push', function (event) {
//     const data = event.data.json();  // Assuming the server sends JSON
//     const options = {
//         body: data.body,
//         icon: 'icon.png',
//         badge: 'badge.png'
//     };
//     event.waitUntil(
//         self.registration.showNotification(data.title, options)
//     );
// });
