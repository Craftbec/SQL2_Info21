//1

CREATE OR REPLACE FUNCTION FncTransferredPoints()
RETURNS  TABLE(Peer1 VARCHAR, Peer2 VARCHAR, "PointsAmount" BIGINT) AS $$
BEGIN
RETURN QUERY
SELECT CheckingPeer, CheckedPeer, SUM(PointsAmount) FROM (
SELECT CheckingPeer, CheckedPeer, PointsAmount
      FROM TransferredPoints WHERE CheckingPeer < CheckedPeer
UNION	    
SELECT CheckedPeer, CheckingPeer, -PointsAmount
      FROM TransferredPoints WHERE CheckedPeer < CheckingPeer	) AS TMP
 GROUP BY CheckingPeer, CheckedPeer;

END;
$$ LANGUAGE plpgsql;


SELECT * FROM TransferredPoints();

//2

CREATE OR REPLACE FUNCTION FncPeerTaskXP()
RETURNS  TABLE(Peer VARCHAR, Task VARCHAR, XP BIGINT) AS $$
BEGIN
RETURN QUERY
SELECT P2P.checkingpeer AS peer, Checks.task, XP.xpamount AS XP FROM  Checks
JOIN P2P
ON Checks.id = P2P."Check"
JOIN XP
ON XP."Check"=P2P."Check"
WHERE P2P."State" = 'Success';
END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncPeerTaskXP();

//3

CREATE OR REPLACE FUNCTION FncAllday(allday Date DEFAULT CURRENT_DATE)
RETURNS  TABLE("Peer" VARCHAR) AS $$
BEGIN
RETURN QUERY
SELECT peer FROM (
SELECT peer, COUNT("State") FROM (
SELECT peer, "State" FROM  TimeTracking AS tmp
WHERE tmp."Date" = allday AND tmp."State" = '1'
UNION
SELECT peer, "State" FROM  TimeTracking AS tmp2
WHERE tmp2."Date" = allday AND tmp2."State" = '2') AS res
GROUP BY peer
) as ok
where count = 1;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncAllday('2023-09-01')

//4

CREATE OR REPLACE FUNCTION FncPeerPoint()
RETURNS  TABLE("Peer" VARCHAR, PointsChange NUMERIC) AS $$
BEGIN
RETURN QUERY
SELECT peer, SUM (n) AS PointsChange FROM (
SELECT TransferredPoints.checkingpeer AS peer, SUM(pointsamount) AS n FROM  TransferredPoints
GROUP by checkingpeer
UNION
SELECT TransferredPoints.checkedpeer AS peer, -SUM(pointsamount) AS n FROM  TransferredPoints
GROUP by checkedpeer) AS res 
GROUP by peer
ORDER BY PointsChange DESC;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncPeerPoint();

//5

CREATE OR REPLACE FUNCTION FncPeerPoint2()
RETURNS  TABLE("Peer" VARCHAR, PointsChange NUMERIC) AS $$
BEGIN
RETURN QUERY
SELECT peer, SUM (n) AS PointsChange FROM (
SELECT FncTransferredPoints.peer1 AS peer, SUM(FncTransferredPoints."PointsAmount") AS n FROM  FncTransferredPoints()
GROUP by peer
UNION
SELECT FncTransferredPoints.peer2 AS peer, -SUM(FncTransferredPoints."PointsAmount") AS n FROM  FncTransferredPoints()
GROUP by peer) AS res 
GROUP by peer
ORDER BY PointsChange DESC;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncPeerPoint2();

//6

CREATE OR REPLACE FUNCTION FncMostTask()
RETURNS  TABLE("Day" DATE, "Task" VARCHAR) AS $$
BEGIN
RETURN QUERY
SELECT "Date", Task
	FROM (
		SELECT *, 
		ROW_NUMBER() OVER (PARTITION BY "Date" ORDER BY counn DESC) AS mor
		FROM(
			SELECT "Date", Task, COUNT(*) AS counn
			FROM Checks
			GROUP BY "Date", Task
		) AS tmp
	)AS tt
	WHERE mor = 1;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncMostTask();

//7
INSERT INTO Checks(ID, Peer, Task, "Date") VALUES
('41','floridas', 'C6_s21_matrix', '2023-09-11'),
('42','floridas', 'C7_SmartCalc_v1.0', '2023-09-12'),
('43','floridas', 'C8_3DViewer_v1.0', '2023-09-12');


INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(41, 'ainorval',  'Success', '10:30:15'), 
(42, 'melodigr',  'Success', '11:23:15'), 
(43, 'onrtyef',  'Success', '18:12:34');


INSERT INTO Verter("Check", "State", "Time") VALUES
(41, 'Start', '11:30:34'), 
(42, 'Start', '14:30:23'), 
(43, 'Start', '15:30:54'), 
(41, 'Success', '11:32:13'), 
(42, 'Success', '14:45:25'), 
(43, 'Success', '15:56:15');





 WITH block AS (SELECT Task FROM Checks
 WHERE Task LIKE '%' || 'C'|| '%')
 SELECT * FROM block

//8

INSERT INTO Recommendations(Peer, RecommendedPeer) VALUES
('morrisro', 'oneudata');

CREATE OR REPLACE FUNCTION FncCheckRecommendation()
RETURNS  TABLE("Peer" VARCHAR, "RecommendedPeer" VARCHAR) AS $$
BEGIN
RETURN QUERY
	WITH tmp AS (
		SELECT Peer, RecommendedPeer, COUNT(RecommendedPeer) AS recoms
		FROM Recommendations
		GROUP BY Peer, RecommendedPeer
	),
	tmpcount AS (
		SELECT tmp.RecommendedPeer, COUNT(tmp.RecommendedPeer) AS coun, Friends.Peer1 AS Peer
		FROM tmp
		LEFT JOIN Friends ON tmp.Peer = Friends.Peer2
		WHERE Friends.Peer1 != tmp.RecommendedPeer
		GROUP BY tmp.RecommendedPeer, tmp.Peer,Friends.Peer1
	),
	res AS (
		SELECT tmpcount.Peer, tmpcount.RecommendedPeer, coun, 
			ROW_NUMBER() OVER (PARTITION BY tmpcount.Peer ORDER BY COUNT(*) DESC) AS rank
		FROM tmpcount
		WHERE coun = (SELECT MAX(coun) 
						FROM tmpcount) AND tmpcount.Peer != tmpcount.RecommendedPeer
		GROUP BY tmpcount.Peer, tmpcount.RecommendedPeer, coun
		ORDER BY tmpcount.Peer ASC
	)
	SELECT Peer, RecommendedPeer
	FROM res
	WHERE rank = 1;
	END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncCheckRecommendation();


//9




//10

INSERT INTO Checks(ID, Peer, Task, "Date") VALUES
('50','elmersha', 'C2_SimpleBash', '2023-03-26');


INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(50, 'ainorval',  'Start', '12:35:15');
INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(50, 'ainorval',  'Success', '12:36:25');



INSERT INTO Verter("Check", "State", "Time") VALUES
(50, 'Start', '12:35:35');
INSERT INTO Verter("Check", "State", "Time") VALUES
(50, 'Success', '12:46:48');


CREATE OR REPLACE FUNCTION FncCheckBirthday()
RETURNS  TABLE(SuccessfulChecks BIGINT, UnsuccessfulChecks BIGINT) AS $$
BEGIN
RETURN QUERY
WITH 
Yess AS (
SELECT COUNT(*) AS amount FROM  Peers
JOIN (
SELECT peer, "Date", P2P."State" FROM Checks
JOIN P2P
ON Checks.id = P2P."Check"
JOIN Verter
ON Checks.id = Verter."Check"
WHERE (Verter."State" = 'Success' OR Verter."State" IS NULL) AND P2P."State" = 'Success')  AS tmp
ON Peers.nickname = tmp.peer AND EXTRACT(MONTH FROM tmp."Date") = EXTRACT(MONTH FROM Peers.Birthday) AND
 EXTRACT(DAY FROM tmp."Date") = EXTRACT(DAY FROM Peers.Birthday)),
