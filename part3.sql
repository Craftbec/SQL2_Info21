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
WITH
res AS (SELECT "Date" AS D , task, COUNT(task) AS  countt FROM  Checks
GROUP BY D, task)
SELECT res.D, task FROM res
JOIN  ( SELECT D, MAX(countt) AS Mcount from res GROUP BY res.D) AS tmp
ON res.D=tmp.D AND res.countt = tmp.Mcount
ORDER BY D, task;
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


CREATE OR REPLACE FUNCTION FncPeersSuccess(ts VARCHAR)
RETURNS TABLE(Task1 VARCHAR, Task2 VARCHAR, Task3 VARCHAR) AS $$
BEGIN
RETURN QUERY
SELECT * FROM FncPeersSuccess('C2_SimpleBash')
SELECT * FROM FncPeersSuccess('C6_s21_matrix')

SELECT * FROM FncPeersSuccess('C4_s21_math')
END;
$$ LANGUAGE plpgsql;

SELECT * FROM FncPeersSuccess('C7_SmartCalc_v1.0')

//12

//13

//14

//15

//16

//17