import { toast as sonnerToast } from "svelte-sonner";

export enum ToastType {
	Success,
	Error,
	Info,
	Warning,
}

export type ToastMessage = {
	id: string;
	message: string;
	type: ToastType;
};

export let toasts = $state<ToastMessage[]>([]);
let pendingToast = $state<{ message: string; type: ToastType } | null>(null);

function generateId(): string {
	return Math.random().toString(36).substring(2, 9);
}

export function setPendingToast(message: string, type = ToastType.Success): void {
	pendingToast = { message, type };
}

export function checkAndShowPendingToasts(): void {
	if (pendingToast) {
		newToast(pendingToast.message, pendingToast.type);
		pendingToast = null;
	}
}

export function newToast(message: string, type = ToastType.Success): string {
	const id = generateId();
	const toastMessage = {
		id,
		message,
		type,
	};

	toasts.push(toastMessage);
	switch (type) {
		case ToastType.Success:
			sonnerToast.success(message, {
				id,
				onDismiss: (t) => removeToast(id),
				onAutoClose: (t) => removeToast(id),
			});
			break;
		case ToastType.Error:
			sonnerToast.error(message, {
				id,
				onDismiss: (t) => removeToast(id),
				onAutoClose: (t) => removeToast(id),
			});
			break;
		case ToastType.Info:
			sonnerToast.info(message, {
				id,
				onDismiss: (t) => removeToast(id),
				onAutoClose: (t) => removeToast(id),
			});
			break;
		case ToastType.Warning:
			sonnerToast.warning(message, {
				id,
				onDismiss: (t) => removeToast(id),
				onAutoClose: (t) => removeToast(id),
			});
			break;
		default:
			sonnerToast(message, {
				id,
				onDismiss: (t) => removeToast(id),
				onAutoClose: (t) => removeToast(id),
			});
	}

	return id;
}

export function removeToast(id: string): void {
	const index = toasts.findIndex((t) => t.id === id);
	if (index !== -1) {
		toasts.splice(index, 1);
	}
}
