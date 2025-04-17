<script lang="ts">
    import {enhance} from '$app/forms';
    import Link from "$lib/components/text/Link.svelte";
    import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import FormButton from "$lib/components/form/FormButton.svelte";
    import Form from "$lib/components/form/Form.svelte";

    let {user} = $props();


</script>

<div class="p-4 border-1 border-gray-200 rounded-sm flex flex-row justify-between">
    <div>
        <Link url="/users/{user.id}"><p>{user.name}</p></Link>
    </div>
</div>