<script lang="ts">
    import {enhance} from '$app/forms';

    import H1 from '$lib/components/text/H1.svelte'
    import FormButton from "$lib/components/form/FormButton.svelte";
    import {Input} from "$lib/components/ui/input/index.js";
    import {Label} from "$lib/components/ui/label/index.js";
    import {newToast, toasts, ToastType} from "$lib/state/toast.svelte";
    import {Textarea} from "$lib/components/ui/textarea";
    import {Badge} from "$lib/components/ui/badge/index.js";

    import * as Tabs from "$lib/components/ui/tabs";
    import * as Card from "$lib/components/ui/card";
    import {z} from "zod";
    import UserForm from "./UserForm.svelte";

    let {data, form} = $props();
    let creating = $state(false);

    let user = data.user;

    let tags = $state(user.tags);
    $effect(() => {
        tags = data.user.tags;
    })


</script>
<div>
    <p>#TODO page needs a fun background!!</p>
    <H1>{user.name}</H1>


    <div>
        <UserForm form_data={data.form} {tags}/>

    </div>

</div>

