// Common API response types
export interface ApiError {
	error?: string;
	exception?: string;
}

export interface ApiResponse<T = unknown> {
	success: boolean;
	res?: T;
	message?: string;
}

export interface PostsResponse {
	feed_items: Feedable[];
	pagy: unknown;
}

export interface Feedable {
	id: string;
	created_at: string;
	feedable: Post | Event | Recommendation;
	class_name: string;
}

export interface Post {
	id: string;
	created_at: string;
	updated_at: string;
	user: User;
	comments: Comment[];
	title: string;
	content?: string;
	class_name: string;
}

export interface Comment {
	id: number;
	created_at: string;
	updated_at: string;
	commentable_id: number;
	user_id: number;
	body: string;
}

// TODO: Theres a zod schema for this, can derive it from the schema
export interface UserUpdatePayload {
	name: string;
	blurb: string;
	tags: string[];
	email: string;
	password: string;
}

export interface User {
	id: string;
	username: string;
	name: string;
	tags: string[];
	string_tags?: string;
	blurb: string;
	presigned_url: string;
}

export interface Event {
	id: string;
	created_at: string;
	updated_at: string;
	title: string;
	description: string;
	start_date_time: string;
	address: string;
	url: string;
	event_type: string;
	user_id: number;
	end_date_time: Date;
	is_public: boolean;
	user: User;
	class_name: string;
	rsvps_count: number;
	comments: Comment[];
	rsvps: Rsvp[];
}

export interface Rsvp {
	id: string;
	created_at: string;
	updated_at: string;
	event_id: string;
	user_id: string;
	status: string;
	user: User;
}

export type EventWithDateHeader =
	| { date_header: string }
	| (Event & { time_string: string; date_header?: string });

export interface Recommendation {
	id: string;
	class_name: string;
	user: User;
	user_id: string;
	title: string;
	media_type: string;
	url: string;
	status: string;
	who_recommended: string;
	rating: number;
	notes: string;
	created_at: string;
	updated_at: string;
	comments: Comment[];
}

export type NotifTypes =
	| "pending_friend_request"
	| "accepted_friend_request"
	| "created_a_feedable";

export interface Notification {
	id: number;
	uuid: string;
	active: boolean;
	user_id: string;
	notif_type: NotifTypes;
	message: string;
	extras: NotificationExtras;
	created_at: string;
}

export interface NotificationExtras {
	user_id?: string;
	post_id?: string;
	event_id?: string;
	recommendation_id?: string;
}

export type PendingFriendRequest = {
	id: string;
	user: User;
	incoming_friend: User;
	message: string;
};

export type CreateRecommendationData = unknown;

export type FriendStatus =
	| "pending_friend_request"
	| "friends"
	| "sent_friend_request"
	| "none"
	| "self";

// key is a user uuid.  If missing, status is "none".
export type FriendsMap = Map<string, FriendStatus>;
