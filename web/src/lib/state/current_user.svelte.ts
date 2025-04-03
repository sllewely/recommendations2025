

export let current_user = $state({
    auth_token: '',
    id: '',
});

// Cannot export derived state
// export let is_signed_in = $derived(current_user.auth_token !== '');

// Debated if this should be a $derived state, but I think I may add handling for expired tokens in the future
export function isSignedIn(): boolean {
    return current_user.auth_token === '';
}


