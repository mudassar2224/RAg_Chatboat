-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 24, 2026 at 08:20 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_sfms`
--

-- --------------------------------------------------------

--
-- Table structure for table `cods`
--

CREATE TABLE `cods` (
  `coid` int(10) NOT NULL,
  `cocode` varchar(255) DEFAULT NULL,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) NOT NULL,
  `gender` varchar(200) NOT NULL,
  `email` varchar(255) NOT NULL,
  `pass` varchar(200) NOT NULL,
  `contactno` varchar(255) NOT NULL,
  `depcode` varchar(255) DEFAULT NULL,
  `depname` varchar(255) DEFAULT NULL,
  `depschool` varchar(255) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `createdon` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cods`
--

INSERT INTO `cods` (`coid`, `cocode`, `FirstName`, `LastName`, `gender`, `email`, `pass`, `contactno`, `depcode`, `depname`, `depschool`, `createdby`, `createdon`) VALUES
(1, 'COD-SST-01', 'Dr. Muhammad', 'Asif', 'Male', 'asif.m@umt.edu.pk', 'umtSst01', '03214567891', 'SST-01', 'Computer Science', 'SST', 'admin', '2026-09-24'),
(2, 'COD-SST-02', 'Dr. Shanza', 'Khan', 'Female', 'shanza.khan@umt.edu.pk', 'umtSst02', '03214567892', 'SST-02', 'Software Engineering', 'SST', 'admin', '2026-09-24'),
(3, 'COD-SST-03', 'Dr. Amjad', 'Ali', 'Male', 'amjad.ali@umt.edu.pk', 'umtSst03', '03214567893', 'SST-03', 'Data Science', 'SST', 'admin', '2026-09-24'),
(4, 'COD-SST-04', 'Dr. Maria', 'Anjum', 'Female', 'maria.anjum@umt.edu.pk', 'umtSst04', '03214567894', 'SST-04', 'Artificial Intelligence', 'SST', 'admin', '2026-09-24'),
(5, 'COD-SST-05', 'Dr. Farooq', 'Ahmad', 'Male', 'farooq.ahmad@umt.edu.pk', 'umtSst05', '03214567895', 'SST-05', 'Information Technology', 'SST', 'admin', '2026-09-24'),
(6, 'COD-SST-06', 'Dr. Nabeel', 'Sabir', 'Male', 'nabeel.sabir@umt.edu.pk', 'umtSst06', '03214567896', 'SST-06', 'Cyber Security', 'SST', 'admin', '2026-09-24'),
(7, 'COD-SST-07', 'Dr. Tayyaba', 'Anees', 'Female', 'tayyaba.anees@umt.edu.pk', 'umtSst07', '03214567897', 'SST-07', 'Informatics and Systems', 'SST', 'admin', '2026-09-24'),
(8, 'COD-HSM-01', 'Dr. Naveed', 'Anwar', 'Male', 'naveed.anwar@umt.edu.pk', 'umtHsm01', '03214567898', 'HSM-01', 'Management', 'HSM', 'admin', '2026-09-24'),
(9, 'COD-HSM-02', 'Dr. Alyia', 'Malik', 'Female', 'alyia.malik@umt.edu.pk', 'umtHsm02', '03214567899', 'HSM-02', 'Marketing', 'HSM', 'admin', '2026-09-24'),
(10, 'COD-HSM-03', 'Dr. Shahid', 'Hassan', 'Male', 'shahid.hassan@umt.edu.pk', 'umtHsm03', '03214567900', 'HSM-03', 'Finance and Banking', 'HSM', 'admin', '2026-09-24'),
(11, 'COD-HSM-04', 'Dr. Sadia', 'Nadeem', 'Female', 'sadia.nadeem@umt.edu.pk', 'umtHsm04', '03214567901', 'HSM-04', 'Human Resource Management', 'HSM', 'admin', '2026-09-24'),
(12, 'COD-HSM-05', 'Dr. Kamran', 'Saeed', 'Male', 'kamran.saeed@umt.edu.pk', 'umtHsm05', '03214567902', 'HSM-05', 'Operations and Supply Chain', 'HSM', 'admin', '2026-09-24'),
(13, 'COD-HSM-06', 'Dr. Zulfiqar', 'Ali', 'Male', 'zulfiqar.ali@umt.edu.pk', 'umtHsm06', '03214567903', 'HSM-06', 'Economics and Statistics', 'HSM', 'admin', '2026-09-24'),
(14, 'COD-HSM-07', 'Dr. Bushra', 'Siddiqui', 'Female', 'bushra.s@umt.edu.pk', 'umtHsm07', '03214567904', 'HSM-07', 'Information Systems Business', 'HSM', 'admin', '2026-09-24'),
(15, 'COD-SEN-01', 'Dr. Haroon', 'Raza', 'Male', 'haroon.raza@umt.edu.pk', 'umtSen01', '03214567905', 'SEN-01', 'Electrical Engineering', 'SEN', 'admin', '2026-09-24'),
(16, 'COD-SEN-02', 'Dr. Bilal', 'Siddique', 'Male', 'bilal.s@umt.edu.pk', 'umtSen02', '03214567906', 'SEN-02', 'Mechanical Engineering', 'SEN', 'admin', '2026-09-24'),
(17, 'COD-SEN-03', 'Dr. Asma', 'Riaz', 'Female', 'asma.riaz@umt.edu.pk', 'umtSen03', '03214567907', 'SEN-03', 'Civil Engineering', 'SEN', 'admin', '2026-09-24'),
(18, 'COD-SEN-04', 'Dr. Rizwan', 'Khan', 'Male', 'rizwan.k@umt.edu.pk', 'umtSen04', '03214567908', 'SEN-04', 'Industrial Engineering', 'SEN', 'admin', '2026-09-24'),
(19, 'COD-SEN-05', 'Dr. Humaira', 'Bano', 'Female', 'humaira.bano@umt.edu.pk', 'umtSen05', '03214567909', 'SEN-05', 'Textile Engineering', 'SEN', 'admin', '2026-09-24'),
(20, 'COD-SHS-01', 'Dr. Khalid', 'Mahmood', 'Male', 'khalid.m@umt.edu.pk', 'umtShs01', '03214567910', 'SHS-01', 'Physical Therapy', 'SHS', 'admin', '2026-09-24'),
(21, 'COD-SHS-02', 'Dr. Zainab', 'Tariq', 'Female', 'zainab.t@umt.edu.pk', 'umtShs02', '03214567911', 'SHS-02', 'Nutrition and Dietetics', 'SHS', 'admin', '2026-09-24'),
(22, 'COD-SHS-03', 'Dr. Usman', 'Ghani', 'Male', 'usman.ghani@umt.edu.pk', 'umtShs03', '03214567912', 'SHS-03', 'Medical Imaging Technology', 'SHS', 'admin', '2026-09-24'),
(23, 'COD-SHS-04', 'Dr. Hina', 'Zafar', 'Female', 'hina.zafar@umt.edu.pk', 'umtShs04', '03214567913', 'SHS-04', 'Medical Laboratory Sciences', 'SHS', 'admin', '2026-09-24'),
(24, 'COD-SHS-05', 'Dr. Faisal', 'Iqbal', 'Male', 'faisal.iqbal@umt.edu.pk', 'umtShs05', '03214567914', 'SHS-05', 'Public Health', 'SHS', 'admin', '2026-09-24'),
(25, 'COD-SPA-01', 'Dr. Sajjad', 'Muneer', 'Male', 'sajjad.m@umt.edu.pk', 'umtSpa01', '03214567915', 'SPA-01', 'Architecture', 'SPA', 'admin', '2026-09-24'),
(26, 'COD-SPA-02', 'Dr. Amna', 'Javed', 'Female', 'amna.javed@umt.edu.pk', 'umtSpa02', '03214567916', 'SPA-02', 'City and Regional Planning', 'SPA', 'admin', '2026-09-24'),
(27, 'COD-SSH-01', 'Dr. Amna', 'Arif', 'Female', 'edu.cod@umt.edu.pk', 'umtSsh01', '03214567917', 'SSH-01', 'Education', 'SSH', 'admin', '2026-09-24'),
(28, 'COD-SSH-02', 'Dr. Tariq', 'Rahman', 'Male', 'tariq.r@umt.edu.pk', 'umtSsh02', '03214567918', 'SSH-02', 'Linguistics and Literature', 'SSH', 'admin', '2026-09-24'),
(29, 'COD-SSH-03', 'Dr. Muhammad', 'Ismail', 'Male', 'ismail.m@umt.edu.pk', 'umtSsh03', '03214567919', 'SSH-03', 'Islamic Thought and Civilization', 'SSH', 'admin', '2026-09-24'),
(30, 'COD-SSH-04', 'Dr. Saima', 'Butt', 'Female', 'saima.butt@umt.edu.pk', 'umtSsh04', '03214567920', 'SSH-04', 'Political Science and IR', 'SSH', 'admin', '2026-09-24'),
(31, 'COD-SST-E1', 'Dr. Omer', 'Riaz', 'Male', 'omer.riaz@umt.edu.pk', 'umtSst08', '03214567921', 'SST-01', 'Computer Science (Evening)', 'SST', 'admin', '2026-09-24'),
(32, 'COD-SST-E2', 'Dr. Saba', 'Iftikhar', 'Female', 'saba.i@umt.edu.pk', 'umtSst09', '03214567922', 'SST-02', 'Software Engineering (Evening)', 'SST', 'admin', '2026-09-24'),
(33, 'COD-SST-M1', 'Dr. Adnan', 'Malik', 'Male', 'adnan.malik@umt.edu.pk', 'umtSst10', '03214567923', 'SST-03', 'Data Science (MS Program)', 'SST', 'admin', '2026-09-24'),
(34, 'COD-HSM-E1', 'Dr. Zoya', 'Rehman', 'Female', 'zoya.r@umt.edu.pk', 'umtHsm08', '03214567924', 'HSM-01', 'MBA Executive Program', 'HSM', 'admin', '2026-09-24'),
(35, 'COD-HSM-E2', 'Dr. Waqas', 'Javed', 'Male', 'waqas.j@umt.edu.pk', 'umtHsm09', '03214567925', 'HSM-02', 'Marketing (Evening Program)', 'HSM', 'admin', '2026-09-24'),
(36, 'COD-SEN-M1', 'Dr. Tanveer', 'Ahmed', 'Male', 'tanveer.a@umt.edu.pk', 'umtSen06', '03214567926', 'SEN-01', 'Electrical Engineering (MS)', 'SEN', 'admin', '2026-09-24'),
(37, 'COD-SHS-M1', 'Dr. Hira', 'Anwar', 'Female', 'hira.anwar@umt.edu.pk', 'umtShs06', '03214567927', 'SHS-01', 'Doctor of Physical Therapy (Adv)', 'SHS', 'admin', '2026-09-24'),
(38, 'COD-SST-08', 'Dr. Kashif', 'Nadeem', 'Male', 'kashif.n@umt.edu.pk', 'umtSst11', '03214567928', 'SST-08', 'Internet of Things', 'SST', 'admin', '2026-09-24'),
(39, 'COD-SST-09', 'Dr. Fatima', 'Siddiqui', 'Female', 'fatima.s@umt.edu.pk', 'umtSst12', '03214567929', 'SST-09', 'Cloud Computing', 'SST', 'admin', '2026-09-24'),
(40, 'COD-HSM-08', 'Dr. Ahsan', 'Khan', 'Male', 'ahsan.k@umt.edu.pk', 'umtHsm10', '03214567930', 'HSM-08', 'Business Analytics', 'HSM', 'admin', '2026-09-24'),
(41, 'COD-HSM-09', 'Dr. Sobia', 'Tariq', 'Female', 'sobia.t@umt.edu.pk', 'umtHsm11', '03214567931', 'HSM-09', 'Entrepreneurship', 'HSM', 'admin', '2026-09-24'),
(42, 'COD-SEN-06', 'Dr. Shoaib', 'Akram', 'Male', 'shoaib.a@umt.edu.pk', 'umtSen07', '03214567932', 'SEN-06', 'Mechatronics Engineering', 'SEN', 'admin', '2026-09-24'),
(43, 'COD-SEN-07', 'Dr. Maryam', 'Ghias', 'Female', 'maryam.g@umt.edu.pk', 'umtSen08', '03214567933', 'SEN-07', 'Energy Engineering', 'SEN', 'admin', '2026-09-24'),
(44, 'COD-SHS-06', 'Dr. Taimoor', 'Baig', 'Male', 'taimoor.b@umt.edu.pk', 'umtShs07', '03214567934', 'SHS-06', 'Optometry and Vision Sciences', 'SHS', 'admin', '2026-09-24'),
(45, 'COD-SHS-07', 'Dr. Kinza', 'Muneer', 'Female', 'kinza.m@umt.edu.pk', 'umtShs08', '03214567935', 'SHS-07', 'Aesthetics and Skin Care', 'SHS', 'admin', '2026-09-24'),
(46, 'COD-SPA-03', 'Dr. Mudassir', 'Hussain', 'Male', 'mudassir.h@umt.edu.pk', 'umtSpa03', '03214567936', 'SPA-03', 'Fine Arts', 'SPA', 'admin', '2026-09-24'),
(47, 'COD-SPA-04', 'Dr. Rimsha', 'Kanwal', 'Female', 'rimsha.k@umt.edu.pk', 'umtSpa04', '03214567937', 'SPA-04', 'Graphic Design', 'SPA', 'admin', '2026-09-24'),
(48, 'COD-SSH-05', 'Dr. Salman', 'Ahmed', 'Male', 'salman.a@umt.edu.pk', 'umtSsh05', '03214567938', 'SSH-05', 'Special Education', 'SSH', 'admin', '2026-09-24'),
(49, 'COD-SSH-06', 'Dr. Humaira', 'Latif', 'Female', 'humaira.l@umt.edu.pk', 'umtSsh06', '03214567939', 'SSH-06', 'Sociology and Culture', 'SSH', 'admin', '2026-09-24'),
(50, 'COD-SST-10', 'Dr. Saad', 'Aslam', 'Male', 'saad.a@umt.edu.pk', 'umtSst13', '03214567940', 'SST-10', 'Game Design and Production', 'SST', 'admin', '2026-09-24'),
(51, 'COD-SST-11', 'Dr. Kiran', 'Shahzadi', 'Female', 'kiran.s@umt.edu.pk', 'umtSst14', '03214567941', 'SST-11', 'Quantum Computing', 'SST', 'admin', '2026-09-24'),
(52, 'COD-HSM-10', 'Dr. Omer', 'Farooq', 'Male', 'omer.f@umt.edu.pk', 'umtHsm12', '03214567942', 'HSM-10', 'Project Management', 'HSM', 'admin', '2026-09-24'),
(53, 'COD-HSM-11', 'Dr. Iqra', 'Shahid', 'Female', 'iqra.s@umt.edu.pk', 'umtHsm13', '03214567943', 'HSM-11', 'Hospitality Leadership', 'HSM', 'admin', '2026-09-24'),
(54, 'COD-SEN-08', 'Dr. Usman', 'Raza', 'Male', 'usman.r@umt.edu.pk', 'umtSen09', '03214567944', 'SEN-08', 'Materials Engineering', 'SEN', 'admin', '2026-09-24'),
(55, 'COD-SHS-08', 'Dr. Faiza', 'Iftikhar', 'Female', 'faiza.i@umt.edu.pk', 'umtShs09', '03214567945', 'SHS-08', 'Medical Lab Technology', 'SHS', 'admin', '2026-09-24');

