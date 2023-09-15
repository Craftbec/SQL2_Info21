SELECT * FROM  Peers;
SELECT * FROM  Tasks;
SELECT * FROM  P2P;
SELECT * FROM  Checks;
SELECT * FROM  TransferredPoints;
SELECT * FROM  Friends;
SELECT * FROM  Recommendations;
SELECT * FROM  XP;
SELECT * FROM  TimeTracking;
SELECT * FROM  Verter;


//1

CREATE OR REPLACE PROCEDURE AddP2PCheck(Peer1 varchar, Peer2 varchar, Task varchar, Status Status, tmp time)
language plpgsql
as $$
begin
  INSERT INTO Checks(id, Peer, Task, "Date") VALUES ((SELECT MAX(ID) FROM Checks)+1,Peer1, Task, current_date);
  INSERT INTO P2P ("Check", CheckingPeer, "State", "Time") VALUES ((SELECT MAX(ID) FROM Checks), Peer2, 'Start',  tmp);
    IF Status != 'Start' THEN
	INSERT INTO P2P ("Check", CheckingPeer, "State", "Time") VALUES ((SELECT MAX(ID) FROM Checks), Peer2, Status,  tmp);
 END IF;
end;
$$;


CALL ADDP2PCheck ('oneudata', 'melodigr', 'C2_SimpleBash', 'Success', '17:15:15');
CALL AddP2PCheck ('ainorval', 'melodigr', 'C2_SimpleBash', 'Start', '15:15:15');
CALL AddP2PCheck ('elmersha', 'onrtyef', 'C5_s21_decimal', 'Failure', '15:15:15');



///2

CREATE OR REPLACE PROCEDURE AddVerterCheck(Pr varchar, Ts varchar, St Status, tmp time)
language plpgsql
as $$
DECLARE
  id_check integer;
begin
id_check = (select Checks.id from Checks
join P2P
on Checks.id= P2p."Check"
where Checks.task = Ts AND P2P."State" = 'Success' AND Checks.peer = Pr
order by "Date" DESC
Limit 1);
 IF id_check IS NOT NULL
 THEN
  INSERT INTO Verter ("Check",  "State", "Time") VALUES (id_check, 'Start',  tmp);
  IF St != 'Start' THEN
  INSERT INTO Verter ("Check",  "State", "Time") VALUES (id_check, St,  tmp);
  END IF;
 END IF;
end;
$$;


CALL AddVerterCheck ('oneudata', 'C2_SimpleBash', 'Success', '18:18:18');
CALL AddVerterCheck ('oneudata', 'C4_s21_math', 'Success', '18:18:18');

////3
CREATE OR REPLACE FUNCTION p2p_update_points()
RETURNS TRIGGER AS $$
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER ADDP2P
AFTER INSERT ON P2P
FOR EACH ROW
EXECUTE FUNCTION p2p_update();



SELECT checkingpeer, peer from P2P
join Checks
ON P2P."Check" = Checks.id
WHERE "State"='Start'


