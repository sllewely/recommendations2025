// Use npx pwa-asset-generator logo.png icons

// import workbox from a cdn

// This code executes in its own worker or thread
self.addEventListener("install", event => {
    console.log("Service worker installed");
});
self.addEventListener("activate", event => {
    console.log("Service worker activated");
});

self.addEventListener('push', function (event) {
    const data = event.data.json();  // Assuming the server sends JSON
    const options = {
        body: data.body,
        icon: 'icon.png',
        badge: 'badge.png'
    };
    event.waitUntil(
        self.registration.showNotification(data.title, options)
    );
});
