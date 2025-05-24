<script>
	// idk if this is how I want to solve this.

	import { TTextSize } from "./textSizeType.js";
	let { size: TTextSizeType } = $props;

	let sizeClasses = {
		[TTextSizeType.h1]: "",
	};

	let size_class = sizeClasses[size];
</script>
