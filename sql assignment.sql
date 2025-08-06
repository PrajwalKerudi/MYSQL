create database sql_assign_2025;
show databases;
use sql_assign_2025;

select * from fifa_players;

select count(*) from fifa_players;

select count(*) as total_records from fifa_players;

# How many players are there in the dataset?

select count(*) as total_players from fifa_players;

# How many nationalities do these players belong to?

select count(distinct nationality) as total_nationalities
from fifa_players;

# What is the total wage given to all players? What's the average and standard deviation?

select
sum(wage) as total_wage,
avg(wage) as avg_wage,
stddev(wage) as stddev_wage
from fifa_players;

# Which nationality has the highest number of players, what are the top 3 nationalities by # of players?

select nationality, count(*) as player_count
from fifa_players
group by nationality
order by player_count desc
limit 3;

# Which player has the highest wage? Who has the lowest?

select name, wage
from fifa_players
order by wage desc
limit 1;

select name, wage
from fifa_players
order by wage asc
limit 1;

# The player having the – best overall rating? Worst overall rating?

select name, overall
from fifa_players
order by overall desc
limit 1;

select name, overall
from fifa_players
order by overall asc
limit 1;

# Club having the highest total of overall rating? Highest Average of overall rating?

select club, sum(overall) as total_overall
from fifa_players
group by club
order by total_overall desc
limit 1;

select club, avg(overall) as avg_overall
from fifa_players
group by club
order by avg_overall desc
limit 1;

# What are the top 5 clubs based on the average ratings of their players and their corresponding averages?

select club, avg(overall) as avg_rating
from fifa_players
group by club
order by avg_rating desc 
limit 5;

# What is the distribution of players whose preferred foot is left vs right?

select preferred_foot, count(*) as preferred_foot
from fifa_players
group by preferred_foot;


# Which jersey number is the luckiest?

select jersey_number, count(*) as frequency
from fifa_players
group by jersey_number
order by frequency desc
limit 1;

# What is the frequency distribution of nationalities among players whose club name starts with M?

select nationality, count(*) as player_count
from fifa_players
where club like "M%"
group by nationality
order by player_count desc;

# How many players have joined their respective clubs in the date range 20 May 2018 to 10 April 2019 (both inclusive)?

select count(*) as players_joined
from fifa_players
where str_to_date(joined, '%d-%m-%Y') between '2018-5-20' and '2019-4-10';

# How many players have joined their respective clubs date wise?

select str_to_date(joined, '%d-%m-%Y') as join_date, count(*) as player_count
from fifa_players
group by join_date
order by join_date;

# How many players have joined their respective clubs yearly?

select year(str_to_date(joined, '%d-%m-%Y')) as join_year, count(*) as player_count
from fifa_players
group by join_year
order by join_year;
