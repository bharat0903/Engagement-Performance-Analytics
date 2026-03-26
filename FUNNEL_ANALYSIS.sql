WITH unified AS (
    SELECT
        u.user_id,
        u.signup_date,
        u.acquisition_source,
        u.city,
        g.course_viewed,
        g.demo_attended,
        e.enrollment_date,
        e.amount_paid
    FROM `26412.Users` u
    LEFT JOIN `26412.Engagement` g USING(user_id)
    LEFT JOIN `26412.Enrollments` e USING(user_id)
)

#Overall Funnel Metrics
SELECT
    COUNT(*) AS signups,
    SUM(CASE WHEN course_viewed = 1 THEN 1 END) AS course_viewed,
    SUM(CASE WHEN demo_attended = 1 THEN 1 END) AS demo_attended,
    SUM(CASE WHEN enrollment_date IS NOT NULL THEN 1 END) AS enrolled
FROM unified;

#Channel Wise Funnel Metrics
WITH unified AS (
    SELECT
        u.user_id,
        u.signup_date,
        u.acquisition_source,
        u.city,
        g.course_viewed,
        g.demo_attended,
        e.enrollment_date,
        e.amount_paid
    FROM `26412.Users` u
    LEFT JOIN `26412.Engagement` g USING(user_id)
    LEFT JOIN `26412.Enrollments` e USING(user_id)
)
SELECT
    acquisition_source,
    COUNT(*) AS signups,
    SUM(CASE WHEN course_viewed = 1 THEN 1 END) AS viewed,
    SUM(CASE WHEN demo_attended = 1 THEN 1 END) AS demo,
    SUM(CASE WHEN enrollment_date IS NOT NULL THEN 1 END) AS enrolled
FROM unified
GROUP BY acquisition_source
ORDER BY signups DESC;

#City Wise Funnel Metrics
WITH unified AS (
    SELECT
        u.user_id,
        u.signup_date,
        u.acquisition_source,
        u.city,
        g.course_viewed,
        g.demo_attended,
        e.enrollment_date,
        e.amount_paid
    FROM `26412.Users` u
    LEFT JOIN `26412.Engagement` g USING(user_id)
    LEFT JOIN `26412.Enrollments` e USING(user_id)
)
SELECT
    city,
    COUNT(*) AS signups,
    SUM(CASE WHEN course_viewed = 1 THEN 1 END) AS viewed,
    SUM(CASE WHEN demo_attended = 1 THEN 1 END) AS demo,
    SUM(CASE WHEN enrollment_date IS NOT NULL THEN 1 END) AS enrolled
FROM unified
GROUP BY city
ORDER BY signups DESC;

#Revenue Summary
SELECT
    SUM(amount_paid) AS total_revenue,
    ROUND(AVG(amount_paid),2) AS avg_revenue,
    COUNT(*) AS enrollments
FROM `26412.Enrollments`