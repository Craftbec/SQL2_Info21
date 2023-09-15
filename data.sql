INSERT INTO Peers(Nickname, Birthday) VALUES 
('omarval', '2004-05-12'),
('desperos', '1998-01-23'),
('floridas', '2003-08-24'),
('mjollor', '2001-07-12'),
('kathayr', '2000-06-21'),
('mikecall', '2001-05-04'),
('oneudata', '2000-04-09'),
('morrisro', '2002-10-19'),
('lorettec', '2004-12-18'),
('melodigr', '1999-11-14'),
('elmersha', '1998-03-26'),
('tomokoki', '1997-02-27'),
('ainorval', '1996-01-16'),
('itchyole', '1996-04-01'),
('onrtyef', '1995-05-18');

INSERT INTO Tasks(Title, ParentTask, MaxXP) VALUES
('C2_SimpleBash', NULL, 250),
('C3_s21_string+', 'C2_SimpleBash', 500),
('C4_s21_math', 'C3_s21_string+', 300),
('C5_s21_decimal', 'C4_s21_math', 350),
('C6_s21_matrix', 'C5_s21_decimal', 200),
('C7_SmartCalc_v1.0', 'C6_s21_matrix', 500),
('C8_3DViewer_v1.0', 'C7_SmartCalc_v1.0', 750),
('D01_Linux', 'C3_s21_string+', 300),
('D02_LinuxNetwork', 'D01_Linux', 250),
('D03_LinuxMonitoring v1.0', 'D02_LinuxNetwork', 350),
('D05_SimpleDocker', 'D03_LinuxMonitoring v1.0', 300),
('D06_CICD', 'D05_SimpleDocker', 350);

INSERT INTO Friends(Peer1, Peer2) VALUES
('omarval', 'kathayr'),
('omarval', 'mikecall'),
('omarval', 'oneudata'),
('desperos', 'morrisro'),
('desperos', 'floridas'),
('floridas', 'melodigr'),
('floridas', 'oneudata'),
('mjollor', 'elmersha'),
('mjollor', 'tomokoki'),
('kathayr', 'ainorval'),
('mikecall', 'itchyole'),
('morrisro', 'onrtyef'),
('lorettec', 'itchyole');

INSERT INTO Recommendations(Peer, RecommendedPeer) VALUES
('omarval', 'kathayr'),
('omarval', 'mikecall'),
('omarval', 'oneudata'),
('desperos', 'morrisro'),
('desperos', 'floridas'),
('floridas', 'melodigr'),
('floridas', 'oneudata'),
('mjollor', 'elmersha'),
('mjollor', 'tomokoki'),
('kathayr', 'ainorval'),
('mikecall', 'itchyole'),
('morrisro', 'onrtyef'),
('lorettec', 'itchyole');



INSERT INTO Checks(ID, Peer, Task, "Date") VALUES
('1','omarval', 'C2_SimpleBash', '2023-06-24'),
('2','mjollor', 'C2_SimpleBash', '2023-08-01'),
('3','omarval', 'C8_3DViewer_v1.0', '2023-07-28'),
('4','desperos', 'C2_SimpleBash', '2023-05-05'),
('5','omarval', 'D01_Linux', '2020-03-09'),
('6','omarval', 'D02_LinuxNetwork', '2020-05-10'),
('7','omarval', 'C3_s21_string+', '2023-09-25'),
('8','omarval', 'C4_s21_math', '2023-09-26'),
('9','omarval', 'C5_s21_decimal', '2023-09-27'),
('10','omarval', 'C6_s21_matrix', '2023-09-28'),
('11','omarval', 'C7_SmartCalc_v1.0', '2023-09-29'),
('12','lorettec', 'C2_SimpleBash', '2023-09-01'),
('13','lorettec', 'C3_s21_string+', '2023-09-20'),
('14','lorettec', 'D01_Linux', '2023-10-08'),
('15','mikecall', 'C2_SimpleBash', '2023-09-04'),
('16','floridas', 'C2_SimpleBash', '2023-09-08'),
('17','floridas', 'C3_s21_string+', '2023-09-12'),
('18','floridas', 'C4_s21_math', '2023-09-15'),
('19','floridas', 'C5_s21_decimal', '2023-09-19');


