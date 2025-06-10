import aws from "aws-sdk";
import { S3_ACCESS_KEY_ID, S3_SECRET_ACCESS_KEY } from "$env/static/private";

const region = "us-east-2";
const bucketName = "bb-profile-image-dev";

// Don't commit
const accessKeyId = S3_ACCESS_KEY_ID;
const secretAccessKey = S3_SECRET_ACCESS_KEY;

const s3 = new aws.S3({
	region,
	accessKeyId,
	secretAccessKey,
});

export async function generateUploadURL() {
	// const rawBytes = await randomBytes(16);
	const imageName = "test123";

	const params = {
		Bucket: bucketName,
		Key: imageName,
		Expires: 36000,
	};

	const uploadURL = await s3.getSignedUrlPromise("putObject", params);
	return uploadURL;
}