Noo AS (
SELECT COUNT(*) AS amount FROM  Peers
JOIN (
SELECT peer, "Date", P2P."State" FROM Checks
JOIN P2P
ON Checks.id = P2P."Check"
JOIN Verter
ON Checks.id = Verter."Check"
WHERE (Verter."State" = 'Failure' OR Verter."State" IS NULL) AND P2P."State" = 'Failure')  AS tmp
ON Peers.nickname = tmp.peer AND EXTRACT(MONTH FROM tmp."Date") = EXTRACT(MONTH FROM Peers.Birthday) AND
EXTRACT(DAY FROM tmp."Date") = EXTRACT(DAY FROM Peers.Birthday)),
total AS (SELECT COALESCE(Yess.amount, 0) + COALESCE((SELECT amount FROM Noo), 0) AS amount FROM Yess)
SELECT (COALESCE((ps.amount::FLOAT), 0)/(SELECT amount FROM total)*100)::BIGINT, (COALESCE((SELECT amount FROM Noo)::FLOAT, 0)/(SELECT amount FROM total)*100)::BIGINT
FROM Yess AS ps;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncCheckBirthday();


//11


INSERT INTO Checks(ID, Peer, Task, "Date") VALUES
('51','lorettec', 'C3_s21_string+', '2023-03-26');


INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(51, 'ainorval',  'Start', '12:35:15');
INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(51, 'ainorval',  'Success', '12:36:25');



INSERT INTO Verter("Check", "State", "Time") VALUES
(51, 'Start', '12:35:35');
INSERT INTO Verter("Check", "State", "Time") VALUES
(51, 'Success', '12:46:48');



INSERT INTO Checks(ID, Peer, Task, "Date") VALUES
('52','mjollor', 'C3_s21_string+', '2023-03-26');


INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(52, 'ainorval',  'Start', '12:35:15');
INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(52, 'ainorval',  'Success', '12:36:25');



INSERT INTO Verter("Check", "State", "Time") VALUES
(52, 'Start', '12:35:35');
INSERT INTO Verter("Check", "State", "Time") VALUES
(52, 'Success', '12:46:48');




INSERT INTO Checks(ID, Peer, Task, "Date") VALUES
('53','mjollor', 'C7_SmartCalc_v1.0', '2023-03-28');


INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(53, 'ainorval',  'Start', '12:35:15');
INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(53, 'ainorval',  'Success', '12:36:25');



INSERT INTO Verter("Check", "State", "Time") VALUES
(53, 'Start', '12:35:35');
INSERT INTO Verter("Check", "State", "Time") VALUES
(53, 'Success', '12:46:48');


CREATE OR REPLACE FUNCTION FncPeersSuccess(ts VARCHAR)
RETURNS TABLE(Peer VARCHAR) AS $$
BEGIN
RETURN QUERY
SELECT Checks.peer FROM Checks
JOIN P2P
ON Checks.id = P2P."Check"
JOIN Verter
ON Checks.id = Verter."Check"
WHERE Checks.task =ts AND P2P."State"='Success' AND Verter."State"='Success';
END;
$$ LANGUAGE plpgsql;
 



CREATE OR REPLACE FUNCTION FncPeersGivenTask(Task1 VARCHAR, Task2 VARCHAR, Task3 VARCHAR)
RETURNS TABLE( Peer VARCHAR) AS $$
BEGIN
RETURN QUERY
SELECT * FROM FncPeersSuccess(Task1)
INTERSECT
SELECT * FROM FncPeersSuccess(Task2)
EXCEPT
SELECT * FROM FncPeersSuccess(Task3);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM FncPeersGivenTask('C2_SimpleBash','C3_s21_string+', 'C7_SmartCalc_v1.0');

//12

CREATE OR REPLACE FUNCTION FncRecursive()
RETURNS TABLE(Task VARCHAR, PrevCount INTEGER) AS $$
BEGIN
RETURN QUERY
	WITH RECURSIVE tmp AS (
		SELECT Title, 0 AS Prev
		FROM Tasks
		WHERE ParentTask IS NULL
		UNION ALL
		SELECT t.Title, tmp.Prev + 1
		FROM Tasks AS t
		INNER JOIN tmp ON t.ParentTask = tmp.Title
	)
	SELECT Title AS Task, Prev
	FROM tmp;
END;
  $$ LANGUAGE plpgsql;
  
 SELECT * FROM  FncRecursive();


//13

//14
INSERT INTO XP("Check", XPAmount) VALUES
(41, 50),
(42, 100),
(43, 150),
(50, 200),
(51, 170),
(52, 160),
(53, 175);

