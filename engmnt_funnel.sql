# TOTAL FUNNEL
WITH 
imps AS (
  SELECT DISTINCT user_id
  FROM `engmnt.video_impressions`
),
eng AS (
  SELECT DISTINCT user_id
  FROM `engmnt.video_engagements`
)

SELECT
  (SELECT COUNT(*) FROM `engmnt.users`) AS total_users,
  (SELECT COUNT(*) FROM imps) AS users_with_impressions,
  (SELECT COUNT(*) FROM eng) AS users_with_engagements,

  SAFE_DIVIDE((SELECT COUNT(*) FROM imps),
              (SELECT COUNT(*) FROM `engmnt.users`)) AS user_to_impression_rate,

  SAFE_DIVIDE((SELECT COUNT(*) FROM eng),
              (SELECT COUNT(*) FROM imps)) AS impression_to_engagement_rate;

# REGIONAL FUNNEL
WITH 
i AS (
  SELECT DISTINCT user_id
  FROM `engmnt.video_impressions`
),
e AS (
  SELECT DISTINCT user_id
  FROM `engmnt.video_engagements`
)

SELECT 
  u.region,
  COUNT(DISTINCT u.user_id) AS total_users,
  COUNT(DISTINCT i.user_id) AS users_with_impressions,
  COUNT(DISTINCT e.user_id) AS users_with_engagements,

  SAFE_DIVIDE(COUNT(DISTINCT i.user_id), COUNT(DISTINCT u.user_id)) AS user_to_impression_rate,
  SAFE_DIVIDE(COUNT(DISTINCT e.user_id), COUNT(DISTINCT i.user_id)) AS impression_to_engagement_rate

FROM `engmnt.users` u
LEFT JOIN i USING(user_id)
LEFT JOIN e USING(user_id)
GROUP BY region
ORDER BY total_users DESC;

# CREATOR CATEGORY FUNNEL
WITH 
imp AS (
  SELECT video_id, COUNT(*) AS impressions
  FROM `engmnt.video_impressions`
  GROUP BY video_id
),
eng AS (
  SELECT video_id, COUNT(*) AS engagements
  FROM `engmnt.video_engagements`
  GROUP BY video_id
)

SELECT
  v.video_id,
  v.creator_id,
  c.creator_category,
  v.category AS video_category,
  i.impressions,
  e.engagements,
  SAFE_DIVIDE(e.engagements, i.impressions) AS engagement_rate
FROM `engmnt.videos` v
LEFT JOIN imp i USING(video_id)
LEFT JOIN eng e USING(video_id)
LEFT JOIN `engmnt.creators` c USING(creator_id)
ORDER BY engagement_rate DESC;

# VIDEO LEVEL FUNNEL
WITH 
imp AS (
  SELECT video_id, COUNT(*) AS impressions
  FROM `engmnt.video_impressions`
  GROUP BY video_id
),
eng AS (
  SELECT video_id, COUNT(*) AS engagements
  FROM `engmnt.video_engagements`
  GROUP BY video_id
)

SELECT
  v.video_id,
  v.creator_id,
  c.creator_category,
  v.category AS video_category,
  i.impressions,
  e.engagements,
  SAFE_DIVIDE(e.engagements, i.impressions) AS engagement_rate
FROM `engmnt.videos` v
LEFT JOIN imp i USING(video_id)
LEFT JOIN eng e USING(video_id)
LEFT JOIN `engmnt.creators` c USING(creator_id)
ORDER BY engagement_rate DESC;

#REGION–WISE ENGAGEMENT QUALITY
SELECT
  u.region,
  AVG(ve.watch_time_sec) AS avg_watch_time,
  SUM(ve.liked) AS likes,
  SUM(ve.shared) AS shares,
  SUM(ve.commented) AS comments
FROM `engmnt.video_engagements` ve
JOIN `engmnt.users` u USING(user_id)
GROUP BY u.region
ORDER BY avg_watch_time DESC;