<script lang="ts">
    import {friends_map} from "$lib/state/friends_map.svelte";
    import {rails_datetime_pretty} from "$lib/utils/dates.svelte";

    const {comment} = $props();
    const author = $derived(friends_map.friends_map[comment.user_id] ?? {});
</script>

<div class="flex justify-left">
    <article class="p-6 text-base bg-white rounded-lg dark:bg-gray-900">
        <div class="flex justify-between items-center mb-2">
            <div class="flex items-center">
                <p class="inline-flex items-center mr-3 text-sm text-gray-900 dark:text-white font-semibold">
                    {author.name}
                </p>
                <p class="text-sm text-gray-600 dark:text-gray-400">
                    {rails_datetime_pretty(comment.created_at)}
                </p>
            </div>
        </div>
        <div class="text-left">
            <p class="text-gray-500 dark:text-gray-400">
                {comment.body}
            </p>
        </div>
    </article>
</div>