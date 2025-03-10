<script lang="ts">
    let {color, url} = $props();

    let default_color_class = "bg-transparent hover:bg-orange-500 text-teal-700 border-teal-500";
    let yellow_class = "bg-yellow-500 hover:bg-yellow-700 text-white border-yellow-500";
    let blue_class = "bg-blue-500 hover:bg-blue-700 text-white border-blue-500";
    let orange_class = "bg-orange-500 hover:bg-orange-700 text-white border-orange-500";


    let color_class = default_color_class;
    if (color === 'yellow') {
        color_class = yellow_class;
    }  else if (color === 'blue') {
        color_class = blue_class;
    } else if (color === 'orange') {
        color_class = orange_class;
    } else if (color !== null) {
        console.warn("missing LinkButton color " + color);
    }

</script>
<a href={url}>
<button class="{color_class} font-bold py-2 px-4 border rounded">
    <slot />
</button>
</a>