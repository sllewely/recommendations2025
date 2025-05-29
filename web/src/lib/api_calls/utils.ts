export function formDataToGeneric<T>(data: FormData): T {
	return Object.fromEntries(data.entries()) as T;
}
