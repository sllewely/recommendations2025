export enum ToastType {
    Success,
    Error,
}

type ToastMessage = {
    message: string,
    type: ToastType,
    time: number
}

export let toasts = $state({
    toast: newToast('')
})

export function newToast(message: string, type = ToastType.Success): ToastMessage {
    return {
        message: message,
        type: type,
        time: Date.now(),
    }
}