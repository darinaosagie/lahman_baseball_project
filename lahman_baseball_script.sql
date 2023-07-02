--Q1. Write a query that gives the first and last name of the player who got the most Hall of Fame Votes in 2017.
		SELECT playerid, namefirst, namelast, MAX(votes) as max_votes
		FROM people INNER JOIN halloffame USING(playerid)
		WHERE yearid = 2017
		AND category = 'Player'
		GROUP BY playerid
		ORDER By max_votes DESC0
		LIMIT 1;
--Q2. Write a query that gives the first and last name of the player that has had the most All-Star Game appearances.
 
		SELECT playerid, namefirst, namelast, COUNT(gamenum) as max_games
		FROM allstarfull INNER JOIN people USING(playerid)
		GROUP BY playerid, namefirst, namelast
		ORDER BY max_games DESC
		LIMIT 1;


--Q3. Write a query that gives the first and last name of the player who had All-Star Game
--appearances in the most different positions (Do not include Nulls).

		SELECT playerid, namefirst, namelast, COUNT(startingpos) as number_of_pos
		FROM allstarfull INNER JOIN people USING(playerid)
		WHERE startingpos IS NOT NULL
		GROUP BY playerid, namefirst, namelast
		ORDER BY number_of_pos DESC
		LIMIT 1;

--Q4. Pt A. First write a query that returns the total salary for each division winning team since 1990.
		SELECT teamid, salaries.yearid,SUM(salary)
		FROM salaries INNER JOIN teams USING (teamid)
		WHERE teams.yearid >1990 AND teams.divwin = 'Y'
		GROUP BY teamid, salaries.yearid, teams.lgid
		ORDER BY teamid, salaries.yearid ASC
--PT B. Then use this query as a CTE to see the average salary of the division winning teams by year, by league.
	with avg_salary_per_team AS 
					(SELECT teamid, salaries.yearid AS year_number, SUM(salary::numeric) AS sum_salary, teams.lgid AS league_id
					FROM salaries INNER JOIN teams USING (teamid)
					WHERE teams.yearid >1990 AND teams.divwin = 'Y'
					GROUP BY teamid, salaries.yearid, league_id
					ORDER BY teamid 
					)
			SELECT league_id, year_number, AVG(sum_salary)
			FROM avg_salary_per_team
			GROUP BY league_id, year_number
			ORDER BY league_id, year_number ASC
--Q5. Write a query that shows all the different teams that had a Middle Tennessee alumni make an appearance.		

		SELECT DISTINCT(teams.name)
		FROM schools INNER JOIN collegeplaying USING(schoolid)
					 INNER JOIN people USING (playerid)
					 INNER JOIN appearances USING (playerid)
					 INNER JOIN teams USING(teamid)
		WHERE schoolid = 'mtennst'

--Q6. What is the first and last name of the player who has had the highest salary out of all Middle Tennessee alumni who made an appearance?
		SELECT playerid, salaries.salary, people.namefirst, people.namelast 
		FROM schools INNER JOIN collegeplaying USING(schoolid)
					 INNER JOIN people USING (playerid)
					 INNER JOIN appearances USING (playerid)
					 INNER JOIN teams USING(teamid)
					 INNER JOIN salaries USING (playerid)
		WHERE schoolid = 'mtennst'
		GROUP BY playerid, people.namefirst, people.namelast, salaries.salary
		ORDER BY Salary DESC