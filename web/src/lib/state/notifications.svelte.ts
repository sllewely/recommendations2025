// TODO: use protobufs or some other tool for typing the API

export enum NotifType {
    pending_friend_request,
    accepted_friend_request,
}

export type Notification = {
    id: number;
    notif_type: string;
    message: string;
    extras: object;
    created_at: string;
}

export let notifs = $state({
    notifs: []
});