INSERT INTO Verter("Check", "State", "Time") VALUES
(1, 'Start', '10:30:15'), 
(2, 'Start', '12:05:00'),
(3, 'Start', '13:07:17'),
(4, 'Start', '07:04:29'),
(5, 'Start', '19:12:45'),
(6, 'Start', '15:15:58'),
(7, 'Start', '17:34:02'),
(8, 'Start', '18:28:10'),
(9, 'Start', '14:26:57'),
(10, 'Start', '11:19:46'),
(11, 'Start', '12:24:32'),
(12, 'Start', '19:24:32'),
(1, 'Success', '11:36:15'), 
(2, 'Success', '12:30:46'),
(3, 'Failure', '14:30:17'),
(4, 'Success', '07:49:29'),
(5, 'Success', '20:30:45'),
(6, 'Failure', '15:18:58'),
(7, 'Success', '17:39:02'),
(8, 'Failure', '18:31:10'),
(9, 'Success', '14:30:12'),
(10, 'Failure', '11:21:59'),
(11, 'Failure', '12:30:15');


INSERT INTO XP("Check", XPAmount) VALUES
(1, 100),
(2, 150),
(4, 200),
(5, 180),
(7, 80),
(9, 50);



INSERT INTO TimeTracking(Peer, "Date", "Time", "State") VALUES
('omarval', '2023-09-01', TIME '08:15:22', '1'),
('morrisro', '2023-09-01', TIME '08:25:36', '1'),
('elmersha', '2023-09-01', TIME '09:12:49', '1'),
('onrtyef', '2023-09-01', TIME '14:03:16', '1'),
('mikecall', '2023-09-01', TIME '18:07:03', '1'),
('omarval', '2023-10-01', TIME '08:15:22', '2'),
('morrisro', '2023-09-01', TIME '22:25:36', '2'),
('elmersha', '2023-09-01', TIME '19:12:49', '2'),
('onrtyef', '2023-09-01', TIME '15:03:16', '2'),
('mikecall', '2023-09-01', TIME '19:07:03', '2'),
('mjollor', '2023-09-02', TIME '09:12:49', '1'),
('onrtyef', '2023-09-02', TIME '14:03:16', '1'),
('melodigr', '2023-09-07', TIME '18:07:03', '1'),
('mjollor', '2023-09-02', TIME '19:12:49', '2'),
('onrtyef', '2023-09-02', TIME '15:03:16', '2'),
('melodigr', '2023-09-12', TIME '22:07:03', '2'),
('morrisro', '2023-09-03', TIME '08:15:22', '1'),
('morrisro', '2023-09-03', TIME '08:25:36', '1'),
('morrisro', '2023-09-03', TIME '09:12:49', '1'),
('tomokoki', '2023-09-03', TIME '14:03:16', '1'),
('tomokoki', '2023-09-03', TIME '18:07:03', '1'),
('morrisro', '2023-09-03', TIME '08:15:22', '2'),
('morrisro', '2023-09-03', TIME '08:17:36', '2'),
('morrisro', '2023-09-03', TIME '09:49:49', '2'),
('tomokoki', '2023-09-03', TIME '14:25:16', '2'),
('tomokoki', '2023-09-03', TIME '18:26:03', '2');



INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(1, 'omarval',  'Start', '10:30:15'), 
(2, 'mjollor', 'Start', '12:05:00'),
(3, 'omarval', 'Start', '13:07:17'),
(4, 'desperos', 'Start', '07:04:29'),
(5, 'lorettec', 'Start', '19:12:45'),
(6, 'kathayr', 'Start', '15:15:58'),
(7, 'mikecall', 'Start', '17:34:02'),
(8, 'floridas', 'Start', '18:28:10'),
(9, 'floridas', 'Start', '14:26:57'),
(10, 'omarval', 'Start', '11:19:46'),
(11, 'omarval', 'Start', '12:24:32'),
(12,  'floridas', 'Start', '19:24:32');


INSERT INTO TransferredPoints(CheckingPeer, CheckedPeer, PointsAmount) VALUES
('omarval',  'ainorval', '1'), 
('mjollor',  'itchyole', '1'), 
('omarval',  'kathayr', '1'), 
('desperos',  'oneudata', '1'), 
('lorettec',  'tomokoki', '1'), 
('kathayr',  'mikecall', '1'), 
('mikecall',  'kathayr', '1'), 
('floridas',  'itchyole', '1'), 
('floridas',  'ainorval', '1'), 
('omarval',  'floridas', '1'), 
('omarval',  'tomokoki', '1'), 
('floridas',  'ainorval', '1');