// Use npx pwa-asset-generator logo.png icons

// import workbox from a cdn

/// <reference types="@sveltejs/kit" />
import {build, files, version} from '$service-worker';

// Create a unique cache name for this deployment
const CACHE = `cache-${version}`;

// This code executes in its own worker or thread
self.addEventListener("install", event => {
    console.log("Service worker installed");
});
self.addEventListener("activate", event => {
    console.log("Service worker activated");
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
