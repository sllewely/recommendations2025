// Given a datetime from the backend,
// parse into a human-readable date
// input ex: 2025-03-19T23:59:00.000Z
// return obj { date_string:, time: }
import moment from "moment/moment";

export function readable_backend_date(raw_date: string) {
    let date_split = raw_date.split('-');
    let year = date_split[0];
    let month = date_split[1];
    let day_split = date_split[2].split('T');
    let day = day_split[0];
    let time_split = day_split[1].split(':');
    let hour = time_split[0];
    let minute = time_split[1];
    // TODO: time zone
    // TODO: am/pm

    return {
        date_string: month + '/' + day + '/' + year,
        time_string: hour + ':' + minute,
    }
}

export function rails_datetime_moment(raw_date: string) {
    return moment(raw_date, moment.ISO_8601);
}

export function rails_date_pretty(raw_date: string) {
    const moment_datetime = rails_datetime_moment(raw_date);
    return moment_datetime.format('MMM D, YYYY');
}

export function rails_datetime_pretty(raw_date: string) {
    const moment_datetime = rails_datetime_moment(raw_date);
    return moment_datetime.format('MMM D, YYYY h:mm:ss a');
}