-- --------------------------------------------------------

--
-- Table structure for table `cod_assigndep`
--

CREATE TABLE `cod_assigndep` (
  `aid` int(10) NOT NULL,
  `cocode` varchar(255) NOT NULL,
  `depcode` varchar(255) DEFAULT NULL,
  `createdby` varchar(200) NOT NULL,
  `creadedon` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cod_assigndep`
--

INSERT INTO `cod_assigndep` (`aid`, `cocode`, `depcode`, `createdby`, `creadedon`) VALUES
(1, 'COD-SST-01', 'SST-01', 'admin', '2026-09-24'),
(2, 'COD-SST-02', 'SST-02', 'admin', '2026-09-24'),
(3, 'COD-SST-03', 'SST-03', 'admin', '2026-09-24'),
(4, 'COD-SST-04', 'SST-04', 'admin', '2026-09-24'),
(5, 'COD-SST-05', 'SST-05', 'admin', '2026-09-24'),
(6, 'COD-SST-06', 'SST-06', 'admin', '2026-09-24'),
(7, 'COD-SST-07', 'SST-07', 'admin', '2026-09-24'),
(8, 'COD-HSM-01', 'HSM-01', 'admin', '2026-09-24'),
(9, 'COD-HSM-02', 'HSM-02', 'admin', '2026-09-24'),
(10, 'COD-HSM-03', 'HSM-03', 'admin', '2026-09-24'),
(11, 'COD-HSM-04', 'HSM-04', 'admin', '2026-09-24'),
(12, 'COD-HSM-05', 'HSM-05', 'admin', '2026-09-24'),
(13, 'COD-HSM-06', 'HSM-06', 'admin', '2026-09-24'),
(14, 'COD-HSM-07', 'HSM-07', 'admin', '2026-09-24'),
(15, 'COD-SEN-01', 'SEN-01', 'admin', '2026-09-24'),
(16, 'COD-SEN-02', 'SEN-02', 'admin', '2026-09-24'),
(17, 'COD-SEN-03', 'SEN-03', 'admin', '2026-09-24'),
(18, 'COD-SEN-04', 'SEN-04', 'admin', '2026-09-24'),
(19, 'COD-SEN-05', 'SEN-05', 'admin', '2026-09-24'),
(20, 'COD-SHS-01', 'SHS-01', 'admin', '2026-09-24'),
(21, 'COD-SHS-02', 'SHS-02', 'admin', '2026-09-24'),
(22, 'COD-SHS-03', 'SHS-03', 'admin', '2026-09-24'),
(23, 'COD-SHS-04', 'SHS-04', 'admin', '2026-09-24'),
(24, 'COD-SHS-05', 'SHS-05', 'admin', '2026-09-24'),
(25, 'COD-SPA-01', 'SPA-01', 'admin', '2026-09-24'),
(26, 'COD-SPA-02', 'SPA-02', 'admin', '2026-09-24'),
(27, 'COD-SSH-01', 'SSH-01', 'admin', '2026-09-24'),
(28, 'COD-SSH-02', 'SSH-02', 'admin', '2026-09-24'),
(29, 'COD-SSH-03', 'SSH-03', 'admin', '2026-09-24'),
(30, 'COD-SSH-04', 'SSH-04', 'admin', '2026-09-24'),
(31, 'COD-SST-E1', 'SST-01', 'admin', '2026-09-24'),
(32, 'COD-SST-E2', 'SST-02', 'admin', '2026-09-24'),
(33, 'COD-SST-M1', 'SST-03', 'admin', '2026-09-24'),
(34, 'COD-HSM-E1', 'HSM-01', 'admin', '2026-09-24'),
(35, 'COD-HSM-E2', 'HSM-02', 'admin', '2026-09-24'),
(36, 'COD-SEN-M1', 'SEN-01', 'admin', '2026-09-24'),
(37, 'COD-SHS-M1', 'SHS-01', 'admin', '2026-09-24'),
(38, 'COD-SST-08', 'SST-08', 'admin', '2026-09-24'),
(39, 'COD-SST-09', 'SST-09', 'admin', '2026-09-24'),
(40, 'COD-HSM-08', 'HSM-08', 'admin', '2026-09-24'),
(41, 'COD-HSM-09', 'HSM-09', 'admin', '2026-09-24'),
(42, 'COD-SEN-06', 'SEN-06', 'admin', '2026-09-24'),
(43, 'COD-SEN-07', 'SEN-07', 'admin', '2026-09-24'),
(44, 'COD-SHS-06', 'SHS-06', 'admin', '2026-09-24'),
(45, 'COD-SHS-07', 'SHS-07', 'admin', '2026-09-24'),
(46, 'COD-SPA-03', 'SPA-03', 'admin', '2026-09-24'),
(47, 'COD-SPA-04', 'SPA-04', 'admin', '2026-09-24'),
(48, 'COD-SSH-05', 'SSH-05', 'admin', '2026-09-24'),
(49, 'COD-SSH-06', 'SSH-06', 'admin', '2026-09-24'),
(50, 'COD-SST-10', 'SST-10', 'admin', '2026-09-24'),
(51, 'COD-SST-11', 'SST-11', 'admin', '2026-09-24'),
(52, 'COD-HSM-10', 'HSM-10', 'admin', '2026-09-24'),
(53, 'COD-HSM-11', 'HSM-11', 'admin', '2026-09-24'),
(54, 'COD-SEN-08', 'SEN-08', 'admin', '2026-09-24'),
(55, 'COD-SHS-08', 'SHS-08', 'admin', '2026-09-24'),
(56, 'COD-SST-01', 'SST-01', 'admin', '2026-09-24'),
(57, 'COD-SST-02', 'SST-02', 'admin', '2026-09-24'),
(58, 'COD-SST-03', 'SST-03', 'admin', '2026-09-24'),
(59, 'COD-SST-04', 'SST-04', 'admin', '2026-09-24'),
(60, 'COD-SST-05', 'SST-05', 'admin', '2026-09-24'),
(61, 'COD-SST-06', 'SST-06', 'admin', '2026-09-24'),
(62, 'COD-SST-07', 'SST-07', 'admin', '2026-09-24'),
(63, 'COD-HSM-01', 'HSM-01', 'admin', '2026-09-24'),
(64, 'COD-HSM-02', 'HSM-02', 'admin', '2026-09-24'),
(65, 'COD-HSM-03', 'HSM-03', 'admin', '2026-09-24'),
(66, 'COD-HSM-04', 'HSM-04', 'admin', '2026-09-24'),
(67, 'COD-HSM-05', 'HSM-05', 'admin', '2026-09-24'),
(68, 'COD-HSM-06', 'HSM-06', 'admin', '2026-09-24'),
(69, 'COD-HSM-07', 'HSM-07', 'admin', '2026-09-24'),
(70, 'COD-SEN-01', 'SEN-01', 'admin', '2026-09-24'),
(71, 'COD-SEN-02', 'SEN-02', 'admin', '2026-09-24'),
(72, 'COD-SEN-03', 'SEN-03', 'admin', '2026-09-24'),
(73, 'COD-SEN-04', 'SEN-04', 'admin', '2026-09-24'),
(74, 'COD-SEN-05', 'SEN-05', 'admin', '2026-09-24'),
(75, 'COD-SHS-01', 'SHS-01', 'admin', '2026-09-24'),
(76, 'COD-SHS-02', 'SHS-02', 'admin', '2026-09-24'),
(77, 'COD-SHS-03', 'SHS-03', 'admin', '2026-09-24'),
(78, 'COD-SHS-04', 'SHS-04', 'admin', '2026-09-24'),
(79, 'COD-SHS-05', 'SHS-05', 'admin', '2026-09-24'),
(80, 'COD-SPA-01', 'SPA-01', 'admin', '2026-09-24'),
(81, 'COD-SPA-02', 'SPA-02', 'admin', '2026-09-24'),
(82, 'COD-SSH-01', 'SSH-01', 'admin', '2026-09-24'),
(83, 'COD-SSH-02', 'SSH-02', 'admin', '2026-09-24'),
(84, 'COD-SSH-03', 'SSH-03', 'admin', '2026-09-24'),
(85, 'COD-SSH-04', 'SSH-04', 'admin', '2026-09-24'),
(86, 'COD-SST-E1', 'SST-01', 'admin', '2026-09-24'),
(87, 'COD-SST-E2', 'SST-02', 'admin', '2026-09-24'),
(88, 'COD-SST-M1', 'SST-03', 'admin', '2026-09-24'),
(89, 'COD-HSM-E1', 'HSM-01', 'admin', '2026-09-24'),
(90, 'COD-HSM-E2', 'HSM-02', 'admin', '2026-09-24'),
(91, 'COD-SEN-M1', 'SEN-01', 'admin', '2026-09-24'),
(92, 'COD-SHS-M1', 'SHS-01', 'admin', '2026-09-24'),
(93, 'COD-SST-08', 'SST-08', 'admin', '2026-09-24'),
(94, 'COD-SST-09', 'SST-09', 'admin', '2026-09-24'),
(95, 'COD-HSM-08', 'HSM-08', 'admin', '2026-09-24'),
(96, 'COD-HSM-09', 'HSM-09', 'admin', '2026-09-24'),
(97, 'COD-SEN-06', 'SEN-06', 'admin', '2026-09-24'),
(98, 'COD-SEN-07', 'SEN-07', 'admin', '2026-09-24'),
(99, 'COD-SHS-06', 'SHS-06', 'admin', '2026-09-24'),
(100, 'COD-SHS-07', 'SHS-07', 'admin', '2026-09-24'),
(101, 'COD-SPA-03', 'SPA-03', 'admin', '2026-09-24'),
(102, 'COD-SPA-04', 'SPA-04', 'admin', '2026-09-24'),
(103, 'COD-SSH-05', 'SSH-05', 'admin', '2026-09-24'),
(104, 'COD-SSH-06', 'SSH-06', 'admin', '2026-09-24'),
(105, 'COD-SST-10', 'SST-10', 'admin', '2026-09-24'),
(106, 'COD-SST-11', 'SST-11', 'admin', '2026-09-24'),
(107, 'COD-HSM-10', 'HSM-10', 'admin', '2026-09-24'),
(108, 'COD-HSM-11', 'HSM-11', 'admin', '2026-09-24'),
(109, 'COD-SEN-08', 'SEN-08', 'admin', '2026-09-24'),
(110, 'COD-SHS-08', 'SHS-08', 'admin', '2026-09-24'),
(111, 'COD-SST-01', 'SST-01', 'admin', '2026-09-24'),
(112, 'COD-SST-02', 'SST-02', 'admin', '2026-09-24'),
(113, 'COD-SST-03', 'SST-03', 'admin', '2026-09-24'),
(114, 'COD-SST-04', 'SST-04', 'admin', '2026-09-24'),
(115, 'COD-SST-05', 'SST-05', 'admin', '2026-09-24'),
(116, 'COD-SST-06', 'SST-06', 'admin', '2026-09-24'),
(117, 'COD-SST-07', 'SST-07', 'admin', '2026-09-24'),
(118, 'COD-HSM-01', 'HSM-01', 'admin', '2026-09-24'),
(119, 'COD-HSM-02', 'HSM-02', 'admin', '2026-09-24'),
(120, 'COD-HSM-03', 'HSM-03', 'admin', '2026-09-24'),
(121, 'COD-HSM-04', 'HSM-04', 'admin', '2026-09-24'),
(122, 'COD-HSM-05', 'HSM-05', 'admin', '2026-09-24'),
(123, 'COD-HSM-06', 'HSM-06', 'admin', '2026-09-24'),
(124, 'COD-HSM-07', 'HSM-07', 'admin', '2026-09-24'),
(125, 'COD-SEN-01', 'SEN-01', 'admin', '2026-09-24'),
(126, 'COD-SEN-02', 'SEN-02', 'admin', '2026-09-24'),
(127, 'COD-SEN-03', 'SEN-03', 'admin', '2026-09-24'),
(128, 'COD-SEN-04', 'SEN-04', 'admin', '2026-09-24'),
(129, 'COD-SEN-05', 'SEN-05', 'admin', '2026-09-24'),
(130, 'COD-SHS-01', 'SHS-01', 'admin', '2026-09-24'),
(131, 'COD-SHS-02', 'SHS-02', 'admin', '2026-09-24'),
(132, 'COD-SHS-03', 'SHS-03', 'admin', '2026-09-24'),
(133, 'COD-SHS-04', 'SHS-04', 'admin', '2026-09-24'),
(134, 'COD-SHS-05', 'SHS-05', 'admin', '2026-09-24'),
(135, 'COD-SPA-01', 'SPA-01', 'admin', '2026-09-24'),
(136, 'COD-SPA-02', 'SPA-02', 'admin', '2026-09-24'),
(137, 'COD-SSH-01', 'SSH-01', 'admin', '2026-09-24'),
(138, 'COD-SSH-02', 'SSH-02', 'admin', '2026-09-24'),
(139, 'COD-SSH-03', 'SSH-03', 'admin', '2026-09-24'),
(140, 'COD-SSH-04', 'SSH-04', 'admin', '2026-09-24'),
(141, 'COD-SST-E1', 'SST-01', 'admin', '2026-09-24'),
(142, 'COD-SST-E2', 'SST-02', 'admin', '2026-09-24'),
(143, 'COD-SST-M1', 'SST-03', 'admin', '2026-09-24'),
(144, 'COD-HSM-E1', 'HSM-01', 'admin', '2026-09-24'),
(145, 'COD-HSM-E2', 'HSM-02', 'admin', '2026-09-24'),
(146, 'COD-SEN-M1', 'SEN-01', 'admin', '2026-09-24'),
(147, 'COD-SHS-M1', 'SHS-01', 'admin', '2026-09-24'),
(148, 'COD-SST-08', 'SST-08', 'admin', '2026-09-24'),
(149, 'COD-SST-09', 'SST-09', 'admin', '2026-09-24'),
(150, 'COD-HSM-08', 'HSM-08', 'admin', '2026-09-24'),
(151, 'COD-HSM-09', 'HSM-09', 'admin', '2026-09-24'),
(152, 'COD-SEN-06', 'SEN-06', 'admin', '2026-09-24'),
(153, 'COD-SEN-07', 'SEN-07', 'admin', '2026-09-24'),
(154, 'COD-SHS-06', 'SHS-06', 'admin', '2026-09-24'),
(155, 'COD-SHS-07', 'SHS-07', 'admin', '2026-09-24'),
(156, 'COD-SPA-03', 'SPA-03', 'admin', '2026-09-24'),
(157, 'COD-SPA-04', 'SPA-04', 'admin', '2026-09-24'),
(158, 'COD-SSH-05', 'SSH-05', 'admin', '2026-09-24'),
(159, 'COD-SSH-06', 'SSH-06', 'admin', '2026-09-24'),
(160, 'COD-SST-10', 'SST-10', 'admin', '2026-09-24'),
(161, 'COD-SST-11', 'SST-11', 'admin', '2026-09-24'),
(162, 'COD-HSM-10', 'HSM-10', 'admin', '2026-09-24'),
(163, 'COD-HSM-11', 'HSM-11', 'admin', '2026-09-24'),
(164, 'COD-SEN-08', 'SEN-08', 'admin', '2026-09-24'),
(165, 'COD-SHS-08', 'SHS-08', 'admin', '2026-09-24');

-- --------------------------------------------------------

--
-- Table structure for table `coordiantor`
--

CREATE TABLE `coordiantor` (
  `cid` int(11) NOT NULL,
  `ccode` varchar(255) DEFAULT NULL,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) NOT NULL,
  `gender` varchar(200) NOT NULL,
  `email` varchar(255) NOT NULL,
  `pass` varchar(200) NOT NULL,
  `contactno` varchar(255) NOT NULL,
  `depcode` varchar(255) DEFAULT NULL,
  `depname` varchar(255) DEFAULT NULL,
  `depschool` varchar(255) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `createdon` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coordiantor`
--

INSERT INTO `coordiantor` (`cid`, `ccode`, `FirstName`, `LastName`, `gender`, `email`, `pass`, `contactno`, `depcode`, `depname`, `depschool`, `createdby`, `createdon`) VALUES
(1, '23623', 'Rana Marwat ', 'Hussain', 'Male', '23623@umt.edu.pk', '3b712de48137572f3849aabd5666a4e3', '03204821306', '-', '-', '-', 'Administrator-admin', '2025-09-27 04:10:36'),
(2, 'C-SST-01', 'Zeeshan', 'Shaukat', 'Male', 'zeeshan.shaukat@umt.edu.pk', 'coordSst01', '03214111001', 'SST-01', 'Computer Science', 'SST', 'admin', '2026-09-24'),
(3, 'C-SST-02', 'Amna', 'Iftikhar', 'Female', 'amna.iftikhar@umt.edu.pk', 'coordSst02', '03214111002', 'SST-02', 'Software Engineering', 'SST', 'admin', '2026-09-24'),
(4, 'C-SST-03', 'Ali', 'Raza', 'Male', 'ali.raza@umt.edu.pk', 'coordSst03', '03214111003', 'SST-03', 'Data Science', 'SST', 'admin', '2026-09-24'),
(5, 'C-SST-04', 'Saba', 'Bashir', 'Female', 'saba.bashir@umt.edu.pk', 'coordSst04', '03214111004', 'SST-04', 'Artificial Intelligence', 'SST', 'admin', '2026-09-24'),
(6, 'C-SST-05', 'Noman', 'Abid', 'Male', 'noman.abid@umt.edu.pk', 'coordSst05', '03214111005', 'SST-05', 'Information Technology', 'SST', 'admin', '2026-09-24'),
(7, 'C-SST-06', 'Hina', 'Fatima', 'Female', 'hina.fatima@umt.edu.pk', 'coordSst06', '03214111006', 'SST-06', 'Cyber Security', 'SST', 'admin', '2026-09-24'),
(8, 'C-SST-07', 'Usman', 'Aslam', 'Male', 'usman.aslam@umt.edu.pk', 'coordSst07', '03214111007', 'SST-07', 'Informatics', 'SST', 'admin', '2026-09-24'),
(9, 'C-HSM-01', 'Faisal', 'Nadeem', 'Male', 'faisal.nadeem@umt.edu.pk', 'coordHsm01', '03214111008', 'HSM-01', 'Management', 'HSM', 'admin', '2026-09-24'),
(10, 'C-HSM-02', 'Sadia', 'Siddique', 'Female', 'sadia.siddique@umt.edu.pk', 'coordHsm02', '03214111009', 'HSM-02', 'Marketing', 'HSM', 'admin', '2026-09-24'),
(11, 'C-HSM-03', 'Bilal', 'Hassan', 'Male', 'bilal.hassan@umt.edu.pk', 'coordHsm03', '03214111010', 'HSM-03', 'Finance', 'HSM', 'admin', '2026-09-24'),
(12, 'C-HSM-04', 'Maria', 'Javed', 'Female', 'maria.javed@umt.edu.pk', 'coordHsm04', '03214111011', 'HSM-04', 'Human Resource', 'HSM', 'admin', '2026-09-24'),
(13, 'C-HSM-05', 'Kamran', 'Mehmood', 'Male', 'kamran.mehmood@umt.edu.pk', 'coordHsm05', '03214111012', 'HSM-05', 'Supply Chain', 'HSM', 'admin', '2026-09-24'),
(14, 'C-HSM-06', 'Zoya', 'Malik', 'Female', 'zoya.malik@umt.edu.pk', 'coordHsm06', '03214111013', 'HSM-06', 'Economics', 'HSM', 'admin', '2026-09-24'),
(15, 'C-SEN-01', 'Haroon', 'Akram', 'Male', 'haroon.akram@umt.edu.pk', 'coordSen01', '03214111014', 'SEN-01', 'Electrical Engineering', 'SEN', 'admin', '2026-09-24'),
(16, 'C-SEN-02', 'Iqra', 'Tariq', 'Female', 'iqra.tariq@umt.edu.pk', 'coordSen02', '03214111015', 'SEN-02', 'Mechanical Engineering', 'SEN', 'admin', '2026-09-24'),
(17, 'C-SEN-03', 'Waqas', 'Ahmad', 'Male', 'waqas.ahmad@umt.edu.pk', 'coordSen03', '03214111016', 'SEN-03', 'Civil Engineering', 'SEN', 'admin', '2026-09-24'),
(18, 'C-SEN-04', 'Ayesha', 'Rehman', 'Female', 'ayesha.rehman@umt.edu.pk', 'coordSen04', '03214111017', 'SEN-04', 'Industrial Engineering', 'SEN', 'admin', '2026-09-24'),
(19, 'C-SEN-05', 'Tanveer', 'Hussain', 'Male', 'tanveer.hussain@umt.edu.pk', 'coordSen05', '03214111018', 'SEN-05', 'Textile Engineering', 'SEN', 'admin', '2026-09-24'),
(20, 'C-SHS-01', 'Dr. Atif', 'Mehmood', 'Male', 'atif.mehmood@umt.edu.pk', 'coordShs01', '03214111019', 'SHS-01', 'Physical Therapy', 'SHS', 'admin', '2026-09-24'),
(21, 'C-SHS-02', 'Dr. Maryam', 'Khan', 'Female', 'maryam.khan@umt.edu.pk', 'coordShs02', '03214111020', 'SHS-02', 'Nutrition Sciences', 'SHS', 'admin', '2026-09-24'),
(22, 'C-SHS-03', 'Dr. Shahzad', 'Anwar', 'Male', 'shahzad.anwar@umt.edu.pk', 'coordShs03', '03214111021', 'SHS-03', 'Imaging Technology', 'SHS', 'admin', '2026-09-24'),
(23, 'C-SHS-04', 'Dr. Fouzia', 'Aslam', 'Female', 'fouzia.aslam@umt.edu.pk', 'coordShs04', '03214111022', 'SHS-04', 'Lab Sciences', 'SHS', 'admin', '2026-09-24'),
(24, 'C-SPA-01', 'Mudassir', 'Riaz', 'Male', 'mudassir.riaz@umt.edu.pk', 'coordSpa01', '03214111023', 'SPA-01', 'Architecture', 'SPA', 'admin', '2026-09-24'),
(25, 'C-SPA-02', 'Rimsha', 'Arshad', 'Female', 'rimsha.arshad@umt.edu.pk', 'coordSpa02', '03214111024', 'SPA-02', 'City Planning', 'SPA', 'admin', '2026-09-24'),
(26, 'C-SST-E1', 'Hamza', 'Shahid', 'Male', 'hamza.shahid@umt.edu.pk', 'coordSst08', '03214111025', 'SST-01', 'Computer Science (Evening)', 'SST', 'admin', '2026-09-24'),
(27, 'C-SST-E2', 'Kiran', 'Sultan', 'Female', 'kiran.sultan@umt.edu.pk', 'coordSst09', '03214111026', 'SST-02', 'Software Engineering (Evening)', 'SST', 'admin', '2026-09-24'),
(28, 'C-SST-M1', 'Adeel', 'Akram', 'Male', 'adeel.akram@umt.edu.pk', 'coordSst10', '03214111027', 'SST-03', 'Data Science (MS)', 'SST', 'admin', '2026-09-24'),
(29, 'C-HSM-E1', 'Sobia', 'Tariq', 'Female', 'sobia.tariq@umt.edu.pk', 'coordHsm07', '03214111028', 'HSM-01', 'Executive MBA', 'HSM', 'admin', '2026-09-24'),
(30, 'C-SEN-M1', 'Shoaib', 'Zafar', 'Male', 'shoaib.zafar@umt.edu.pk', 'coordSen06', '03214111029', 'SEN-01', 'Electrical MS', 'SEN', 'admin', '2026-09-24'),
(31, 'C-SST-08', 'Kashif', 'Idrees', 'Male', 'kashif.idrees@umt.edu.pk', 'coordSst11', '03214111030', 'SST-08', 'Internet of Things', 'SST', 'admin', '2026-09-24'),
(32, 'C-SST-09', 'Tehreem', 'Ghias', 'Female', 'tehreem.ghias@umt.edu.pk', 'coordSst12', '03214111031', 'SST-09', 'Cloud Computing', 'SST', 'admin', '2026-09-24'),
(33, 'C-HSM-07', 'Ahsan', 'Bashir', 'Male', 'ahsan.bashir@umt.edu.pk', 'coordHsm08', '03214111032', 'HSM-07', 'Business Analytics', 'HSM', 'admin', '2026-09-24'),
(34, 'C-HSM-08', 'Bushra', 'Latif', 'Female', 'bushra.latif@umt.edu.pk', 'coordHsm09', '03214111033', 'HSM-08', 'Entrepreneurship', 'HSM', 'admin', '2026-09-24'),
(35, 'C-SEN-06', 'Sohail', 'Abbas', 'Male', 'sohail.abbas@umt.edu.pk', 'coordSen07', '03214111034', 'SEN-06', 'Mechatronics', 'SEN', 'admin', '2026-09-24'),
(36, 'C-SHS-05', 'Taimoor', 'Muneer', 'Male', 'taimoor.muneer@umt.edu.pk', 'coordShs05', '03214111035', 'SHS-05', 'Public Health', 'SHS', 'admin', '2026-09-24'),
(37, 'C-SST-10', 'Fiza', 'Zahid', 'Female', 'fiza.zahid@umt.edu.pk', 'coordSst13', '03214111036', 'SST-10', 'Game Production', 'SST', 'admin', '2026-09-24'),
(38, 'C-SST-11', 'Mubashir', 'Ali', 'Male', 'mubashir.ali@umt.edu.pk', 'coordSst14', '03214111037', 'SST-11', 'Quantum Computing', 'SST', 'admin', '2026-09-24'),
(39, 'C-HSM-09', 'Kinza', 'Shahzadi', 'Female', 'kinza.shahzadi@umt.edu.pk', 'coordHsm10', '03214111038', 'HSM-09', 'Project Management', 'HSM', 'admin', '2026-09-24'),
(40, 'C-SEN-07', 'Omer', 'Mahmood', 'Male', 'omer.mahmood@umt.edu.pk', 'coordSen08', '03214111039', 'SEN-07', 'Materials Science', 'SEN', 'admin', '2026-09-24'),
(41, 'C-SHS-06', 'Faiza', 'Anwar', 'Female', 'faiza.anwar@umt.edu.pk', 'coordShs06', '03214111040', 'SHS-06', 'Optometry', 'SHS', 'admin', '2026-09-24'),
(42, 'C-SST-12', 'Tayyab', 'Shafi', 'Male', 'tayyab.shafi@umt.edu.pk', 'coordSst15', '03214111041', 'SST-01', 'Computer Science', 'SST', 'admin', '2026-09-24'),
(43, 'C-SST-13', 'Sadia', 'Rasheed', 'Female', 'sadia.rasheed@umt.edu.pk', 'coordSst16', '03214111042', 'SST-02', 'Software Engineering', 'SST', 'admin', '2026-09-24'),
(44, 'C-HSM-10', 'Junaid', 'Kanwal', 'Male', 'junaid.kanwal@umt.edu.pk', 'coordHsm11', '03214111043', 'HSM-01', 'Management', 'HSM', 'admin', '2026-09-24'),
(45, 'C-HSM-11', 'Mehak', 'Naureen', 'Female', 'mehak.naureen@umt.edu.pk', 'coordHsm12', '03214111044', 'HSM-02', 'Marketing', 'HSM', 'admin', '2026-09-24'),
(46, 'C-SEN-08', 'Rizwan', 'Hussain', 'Male', 'rizwan.hussain@umt.edu.pk', 'coordSen09', '03214111045', 'SEN-01', 'Electrical Engineering', 'SEN', 'admin', '2026-09-24'),
(47, 'C-SHS-07', 'Shazia', 'Iftikhar', 'Female', 'shazia.iftikhar@umt.edu.pk', 'coordShs07', '03214111046', 'SHS-01', 'Physical Therapy', 'SHS', 'admin', '2026-09-24'),
(48, 'C-SST-14', 'Kamran', 'Arshad', 'Male', 'kamran.arshad@umt.edu.pk', 'coordSst17', '03214111047', 'SST-04', 'Artificial Intelligence', 'SST', 'admin', '2026-09-24'),
(49, 'C-SST-15', 'Aalia', 'Akhtar', 'Female', 'aalia.akhtar@umt.edu.pk', 'coordSst18', '03214111048', 'SST-05', 'Information Technology', 'SST', 'admin', '2026-09-24'),
(50, 'C-HSM-12', 'Adnan', 'Ahmed', 'Male', 'adnan.ahmed2@umt.edu.pk', 'coordHsm13', '03214111049', 'HSM-03', 'Finance', 'HSM', 'admin', '2026-09-24'),
(51, 'C-SEN-09', 'Sobia', 'Ghias', 'Female', 'sobia.ghias@umt.edu.pk', 'coordSen10', '03214111050', 'SEN-02', 'Mechanical Engineering', 'SEN', 'admin', '2026-09-24'),
(52, 'C-SST-01', 'Zeeshan', 'Shaukat', 'Male', 'zeeshan.shaukat@umt.edu.pk', 'coordSst01', '03214111001', 'SST-01', 'Computer Science', 'SST', 'admin', '2026-09-24'),
(53, 'C-SST-02', 'Amna', 'Iftikhar', 'Female', 'amna.iftikhar@umt.edu.pk', 'coordSst02', '03214111002', 'SST-02', 'Software Engineering', 'SST', 'admin', '2026-09-24'),
(54, 'C-SST-03', 'Ali', 'Raza', 'Male', 'ali.raza@umt.edu.pk', 'coordSst03', '03214111003', 'SST-03', 'Data Science', 'SST', 'admin', '2026-09-24'),
(55, 'C-SST-04', 'Saba', 'Bashir', 'Female', 'saba.bashir@umt.edu.pk', 'coordSst04', '03214111004', 'SST-04', 'Artificial Intelligence', 'SST', 'admin', '2026-09-24'),
(56, 'C-SST-05', 'Noman', 'Abid', 'Male', 'noman.abid@umt.edu.pk', 'coordSst05', '03214111005', 'SST-05', 'Information Technology', 'SST', 'admin', '2026-09-24'),
(57, 'C-SST-06', 'Hina', 'Fatima', 'Female', 'hina.fatima@umt.edu.pk', 'coordSst06', '03214111006', 'SST-06', 'Cyber Security', 'SST', 'admin', '2026-09-24'),
(58, 'C-SST-07', 'Usman', 'Aslam', 'Male', 'usman.aslam@umt.edu.pk', 'coordSst07', '03214111007', 'SST-07', 'Informatics', 'SST', 'admin', '2026-09-24'),
(59, 'C-HSM-01', 'Faisal', 'Nadeem', 'Male', 'faisal.nadeem@umt.edu.pk', 'coordHsm01', '03214111008', 'HSM-01', 'Management', 'HSM', 'admin', '2026-09-24'),
(60, 'C-HSM-02', 'Sadia', 'Siddique', 'Female', 'sadia.siddique@umt.edu.pk', 'coordHsm02', '03214111009', 'HSM-02', 'Marketing', 'HSM', 'admin', '2026-09-24'),
(61, 'C-HSM-03', 'Bilal', 'Hassan', 'Male', 'bilal.hassan@umt.edu.pk', 'coordHsm03', '03214111010', 'HSM-03', 'Finance', 'HSM', 'admin', '2026-09-24'),
(62, 'C-HSM-04', 'Maria', 'Javed', 'Female', 'maria.javed@umt.edu.pk', 'coordHsm04', '03214111011', 'HSM-04', 'Human Resource', 'HSM', 'admin', '2026-09-24'),
(63, 'C-HSM-05', 'Kamran', 'Mehmood', 'Male', 'kamran.mehmood@umt.edu.pk', 'coordHsm05', '03214111012', 'HSM-05', 'Supply Chain', 'HSM', 'admin', '2026-09-24'),
(64, 'C-HSM-06', 'Zoya', 'Malik', 'Female', 'zoya.malik@umt.edu.pk', 'coordHsm06', '03214111013', 'HSM-06', 'Economics', 'HSM', 'admin', '2026-09-24'),
(65, 'C-SEN-01', 'Haroon', 'Akram', 'Male', 'haroon.akram@umt.edu.pk', 'coordSen01', '03214111014', 'SEN-01', 'Electrical Engineering', 'SEN', 'admin', '2026-09-24'),
(66, 'C-SEN-02', 'Iqra', 'Tariq', 'Female', 'iqra.tariq@umt.edu.pk', 'coordSen02', '03214111015', 'SEN-02', 'Mechanical Engineering', 'SEN', 'admin', '2026-09-24'),
(67, 'C-SEN-03', 'Waqas', 'Ahmad', 'Male', 'waqas.ahmad@umt.edu.pk', 'coordSen03', '03214111016', 'SEN-03', 'Civil Engineering', 'SEN', 'admin', '2026-09-24'),
(68, 'C-SEN-04', 'Ayesha', 'Rehman', 'Female', 'ayesha.rehman@umt.edu.pk', 'coordSen04', '03214111017', 'SEN-04', 'Industrial Engineering', 'SEN', 'admin', '2026-09-24'),
(69, 'C-SEN-05', 'Tanveer', 'Hussain', 'Male', 'tanveer.hussain@umt.edu.pk', 'coordSen05', '03214111018', 'SEN-05', 'Textile Engineering', 'SEN', 'admin', '2026-09-24'),
(70, 'C-SHS-01', 'Dr. Atif', 'Mehmood', 'Male', 'atif.mehmood@umt.edu.pk', 'coordShs01', '03214111019', 'SHS-01', 'Physical Therapy', 'SHS', 'admin', '2026-09-24'),
(71, 'C-SHS-02', 'Dr. Maryam', 'Khan', 'Female', 'maryam.khan@umt.edu.pk', 'coordShs02', '03214111020', 'SHS-02', 'Nutrition Sciences', 'SHS', 'admin', '2026-09-24'),
(72, 'C-SHS-03', 'Dr. Shahzad', 'Anwar', 'Male', 'shahzad.anwar@umt.edu.pk', 'coordShs03', '03214111021', 'SHS-03', 'Imaging Technology', 'SHS', 'admin', '2026-09-24'),
(73, 'C-SHS-04', 'Dr. Fouzia', 'Aslam', 'Female', 'fouzia.aslam@umt.edu.pk', 'coordShs04', '03214111022', 'SHS-04', 'Lab Sciences', 'SHS', 'admin', '2026-09-24'),
(74, 'C-SPA-01', 'Mudassir', 'Riaz', 'Male', 'mudassir.riaz@umt.edu.pk', 'coordSpa01', '03214111023', 'SPA-01', 'Architecture', 'SPA', 'admin', '2026-09-24'),
(75, 'C-SPA-02', 'Rimsha', 'Arshad', 'Female', 'rimsha.arshad@umt.edu.pk', 'coordSpa02', '03214111024', 'SPA-02', 'City Planning', 'SPA', 'admin', '2026-09-24'),
(76, 'C-SST-E1', 'Hamza', 'Shahid', 'Male', 'hamza.shahid@umt.edu.pk', 'coordSst08', '03214111025', 'SST-01', 'Computer Science (Evening)', 'SST', 'admin', '2026-09-24'),
(77, 'C-SST-E2', 'Kiran', 'Sultan', 'Female', 'kiran.sultan@umt.edu.pk', 'coordSst09', '03214111026', 'SST-02', 'Software Engineering (Evening)', 'SST', 'admin', '2026-09-24'),
(78, 'C-SST-M1', 'Adeel', 'Akram', 'Male', 'adeel.akram@umt.edu.pk', 'coordSst10', '03214111027', 'SST-03', 'Data Science (MS)', 'SST', 'admin', '2026-09-24'),
(79, 'C-HSM-E1', 'Sobia', 'Tariq', 'Female', 'sobia.tariq@umt.edu.pk', 'coordHsm07', '03214111028', 'HSM-01', 'Executive MBA', 'HSM', 'admin', '2026-09-24'),
(80, 'C-SEN-M1', 'Shoaib', 'Zafar', 'Male', 'shoaib.zafar@umt.edu.pk', 'coordSen06', '03214111029', 'SEN-01', 'Electrical MS', 'SEN', 'admin', '2026-09-24'),
(81, 'C-SST-08', 'Kashif', 'Idrees', 'Male', 'kashif.idrees@umt.edu.pk', 'coordSst11', '03214111030', 'SST-08', 'Internet of Things', 'SST', 'admin', '2026-09-24'),
(82, 'C-SST-09', 'Tehreem', 'Ghias', 'Female', 'tehreem.ghias@umt.edu.pk', 'coordSst12', '03214111031', 'SST-09', 'Cloud Computing', 'SST', 'admin', '2026-09-24'),
(83, 'C-HSM-07', 'Ahsan', 'Bashir', 'Male', 'ahsan.bashir@umt.edu.pk', 'coordHsm08', '03214111032', 'HSM-07', 'Business Analytics', 'HSM', 'admin', '2026-09-24'),
(84, 'C-HSM-08', 'Bushra', 'Latif', 'Female', 'bushra.latif@umt.edu.pk', 'coordHsm09', '03214111033', 'HSM-08', 'Entrepreneurship', 'HSM', 'admin', '2026-09-24'),
(85, 'C-SEN-06', 'Sohail', 'Abbas', 'Male', 'sohail.abbas@umt.edu.pk', 'coordSen07', '03214111034', 'SEN-06', 'Mechatronics', 'SEN', 'admin', '2026-09-24'),
(86, 'C-SHS-05', 'Taimoor', 'Muneer', 'Male', 'taimoor.muneer@umt.edu.pk', 'coordShs05', '03214111035', 'SHS-05', 'Public Health', 'SHS', 'admin', '2026-09-24'),
(87, 'C-SST-10', 'Fiza', 'Zahid', 'Female', 'fiza.zahid@umt.edu.pk', 'coordSst13', '03214111036', 'SST-10', 'Game Production', 'SST', 'admin', '2026-09-24'),
(88, 'C-SST-11', 'Mubashir', 'Ali', 'Male', 'mubashir.ali@umt.edu.pk', 'coordSst14', '03214111037', 'SST-11', 'Quantum Computing', 'SST', 'admin', '2026-09-24'),
(89, 'C-HSM-09', 'Kinza', 'Shahzadi', 'Female', 'kinza.shahzadi@umt.edu.pk', 'coordHsm10', '03214111038', 'HSM-09', 'Project Management', 'HSM', 'admin', '2026-09-24'),
(90, 'C-SEN-07', 'Omer', 'Mahmood', 'Male', 'omer.mahmood@umt.edu.pk', 'coordSen08', '03214111039', 'SEN-07', 'Materials Science', 'SEN', 'admin', '2026-09-24'),
(91, 'C-SHS-06', 'Faiza', 'Anwar', 'Female', 'faiza.anwar@umt.edu.pk', 'coordShs06', '03214111040', 'SHS-06', 'Optometry', 'SHS', 'admin', '2026-09-24'),
(92, 'C-SST-12', 'Tayyab', 'Shafi', 'Male', 'tayyab.shafi@umt.edu.pk', 'coordSst15', '03214111041', 'SST-01', 'Computer Science', 'SST', 'admin', '2026-09-24'),
(93, 'C-SST-13', 'Sadia', 'Rasheed', 'Female', 'sadia.rasheed@umt.edu.pk', 'coordSst16', '03214111042', 'SST-02', 'Software Engineering', 'SST', 'admin', '2026-09-24'),
(94, 'C-HSM-10', 'Junaid', 'Kanwal', 'Male', 'junaid.kanwal@umt.edu.pk', 'coordHsm11', '03214111043', 'HSM-01', 'Management', 'HSM', 'admin', '2026-09-24'),
(95, 'C-HSM-11', 'Mehak', 'Naureen', 'Female', 'mehak.naureen@umt.edu.pk', 'coordHsm12', '03214111044', 'HSM-02', 'Marketing', 'HSM', 'admin', '2026-09-24'),
(96, 'C-SEN-08', 'Rizwan', 'Hussain', 'Male', 'rizwan.hussain@umt.edu.pk', 'coordSen09', '03214111045', 'SEN-01', 'Electrical Engineering', 'SEN', 'admin', '2026-09-24'),
(97, 'C-SHS-07', 'Shazia', 'Iftikhar', 'Female', 'shazia.iftikhar@umt.edu.pk', 'coordShs07', '03214111046', 'SHS-01', 'Physical Therapy', 'SHS', 'admin', '2026-09-24'),
(98, 'C-SST-14', 'Kamran', 'Arshad', 'Male', 'kamran.arshad@umt.edu.pk', 'coordSst17', '03214111047', 'SST-04', 'Artificial Intelligence', 'SST', 'admin', '2026-09-24'),
(99, 'C-SST-15', 'Aalia', 'Akhtar', 'Female', 'aalia.akhtar@umt.edu.pk', 'coordSst18', '03214111048', 'SST-05', 'Information Technology', 'SST', 'admin', '2026-09-24'),
(100, 'C-HSM-12', 'Adnan', 'Ahmed', 'Male', 'adnan.ahmed2@umt.edu.pk', 'coordHsm13', '03214111049', 'HSM-03', 'Finance', 'HSM', 'admin', '2026-09-24'),
(101, 'C-SEN-09', 'Sobia', 'Ghias', 'Female', 'sobia.ghias@umt.edu.pk', 'coordSen10', '03214111050', 'SEN-02', 'Mechanical Engineering', 'SEN', 'admin', '2026-09-24');

-- --------------------------------------------------------

--
-- Table structure for table `coordiantor_assigndep`
--

CREATE TABLE `coordiantor_assigndep` (
  `aid` int(11) NOT NULL,
  `ccode` varchar(255) NOT NULL,
  `depcode` varchar(255) DEFAULT NULL,
  `createdby` varchar(200) NOT NULL,
  `creadedon` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coordiantor_assigndep`
--

INSERT INTO `coordiantor_assigndep` (`aid`, `ccode`, `depcode`, `createdby`, `creadedon`) VALUES
(1, '23623', '001', 'Administrator-admin', '2025-09-27 04:10:42'),
(2, 'C-SST-01', 'SST-01', 'admin', '2026-09-24'),
(3, 'C-SST-02', 'SST-02', 'admin', '2026-09-24'),
(4, 'C-SST-03', 'SST-03', 'admin', '2026-09-24'),
(5, 'C-SST-04', 'SST-04', 'admin', '2026-09-24'),
(6, 'C-SST-05', 'SST-05', 'admin', '2026-09-24'),
(7, 'C-SST-06', 'SST-06', 'admin', '2026-09-24'),
(8, 'C-SST-07', 'SST-07', 'admin', '2026-09-24'),
(9, 'C-HSM-01', 'HSM-01', 'admin', '2026-09-24'),
(10, 'C-HSM-02', 'HSM-02', 'admin', '2026-09-24'),
(11, 'C-HSM-03', 'HSM-03', 'admin', '2026-09-24'),
(12, 'C-HSM-04', 'HSM-04', 'admin', '2026-09-24'),
(13, 'C-HSM-05', 'HSM-05', 'admin', '2026-09-24'),
(14, 'C-HSM-06', 'HSM-06', 'admin', '2026-09-24'),
(15, 'C-SEN-01', 'SEN-01', 'admin', '2026-09-24'),
(16, 'C-SEN-02', 'SEN-02', 'admin', '2026-09-24'),
(17, 'C-SEN-03', 'SEN-03', 'admin', '2026-09-24'),
(18, 'C-SEN-04', 'SEN-04', 'admin', '2026-09-24'),
(19, 'C-SEN-05', 'SEN-05', 'admin', '2026-09-24'),
(20, 'C-SHS-01', 'SHS-01', 'admin', '2026-09-24'),
(21, 'C-SHS-02', 'SHS-02', 'admin', '2026-09-24'),
(22, 'C-SHS-03', 'SHS-03', 'admin', '2026-09-24'),
(23, 'C-SHS-04', 'SHS-04', 'admin', '2026-09-24'),
(24, 'C-SPA-01', 'SPA-01', 'admin', '2026-09-24'),
(25, 'C-SPA-02', 'SPA-02', 'admin', '2026-09-24'),
(26, 'C-SST-E1', 'SST-01', 'admin', '2026-09-24'),
(27, 'C-SST-E2', 'SST-02', 'admin', '2026-09-24'),
(28, 'C-SST-M1', 'SST-03', 'admin', '2026-09-24'),
(29, 'C-HSM-E1', 'HSM-01', 'admin', '2026-09-24'),
(30, 'C-SEN-M1', 'SEN-01', 'admin', '2026-09-24'),
(31, 'C-SST-08', 'SST-08', 'admin', '2026-09-24'),
(32, 'C-SST-09', 'SST-09', 'admin', '2026-09-24'),
(33, 'C-HSM-07', 'HSM-07', 'admin', '2026-09-24'),
(34, 'C-HSM-08', 'HSM-08', 'admin', '2026-09-24'),
(35, 'C-SEN-06', 'SEN-06', 'admin', '2026-09-24'),
(36, 'C-SHS-05', 'SHS-05', 'admin', '2026-09-24'),
(37, 'C-SST-10', 'SST-10', 'admin', '2026-09-24'),
(38, 'C-SST-11', 'SST-11', 'admin', '2026-09-24'),
(39, 'C-HSM-09', 'HSM-09', 'admin', '2026-09-24'),
(40, 'C-SEN-07', 'SEN-07', 'admin', '2026-09-24'),
(41, 'C-SHS-06', 'SHS-06', 'admin', '2026-09-24'),
(42, 'C-SST-12', 'SST-01', 'admin', '2026-09-24'),
(43, 'C-SST-13', 'SST-02', 'admin', '2026-09-24'),
(44, 'C-HSM-10', 'HSM-01', 'admin', '2026-09-24'),
(45, 'C-HSM-11', 'HSM-02', 'admin', '2026-09-24'),
(46, 'C-SEN-08', 'SEN-01', 'admin', '2026-09-24'),
(47, 'C-SHS-07', 'SHS-01', 'admin', '2026-09-24'),
(48, 'C-SST-14', 'SST-04', 'admin', '2026-09-24'),
(49, 'C-SST-15', 'SST-05', 'admin', '2026-09-24'),
(50, 'C-HSM-12', 'HSM-03', 'admin', '2026-09-24'),
(51, 'C-SEN-09', 'SEN-02', 'admin', '2026-09-24');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `cid` int(11) NOT NULL,
  `coursecode` varchar(255) NOT NULL,
  `courseName` varchar(255) DEFAULT NULL,
  `coursesection` varchar(500) NOT NULL,
  `createdby` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`cid`, `coursecode`, `courseName`, `coursesection`, `createdby`) VALUES
(3, 'CS3022', 'Civic Educaiton  ', '-', '23623'),
(4, '1212', 'ICFCS ', '-', '23623'),
(5, 'CC432', 'thoeyr of automata ', '-', '23623'),
(6, 'CS110', 'Programming Fundamentals', '-', '23623'),
(7, 'CS210', 'Object Oriented Programming', '-', '23623'),
(8, 'CS220', 'Data Structures and Algorithms', '-', '23623'),
(9, 'CS321', 'Database Systems', '-', '23623'),
(10, 'CS351', 'Software Engineering Principles', '-', '23623'),
(11, 'CS452', 'Web Application Development', '-', '23623'),
(12, 'CS411', 'Artificial Intelligence', '-', '23623'),
(13, 'CS481', 'Introduction to Data Science', '-', '23623'),
(14, 'CS415', 'Machine Learning Foundations', '-', '23623'),
(15, 'CS382', 'Information Security', '-', '23623'),
(16, 'CS312', 'Analysis of Algorithms', '-', '23623'),
(17, 'CS422', 'Cloud Computing Architecture', '-', '23623'),
(18, 'CS431', 'Compiler Construction', '-', '23623'),
(19, 'CS471', 'Mobile Application Development', '-', '23623'),
(20, 'MGT101', 'Principles of Management', '-', '23623'),
(21, 'MKT211', 'Principles of Marketing', '-', '23623'),
(22, 'FIN301', 'Corporate Finance', '-', '23623'),
(23, 'HRM320', 'Human Resource Management', '-', '23623'),
(24, 'SCM410', 'Supply Chain Logistics', '-', '23623'),
(25, 'ECO110', 'Microeconomics', '-', '23623'),
(26, 'ECO210', 'Macroeconomics', '-', '23623'),
(27, 'MGT450', 'Strategic Business Analytics', '-', '23623'),
(28, 'MKT350', 'Digital Marketing Strategies', '-', '23623'),
(29, 'FIN420', 'Investment & Portfolio Management', '-', '23623'),
(30, 'EE110', 'Linear Circuit Analysis', '-', '23623'),
(31, 'EE221', 'Digital Logic Design', '-', '23623'),
(32, 'ME101', 'Engineering Mechanics', '-', '23623'),
(33, 'ME315', 'Fluid Mechanics', '-', '23623'),
(34, 'CE112', 'Engineering Surveying', '-', '23623'),
(35, 'CE320', 'Structural Analysis', '-', '23623'),
(36, 'IE211', 'Production Planning and Control', '-', '23623'),
(37, 'TE101', 'Introduction to Textile Technology', '-', '23623'),
(38, 'PT101', 'Introduction to Physical Therapy', '-', '23623'),
(39, 'NUT210', 'Fundamentals of Human Nutrition', '-', '23623'),
(40, 'PH401', 'Epidemiology and Public Health', '-', '23623');

-- --------------------------------------------------------

--
-- Table structure for table `courses_assign`
--

CREATE TABLE `courses_assign` (
  `assid` int(11) NOT NULL,
  `fcode` varchar(255) DEFAULT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `corsecode` varchar(255) DEFAULT NULL,
  `courseName` varchar(255) DEFAULT NULL,
  `coursesection` varchar(255) DEFAULT NULL,
  `session` varchar(500) NOT NULL,
  `assignedby` varchar(255) DEFAULT NULL,
  `folderstatus` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `courses_assign`
--

INSERT INTO `courses_assign` (`assid`, `fcode`, `firstname`, `lastname`, `corsecode`, `courseName`, `coursesection`, `session`, `assignedby`, `folderstatus`) VALUES
(16, '23623', 'RANA MARWAT  ', 'Hussain', 'CS3022', 'Civic Educaiton  ', 'V21', 'SPRING2026', '23623', '0'),
(17, '1122', 'ali ', 'khan', '1212', 'ICFCS ', 'V21', 'SPRING2026', '23623', '1'),
(18, '23623', 'RANA MARWAT   ', 'Hussain', 'CC432', 'thoeyr of automata ', 'V22', 'SPRING2026', '23623', '0'),
(19, 'F-SST-001', 'KAMRAN', 'Ali', 'CS110', 'Programming Fundamentals', 'V21', 'SPRING2026', '23623', '1'),
(20, 'F-SST-002', 'YASSER', 'Arafat', 'CS210', 'Object Oriented Programming', 'V21', 'SPRING2026', '23623', '0'),
(21, 'F-SST-003', 'ADNAN', 'Abid', 'CS220', 'Data Structures and Algorithms', 'V21', 'SPRING2026', '23623', '1'),
(22, 'F-SST-050', 'SHAHZAD', 'Sarwar', 'CS321', 'Database Systems', 'V21', 'SPRING2026', '23623', '1'),
(23, 'F-SST-004', 'SAJJAD', 'Hussain', 'CS351', 'Software Engineering Principles', 'V22', 'SPRING2026', '23623', '0'),
(24, 'F-SST-005', 'AMJAD', 'Iqbal', 'CS452', 'Web Application Development', 'V23', 'SPRING2026', '23623', '1'),
(25, 'F-SST-008', 'MUHAMMAD', 'Asif', 'CS411', 'Artificial Intelligence', 'V21', 'SPRING2026', '23623', '0'),
(26, 'F-SST-007', 'TAYYABA', 'Anees', 'CS481', 'Introduction to Data Science', 'V21', 'SPRING2026', '23623', '1'),
(27, 'F-SST-007', 'TAYYABA', 'Anees', 'CS415', 'Machine Learning Foundations', 'V22', 'SPRING2026', '23623', '0'),
(28, 'F-SST-010', 'MARIA', 'Anjum', 'CS382', 'Information Security', 'V24', 'SPRING2026', '23623', '1'),
(29, 'F-SST-003', 'ADNAN', 'Abid', 'CS312', 'Analysis of Algorithms', 'V21', 'SPRING2026', '23623', '1'),
(30, 'F-SST-035', 'OMER', 'Riaz', 'CS422', 'Cloud Computing Architecture', 'V21', 'SPRING2026', '23623', '0'),
(31, 'F-SST-001', 'KAMRAN', 'Ali', 'CS431', 'Compiler Construction', 'V22', 'SPRING2026', '23623', '1'),
(32, 'F-SST-009', 'NABEEL', 'Sabir', 'CS471', 'Mobile Application Development', 'V21', 'SPRING2026', '23623', '0'),
(33, 'F-HSM-011', 'NAVID', 'Jamil', 'MGT101', 'Principles of Management', 'V21', 'SPRING2026', '23623', '1'),
(34, 'F-HSM-013', 'RUKHSANA', 'Kausar', 'MKT211', 'Principles of Marketing', 'V21', 'SPRING2026', '23623', '1'),
(35, 'F-HSM-014', 'SHAHID', 'Hassan', 'FIN301', 'Corporate Finance', 'V21', 'SPRING2026', '23623', '0'),
(36, 'F-HSM-016', 'SADIA', 'Nadeem', 'HRM320', 'Human Resource Management', 'V22', 'SPRING2026', '23623', '1'),
(37, 'F-HSM-017', 'KAMRAN', 'Saeed', 'SCM410', 'Supply Chain Logistics', 'V21', 'SPRING2026', '23623', '0'),
(38, 'F-HSM-018', 'ZULFIQAR', 'Ali', 'ECO110', 'Microeconomics', 'V21', 'SPRING2026', '23623', '1'),
(39, 'F-HSM-018', 'ZULFIQAR', 'Ali', 'ECO210', 'Macroeconomics', 'V22', 'SPRING2026', '23623', '0'),
(40, 'F-HSM-044', 'AHSAN', 'Khan', 'MGT450', 'Strategic Business Analytics', 'V21', 'SPRING2026', '23623', '1'),
(41, 'F-HSM-013', 'RUKHSANA', 'Kausar', 'MKT350', 'Digital Marketing Strategies', 'V22', 'SPRING2026', '23623', '1'),
(42, 'F-HSM-015', 'IMRAN', 'Sadiq', 'FIN420', 'Investment & Portfolio Management', 'V21', 'SPRING2026', '23623', '0'),
(43, 'F-SEN-019', 'HAROON', 'Raza', 'EE110', 'Linear Circuit Analysis', 'V21', 'SPRING2026', '23623', '1'),
(44, 'F-SEN-019', 'HAROON', 'Raza', 'EE221', 'Digital Logic Design', 'V22', 'SPRING2026', '23623', '1'),
(45, 'F-SEN-020', 'BILAL', 'Siddique', 'ME101', 'Engineering Mechanics', 'V21', 'SPRING2026', '23623', '0'),
(46, 'F-SEN-020', 'BILAL', 'Siddique', 'ME315', 'Fluid Mechanics', 'V22', 'SPRING2026', '23623', '1'),
(47, 'F-SEN-021', 'ASMA', 'Riaz', 'CE112', 'Engineering Surveying', 'V21', 'SPRING2026', '23623', '0'),
(48, 'F-SEN-021', 'ASMA', 'Riaz', 'CE320', 'Structural Analysis', 'V22', 'SPRING2026', '23623', '1'),
(49, 'F-SEN-022', 'RIZWAN', 'Khan', 'IE211', 'Production Planning and Control', 'V21', 'SPRING2026', '23623', '1'),
(50, 'F-SEN-023', 'HUMAIRA', 'Bano', 'TE101', 'Introduction to Textile Technology', 'V21', 'SPRING2026', '23623', '0'),
(51, 'F-SHS-024', 'KHALID', 'Mahmood', 'PT101', 'Introduction to Physical Therapy', 'V21', 'SPRING2026', '23623', '1'),
(52, 'F-SHS-025', 'ZAINAB', 'Tariq', 'NUT210', 'Fundamentals of Human Nutrition', 'V21', 'SPRING2026', '23623', '1'),
(53, 'F-SHS-028', 'FAISAL', 'Iqbal', 'PH401', 'Epidemiology and Public Health', 'V21', 'SPRING2026', '23623', '0');

-- --------------------------------------------------------

--
-- Table structure for table `courses_section`
--

CREATE TABLE `courses_section` (
  `sid` int(11) NOT NULL,
  `coursecode` varchar(255) NOT NULL,
  `coursename` varchar(255) DEFAULT NULL,
  `coursesection` varchar(255) DEFAULT NULL,
  `session` varchar(500) NOT NULL,
  `creadedby` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `courses_section`
--

INSERT INTO `courses_section` (`sid`, `coursecode`, `coursename`, `coursesection`, `session`, `creadedby`) VALUES
(0, 'CS3022', 'Civic Educaiton  ', 'V21', 'SPRING2026', '23623'),
(0, '1212', 'ICFCS ', 'V21', 'SPRING2026', '23623'),
(0, 'CC432', 'thoeyr of automata ', 'V22', 'SPRING2026', '23623'),
(0, 'CS110', 'Programming Fundamentals', 'V21', 'SPRING2026', '23623'),
(0, 'CS210', 'Object Oriented Programming', 'V21', 'SPRING2026', '23623'),
(0, 'CS220', 'Data Structures and Algorithms', 'V21', 'SPRING2026', '23623'),
(0, 'CS321', 'Database Systems', 'V21', 'SPRING2026', '23623'),
(0, 'CS351', 'Software Engineering Principles', 'V22', 'SPRING2026', '23623'),
(0, 'CS452', 'Web Application Development', 'V23', 'SPRING2026', '23623'),
(0, 'CS411', 'Artificial Intelligence', 'V21', 'SPRING2026', '23623'),
(0, 'CS481', 'Introduction to Data Science', 'V21', 'SPRING2026', '23623'),
(0, 'CS415', 'Machine Learning Foundations', 'V22', 'SPRING2026', '23623'),
(0, 'CS382', 'Information Security', 'V24', 'SPRING2026', '23623'),
(0, 'CS312', 'Analysis of Algorithms', 'V21', 'SPRING2026', '23623'),
(0, 'CS422', 'Cloud Computing Architecture', 'V21', 'SPRING2026', '23623'),
(0, 'CS431', 'Compiler Construction', 'V22', 'SPRING2026', '23623'),
(0, 'CS471', 'Mobile Application Development', 'V21', 'SPRING2026', '23623'),
(0, 'MGT101', 'Principles of Management', 'V21', 'SPRING2026', '23623'),
(0, 'MKT211', 'Principles of Marketing', 'V21', 'SPRING2026', '23623'),
(0, 'FIN301', 'Corporate Finance', 'V21', 'SPRING2026', '23623'),
(0, 'HRM320', 'Human Resource Management', 'V22', 'SPRING2026', '23623'),
(0, 'SCM410', 'Supply Chain Logistics', 'V21', 'SPRING2026', '23623'),
(0, 'ECO110', 'Microeconomics', 'V21', 'SPRING2026', '23623'),
(0, 'ECO210', 'Macroeconomics', 'V22', 'SPRING2026', '23623'),
(0, 'MGT450', 'Strategic Business Analytics', 'V21', 'SPRING2026', '23623'),
(0, 'MKT350', 'Digital Marketing Strategies', 'V22', 'SPRING2026', '23623'),
(0, 'FIN420', 'Investment & Portfolio Management', 'V21', 'SPRING2026', '23623'),
(0, 'EE110', 'Linear Circuit Analysis', 'V21', 'SPRING2026', '23623'),
(0, 'EE221', 'Digital Logic Design', 'V22', 'SPRING2026', '23623'),
(0, 'ME101', 'Engineering Mechanics', 'V21', 'SPRING2026', '23623'),
(0, 'ME315', 'Fluid Mechanics', 'V22', 'SPRING2026', '23623'),
(0, 'CE112', 'Engineering Surveying', 'V21', 'SPRING2026', '23623'),
(0, 'CE320', 'Structural Analysis', 'V22', 'SPRING2026', '23623'),
(0, 'IE211', 'Production Planning and Control', 'V21', 'SPRING2026', '23623'),
(0, 'TE101', 'Introduction to Textile Technology', 'V21', 'SPRING2026', '23623'),
(0, 'PT101', 'Introduction to Physical Therapy', 'V21', 'SPRING2026', '23623'),
(0, 'NUT210', 'Fundamentals of Human Nutrition', 'V21', 'SPRING2026', '23623'),
(0, 'PH401', 'Epidemiology and Public Health', 'V21', 'SPRING2026', '23623');

-- --------------------------------------------------------

--
-- Table structure for table `deans`
--

CREATE TABLE `deans` (
  `didid` int(11) NOT NULL,
  `dcode` varchar(255) DEFAULT NULL,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) NOT NULL,
  `gender` varchar(200) NOT NULL,
  `email` varchar(255) NOT NULL,
  `pass` varchar(200) NOT NULL,
  `contactno` varchar(255) NOT NULL,
  `depcode` varchar(255) DEFAULT NULL,
  `depname` varchar(255) DEFAULT NULL,
  `depschool` varchar(255) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `createdon` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `deans`
--

INSERT INTO `deans` (`didid`, `dcode`, `FirstName`, `LastName`, `gender`, `email`, `pass`, `contactno`, `depcode`, `depname`, `depschool`, `createdby`, `createdon`) VALUES
(1, 'DEAN-SST-01', 'Dr. Adnan', 'Abid', 'Male', 'dean.sst@umt.edu.pk', 'umtDeanSst', '03214567001', 'SST-01', 'Computer Science', 'SST', 'Administrator-admin', '2026-09-24 11:00:00'),
(2, 'DEAN-HSM-01', 'Dr. Navid', 'Jamil Malik', 'Male', 'dean.hsm@umt.edu.pk', 'umtDeanHsm', '03214567002', 'HSM-01', 'Management', 'HSM', 'Administrator-admin', '2026-09-24 11:02:00'),
(3, 'DEAN-SEN-01', 'Dr. Muhammad', 'Asif', 'Male', 'dean.sen@umt.edu.pk', 'umtDeanSen', '03214567003', 'SEN-01', 'Electrical Engineering', 'SEN', 'Administrator-admin', '2026-09-24 11:04:00'),
(4, 'DEAN-SHS-01', 'Dr. Khalid', 'Mahmood', 'Male', 'dean.shs@umt.edu.pk', 'umtDeanShs', '03214567004', 'SHS-01', 'Physical Therapy', 'SHS', 'Administrator-admin', '2026-09-24 11:06:00'),
(5, 'DEAN-SPA-01', 'Dr. Sajjad', 'Muneer', 'Male', 'dean.spa@umt.edu.pk', 'umtDeanSpa', '03214567005', 'SPA-01', 'Architecture', 'SPA', 'Administrator-admin', '2026-09-24 11:08:00'),
(6, 'DEAN-SSH-01', 'Dr. Tariq', 'Rahman', 'Male', 'dean.ssh@umt.edu.pk', 'umtDeanSsh', '03214567006', 'SSH-01', 'Linguistics and Literature', 'SSH', 'Administrator-admin', '2026-09-24 11:10:00');

-- --------------------------------------------------------

--
-- Table structure for table `deans_assigndep`
--

CREATE TABLE `deans_assigndep` (
  `aid` int(11) NOT NULL,
  `dcode` varchar(255) NOT NULL,
  `depcode` varchar(255) DEFAULT NULL,
  `createdby` varchar(200) NOT NULL,
  `creadedon` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `deans_assigndep`
--

INSERT INTO `deans_assigndep` (`aid`, `dcode`, `depcode`, `createdby`, `creadedon`) VALUES
(1, 'DEAN-SST-01', 'SST-01', 'Administrator-admin', '2026-09-24'),
(2, 'DEAN-HSM-01', 'HSM-01', 'Administrator-admin', '2026-09-24'),
(3, 'DEAN-SEN-01', 'SEN-01', 'Administrator-admin', '2026-09-24'),
(4, 'DEAN-SHS-01', 'SHS-01', 'Administrator-admin', '2026-09-24'),
(5, 'DEAN-SPA-01', 'SPA-01', 'Administrator-admin', '2026-09-24'),
(6, 'DEAN-SSH-01', 'SSH-01', 'Administrator-admin', '2026-09-24');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `did` int(11) NOT NULL,
  `depschool` varchar(255) DEFAULT NULL,
  `depcode` varchar(255) NOT NULL,
  `depname` varchar(255) DEFAULT NULL,
  `deploc` varchar(255) DEFAULT NULL,
  `createdby` varchar(200) NOT NULL,
  `createdon` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`did`, `depschool`, `depcode`, `depname`, `deploc`, `createdby`, `createdon`) VALUES
(1, 'SST', '001', 'Computer Science ', 'STD', 'Administrator-admin', '2025-09-27 04:09:59'),
(2, 'SST', 'SST-01', 'Computer Science', 'SST Building', 'admin', '2026-09-24'),
(3, 'SST', 'SST-02', 'Software Engineering', 'SST Building', 'admin', '2026-09-24'),
(4, 'SST', 'SST-03', 'Data Science', 'SST Building', 'admin', '2026-09-24'),
(5, 'SST', 'SST-04', 'Artificial Intelligence', 'SST Building', 'admin', '2026-09-24'),
(6, 'SST', 'SST-05', 'Information Technology', 'SST Building', 'admin', '2026-09-24'),
(7, 'SST', 'SST-06', 'Cyber Security', 'SST Building', 'admin', '2026-09-24'),
(8, 'HSM', 'HSM-01', 'Management', 'HSM Building', 'admin', '2026-09-24'),
(9, 'HSM', 'HSM-02', 'Marketing', 'HSM Building', 'admin', '2026-09-24'),
(10, 'HSM', 'HSM-03', 'Finance and Banking', 'HSM Building', 'admin', '2026-09-24'),
(11, 'HSM', 'HSM-04', 'Human Resource Management', 'HSM Building', 'admin', '2026-09-24'),
(12, 'SEN', 'SEN-01', 'Electrical Engineering', 'SEN Building', 'admin', '2026-09-24'),
(13, 'SEN', 'SEN-02', 'Mechanical Engineering', 'SEN Building', 'admin', '2026-09-24'),
(14, 'SEN', 'SEN-03', 'Civil Engineering', 'SEN Building', 'admin', '2026-09-24'),
(15, 'SHS', 'SHS-01', 'Physical Therapy', 'SHS Building', 'admin', '2026-09-24'),
(16, 'SPA', 'SPA-01', 'Architecture', 'SPA Building', 'admin', '2026-09-24');

-- --------------------------------------------------------

--
-- Table structure for table `faculty`
--

CREATE TABLE `faculty` (
  `fid` int(10) NOT NULL,
  `fcode` varchar(255) DEFAULT NULL,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) NOT NULL,
  `gender` varchar(200) NOT NULL,
  `email` varchar(255) NOT NULL,
  `pass` varchar(200) NOT NULL,
  `contactno` varchar(255) NOT NULL,
  `depcode` varchar(255) DEFAULT NULL,
  `depname` varchar(255) DEFAULT NULL,
  `depschool` varchar(255) DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `createdon` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faculty`
--

INSERT INTO `faculty` (`fid`, `fcode`, `FirstName`, `LastName`, `gender`, `email`, `pass`, `contactno`, `depcode`, `depname`, `depschool`, `createdby`, `createdon`) VALUES
(1, '23623', 'RANA MARWAT    ', 'Hussain', 'Male', 'marwat.hussain@umt.edu.pk', '3b712de48137572f3849aabd5666a4e3', '03204821306', '001', 'Computer Science ', 'SST', '23623', '2025-09-27 04:11:53'),
(3, '1122', 'ali ', 'khan', 'Male', 'ALI@GMAIL.COM', '1122', '0222', '001', 'Computer Science ', 'SST', '23623', '2026-08-19 13:36:38'),
(4, 'F-SST-001', 'KAMRAN', 'Ali', 'Male', 'kamran.ali@umt.edu.pk', 'facpass01', '03210000001', 'SST-01', 'Computer Science', 'SST', '23623', '2026-09-24'),
(5, 'F-SST-002', 'YASSER', 'Arafat', 'Male', 'yasser.arafat@umt.edu.pk', 'facpass02', '03210000002', 'SST-01', 'Computer Science', 'SST', '23623', '2026-09-24'),
(6, 'F-SST-003', 'ADNAN', 'Abid', 'Male', 'adnan.abid@umt.edu.pk', 'facpass03', '03210000003', 'SST-01', 'Computer Science', 'SST', '23623', '2026-09-24'),
(7, 'F-SST-004', 'SAJJAD', 'Hussain', 'Male', 'sajjad.hussain@umt.edu.pk', 'facpass04', '03210000004', 'SST-02', 'Software Engineering', 'SST', '23623', '2026-09-24'),
(8, 'F-SST-005', 'AMJAD', 'Iqbal', 'Male', 'amjad.iqbal@umt.edu.pk', 'facpass05', '03210000005', 'SST-02', 'Software Engineering', 'SST', '23623', '2026-09-24'),
(9, 'F-SST-007', 'TAYYABA', 'Anees', 'Female', 'tayyaba.a@umt.edu.pk', 'facpass07', '03210000007', 'SST-03', 'Data Science', 'SST', '23623', '2026-09-24'),
(10, 'F-SST-008', 'MUHAMMAD', 'Asif', 'Male', 'm.asif@umt.edu.pk', 'facpass08', '03210000008', 'SST-04', 'Artificial Intelligence', 'SST', '23623', '2026-09-24'),
(11, 'F-SST-009', 'NABEEL', 'Sabir', 'Male', 'nabeel.s@umt.edu.pk', 'facpass09', '03210000009', 'SST-05', 'Information Technology', 'SST', '23623', '2026-09-24'),
(12, 'F-SST-010', 'MARIA', 'Anjum', 'Female', 'maria.a@umt.edu.pk', 'facpass10', '03210000010', 'SST-06', 'Cyber Security', 'SST', '23623', '2026-09-24'),
(13, 'F-SST-035', 'OMER', 'Riaz', 'Male', 'omer.r@umt.edu.pk', 'facpass35', '03210000035', 'SST-01', 'Computer Science', 'SST', '23623', '2026-09-24'),
(14, 'F-SST-050', 'SHAHZAD', 'Sarwar', 'Male', 'shahzad.sarwar@umt.edu.pk', 'facpass50', '03210000050', 'SST-01', 'Computer Science', 'SST', '23623', '2026-09-24'),
(15, 'F-HSM-011', 'NAVID', 'Jamil', 'Male', 'navid.jamil@umt.edu.pk', 'facpass11', '03210000011', 'HSM-01', 'Management', 'HSM', '23623', '2026-09-24'),
(16, 'F-HSM-013', 'RUKHSANA', 'Kausar', 'Female', 'rukhsana.k@umt.edu.pk', 'facpass13', '03210000013', 'HSM-02', 'Marketing', 'HSM', '23623', '2026-09-24'),
(17, 'F-HSM-014', 'SHAHID', 'Hassan', 'Male', 'shahid.h@umt.edu.pk', 'facpass14', '03210000014', 'HSM-03', 'Finance and Banking', 'HSM', '23623', '2026-09-24'),
(18, 'F-HSM-015', 'IMRAN', 'Sadiq', 'Male', 'imran.sadiq@umt.edu.pk', 'facpass15', '03210000015', 'HSM-03', 'Finance and Banking', 'HSM', '23623', '2026-09-24'),
(19, 'F-HSM-016', 'SADIA', 'Nadeem', 'Female', 'sadia.n@umt.edu.pk', 'facpass16', '03210000016', 'HSM-04', 'Human Resource Management', 'HSM', '23623', '2026-09-24'),
(20, 'F-HSM-017', 'KAMRAN', 'Saeed', 'Male', 'kamran.s@umt.edu.pk', 'facpass17', '03210000017', 'HSM-05', 'Operations and Supply Chain', 'HSM', '23623', '2026-09-24'),
(21, 'F-HSM-018', 'ZULFIQAR', 'Ali', 'Male', 'zulfiqar.a@umt.edu.pk', 'facpass18', '03210000018', 'HSM-06', 'Economics', 'HSM', '23623', '2026-09-24'),
(22, 'F-HSM-044', 'AHSAN', 'Khan', 'Male', 'ahsan.khan@umt.edu.pk', 'facpass44', '03210000044', 'HSM-03', 'Finance', 'HSM', '23623', '2026-09-24'),
(23, 'F-SEN-019', 'HAROON', 'Raza', 'Male', 'haroon.r@umt.edu.pk', 'facpass19', '03210000019', 'SEN-01', 'Electrical Engineering', 'SEN', '23623', '2026-09-24'),
(24, 'F-SEN-020', 'BILAL', 'Siddique', 'Male', 'bilal.sid@umt.edu.pk', 'facpass20', '03210000020', 'SEN-02', 'Mechanical Engineering', 'SEN', '23623', '2026-09-24'),
(25, 'F-SEN-021', 'ASMA', 'Riaz', 'Female', 'asma.r@umt.edu.pk', 'facpass21', '03210000021', 'SEN-03', 'Civil Engineering', 'SEN', '23623', '2026-09-24'),
(26, 'F-SEN-022', 'RIZWAN', 'Khan', 'Male', 'rizwan.khan@umt.edu.pk', 'facpass22', '03210000022', 'SEN-04', 'Industrial Engineering', 'SEN', '23623', '2026-09-24'),
(27, 'F-SEN-023', 'HUMAIRA', 'Bano', 'Female', 'humaira.b@umt.edu.pk', 'facpass23', '03210000023', 'SEN-05', 'Textile Engineering', 'SEN', '23623', '2026-09-24'),
(28, 'F-SHS-024', 'KHALID', 'Mahmood', 'Male', 'khalid.mahmood@umt.edu.pk', 'facpass24', '03210000024', 'SHS-01', 'Physical Therapy', 'SHS', '23623', '2026-09-24'),
(29, 'F-SHS-025', 'ZAINAB', 'Tariq', 'Female', 'zainab.tariq@umt.edu.pk', 'facpass25', '03210000025', 'SHS-02', 'Nutrition and Dietetics', 'SHS', '23623', '2026-09-24'),
(30, 'F-SHS-028', 'FAISAL', 'Iqbal', 'Male', 'faisal.i@umt.edu.pk', 'facpass28', '03210000028', 'SHS-05', 'Public Health', 'SHS', '23623', '2026-09-24');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `sid` int(11) NOT NULL,
  `session` varchar(255) NOT NULL,
  `status` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`sid`, `session`, `status`) VALUES
(1, 'FALL 2025 ', 'IN Active '),
(2, 'SPRING 2025 ', 'IN Active '),
(3, 'SPRING2026', 'Active ');

-- --------------------------------------------------------

--
-- Table structure for table `storage`
--

CREATE TABLE `storage` (
  `store_id` int(11) NOT NULL,
  `filename` varchar(100) NOT NULL,
  `file_type` varchar(20) NOT NULL,
  `Assessment_type` varchar(500) NOT NULL,
  `date_uploaded` varchar(100) NOT NULL,
  `fcode` int(100) NOT NULL,
  `pattern` int(6) NOT NULL,
  `coursename` varchar(500) NOT NULL,
  `section` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `storage`
--

INSERT INTO `storage` (`store_id`, `filename`, `file_type`, `Assessment_type`, `date_uploaded`, `fcode`, `pattern`, `coursename`, `section`) VALUES
(7, '8860crcOutline_cc342v12.pdf', 'application/pdf', 'Course_Outline', '2025-10-11, 10:28 PM', 23623, 5, 'Analysis of Algorithms/Fundamental of algorithms  ', 'V1'),
(8, '8183Quiz1.pdf', 'application/pdf', 'Quizzes', '2025-10-14, 04:33 PM', 23623, 5, 'Analysis of Algorithms/Fundamental of algorithms  ', 'V1'),
(9, '3867Quiz2.pdf', 'application/pdf', 'Quizzes', '2025-10-14, 04:33 PM', 23623, 5, 'Analysis of Algorithms/Fundamental of algorithms  ', 'V1'),
(10, '4156Midterm Exam.pdf', 'application/pdf', 'MidTerm', '2025-10-14, 04:33 PM', 23623, 7, 'Analysis of Algorithms/Fundamental of algorithms  ', 'V1'),
(11, '6609Finals.pdf', 'application/pdf', 'FinalTerm', '2025-10-14, 04:34 PM', 23623, 8, 'Analysis of Algorithms/Fundamental of algorithms  ', 'V1'),
(12, '5786Finals.pdf', 'application/pdf', 'FinalTerm', '2025-10-15, 07:42 PM', 236255, 8, 'Civic Educaiton  ', 'V1'),
(27, '9778Doc1.pdf', 'application/pdf', 'Best_Folder', '2025-11-13, 09:55 PM', 23623, 18, 'Analysis of Algorithms/Fundamental of algorithms  ', 'V7'),
(28, '2343ICFCS Mockups (Option White).pdf', 'application/pdf', 'Best_Folder', '2025-11-13, 09:55 PM', 23623, 19, 'Analysis of Algorithms/Fundamental of algorithms  ', 'V7'),
(29, '1561Salary slip ( 31691808 December , 2024 ).pdf', 'application/pdf', 'Best_Folder', '2025-11-22, 03:59 PM', 23623, 5, 'ICFCS ', 'V1'),
(30, '7495Salary slip ( 31691808 February , 2025 ).pdf', 'application/pdf', 'Awared_Sheet', '2025-11-22, 04:00 PM', 23623, 7, 'ICFCS ', 'V1'),
(31, '4097Salary slip ( 31691808 January , 2025 ).pdf', 'application/pdf', 'Best_Folder', '2025-11-22, 04:00 PM', 23623, 18, 'ICFCS ', 'V1'),
(32, '6923Salary slip ( 31691808 March , 2025 ).pdf', 'application/pdf', 'Awared_Sheet', '2025-11-22, 04:00 PM', 23623, 17, 'ICFCS ', 'V1'),
(33, '8304Salary slip ( 31691808 November , 2024 ).pdf', 'application/pdf', 'Best_Folder', '2025-11-22, 04:00 PM', 23623, 19, 'ICFCS ', 'V1'),
(34, '3098Salary slip ( 31691808 October , 2024 ).pdf', 'application/pdf', 'Best_Folder', '2025-11-22, 04:00 PM', 23623, 20, 'ICFCS ', 'V1'),
(35, '8211Salary slip ( 31691808 October , 2025 ).pdf', 'application/pdf', 'Best_Folder', '2025-11-22, 04:01 PM', 23623, 19, 'ICFCS ', 'V1'),
(36, '6247Salary slip ( 31691808 September , 2024 ).pdf', 'application/pdf', 'Best_Folder', '2025-11-22, 04:01 PM', 23623, 19, 'ICFCS ', 'V1'),
(37, '4699Midterm_Exam_F2025.46.pdf', 'application/pdf', 'MidTerm', '2026-01-09, 01:26 AM', 23623, 4, 'Analysis of Algorithms/Fundamental of algorithms  ', 'V6'),
(38, '3057crcOutline_cc342v12.pdf', 'application/pdf', 'Course_Outline', '2026-01-09, 01:26 AM', 23623, 1, 'Analysis of Algorithms/Fundamental of algorithms  ', 'V6'),
(40, '6530_crcOutline_cc342v12.pdf', 'application/pdf', 'Best_Folder', '2026-01-09 09:24 PM', 23623, 18, 'Analysis of Algorithms/Fundamental of algorithms  ', 'V1'),
(41, '4311_CamScanner18-07-202610.22.pdf', 'application/pdf', 'Attendance', '2026-08-19 06:38 PM', 1122, 1, 'ICFCS ', 'V21');

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `stud_id` int(11) NOT NULL,
  `stud_no` int(10) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `yr&sec` varchar(5) NOT NULL,
  `password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`stud_id`, `stud_no`, `firstname`, `lastname`, `gender`, `yr&sec`, `password`) VALUES
(1, 202300501, 'Muhammad', 'Ali', 'Male', 'V21', 'stdpass01'),
(2, 202300502, 'Ahmad', 'Hassan', 'Male', 'V21', 'stdpass02'),
(3, 202300503, 'Zainab', 'Fatima', 'Female', 'V21', 'stdpass03'),
(4, 202300504, 'Hamza', 'Khan', 'Male', 'V21', 'stdpass04'),
(5, 202300505, 'Ayesha', 'Siddiqua', 'Female', 'V21', 'stdpass05'),
(6, 202300506, 'Bilal', 'Ahmed', 'Male', 'V22', 'stdpass06'),
(7, 202300507, 'Sana', 'Malik', 'Female', 'V22', 'stdpass07'),
(8, 202300508, 'Usman', 'Raza', 'Male', 'V22', 'stdpass08'),
(9, 202300509, 'Hira', 'Anwar', 'Female', 'V22', 'stdpass09'),
(10, 202300510, 'Faisal', 'Mehmood', 'Male', 'V22', 'stdpass10'),
(11, 202400601, 'Omer', 'Farooq', 'Male', 'V21', 'stdpass11'),
(12, 202400602, 'Iqra', 'Shahid', 'Female', 'V21', 'stdpass12'),
(13, 202400603, 'Asif', 'Iqbal', 'Male', 'V21', 'stdpass13'),
(14, 202400604, 'Zoya', 'Rehman', 'Female', 'V21', 'stdpass14'),
(15, 202400605, 'Haris', 'Munir', 'Male', 'V21', 'stdpass15'),
(16, 202400606, 'Saba', 'Parveen', 'Female', 'V23', 'stdpass16'),
(17, 202400607, 'Waqas', 'Javed', 'Male', 'V23', 'stdpass17'),
(18, 202400608, 'Kiran', 'Shahzadi', 'Female', 'V23', 'stdpass18'),
(19, 202400609, 'Saad', 'Aslam', 'Male', 'V23', 'stdpass19'),
(20, 202400610, 'Amina', 'Bibi', 'Female', 'V23', 'stdpass20'),
(21, 202400701, 'Tayyab', 'Mahmood', 'Male', 'V24', 'stdpass21'),
(22, 202400702, 'Sadia', 'Anwar', 'Female', 'V24', 'stdpass22'),
(23, 202400703, 'Junaid', 'Akram', 'Male', 'V24', 'stdpass23'),
(24, 202400704, 'Mehak', 'Sultan', 'Female', 'V24', 'stdpass24'),
(25, 202400705, 'Rizwan', 'Bashir', 'Male', 'V24', 'stdpass25'),
(26, 202500801, 'Fouzia', 'Yasmeen', 'Female', 'V21', 'stdpass26'),
(27, 202500802, 'Kamran', 'Shafi', 'Male', 'V21', 'stdpass27'),
(28, 202500803, 'Aalia', 'Rasheed', 'Female', 'V21', 'stdpass28'),
(29, 202500804, 'Adnan', 'Saeed', 'Male', 'V21', 'stdpass29'),
(30, 202500805, 'Rimsha', 'Kanwal', 'Female', 'V21', 'stdpass30'),
(31, 202500806, 'Kashif', 'Nadeem', 'Male', 'V22', 'stdpass31'),
(32, 202500807, 'Shazia', 'Naureen', 'Female', 'V22', 'stdpass32'),
(33, 202500808, 'Mudassir', 'Hussain', 'Male', 'V22', 'stdpass33'),
(34, 202500809, 'Faiza', 'Iftikhar', 'Female', 'V22', 'stdpass34'),
(35, 202500810, 'Noman', 'Idrees', 'Male', 'V22', 'stdpass35'),
(36, 202500901, 'Tehreem', 'Arshad', 'Female', 'V21', 'stdpass36'),
(37, 202500902, 'Adeel', 'Akhtar', 'Male', 'V21', 'stdpass37'),
(38, 202500903, 'Sobia', 'Tariq', 'Female', 'V21', 'stdpass38'),
(39, 202500904, 'Salman', 'Ahmed', 'Male', 'V21', 'stdpass39'),
(40, 202500905, 'Maria', 'Ghias', 'Female', 'V21', 'stdpass40'),
(41, 202600101, 'Ahsan', 'Khan', 'Male', 'V22', 'stdpass41'),
(42, 202600102, 'Humaira', 'Latif', 'Female', 'V22', 'stdpass42'),
(43, 202600103, 'Sohail', 'Abbas', 'Male', 'V22', 'stdpass43'),
(44, 202600104, 'Bushra', 'Riaz', 'Female', 'V22', 'stdpass44'),
(45, 202600105, 'Shoaib', 'Akram', 'Male', 'V22', 'stdpass45'),
(46, 202600106, 'Areej', 'Zahid', 'Female', 'V23', 'stdpass46'),
(47, 202600107, 'Taimoor', 'Baig', 'Male', 'V23', 'stdpass47'),
(48, 202600108, 'Fiza', 'Ali', 'Female', 'V23', 'stdpass48'),
(49, 202600109, 'Mubashir', 'Bashir', 'Male', 'V23', 'stdpass49'),
(50, 202600110, 'Kinza', 'Muneer', 'Female', 'V23', 'stdpass50');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(50) NOT NULL,
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `firstname`, `lastname`, `username`, `password`, `status`) VALUES
(1, 'Administrator', '', 'admin', '1122', 'administrator'),
(2, 'SST', 'Desk Office', 'sst_coord', 'sstPass2026', 'staff'),
(3, 'HSM', 'Desk Office', 'hsm_coord', 'hsmPass2026', 'staff'),
(4, 'SEN', 'Desk Office', 'sen_coord', 'senPass2026', 'staff'),
(5, 'SHS', 'Desk Office', 'shs_coord', 'shsPass2026', 'staff'),
(6, 'SPA', 'Desk Office', 'spa_coord', 'spaPass2026', 'staff'),
(7, 'Zain', 'Asif', 'zain_admin', 'zainUmt786', 'administrator'),
(8, 'Ayesha', 'Malik', 'ayesha_staff', 'ayeshaPass1', 'staff'),
(9, 'Hamza', 'Ali', 'hamza_staff', 'hamzaPass2', 'staff'),
(10, 'Bilal', 'Hassan', 'bilal_staff', 'bilalPass3', 'staff'),
(11, 'Sana', 'Fatima', 'sana_staff', 'sanaPass4', 'staff');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cods`
--
ALTER TABLE `cods`
  ADD PRIMARY KEY (`coid`);

--
-- Indexes for table `cod_assigndep`
--
ALTER TABLE `cod_assigndep`
  ADD PRIMARY KEY (`aid`);

--
-- Indexes for table `coordiantor`
--
ALTER TABLE `coordiantor`
  ADD PRIMARY KEY (`cid`);

--
-- Indexes for table `coordiantor_assigndep`
--
ALTER TABLE `coordiantor_assigndep`
  ADD PRIMARY KEY (`aid`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`cid`);

--
-- Indexes for table `courses_assign`
--
ALTER TABLE `courses_assign`
  ADD PRIMARY KEY (`assid`);

--
-- Indexes for table `deans`
--
ALTER TABLE `deans`
  ADD PRIMARY KEY (`didid`);

--
-- Indexes for table `deans_assigndep`
--
ALTER TABLE `deans_assigndep`
  ADD PRIMARY KEY (`aid`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`did`);

--
-- Indexes for table `faculty`
--
ALTER TABLE `faculty`
  ADD PRIMARY KEY (`fid`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`sid`);

--
-- Indexes for table `storage`
--
ALTER TABLE `storage`
  ADD PRIMARY KEY (`store_id`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`stud_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cods`
--
ALTER TABLE `cods`
  MODIFY `coid` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `cod_assigndep`
--
ALTER TABLE `cod_assigndep`
  MODIFY `aid` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=166;

--
-- AUTO_INCREMENT for table `coordiantor`
--
ALTER TABLE `coordiantor`
  MODIFY `cid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `coordiantor_assigndep`
--
ALTER TABLE `coordiantor_assigndep`
  MODIFY `aid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `cid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `courses_assign`
--
ALTER TABLE `courses_assign`
  MODIFY `assid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `deans`
--
ALTER TABLE `deans`
  MODIFY `didid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `deans_assigndep`
--
ALTER TABLE `deans_assigndep`
  MODIFY `aid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `did` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `faculty`
--
ALTER TABLE `faculty`
  MODIFY `fid` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `sessions`
--
ALTER TABLE `sessions`
  MODIFY `sid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `storage`
--
ALTER TABLE `storage`
  MODIFY `store_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `student`
--
ALTER TABLE `student`
  MODIFY `stud_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
