<script lang="ts">
    /* Toggle Button
    * Used for selecting one of multiple

     */

    let {color, selected} = $props();

    // TODO: turn into color consts

    let default_color_class = "bg-white hover:bg-orange-200 text-teal-700 border-teal-500";
    let default_color_selected_class = "bg-teal-700 text-white border-teal-500";
    let yellow_class = "bg-yellow-200 hover:bg-yellow-500 text-black border-yellow-500";
    let yellow_selected_class = "bg-yellow-500 text-black border-yellow-500";
    let blue_class = "bg-blue-200 hover:bg-blue-500 text-black border-blue-500";
    let blue_selected_class = "bg-blue-500 text-black border-blue-500";
    let orange_class = "bg-orange-200 hover:bg-orange-500 text-black border-orange-500";
    let orange_selected_class = "bg-orange-500 text-black border-orange-500";


    let color_class = default_color_class;
    let color_selected_class = default_color_selected_class;
    if (color === 'yellow') {
        color_class = yellow_class;
        color_selected_class = yellow_selected_class;
    }  else if (color === 'blue') {
        color_class = blue_class;
        color_selected_class = blue_selected_class
    } else if (color === 'orange') {
        color_class = orange_class;
        color_selected_class = orange_selected_class;
    } else if (color !== null) {
        console.warn("missing LinkButton color " + color);
    }

</script>
    <button type="button" class="{selected ? color_selected_class : color_class} font-bold py-2 px-4 border rounded">
        <slot />
    </button>