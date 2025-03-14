<script>
    let { date_value, time_value } = $props();
    // let default_date = date_value ?? (new Date(new Date().getTime() + 24 * 60 * 60 * 1000));
    // let input_date_value = 'Y-m-d'.replace('Y', default_date.getFullYear())
    //     .replace('m', default_date.getMonth()+1)
    //     .replace('d', default_date.getDate());


</script>
<div class="mb-5">
    <div class="flex flex-row">
    <div>
    <label for="date_input" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Date
        <input
                type="date"
                name="date_input"
                id="date_input"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                value={date_value}
                required
        />
    </label>
        </div>
        <div>
            <label for="time_input" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Time
                <input
                        type="time"
                        name="time_input"
                        id="time_input"
                        class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                        value={time_value}
                        required
                />
            </label>
        </div>
    </div>

</div>