CREATE OR REPLACE FUNCTION FncPeerMostXP()
RETURNS  TABLE(Peer VARCHAR, XP NUMERIC) AS $$
BEGIN
RETURN QUERY
SELECT Checks.peer, SUM(XP.xpamount) AS ssum FROM Checks
JOIN P2P
ON Checks.id = P2P."Check"
JOIN Verter
ON Checks.id = Verter."Check"
JOIN XP
ON Checks.id = XP."Check"
WHERE P2P."State"='Success' AND Verter."State"='Success'
GROUP BY Checks.peer
ORDER BY ssum DESC
LIMIT 1;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncPeerMostXP();

//15
INSERT INTO TimeTracking(Peer, "Date", "Time", "State") VALUES
('omarval', '2023-09-20', TIME '11:15:22', '1'),
('omarval', '2023-09-20', TIME '16:18:14', '2');

CREATE OR REPLACE FUNCTION FncBeforeTime(Tim TIME, N INTEGER)
RETURNS  TABLE("Peer" VARCHAR) AS $$
BEGIN
RETURN QUERY
SELECT peer FROM  TimeTracking
WHERE "State" = '1' AND "Time"<Tim
GROUP BY peer
HAVING COUNT(*) >= N;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncBeforeTime('12:00:00', 2);


//16

CREATE OR REPLACE FUNCTION FncPeerLeftCampus(N INTEGER, Mm INTEGER)
RETURNS  TABLE("Peer" VARCHAR) AS $$
BEGIN
RETURN QUERY
SELECT peer FROM  TimeTracking
WHERE "State"='2' AND "Date" > (CURRENT_DATE - N)
GROUP BY peer
HAVING COUNT(*) >= Mm;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncPeerLeftCampus(19, 2);

//17

INSERT INTO TimeTracking(Peer, "Date", "Time", "State") VALUES
('ainorval', '2023-01-20', TIME '11:15:22', '1'),
('ainorval', '2023-01-20', TIME '16:18:14', '2'),
('ainorval', '2023-01-25', TIME '15:15:22', '1'),
('ainorval', '2023-01-25', TIME '16:18:14', '2'),
('ainorval', '2023-01-29', TIME '07:15:22', '1'),
('ainorval', '2023-01-29', TIME '16:18:14', '2'),
('itchyole', '2023-04-02', TIME '07:15:22', '1'),
('itchyole', '2023-04-02', TIME '16:18:14', '2'),
('itchyole', '2023-04-03', TIME '07:15:22', '1'),
('itchyole', '2023-04-03', TIME '16:18:14', '2'),
('itchyole', '2023-04-04', TIME '07:15:22', '1'),
('itchyole', '2023-04-04', TIME '16:18:14', '2'),
('itchyole', '2023-04-05', TIME '07:15:22', '1'),
('itchyole', '2023-04-05', TIME '16:18:14', '2'),
('onrtyef', '2023-05-05', TIME '16:15:22', '1'),
('onrtyef', '2023-05-05', TIME '16:18:14', '2'),
('onrtyef', '2023-05-05', TIME '18:15:22', '1'),
('onrtyef', '2023-05-05', TIME '19:18:14', '2');



CREATE OR REPLACE FUNCTION FncEarlyEntries()
RETURNS  TABLE( "Month" TEXT, EarlyEntries NUMERIC) AS $$
BEGIN
RETURN QUERY
WITH 
    tmp AS (SELECT "Time", EXTRACT(MONTH FROM Peers.Birthday) AS mon
      FROM TimeTracking
	JOIN Peers
ON TimeTracking.peer=Peers.nickname		
      WHERE EXTRACT(MONTH FROM TimeTracking."Date") = EXTRACT(MONTH FROM Peers.birthday) AND TimeTracking."State" = '1'),
    early AS (SELECT mon, COUNT("Time") AS ale
      FROM tmp
	WHERE "Time" < '12:00'
      GROUP BY mon), 
	  total AS (
	 SELECT mon, COUNT("Time") AS al
      FROM tmp
      GROUP BY mon
	  )
	 SELECT  to_char(make_date(2000, CAST(total.mon as integer), 1), 'Month'),
	  ROUND(COALESCE(early.ale * 100.0 / total.al, 0))
	 FROM total
	 LEFT JOIN early
	 ON total.mon = early.mon
	   ORDER BY total.mon; 
END;
$$ LANGUAGE plpgsql;


SELECT * FROM FncEarlyEntries();