<script lang="ts">
    import {Button} from "$lib/components/ui/button";

    const requestNotifPermissions = () => {
        Notification.requestPermission().then((result) => {
            if (result === "granted") {
                randomNotification();
            }
        });
    };

    function randomNotification() {
        // const randomItem = Math.floor(Math.random() * games.length);
        // const notifTitle = games[randomItem].name;
        // const notifBody = `Created by ${games[randomItem].author}.`;
        // const notifImg = `data/img/${games[randomItem].slug}.jpg`;
        // const options = {
        //     body: "My notif!!",
        //     icon: notifImg,
        // };
        new Notification("My test notification!!");
        setTimeout(randomNotification, 30000);
    }


</script>

<Button onClick={requestNotifPermissions} className=" bg-lime-200 " id="notifications">*~Notif permission~*</Button>