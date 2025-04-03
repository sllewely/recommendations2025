

export let current_user = $state({
    auth_token: '',
    id: '',
});

// Debated if this should be a $derived state, but I think I may add handling for expired tokens in the future
export function isSignedIn(): boolean {
    return current_user.auth_token === '';
}


