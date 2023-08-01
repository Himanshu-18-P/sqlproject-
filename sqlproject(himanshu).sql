
-- QNS 1 :  Create an ER diagram or draw a schema for the given database

-- QNS 2 : We want to reward the user who has been around the longest, Find the 5 oldest users

select username , 
timestampdiff(day , created_at , now()) as number_of_days_join 
 from users order by number_of_days_join desc limit 5 
 ;
 
 -- QNS 3 : To target inactive users in an email ad campaign, find the users who have never posted a photo
 
 select id , username from users
 where id not in 
 (select distinct user_id from photos) ;
 
 
 -- QNS 4 :Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?
 with cte as 
 (select p.user_id , photo_id , count(*)  as total_like 
 from likes  as l join photos as p on l.photo_id = p.id
 group by photo_id , user_id
 order by total_like desc limit 1  )  
 
 select id as winner_id , username as winner_of_contest  from users 
 where id in (select user_id from cte ) ;

-- QNS 5 : The investors want to know how many times does the average user post
 
 select round(count(*)/(select count( distinct user_id) from photos ),2) 
 as avg_user_post 
 from photos ;
 
 
 -- QNS 6  : A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags
 
 with cte as 
 (select tag_id , count(*) as number_of_tag 
 from photo_tags 
 group by tag_id 
 order by number_of_tag  desc limit 5)  
 
 select   row_number() over() as tag_rank ,  tag_name 
 from tags where id in  (select tag_id from cte ) ;
 
 
 -- QNS 7 : To find out if there are bots, find users who have liked every single photo on the site
with cte as ( 
select user_id from likes 
group by user_id having count(*) = 
(select count(*) as total_photo from photos) ) 

select id , username  as bots 
from users where id in (select user_id from cte )  ;


-- QNS 8 : Find the users who have created instagramid in may and select top 5 newest joinees from it
select  username ,  created_at 
from users where  monthname(created_at) = 'May' 
order by created_at desc limit 5  ;

-- QNS 9 : Can you help me find the users whose name starts with c and ends with any number and have posted the photos as well as liked the photos?

with cte as (
select a.user_id from 
(select distinct user_id from photos) as a 
join 
(select distinct user_id from likes ) as b
on a.user_id = b.user_id)

select id , username 
from users where username regexp '^[c].*[0-9]$' 
and id in  (select user_id from cte ) ;

-- QNS 10 : Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5

with cte as 
(select  user_id , count(*) num_of_photo from photos 
group by user_id 
having count(*) between 3 and 5 
order by count(*) desc 
limit 30)

select id , username from 
users where id in (select user_id from cte ) ;


-- thank you :) -- 




 
 