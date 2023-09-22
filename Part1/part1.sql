DROP TABLE IF EXISTS Peers, Tasks, P2P, Verter, Checks, TransferredPoints, Friends, Recommendations, XP, TimeTracking CASCADE;
DROP TYPE IF EXISTS status;

CREATE TYPE status AS ENUM ('Start', 'Success', 'Failure');

CREATE TABLE IF NOT EXISTS Peers(
	Nickname VARCHAR PRIMARY KEY NOT NULL,
	Birthday DATE
);

CREATE TABLE IF NOT EXISTS Tasks(
	Title VARCHAR PRIMARY KEY NOT NULL UNIQUE,
	ParentTask VARCHAR,
	MaxXp INT NOT NULL,
	CONSTRAINT fk_Tasks_ParentTask foreign key (ParentTask) references Tasks (Title),
	CONSTRAINT check_equality CHECK (ParentTask != Title)
);

CREATE TABLE IF NOT EXISTS  Checks (
	ID SERIAL PRIMARY KEY,
	Peer VARCHAR NOT NULL,
	Task VARCHAR NOT NULL,
	"Date" DATE,
	CONSTRAINT fk_Checks_Peer foreign key (Peer) references Peers (Nickname),
	CONSTRAINT fk_Checks_Task foreign key (Task) references Tasks (Title)
	
);

CREATE TABLE IF NOT EXISTS P2P(
	ID SERIAL PRIMARY KEY,
	"Check" BIGINT NOT NULL,
	CheckingPeer VARCHAR NOT NULL,
	"State" status,
	"Time" TIME NOT NULL,
	CONSTRAINT fk_P2P_CheckingPeer foreign key (CheckingPeer) references Peers (Nickname),
	CONSTRAINT fk_P2P_Check foreign key ("Check") references Checks (ID)
);


CREATE TABLE IF NOT EXISTS Verter (
	ID SERIAL PRIMARY KEY,
	"Check" BIGINT NOT NULL,
	"State" status,
	"Time" TIME NOT NULL,
	CONSTRAINT fk_Verter_Check foreign key ("Check") references Checks (ID)
);



CREATE TABLE IF NOT EXISTS TransferredPoints (
	ID SERIAL PRIMARY KEY,
	CheckingPeer VARCHAR NOT NULL,
	CheckedPeer VARCHAR NOT NULL,
	PointsAmount INT NOT NULL DEFAULT 0,
	CONSTRAINT check_equality CHECK (CheckingPeer != CheckedPeer),
	CONSTRAINT fk_TransferredPoints_CheckingPeer foreign key (CheckingPeer) references Peers (Nickname),
	CONSTRAINT fk_TransferredPoints_CheckedPeer foreign key (CheckedPeer) references Peers (Nickname)
	
);

CREATE TABLE IF NOT EXISTS Friends (
	ID SERIAL PRIMARY KEY,
	Peer1  VARCHAR NOT NULL,
	Peer2  VARCHAR NOT NULL,
	CONSTRAINT check_equality CHECK (Peer1 != Peer2),
	CONSTRAINT fk_Friends_Peer1 foreign key (Peer1) references Peers (Nickname),
	CONSTRAINT fk_Friends_Peer2 foreign key (Peer2) references Peers (Nickname)
	
);

CREATE TABLE IF NOT EXISTS Recommendations (
	ID SERIAL PRIMARY KEY,
	Peer VARCHAR NOT NULL,
	RecommendedPeer VARCHAR NOT NULL,
	CONSTRAINT check_equality CHECK (Peer != RecommendedPeer),
	CONSTRAINT fk_Recommendations_Peer foreign key (Peer) references Peers (Nickname),
	CONSTRAINT fk_Recommendations_RecommendedPeer foreign key (RecommendedPeer) references Peers (Nickname)
);

CREATE TABLE IF NOT EXISTS XP (
	ID SERIAL PRIMARY KEY,
    "Check" BIGINT NOT NULL,
	XPAmount BIGINT NOT NULL,
	CONSTRAINT fk_XP_Check foreign key ("Check") references Checks (ID)
);

CREATE TABLE IF NOT EXISTS TimeTracking (
	ID SERIAL PRIMARY KEY,
    Peer VARCHAR NOT NULL,
	"Date" DATE NOT NULL,
    "Time" TIME WITHOUT TIME ZONE NOT NULL,
    "State" VARCHAR NOT NULL  CHECK ("State" IN ('1', '2')),
	CONSTRAINT fk_TimeTracking_Peer foreign key (Peer) references Peers(Nickname)
);


CREATE OR REPLACE PROCEDURE ExportToCSV
(tabl varchar, filepath varchar, delim char(1))
AS $$
  BEGIN
EXECUTE FORMAT('COPY '||tabl||' TO %L WITH CSV DELIMITER %L', filepath, delim);
  END;
  $$LANGUAGE plpgsql;




CREATE OR REPLACE PROCEDURE ExportFromCSV
(tabl varchar, filepath varchar, delim char(1))
AS $$
  BEGIN
EXECUTE FORMAT('COPY '||tabl||' FROM %L WITH CSV DELIMITER %L', filepath, delim);
  END;
  $$LANGUAGE plpgsql;
