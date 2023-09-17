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

 WITH block AS (SELECT Task FROM Checks
 WHERE Task LIKE '%' || 'C'|| '%')
 SELECT * FROM block

//8

//9

//10

//11

//12

//13

//14

//15

//16

//17