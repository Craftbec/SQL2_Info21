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


INSERT INTO TimeTracking(Peer, "Date", "Time", "State") VALUES
('omarval', '2023-09-01', TIME '08:15:22', '1'),
('morrisro', '2023-09-01', TIME '08:25:36', '1'),
('elmersha', '2023-09-01', TIME '09:12:49', '1'),
('onrtyef', '2023-09-01', TIME '14:03:16', '1'),
('mikecall', '2023-09-01', TIME '18:07:03', '1'),
('omarval', '2023-08-01', TIME '08:15:22', '2'),
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





INSERT INTO P2P("Check", CheckingPeer, "State", "Time") VALUES
(1, 'ainorval',  'Start', '10:30:15'), 
(2, 'itchyole', 'Start', '12:05:00'),
(3, 'kathayr', 'Start', '13:07:17'),
(4, 'oneudata', 'Start', '07:04:29'),
(5, 'tomokoki', 'Start', '19:12:45'),
(6, 'mikecall', 'Start', '15:15:58'),
(7, 'kathayr', 'Start', '17:34:02'),
(8, 'itchyole', 'Start', '18:28:10'),
(9, 'ainorval', 'Start', '14:26:57'),
(10, 'floridas', 'Start', '11:19:46'),
(11, 'tomokoki', 'Start', '12:24:32'),
(12,  'omarval', 'Start', '11:12:14'),
(13,  'omarval', 'Start', '12:36:25'),
(14,  'mikecall', 'Start', '13:48:35'),
(15,  'mjollor', 'Start', '22:11:46'),
(16,  'elmersha', 'Start', '16:36:02'),
(17,  'lorettec', 'Start', '11:05:09'),
(18,  'itchyole', 'Start', '08:09:17'),
(19,  'desperos', 'Start', '07:59:25'),
(1, 'ainorval',  'Success', '10:30:15'), 
(2, 'itchyole', 'Success', '12:05:00'),
(3, 'kathayr', 'Failure', '13:07:17'),
(4, 'oneudata', 'Success', '07:04:29'),
(5, 'tomokoki', 'Success', '19:12:45'),
(6, 'mikecall', 'Success', '15:15:58'),
(7, 'kathayr', 'Failure', '17:34:02'),
(8, 'itchyole', 'Failure', '18:28:10'),
(9, 'ainorval', 'Success', '14:26:57'),
(10, 'floridas', 'Failure', '11:19:46'),
(11, 'tomokoki', 'Failure', '12:24:32'),
(12,  'omarval', 'Success', '11:12:14'),
(13,  'omarval', 'Success', '12:36:25'),
(14,  'mikecall', 'Failure', '13:48:35'),
(15,  'mjollor', 'Success', '22:11:46'),
(16,  'elmersha', 'Success', '16:36:02'),
(17,  'lorettec', 'Failure', '11:05:09'),


INSERT INTO TransferredPoints(CheckingPeer, CheckedPeer, PointsAmount) VALUES
('ainorval','omarval',  '2'),
('itchyole', 'mjollor',  '1'),
('kathayr','omarval',  '2'),
('oneudata','desperos',  '1'),
('tomokoki','omarval',  '2'),
('mikecall','omarval',  '1'),
('itchyole','omarval', '1'),
('floridas','omarval',  '1'),
('omarval','lorettec',  '2'),
('mikecall','lorettec',  '1'),
('mjollor','mikecall',  '1'),
('elmersha','floridas',  '1'),
('lorettec','floridas',  '1'),
('itchyole','floridas',  '1'),
('desperos','floridas',  '1');



INSERT INTO Verter("Check", "State", "Time") VALUES
(1, 'Start', '10:30:15'), 
(2, 'Start', '12:05:00'),
(4, 'Start', '13:07:17'),
(5, 'Start', '07:04:29'),
(6, 'Start', '19:12:45'),
(9, 'Start', '15:15:58'),
(12, 'Start', '17:34:02'),
(13, 'Start', '18:28:10'),
(15, 'Start', '14:26:57'),
(16, 'Start', '11:19:46'),
(1, 'Success', '11:36:15'), 
(2, 'Success', '12:30:46'),
(4, 'Failure', '14:30:17'),
(5, 'Success', '07:49:29'),
(6, 'Success', '20:30:45'),
(9, 'Failure', '15:18:58'),
(12, 'Success', '17:39:02'),
(13, 'Failure', '18:31:10'),
(15, 'Success', '14:30:12'),
(16, 'Failure', '11:21:59');



INSERT INTO XP("Check", XPAmount) VALUES
(1, 100),
(2, 150),
(5, 200),
(6, 180),
(12, 80),
(15, 50);