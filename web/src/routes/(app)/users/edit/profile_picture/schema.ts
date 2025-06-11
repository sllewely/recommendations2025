import { z } from "zod";

const MAX_FILE_SIZE = 5000000;
const ACCEPTED_IMAGE_TYPES = ["image/jpeg", "image/jpg", "image/png", "image/webp"];

// export const IMAGE_SCHEMA = z
// 	.any()
// 	.refine(
// 		(file) =>
// 			["image/png", "image/jpeg", "image/jpg", "image/svg+xml", "image/gif"].includes(file.type),
// 		{ message: "Invalid image file type" },
// 	);

export const imageFormSchema = z.object({
	image: z
		.any()
		.refine((file) => file?.size <= MAX_FILE_SIZE, `Max image size is 5MB.`)
		.refine(
			(file) => ACCEPTED_IMAGE_TYPES.includes(file?.type),
			"Only .jpg, .jpeg, .png and .webp formats are supported.",
		),
});

export type ImageSchema = typeof imageFormSchema;
