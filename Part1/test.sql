-- For check filled tables
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

-- For append date to csv
CALL ExportToCSV('TableName', 'PathToFile', ';'); 

-- For get data from csv
CALL ExportFromCSV('TableName', 'PathToFile', ';');