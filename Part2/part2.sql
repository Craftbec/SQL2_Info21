-- 1

CREATE OR REPLACE PROCEDURE AddP2PCheck(Peer1 varchar, Peer2 varchar, Task varchar, Status Status, tmp time)
language plpgsql
AS $$
BEGIN
  INSERT INTO Checks(id, Peer, Task, "Date") VALUES ((SELECT MAX(ID) FROM Checks)+1,Peer1, Task, current_date);
  INSERT INTO P2P ("Check", CheckingPeer, "State", "Time") VALUES ((SELECT MAX(ID) FROM Checks), Peer2, 'Start',  tmp);
    IF Status != 'Start' THEN
	INSERT INTO P2P ("Check", CheckingPeer, "State", "Time") VALUES ((SELECT MAX(ID) FROM Checks), Peer2, Status,  tmp);
 END IF;
END;
$$;

SELECT Checks.peer, P2P.checkingpeer, Checks.task, P2P."State", P2P."Time" FROM P2P
JOIN Checks
ON Checks.id = P2P."Check"
ORDER BY Checks.peer;

CALL ADDP2PCheck ('oneudata', 'melodigr', 'C2_SimpleBash', 'Success', '17:15:15');
CALL AddP2PCheck ('ainorval', 'melodigr', 'C2_SimpleBash', 'Start', '15:15:15');
CALL AddP2PCheck ('elmersha', 'onrtyef', 'C5_s21_decimal', 'Failure', '15:15:15');


-- 2

CREATE OR REPLACE PROCEDURE AddVerterCheck(Pr varchar, Ts varchar, St Status, tmp time)
language plpgsql
AS $$
DECLARE
  id_check integer;
BEGIN
id_check = (SELECT Checks.id FROM Checks
JOIN P2P
ON Checks.id= P2p."Check"
WHERE Checks.task = Ts AND P2P."State" = 'Success' AND Checks.peer = Pr
ORDER BY "Date" DESC
LIMIT 1);
 IF id_check IS NOT NULL
 THEN
  INSERT INTO Verter ("Check",  "State", "Time") VALUES (id_check, 'Start',  tmp);
  IF St != 'Start' THEN
  INSERT INTO Verter ("Check",  "State", "Time") VALUES (id_check, St,  tmp);
  END IF;
 END IF;
END;
$$;

SELECT Checks.peer, Checks.task, Verter."State", Verter."Time" FROM Verter
JOIN Checks
ON Verter."Check" = Checks.id
ORDER BY Checks.peer;

CALL AddVerterCheck ('oneudata', 'C2_SimpleBash', 'Success', '18:18:18');
CALL AddVerterCheck ('oneudata', 'C4_s21_math', 'Success', '18:18:18');

-- 3

CREATE OR REPLACE FUNCTION P2PUpdatePoints()
RETURNS TRIGGER AS $$
DECLARE
peer varchar;
idt integer;
BEGIN
IF NEW."State"='Start'
THEN
peer = (SELECT Checks.peer FROM P2P
JOIN Checks
ON P2P."Check"=Checks.id
WHERE Checks.id= NEW."Check");
idt = (SELECT TransferredPoints.id FROM TransferredPoints WHERE checkingpeer = NEW.checkingpeer AND checkedpeer = peer);
IF idt IS NOT NULL
 THEN
 UPDATE TransferredPoints SET PointsAmount= PointsAmount+1 WHERE id = idt;
 ELSE
 INSERT INTO TransferredPoints(CheckingPeer, CheckedPeer, PointsAmount) VALUES (NEW.checkingpeer,peer,  '1');
END IF;
RETURN NEW;
END IF;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trg_P2PUpdatePoints
AFTER INSERT ON P2P
FOR EACH ROW
EXECUTE FUNCTION P2PUpdatePoints();


SELECT * FROM  TransferredPoints;
INSERT INTO Checks(ID, Peer, Task, "Date") VALUES ('30','kathayr', 'C2_SimpleBash', '2023-09-17');
INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES (30, 'floridas',  'Start', '13:46:15');
INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES (30, 'floridas',  'Failure', '13:46:15');
INSERT INTO Checks(ID, Peer, Task, "Date") VALUES ('31','kathayr', 'C2_SimpleBash', '2023-09-18');
INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES (31, 'floridas',  'Start', '18:18:18');


-- 4

CREATE OR REPLACE FUNCTION ValidXP()
RETURNS TRIGGER AS $$
DECLARE
st status;
xpmap integer;
BEGIN
st = (SELECT P2P."State" FROM P2P
WHERE P2P."Check"=NEW."Check"
ORDER BY P2P.id DESC
LIMIT 1);
IF st = 'Success'
THEN
xpmap = (SELECT Tasks.maxxp FROM  Tasks
JOIN Checks
ON Tasks.title = Checks.task
WHERE id = NEW."Check");
IF xpmap>=NEW.xpamount
THEN
RETURN NEW;
ELSE
RETURN OLD;
END IF;
END IF;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trg_ValidXP
  BEFORE INSERT ON XP FOR EACH ROW
  EXECUTE FUNCTION ValidXP();


SELECT * FROM  XP;
INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES (31, 'floridas',  'Success', '13:46:15');
INSERT INTO XP("Check", XPAmount) VALUES (30, 150);
INSERT INTO XP("Check", XPAmount) VALUES (31, 1000);
INSERT INTO XP("Check", XPAmount) VALUES (31, 250);


