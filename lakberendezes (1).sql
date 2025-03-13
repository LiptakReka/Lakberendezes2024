-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Már 13. 21:11
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `lakberendezes`
--
CREATE DATABASE IF NOT EXISTS `lakberendezes` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `lakberendezes`;

DELIMITER $$
--
-- Eljárások
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `POMELO_AFTER_ADD_PRIMARY_KEY` (IN `SCHEMA_NAME_ARGUMENT` VARCHAR(255), IN `TABLE_NAME_ARGUMENT` VARCHAR(255), IN `COLUMN_NAME_ARGUMENT` VARCHAR(255))   BEGIN
	DECLARE HAS_AUTO_INCREMENT_ID INT(11);
	DECLARE PRIMARY_KEY_COLUMN_NAME VARCHAR(255);
	DECLARE PRIMARY_KEY_TYPE VARCHAR(255);
	DECLARE SQL_EXP VARCHAR(1000);
	SELECT COUNT(*)
		INTO HAS_AUTO_INCREMENT_ID
		FROM `information_schema`.`COLUMNS`
		WHERE `TABLE_SCHEMA` = (SELECT IFNULL(SCHEMA_NAME_ARGUMENT, SCHEMA()))
			AND `TABLE_NAME` = TABLE_NAME_ARGUMENT
			AND `COLUMN_NAME` = COLUMN_NAME_ARGUMENT
			AND `COLUMN_TYPE` LIKE '%int%'
			AND `COLUMN_KEY` = 'PRI';
	IF HAS_AUTO_INCREMENT_ID THEN
		SELECT `COLUMN_TYPE`
			INTO PRIMARY_KEY_TYPE
			FROM `information_schema`.`COLUMNS`
			WHERE `TABLE_SCHEMA` = (SELECT IFNULL(SCHEMA_NAME_ARGUMENT, SCHEMA()))
				AND `TABLE_NAME` = TABLE_NAME_ARGUMENT
				AND `COLUMN_NAME` = COLUMN_NAME_ARGUMENT
				AND `COLUMN_TYPE` LIKE '%int%'
				AND `COLUMN_KEY` = 'PRI';
		SELECT `COLUMN_NAME`
			INTO PRIMARY_KEY_COLUMN_NAME
			FROM `information_schema`.`COLUMNS`
			WHERE `TABLE_SCHEMA` = (SELECT IFNULL(SCHEMA_NAME_ARGUMENT, SCHEMA()))
				AND `TABLE_NAME` = TABLE_NAME_ARGUMENT
				AND `COLUMN_NAME` = COLUMN_NAME_ARGUMENT
				AND `COLUMN_TYPE` LIKE '%int%'
				AND `COLUMN_KEY` = 'PRI';
		SET SQL_EXP = CONCAT('ALTER TABLE `', (SELECT IFNULL(SCHEMA_NAME_ARGUMENT, SCHEMA())), '`.`', TABLE_NAME_ARGUMENT, '` MODIFY COLUMN `', PRIMARY_KEY_COLUMN_NAME, '` ', PRIMARY_KEY_TYPE, ' NOT NULL AUTO_INCREMENT;');
		SET @SQL_EXP = SQL_EXP;
		PREPARE SQL_EXP_EXECUTE FROM @SQL_EXP;
		EXECUTE SQL_EXP_EXECUTE;
		DEALLOCATE PREPARE SQL_EXP_EXECUTE;
	END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `achievements`
--

CREATE TABLE `achievements` (
  `id` varchar(255) NOT NULL,
  `user_Id` int(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `icon` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `achievements`
--

INSERT INTO `achievements` (`id`, `user_Id`, `title`, `description`, `icon`, `created_at`) VALUES
('00ffe81b-c5d3-44e7-ab24-6e35f69fe43e', 1, 'Első terv!', 'Elmentetted az első terved!', '🏠', '2025-03-13 19:46:52'),
('21402bd4-a6bb-4206-bab9-77633121aab3', 1, 'Szépségszalon', 'Profilképed megváltozott', '💄', '2025-03-13 19:44:52'),
('84413a32-0e36-48d6-8164-cccfc2916646', 1, 'Első terv!', 'Elmentetted az első terved!', '🏠', '2025-03-01 18:19:44'),
('ec53c219-dd76-45cc-ba6c-0b2acafe64fa', 1, 'Kosár elküldve!', 'Összegzés elküldve', '🛒', '2025-03-13 19:55:30');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kategories`
--

CREATE TABLE `kategories` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `kategories`
--

INSERT INTO `kategories` (`id`, `name`) VALUES
(1, 'Nappali'),
(3, 'Hálószoba'),
(4, 'Fürdőszoba'),
(5, 'Étkező');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `planproducts`
--

CREATE TABLE `planproducts` (
  `id` int(11) NOT NULL,
  `productid` int(11) NOT NULL,
  `position` varchar(255) NOT NULL,
  `scale` float NOT NULL DEFAULT 1,
  `userplanid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `planproducts`
--

INSERT INTO `planproducts` (`id`, `productid`, `position`, `scale`, `userplanid`) VALUES
(161, 53, '-198, 534', 0.6, 71),
(162, 73, '-68, 569', 0.5, 71),
(163, 174, '195, 485', 0.7, 71),
(164, 347, '946, 439', 0.8, 71);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `shoplink` varchar(255) DEFAULT NULL,
  `imageurl` varchar(255) DEFAULT NULL,
  `shopid` int(11) DEFAULT NULL,
  `product_type_id` int(11) DEFAULT NULL,
  `roomid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `shoplink`, `imageurl`, `shopid`, `product_type_id`, `roomid`) VALUES
(1, 'Kihúzható Asztal Coburg 140/80 Cm', 69990, 'https://www.moebelix.hu/p/kihuzhato-asztal-coburg-140-80-cm-002478005115', 'https://i.postimg.cc/LX0791xk/coburg-removebg-preview.png', 2, 21, 5),
(2, 'Étkezőasztal Juliette', 59990, 'https://www.moebelix.hu/p/tkezoasztal-juliette-000055013601', 'https://i.postimg.cc/pLvHKn3k/a-removebg-preview.png', 2, 21, 5),
(3, 'Kihúzható Étkezőasztal Elara', 99990, 'https://www.moebelix.hu/p/kihuzhato-etkezoasztal-elara-000687071007', 'https://i.postimg.cc/CKSsW-xsF/Elara-tkez-asztal-removebg-preview.png', 2, 21, 5),
(4, 'Étkezőasztal Severin 138', 79990, 'https://www.moebelix.hu/p/tkezoasztal-severin-138-002647007606', 'https://i.postimg.cc/Pf3Rd8SV/Severin-138-removebg-preview.png', 2, 21, 5),
(5, 'Étkezőasztal Aron 138', 56990, 'https://www.moebelix.hu/p/tkezoasztal-aron-138-002647009201', 'https://i.postimg.cc/ZqfJZ528/Aron138-removebg-preview.png', 2, 21, 5),
(6, 'Étkezőasztal Wood 160', 229900, 'https://www.moebelix.hu/p/james-wood-tkezoasztal-wood-160-002730002503', 'https://i.postimg.cc/fLGynbSH/James-wood-removebg-preview.png', 2, 21, 5),
(7, 'Étkezőasztal Brick 80', 27990, 'https://www.moebelix.hu/p/tkezoasztal-brick-80-002647011202', 'https://i.postimg.cc/wTs5mtkB/Brick-removebg-preview.png', 2, 21, 5),
(8, 'Kihúzható Asztal Charme 160/90 Cm', 139900, 'https://www.moebelix.hu/p/kihuzhato-asztal-charme-160-90-cm-002546002001', 'https://i.postimg.cc/C170JLHB/Charme-removebg-preview.png', 2, 21, 5),
(9, 'Étkezőasztal Köln 75', 18990, 'https://www.moebelix.hu/p/tkezoasztal-koeln-75-001606005501', 'https://i.postimg.cc/4xWF87rT/Koeln-removebg-preview.png', 2, 21, 5),
(10, 'Étkezőasztal Bonny T', 89990, 'https://www.moebelix.hu/p/tkezoasztal-bonny-t-001606009706', 'https://i.postimg.cc/W3YNT1FR/Bonny-t-removebg-preview.png', 2, 21, 5),
(21, 'Szék Lech', 14990, 'https://www.moebelix.hu/p/szek-lech-001125019702', 'https://i.postimg.cc/LXT0z5KJ/lech-removebg-preview.png', 2, 23, 5),
(22, 'Szék Franzi', 7990, 'https://www.moebelix.hu/p/szek-franzi-001634010501', 'https://i.postimg.cc/mDzyrrZx/franzi-removebg-preview.png', 2, 23, 5),
(23, 'Szék John', 15990, 'https://www.moebelix.hu/p/szek-john-001013002911', 'https://i.postimg.cc/W4tHMTp8/jhon-removebg-preview.png', 2, 23, 5),
(24, 'Szék Basti Giga-S', 19990, 'https://www.moebelix.hu/p/szek-basti-giga-s-001634006201', 'https://i.postimg.cc/jqkCXhhh/basti-giga-removebg-preview.png', 2, 23, 5),
(25, 'Szék Anne Ii', 19990, 'https://www.moebelix.hu/p/szek-anne-ii-000758019902', 'https://i.postimg.cc/nzRCjKzM/anne-ii-removebg-preview.png', 2, 23, 5),
(26, 'Szék Anne\r\n', 15990, 'https://www.moebelix.hu/p/szek-anne-000758019802', 'https://i.postimg.cc/yYZ935zR/anne-removebg-preview.png', 2, 23, 5),
(27, 'Szánkótalpas Szék Teddy Giga-S', 29990, 'https://www.moebelix.hu/p/szankotalpas-szek-teddy-giga-s-000289015201', 'https://i.postimg.cc/L4BhdpRN/teddy-removebg-preview.png', 2, 23, 5),
(28, 'Szék Olivia Giga-S', 39990, 'https://www.moebelix.hu/p/szek-olivia-giga-s-000039003202', 'https://i.postimg.cc/vB4jrMhM/olivia-removebg-preview.png', 2, 23, 5),
(29, 'Szánkótalpas Szék Phil Giga-S', 37990, 'https://www.moebelix.hu/p/szankotalpas-szek-phil-giga-s-001634010601', 'https://i.postimg.cc/25bMvr2Y/phil-removebg-preview.png', 2, 23, 5),
(30, 'Szánkótalpas Szék Nick', 44990, 'https://www.moebelix.hu/p/szankotalpas-szek-nick-002540022501', 'https://i.postimg.cc/HWX8pNDP/nick-removebg-preview.png', 2, 23, 5),
(42, 'Falipolc Szett Simple', 4990, 'https://www.moebelix.hu/p/falipolc-szett-simple-007326001604', 'https://i.postimg.cc/rFD72rP8/simpeszett-removebg-preview.png', 2, 22, 5),
(43, 'Falipolc Isola\r\n', 11990, 'https://www.moebelix.hu/p/falipolc-isola-001803072102', 'https://i.postimg.cc/1txDXL9C/isola-removebg-preview.png', 2, 22, 5),
(44, 'Falipolc Bc 3105', 39990, 'https://www.moebelix.hu/p/falipolc-bc-3105-000887057201', 'https://i.postimg.cc/wjC1QLS3/bc-removebg-preview.png', 2, 22, 5),
(45, 'Falipolc Linate', 19990, 'https://www.moebelix.hu/p/falipolc-linate-001803072907\r\n', 'https://i.postimg.cc/8zmCM9BX/linate-removebg-preview.png', 2, 22, 5),
(46, 'Falipolc Elke', 9990, 'https://www.moebelix.hu/p/falipolc-elke-001803038601', 'https://i.postimg.cc/R022FV6k/elke-removebg-preview.png', 2, 22, 5),
(47, 'Falipolc Szett Sven', 19990, 'https://www.moebelix.hu/p/moebelix-falipolc-szett-sven-000366002501\r\n', 'https://i.postimg.cc/C1VJXZfx/sven-removebg-preview.png', 2, 22, 5),
(48, 'Falipolc Kashmir New', 12990, 'https://www.moebelix.hu/p/james-wood-falipolc-kashmir-new-001803052805', 'https://i.postimg.cc/QMWhSzpr/jamesw-ood-removebg-preview.png', 2, 22, 5),
(49, 'Falipolc Alassio', 18990, 'https://www.moebelix.hu/p/luca-bessoni-falipolc-alassio-001803056907', 'https://i.postimg.cc/VN7ZrsSf/lucabessoni-removebg-preview.png', 2, 22, 5),
(50, 'Falipolc Auris', 19990, 'https://www.moebelix.hu/p/luca-bessoni-falipolc-auris-001803063113', 'https://i.postimg.cc/tTxdq9Wm/lucabessoniauris-removebg-preview.png', 2, 22, 5),
(51, 'Falipolc Szett Nizza', 14990, 'https://www.moebelix.hu/p/falipolc-szett-nizza-007326059701', 'https://i.postimg.cc/5ymCyy0p/nizza-removebg-preview.png', 2, 22, 5),
(52, 'Kétüléses Kanapé Monaco', 179900, 'https://www.moebelix.hu/p/luca-bessoni-ketueleses-kanape-monaco-002694000902', 'https://i.postimg.cc/ZYfgL7vq/monaco-removebg-preview.png', 2, 1, 1),
(53, 'Kanapé Monaco', 189900, 'https://www.moebelix.hu/p/luca-bessoni-kanape-monaco-002694000903', 'https://i.postimg.cc/9QHBPZbM/monaco2-removebg-preview.png', 2, 1, 1),
(54, 'Kanapéágy Cadiz New', 289900, 'https://www.moebelix.hu/p/kanapeagy-cadiz-new-001204002406', 'https://i.postimg.cc/kXKHdnh2/cadiz-removebg-preview.png', 2, 1, 1),
(55, 'KANAPÉÁGY Levi B: Ca. 208 Cm', 179900, 'https://www.moebelix.hu/p/ondega-kanapeagy-levi-b-ca-208-cm-000317001701', 'https://i.postimg.cc/KzC0dVP7/levi-removebg-preview.png', 2, 1, 1),
(56, 'Kanapéágy Malcolm Hellgrau', 399900, 'https://www.moebelix.hu/p/kanapeagy-malcolm-hellgrau-000295005701', 'https://i.postimg.cc/rpPjrbP6/malcolm-removebg-preview.png', 2, 1, 1),
(57, 'Kanapéágy Beta New', 339900, 'https://www.moebelix.hu/p/kanapeagy-beta-new-002427014701', 'https://i.postimg.cc/nhLqG27n/beta-removebg-preview.png', 2, 1, 1),
(58, 'Óriás Kanapé Aruba', 349900, 'https://www.moebelix.hu/p/rias-kanape-aruba-000552031906', 'https://i.postimg.cc/Hkj7yxDx/aruba-removebg-preview.png', 2, 1, 1),
(59, 'Boxpring Kanapé Emily', 299900, 'https://www.moebelix.hu/p/ondega-boxpring-kanape-emily-001174000701', 'https://i.postimg.cc/CLrRSgBV/emily-removebg-preview.png', 2, 1, 1),
(60, 'Kanapé Ibiza', 189900, 'https://www.moebelix.hu/p/kanape-ibiza-001204003509', 'https://i.postimg.cc/3NVQfnRz/ibiza-removebg-preview.png', 2, 1, 1),
(61, 'Kanapéágy Anna', 379900, 'https://www.moebelix.hu/p/kanapeagy-anna-002990004301', 'https://i.postimg.cc/bJvXzKSK/anna-removebg-preview.png', 2, 1, 1),
(72, 'Dohányzóasztal Silvia', 39990, 'https://www.moebelix.hu/p/dohanyzoasztal-silvia-001973001702', 'https://i.postimg.cc/V6GtVkbG/silvia-removebg-preview.png', 2, 3, 1),
(73, 'Dohányzóasztal Silvia/2', 39990, 'https://www.moebelix.hu/p/dohanyzoasztal-silvia-001973001701', 'https://i.postimg.cc/nrXmbf4H/silvia2-removebg-preview.png', 2, 3, 1),
(74, 'Dohányzóasztal Cala Luna', 26990, 'https://www.moebelix.hu/p/dohanyzoasztal-cala-luna-001803035301', 'https://i.postimg.cc/zv4gq27T/luna-removebg-preview.png', 2, 3, 1),
(75, 'Dohányzóasztal Gina Sonoma Tölgy Dekorral', 17990, 'https://www.moebelix.hu/p/dohanyzoasztal-gina-sonoma-toelgy-dekorral-002140003003', 'https://i.postimg.cc/59rv5jJj/sonoma-removebg-preview.png', 2, 3, 1),
(76, 'Dohányzóasztal Cestino', 59990, 'https://www.moebelix.hu/p/dohanyzoasztal-cestino-001803072308', 'https://i.postimg.cc/NfrXdYGD/cestino-removebg-preview.png', 2, 3, 1),
(77, 'Dohányzóasztal Cala Luna/2', 26990, 'https://www.moebelix.hu/p/dohanyzoasztal-cala-luna-001803035302', 'https://i.postimg.cc/XYSChhpb/luna2-removebg-preview.png', 2, 3, 1),
(78, 'Dohányzóasztal Laura', 19990, 'https://www.moebelix.hu/p/dohanyzoasztal-laura-001803023910', 'https://i.postimg.cc/W4p6WKH4/laura-removebg-preview.png', 2, 3, 1),
(79, 'Dohányzóasztal Saba', 14990, 'https://www.moebelix.hu/p/moebelix-dohanyzoasztal-saba-001973000101', 'https://i.postimg.cc/3wLjPBsF/saba-removebg-preview.png', 2, 3, 1),
(80, 'Dohányzóasztal Paolo', 11990, 'https://www.moebelix.hu/p/dohanyzoasztal-paolo-001555000508', 'https://i.postimg.cc/qMfcVg5S/paolo-removebg-preview.png', 2, 3, 1),
(81, 'Dohányzóasztal Paolo/2', 11990, 'https://www.moebelix.hu/p/dohanyzoasztal-paolo-001555000509', 'https://i.postimg.cc/pXDf2RNT/paolo2-removebg-preview.png', 2, 3, 1),
(92, 'Tv-elem Genetic', 89990, 'https://www.moebelix.hu/p/tv-elem-genetic-000687037402', 'https://i.postimg.cc/5yhzqKZn/genetic-removebg-preview.png', 2, 5, 1),
(93, 'Médiaállvány Tico', 29990, 'https://www.moebelix.hu/p/mediaallvany-tico-001803030204', 'https://i.postimg.cc/3wFsvdkc/tico-removebg-preview.png', 2, 5, 1),
(94, 'Tv-elem Yoris', 54990, 'https://www.moebelix.hu/p/tv-elem-yoris-000241005205', 'https://i.postimg.cc/GtgKw1HK/yoris-removebg-preview.png', 2, 5, 1),
(95, 'Tv-elem Bretagne', 59990, 'https://www.moebelix.hu/p/tv-elem-bretagne-000834009603', 'https://i.postimg.cc/vHDX7DNN/bretagne-removebg-preview.png', 2, 5, 1),
(96, 'Tv-elem Alassio', 99990, 'https://www.moebelix.hu/p/luca-bessoni-tv-elem-alassio-001803056902', 'https://i.postimg.cc/yNhT6RDk/ucabessonialassio-removebg-preview.png', 2, 5, 1),
(97, 'Tv-elem Alassio/2', 119900, 'https://www.moebelix.hu/p/luca-bessoni-tv-elem-alassio-001803056906', 'https://i.postimg.cc/kg2bhbQk/alassio2-removebg-preview.png', 2, 5, 1),
(98, 'Tv-elem Tonale', 89990, 'https://www.moebelix.hu/p/tv-elem-tonale-001803057308', 'https://i.postimg.cc/HnSr6YVY/tonale-removebg-preview.png', 2, 5, 1),
(99, 'Tv-elem Venedig', 59990, 'https://www.moebelix.hu/p/tv-elem-venedig-001803053302', 'https://i.postimg.cc/yYbJ98Mn/venedig-removebg-preview.png', 2, 5, 1),
(100, 'Tv-elem Malta', 49990, 'https://www.moebelix.hu/p/tv-elem-malta-001803031815', 'https://i.postimg.cc/mrxtX62H/malta-removebg-preview.png', 2, 5, 1),
(101, 'Médiaállvány Bernd 2 Mx 144', 89990, 'https://www.moebelix.hu/p/mediaallvany-bernd-2-mx-144-002698012302', 'https://i.postimg.cc/Wp9tL41j/bernd-removebg-preview.png', 2, 5, 1),
(102, 'Tükör Alassio', 39990, 'https://www.moebelix.hu/p/luca-bessoni-tuekoer-alassio-001803058705', 'https://i.postimg.cc/DzNzQh2C/alassio-removebg-preview.png', 2, 16, 4),
(103, 'Tükör Salve', 29990, 'https://www.moebelix.hu/p/tuekoer-salve-001803072501', 'https://i.postimg.cc/NFgZ5yWZ/salve-removebg-preview.png', 2, 16, 4),
(104, 'Fali Tükör Bonny', 4990, 'https://www.moebelix.hu/p/ondega-fali-tuekoer-bonny-002757019001', 'https://i.postimg.cc/NFgZ5yWZ/salve-removebg-preview.png', 2, 16, 4),
(105, 'Fali Tükör Rom', 5490, 'https://www.moebelix.hu/p/fali-tuekoer-rom-008103023401', 'https://i.postimg.cc/GpdP0kG0/rom-removebg-preview.png', 2, 16, 4),
(106, 'Tükör Vancouver', 34990, 'https://www.moebelix.hu/p/tuekoer-vancouver-000196087002', 'https://i.postimg.cc/BQFVcf0m/vancouver-removebg-preview.png', 2, 16, 4),
(107, 'Fali Tükör Jakob', 6990, 'https://www.moebelix.hu/p/fali-tuekoer-jakob-007326007601', 'https://i.postimg.cc/XvYLPTRS/jakob-removebg-preview.png', 2, 16, 4),
(108, 'Fali Tükör Attack', 12990, 'https://www.moebelix.hu/p/fali-tuekoer-attack-001803044905', 'https://i.postimg.cc/SxD7cgJZ/attack-removebg-preview.png', 2, 16, 4),
(109, 'Fali Tükör Malta', 24990, 'https://www.moebelix.hu/p/fali-tuekoer-malta-001803031823', 'https://i.postimg.cc/MpQqQFPw/malta-removebg-preview.png', 2, 16, 4),
(110, 'Fali Tükör Kastor', 9990, 'https://www.moebelix.hu/p/ondega-fali-tuekoer-kastor-002757019401', 'https://i.postimg.cc/rm3LsG1s/kastor-removebg-preview.png', 2, 16, 4),
(111, 'Tükör Spring\r\n', 24990, 'https://www.moebelix.hu/p/tuekoer-spring-001803071305', 'https://i.postimg.cc/HWyq3y00/spring-removebg-preview.png', 2, 16, 4),
(132, 'Kárpitozott Ágy Padua 180/200 Cm', 179900, 'https://www.moebelix.hu/p/karpitozott-agy-padua-180-200-cm-002216001301', 'https://i.postimg.cc/GhTGMLV0/padua-removebg-preview.png', 2, 11, 3),
(133, 'Kihúzható Ágy Storm', 149900, 'https://www.moebelix.hu/p/kihuzhato-agy-storm-002561000101', 'https://i.postimg.cc/RVtXD5bY/storm-removebg-preview.png', 2, 11, 3),
(134, 'Tárolós Ágy Till 140/200 Cm', 229900, 'https://www.moebelix.hu/p/tarolos-agy-till-140-200-cm-000528021003', 'https://i.postimg.cc/v8Jv92Ht/till-removebg-preview.png', 2, 11, 3),
(135, 'Boxspring-ágy Ancona 180/200 Cm', 449900, 'https://www.moebelix.hu/p/boxspring-agy-ancona-180-200-cm-002366000801', 'https://i.postimg.cc/139wckxw/ancona-removebg-preview.png', 2, 11, 3),
(136, 'Tárolós Ágy Saturn 180/200 Cm', 139900, 'https://www.moebelix.hu/p/tarolos-agy-saturn-180-200-cm-002427003718', 'https://i.postimg.cc/xjvXx63R/saturn-removebg-preview.png', 2, 11, 3),
(137, 'Kihúzható Ágy Timmi', 229900, 'https://www.moebelix.hu/p/kihuzhato-agy-timmi-000423004701', 'https://i.postimg.cc/26p5TWqM/timmi-removebg-preview.png', 2, 11, 3),
(138, 'Kárpitozott Ágy Lucy 180/200 Cm', 139900, 'https://www.moebelix.hu/p/karpitozott-agy-lucy-180-200-cm-002216002401', 'https://i.postimg.cc/9f9m4fxp/lucy-removebg-preview.png', 2, 11, 3),
(139, 'Tárolós Ágy Till 90/200 Cm/2', 159900, 'https://www.moebelix.hu/p/tarolos-agy-till-90-200-cm-000528021004', 'https://i.postimg.cc/VNXwfV6Z/till2-removebg-preview.png', 2, 11, 3),
(140, 'Tárolós Ágy Bonny 90/200 Cm', 99990, 'https://www.moebelix.hu/p/tarolos-agy-bonny-90-200-cm-000423010702', 'https://i.postimg.cc/TY54vWhC/bonny-removebg-preview.png', 2, 11, 3),
(141, 'Tárolós ágy Cindy 2', 109900, 'https://www.moebelix.hu/p/tarolos-agy-cindy-2-001787084903', 'https://i.postimg.cc/MpD49JnS/cindy-removebg-preview.png', 2, 11, 3),
(142, 'Éjjeliszekrény Ella', 14990, 'https://www.moebelix.hu/p/jjeliszekreny-ella-000778006901', 'https://i.postimg.cc/zB03TZPv/ella-removebg-preview.png', 2, 13, 3),
(143, 'Éjjeliszekrény Tölgy Dekor', 29990, 'https://www.moebelix.hu/p/jjeliszekreny-toelgy-dekor-002522029403', 'https://i.postimg.cc/Z5bbFDpy/tolgy-removebg-preview.png', 2, 13, 3),
(144, 'Éjjeliszekrény Billund', 39990, 'https://www.moebelix.hu/p/jjeliszekreny-billund-001787029018', 'https://i.postimg.cc/NMgkgtHj/billund-removebg-preview.png', 2, 13, 3),
(145, 'Éjjeliszekrény Ella/2\r\n', 14990, 'https://www.moebelix.hu/p/jjeliszekreny-ella-000778006902', 'https://i.postimg.cc/26ZLRXHS/ella2-removebg-preview.png', 2, 13, 3),
(146, 'Éjjeliszekrény Saturn', 29990, 'https://www.moebelix.hu/p/jjeliszekreny-saturn-002427003705', 'https://i.postimg.cc/qR4H4Nw6/saturn-removebg-preview.png', 2, 13, 3),
(147, 'Éjjeliszekrény 4-You', 14990, 'https://www.moebelix.hu/p/jjeliszekreny-4-you-001803027111', 'https://i.postimg.cc/YCddhhtm/4you-removebg-preview.png', 2, 13, 3),
(148, 'Éjjeliszekrény Saturn/2', 29990, 'https://www.moebelix.hu/p/jjeliszekreny-saturn-002427003713', 'https://i.postimg.cc/wjR1srpc/saturn2-removebg-preview.png', 2, 13, 3),
(149, 'Éjjeliszekrény Box', 24990, 'https://www.moebelix.hu/p/ondega-jjeliszekreny-box-001803018732', 'https://i.postimg.cc/wTLvqmc0/ondega-removebg-preview.png', 2, 13, 3),
(150, 'Éjjeliszekrény Avensis New', 39990, 'https://www.moebelix.hu/p/luca-bessoni-jjeliszekreny-avensis-new-001803037803', 'https://i.postimg.cc/0Q0n1QXQ/avensis-removebg-preview.png', 2, 13, 3),
(151, 'Éjjeliszekrény 4-You New/2', 19990, 'https://www.moebelix.hu/p/jjeliszekreny-4-you-new-001803044804', 'https://i.postimg.cc/52563CX6/4you2-removebg-preview.png', 2, 13, 3),
(152, 'Tolóajtós Szekrény Time 170/195 Cm', 99990, 'https://www.moebelix.hu/p/toloajtos-szekreny-time-170-195-cm-002522035901', 'https://i.postimg.cc/Y9MYGWzN/time-removebg-preview.png', 2, 14, 3),
(153, 'Tolóajtós Szekrény Starter B 125/196 Cm', 79990, 'https://www.moebelix.hu/p/toloajtos-szekreny-starter-b-125-196-cm-002522031501', 'https://i.postimg.cc/XYgCMJbp/starterb-removebg-preview.png', 2, 14, 3),
(154, 'Nyílóajtós Szekrény Karl 159/196 Cm', 129900, 'https://www.moebelix.hu/p/nyiloajtos-szekreny-karl-159-196-cm-002522018202', 'https://i.postimg.cc/Qx8D4x06/karl-removebg-preview.png', 2, 14, 3),
(155, 'Nyílóajtós Szekrény Landwood 80/200 Cm', 89990, 'https://www.moebelix.hu/p/nyiloajtos-szekreny-landwood-80-200-cm-002478007907', 'https://i.postimg.cc/G9wyRTts/landwood-removebg-preview.png', 2, 14, 3),
(156, 'Tolóajtós Szekrény Oldenburg 180/198 Cm', 199900, 'https://www.moebelix.hu/p/toloajtos-szekreny-oldenburg-180-198-cm-001787071601', 'https://i.postimg.cc/T3PD6xY0/oldenburg-removebg-preview.png', 2, 14, 3),
(157, 'Nyílóajtós szekrény Base 3 121/177 Cm', 79990, 'https://www.moebelix.hu/p/nyiloajtos-szekreny-base-3-121-177-cm-002522000804', 'https://i.postimg.cc/zfFZSsTm/base-removebg-preview.png', 2, 14, 3),
(158, 'Tolóajtós Szekrény Sinfonie Sand 249/221 Cm', 339900, 'https://www.moebelix.hu/p/toloajtos-szekreny-sinfonie-sand-249-221-cm-000531041102', 'https://i.postimg.cc/Yq65Hcyv/sinfone-removebg-preview.png', 2, 14, 3),
(159, 'Tolóajtós Szekrény Navara 242/215,5 Cm', 269900, 'https://www.moebelix.hu/p/toloajtos-szekreny-navara-242-215-5-cm-000834009001', 'https://i.postimg.cc/cJwYDmJG/navara-removebg-preview.png', 2, 14, 3),
(160, 'Tolóajtós Szekrény Mega 312/226 Cm', 279900, 'https://www.moebelix.hu/p/toloajtos-szekreny-mega-312-226-cm-002522035502', 'https://i.postimg.cc/vBDyYPxp/mega-removebg-preview.png', 2, 14, 3),
(161, 'Bejárható Sarokszekrény Yoris 146,4/199 Cm', 249900, 'https://www.moebelix.hu/p/bejarhato-sarokszekreny-yoris-146-4-199-cm-000241005201', 'https://i.postimg.cc/jqHTsJDq/yoris-removebg-preview.png', 2, 14, 3),
(162, 'Texas tv állvány', 74900, 'https://somabutor.hu/texas-tv-allvany', 'https://i.postimg.cc/4ynfVxrt/texas-removebg-preview.png', 14, 5, 1),
(163, 'Pixie tv állvány', 45900, 'https://somabutor.hu/pixie-tv-allvany', 'https://i.postimg.cc/y8hHJRkt/Pixie-removebg-preview.png', 14, 5, 1),
(164, 'Velence TV állvány (John TV állvány)', 46700, 'https://somabutor.hu/velence-tv-allvany', 'https://i.postimg.cc/9032RYY3/Velence-removebg-preview.png', 14, 5, 1),
(165, 'Maldív fiókos tv állvány', 49500, 'https://somabutor.hu/maldiv-fiokos-tv-allvany', 'https://i.postimg.cc/5yPmKn7T/maldiv-removebg-preview.png', 14, 5, 1),
(166, 'Toledo tv állvány', 74900, 'https://somabutor.hu/toledo-tv-allvany', 'https://i.postimg.cc/JnpJRtNB/toledo-removebg-preview.png', 14, 5, 1),
(167, 'Dohányzó asztal c 1 dohányzóasztal (40.5 × 80 × 50 cm)', 29900, 'https://somabutor.hu/dohanyzo-asztal-c-1-dohanyzoasztal', 'https://i.postimg.cc/CLbFTXHj/c1-removebg-preview.png', 14, 3, 1),
(168, 'Dubai 2 dohányzóasztal', 39000, 'https://somabutor.hu/dubai-2-dohanyzoasztal', 'https://i.postimg.cc/vTfdyx9Q/dubai2-removebg-preview.png', 14, 3, 1),
(169, 'Capri 2 dohányzóasztal', 39000, 'https://somabutor.hu/capri-2-dohanyzoasztal', 'https://i.postimg.cc/HLNG799Y/capri2-removebg-preview.png', 14, 3, 1),
(170, 'EVEREST FIÓKOS DOHÁNYZÓASZTAL', 44200, 'https://somabutor.hu/everest-fiokos-dohanyzoasztal', 'https://i.postimg.cc/ZYpkC3Bm/everest-removebg-preview.png', 14, 3, 1),
(171, 'Baldo 2 dohányzóasztal', 39000, 'https://somabutor.hu/baldo-dohanyzo', 'https://i.postimg.cc/JnXFHVhx/baldo-removebg-preview.png', 14, 3, 1),
(172, 'MEGAN kanapé', 129500, 'https://somabutor.hu/megan-kanape', 'https://i.postimg.cc/SRdJ6KQf/megan-removebg-preview.png', 14, 1, 1),
(173, 'CHERRY 2-es kanapé', 147900, 'https://somabutor.hu/cherry-2-es-kanape', 'https://i.postimg.cc/ZqNnfHKR/cherry2-removebg-preview.png', 14, 1, 1),
(174, 'BENIAMIN 2-es szófa', 148900, 'https://somabutor.hu/beniamin-2-es-szofa', 'https://i.postimg.cc/Qd9dtm7b/beniamin-removebg-preview.png', 14, 1, 1),
(175, 'MILANO kanapé', 154900, 'https://somabutor.hu/milano-kanape', 'https://i.postimg.cc/VN91rVkj/milano-removebg-preview.png', 14, 1, 1),
(176, 'Noel ortopéd rugós/szivacsos sarokülő', 169900, 'https://somabutor.hu/noel-ortoped-rugosszivacsos-sarokulo', 'https://i.postimg.cc/nc6tdJs4/noel-removebg-preview.png', 14, 1, 1),
(177, 'Könyvespolc', 44900, 'https://somabutor.hu/konyvespolc', 'https://i.postimg.cc/Qxrp3BWV/k-nyvespolc-removebg-preview.png', 14, 22, 5),
(178, 'Joker falipolc', 17400, 'https://somabutor.hu/joker-falipolc', 'https://i.postimg.cc/QCZWhPCv/joker-removebg-preview.png', 14, 22, 5),
(179, 'Térelválasztó', 59600, 'https://somabutor.hu/terelvalaszto', 'https://i.postimg.cc/rsTzvrYk/t-relvalaszto-removebg-preview.png', 14, 22, 5),
(180, 'Taipei könyvespolc', 38900, 'https://somabutor.hu/taipei-konyvespolc', 'https://i.postimg.cc/1XMR2YqG/taipei-removebg-preview.png', 14, 22, 5),
(181, 'Lucky falipolc', 20800, 'https://somabutor.hu/lucky-falipolc', 'https://i.postimg.cc/FRVhknGM/lucky-removebg-preview.png', 14, 22, 5),
(182, 'Niki szék', 20300, 'https://somabutor.hu/niki-szek', 'https://i.postimg.cc/zfcqCg1j/niki-removebg-preview.png', 14, 23, 5),
(183, 'Kitty szék', 21600, 'https://somabutor.hu/kitty-szek', 'https://i.postimg.cc/cLDWWn6S/Ktty-removebg-preview.png', 14, 23, 5),
(184, 'Herman szék', 22000, 'https://somabutor.hu/herman-szek', 'https://i.postimg.cc/7hMvWCjj/herman-removebg-preview.png', 14, 23, 5),
(185, 'LARA szék', 28300, 'https://somabutor.hu/lara-szek-132', 'https://i.postimg.cc/mgrxmgj6/lara-removebg-preview.png', 14, 23, 5),
(186, 'Inez szék', 34200, 'https://somabutor.hu/inez-szek', 'https://i.postimg.cc/sxzq7j1m/inez-removebg-preview.png', 14, 23, 5),
(187, 'Debora asztal - székek nélkül (160 cm x 88 cm + 40 cm)', 62400, 'https://somabutor.hu/debora-asztal-160-cm-x-88-cm-40-cm', 'https://i.postimg.cc/DyJp04Ch/debora-removebg-preview.png', 14, 21, 5),
(188, 'Hanna asztal - székek nélkül (160 cm x 88 cm + 40 cm)', 68900, 'https://somabutor.hu/hanna-asztal-160-cm-x-88-cm-40-cm', 'https://i.postimg.cc/C12Hpmpq/Hanna-removebg-preview.png', 14, 21, 5),
(189, 'Magasfényű Flóra asztal - székek nélkül (160 CM X 88 CM + 40 CM)', 112700, 'https://somabutor.hu/fenyes-flora-asztal-szekek-nelkul-160-cm-x-88-cm-40-cm', 'https://i.postimg.cc/7LWmqxgh/fl-ra-removebg-preview.png', 14, 21, 5),
(190, 'BERTA asztal - székek nélkül (120 cm x 70 cm + 40 cm)', 48600, 'https://somabutor.hu/berta-asztal-159', 'https://i.postimg.cc/tT6tyFqv/berta-removebg-preview.png', 14, 21, 5),
(191, 'Tony asztal - székek nélkül (160 cm x 90 + 40 cm)', 73500, 'https://somabutor.hu/tony-asztal-szekek-nelkul-160-cm-x-90-40-cm', 'https://i.postimg.cc/dt5Cb5Rt/tony-removebg-preview.png', 14, 21, 5),
(192, 'Diablo szekrénysor (320cm)', 201000, 'https://somabutor.hu/diablo-szekrenysor-1200', 'https://i.postimg.cc/cHj3KCHg/diablo-removebg-preview.png', 14, 14, 3),
(193, 'Uni Viktória szekrénysor (320 cm)', 234900, 'https://somabutor.hu/uni-viktoria-szekrenysor-320-cm', 'https://i.postimg.cc/fb8gkG9t/univiktoria-removebg-preview.png', 14, 14, 3),
(194, 'DUBALUX szekrénysor (375 cm)', 326400, 'https://somabutor.hu/dubalux-szekrenysor-1314', 'https://i.postimg.cc/4xZ8PfvH/dubalux-removebg-preview.png', 14, 14, 3),
(195, 'Golden szekrénysor (360 cm)', 207600, 'https://somabutor.hu/golden-szekrenysor-1357', 'https://i.postimg.cc/vHwX8YN2/golden-removebg-preview.png', 14, 14, 3),
(196, 'Peremes 1 fiókos éjjeliszekrény', 22900, 'https://somabutor.hu/peremes-1-fiokos-ejjeliszekreny', 'https://i.postimg.cc/DmVb6wtW/peremes-removebg-preview.png', 14, 13, 3),
(197, '2 fiókos alsó polcos éjjeliszekrény', 23900, 'https://somabutor.hu/2-fiokos-also-polcos-ejjeliszekreny', 'https://i.postimg.cc/KYgjq2DB/2fiokos-removebg-preview.png', 14, 13, 3),
(198, 'TYP07 ágyrácsos ágy', 249900, 'https://somabutor.hu/typ07-agyracsos-agy', 'https://i.postimg.cc/T2k9vjX0/typ07-removebg-preview.png', 14, 11, 3),
(199, 'ST3 (140/160/180/200 x 200 cm) ágyrácsos ágy', 249900, 'https://somabutor.hu/st3-140160180200-x-200-agyracsos-agy', 'https://i.postimg.cc/Cxbk5k9W/st3-removebg-preview.png', 14, 11, 3),
(200, 'TYP50 boxspring ágy', 321900, 'https://somabutor.hu/typ50-boxspring-agy', 'https://i.postimg.cc/VsTCFK8x/typ50-removebg-preview.png', 14, 11, 3),
(201, 'TYP58 boxspring ágy', 355900, 'https://somabutor.hu/typ58-boxspring-agy', 'https://i.postimg.cc/QC5177H9/typ58-removebg-preview.png', 14, 11, 3),
(202, 'Danilo extra bonell rugós franciaágy (160 X 200 cm)', 132200, 'https://somabutor.hu/danilo-extra-bonell-rugos-franciaagy-160-x-200-cm', 'https://i.postimg.cc/SxQYS37z/danilo-removebg-preview.png', 14, 11, 3),
(203, 'Komód FASO 180 kandallóval fehér', 241300, 'https://butorline.hu/komod-faso-180-kandalloval-feher', 'https://i.postimg.cc/2yzSxYBC/komod-removebg-preview.png', 13, 5, 1),
(204, 'TV komód INEZA IN02 artisan tölgy / fekete', 63000, 'https://butorline.hu/tv-komod-ineza-in02-artisan-toelgy-fekete', 'https://i.postimg.cc/bJy7CwLV/ineza-removebg-preview.png', 13, 5, 1),
(205, 'Szekrény RTV POWER Fehér / Sandal / Fehér fényes', 53400, 'https://butorline.hu/szekreny-rtv-power-feher-sandal-feher-fenyes-kiarusitas', 'https://i.postimg.cc/tCFH4w15/trv-removebg-preview.png', 13, 5, 1),
(206, 'TV szekrény BERAM 01 artisan tölgy', 76000, 'https://butorline.hu/tv-szekreny-beram-01-artisan-toelgy', 'https://i.postimg.cc/bwvLB2jt/beram-removebg-preview.png', 13, 5, 1),
(207, 'TV szekrény 180 GOVI VG1G fekete / wotan tölgy', 66900, 'https://butorline.hu/tv-szekreny-180-govi-vg1g-fekete-wotan-toelgy', 'https://i.postimg.cc/65Mfn5G5/govi-removebg-preview.png', 13, 5, 1),
(208, 'Dohányzóasztal ALVARO 10 kasmír', 64900, 'https://butorline.hu/dohanyzoasztal-alvaro-10-kasmir', 'https://i.postimg.cc/wvCgWs45/alvaro-removebg-preview.png', 13, 3, 1),
(209, 'Dohányzóasztal DANTE 06 fekete', 72000, 'https://butorline.hu/dohanyzoasztal-dante-06-fekete', 'https://i.postimg.cc/GtfYgzw7/dante-removebg-preview.png', 13, 3, 1),
(210, 'Dohányzóasztal CIMER 04 fekete / artisan', 71500, 'https://butorline.hu/dohanyzoasztal-cimer-04-fekete-artisan', 'https://i.postimg.cc/5Nvqkdy8/cimer-removebg-preview.png', 13, 3, 1),
(211, 'Dohányzóasztal DANTE 07 fekete', 55100, 'https://butorline.hu/dohanyzoasztal-dante-07-fekete', 'https://i.postimg.cc/mZ9HT34s/dante2-removebg-preview.png', 13, 3, 1),
(212, 'Dohányzóasztal DENVI DV10 monastery tölgy / fekete fényes', 78300, 'https://butorline.hu/dohanyzoasztal-denvi-dv10-monastery-toelgy-fekete-fenyes', 'https://i.postimg.cc/mgnLcq36/denvi-removebg-preview.png', 13, 3, 1),
(213, 'Kanapé BERGI tiffany 10', 312900, 'https://butorline.hu/kanape-bergi-tiffany-10', 'https://i.postimg.cc/y6XssW-Dd/tiffany-removebg-preview.png', 13, 1, 1),
(214, 'Kanapé DART 2 soft 66 / kreta 07', 212900, 'https://butorline.hu/kanape-dart-2-soft-66-kreta-07', 'https://i.postimg.cc/Ghg0mDdc/dart2-removebg-preview.png', 13, 1, 1),
(215, 'Kanapé LAKCHOS 2 monolith 85', 223900, 'https://butorline.hu/kanape-lakchos-2-monolith-85', 'https://i.postimg.cc/sxf8VjLQ/Lakchos-removebg-preview.png', 13, 1, 1),
(216, 'Kanapé DART kreta 05 / soft 66', 212900, 'https://butorline.hu/kanape-dart-kreta-05-soft-66', 'https://i.postimg.cc/SRtZkW83/dart-removebg-preview.png', 13, 1, 1),
(217, 'Kanapé SELVA A - manila sötét szürke, króm', 248000, 'https://butorline.hu/kanape-selva-a-manila-soetet-szuerke-krom', 'https://i.postimg.cc/0Qydjz8s/selva-removebg-preview.png', 13, 1, 1),
(218, 'Alsó konyhai sarokpolc 30 STILL ST50 fehér', 27000, 'https://butorline.hu/also-konyhai-sarokpolc-30-still-st50-feher', 'https://i.postimg.cc/NGH7M9T1/still-removebg-preview.png', 13, 22, 5),
(219, 'Fali polc MAMONE ME01 arany tölgy / fehér / grafit', 12000, 'https://butorline.hu/fali-polc-mamone-me01-arany-toelgy-feher-grafit', 'https://i.postimg.cc/hjwrYVmG/mamone-removebg-preview.png', 13, 22, 5),
(220, 'Fali szekrény MALTIS MT03 világosszürke', 35900, 'https://butorline.hu/fali-szekreny-maltis-mt03-vilagosszuerke', 'https://i.postimg.cc/J7GYQzXn/maltis-removebg-preview.png', 13, 22, 5),
(221, 'Fali polc CIMER 06 fekete / artisan', 24400, 'https://butorline.hu/fali-polc-cimer-06-fekete-artisan', 'https://i.postimg.cc/nLF9nNkj/cimer-removebg-preview.png', 13, 22, 5),
(222, 'Fali polc CALABRIA CL15 artisan tölgy', 32500, 'https://butorline.hu/fali-polc-calabria-cl15-artisan-toelgy', 'https://i.postimg.cc/15VpTxCy/calabria-removebg-preview.png', 13, 22, 5),
(223, 'Szék BOS 10 fehér / 8B', 20400, 'https://butorline.hu/szek-bos-10-feher-8b', 'https://i.postimg.cc/7ZSqZynH/bos10-removebg-preview.png', 13, 23, 5),
(224, 'Szék BOS 10D grafit', 24800, 'https://butorline.hu/szek-bos-10d-grafit', 'https://i.postimg.cc/44vMyNrF/bos10d-removebg-preview.png', 13, 23, 5),
(225, 'Szék BOS 4D fekete', 23900, 'https://butorline.hu/szek-bos-4d-fekete', 'https://i.postimg.cc/Xq84kKXr/bos-4d-removebg-preview.png', 13, 23, 5),
(226, 'Szék LUNA 1 sonoma tölgy / 16B', 29500, 'https://butorline.hu/szek-luna-1-sonoma-toelgy-16b', 'https://i.postimg.cc/TPY7KVvk/luna-removebg-preview.png', 13, 23, 5),
(227, 'Szék KD49D dió', 23200, 'https://butorline.hu/szek-kd49d-dio', 'https://i.postimg.cc/9QpV3YB1/kd49d-removebg-preview.png', 13, 23, 5),
(231, 'Pt40w', 73990, 'https://www.moebelix.hu/p/zuhanykabin-pt40w-001955016601', 'https://files.catbox.moe/bn58f4.png', 2, 34, 4),
(232, 'B8090', 89990, 'https://www.moebelix.hu/p/zuhanykabin-b8090m-001955000101', 'https://files.catbox.moe/11fnwc.png', 2, 34, 4),
(233, 'Tc01', 199900, 'https://www.moebelix.hu/p/zuhanykabin-tc01-001955006801', 'https://files.catbox.moe/klvbgt.png', 2, 34, 4),
(234, 'SLIM SL3', 20300, 'https://butorline.hu/alacsony-fuerdoszoba-szekreny-slim-sl3-artisan-toelgy', 'https://files.catbox.moe/k1quf6.png', 13, 35, 4),
(235, 'SLIM SL1', 37300, 'https://butorline.hu/magas-fuerdoszoba-szekreny-slim-sl1-feher-laminalt', 'https://files.catbox.moe/vydabz.png', 13, 35, 4),
(236, 'HILL 800', 164900, 'https://butorline.hu/fuerdoszoba-szekreny-hill-800-arany-toelgy', 'https://files.catbox.moe/y3t5m2.png', 13, 35, 4),
(237, 'Calvi', 29990, 'https://www.moebelix.hu/p/mosdo-alatti-szekreny-calvi-001803056302', 'https://files.catbox.moe/c9j4mg.png', 2, 35, 4),
(238, 'Pearl', 39990, 'https://www.moebelix.hu/p/pearl-new-snol-111-mosdo-alatti-szekreny-001803071701', 'https://files.catbox.moe/uyfcok.png', 2, 35, 4),
(239, 'Mura', 239900, 'https://www.moebelix.hu/p/mosdo-alatti-szekreny-mura-000780000412', 'https://files.catbox.moe/ywm53w.png', 2, 35, 4),
(241, 'Limpik', 297753, 'https://www.bogart-butor.hu/limpik-kihuzhato-kanapek---fekete-barrel-99-szovet-p-157408-1634-1634.html', 'https://files.catbox.moe/s6yxvg.png', 10, 1, 1),
(242, 'Fabio', 333250, 'https://www.bogart-butor.hu/flabio-kinyithato-kanape---bezs-lincoln-03-p-151869-1634-1634.html', 'https://files.catbox.moe/4tf9qp.png', 10, 1, 1),
(243, 'Fabio Gemma', 333250, 'https://www.bogart-butor.hu/flabio-kinyithato-kanape---szurke-gemma-85-fonott-p-161931-1634-1634.html', 'https://files.catbox.moe/gqsf1h.png', 10, 1, 1),
(244, 'Magnelio', 598170, 'https://www.bogart-butor.hu/magnelio-prestige-iii-kanape-elektronikus-ulohellyel---bezs-leo-03-szovet-p-164031-1634-1634.html#gallery-1', 'https://files.catbox.moe/gr9603.png', 10, 1, 1),
(245, 'Dragonis', 394210, 'https://www.bogart-butor.hu/kanape-kinyithato-dragonis---barna-velur-velluto-29-p-162364-1634-1634.html', 'https://files.catbox.moe/lo3lvb.png', 10, 1, 1),
(246, 'Scalia', 98290, 'https://www.bogart-butor.hu/scalia-ii-120-2k-dohanyzoasztal-fiokkal---fekete-matt---fekete-labak-p-149239-1072-1072.html', 'https://files.catbox.moe/08pp88.png', 10, 3, 1),
(247, 'Nicole', 153190, 'https://www.bogart-butor.hu/nicole-dohanyzoasztal-120-cm---kasmir---arany-labak-p-55574-1072-1072.html', 'https://files.catbox.moe/5v47t0.png', 10, 3, 1),
(248, 'Baros', 45536, 'https://www.bogart-butor.hu/baros-99-dohanyzoasztal---artisan-tolgy---szurke-p-48505-1072-1072.html', 'https://files.catbox.moe/je3xxi.png', 10, 3, 1),
(249, 'Armino', 33300, 'https://www.bogart-butor.hu/paola-dohanyzoasztal-szett---2db---marvany---arany-p-38926-1072-1072.html', 'https://files.catbox.moe/kvky6c.png', 10, 3, 1),
(250, 'Universe', 101200, 'https://www.bogart-butor.hu/universe-asztal--keret---ezust--uveg---fustos-p-38941-1072-1072.html', 'https://files.catbox.moe/6x1mkf.png', 10, 3, 1),
(251, 'Nicole', 151650, 'https://www.bogart-butor.hu/nicole-fali-tv-szekreny-200-cm-nyitott-polccal-es-fiokokkal---feher---feher-matt-p-55339-1061-1061.html', 'https://files.catbox.moe/wyxz2l.png', 10, 5, 1),
(252, 'Loftia', 65550, 'https://www.bogart-butor.hu/loftia-mini-rtv-szekreny-160-cm-nyitott-polcokkal---fekete---fekete-matt-p-54281-1061-1061.html', 'https://files.catbox.moe/0dazee.png', 10, 5, 1),
(253, 'Desin', 131090, 'https://www.bogart-butor.hu/desin-170-cm-haromajtos-tv-szekreny---olivazold---nagano-tolgy-p-149085-1061-1061.html', 'https://files.catbox.moe/qfw8ix.png', 10, 5, 1),
(254, 'Murano', 116600, 'https://www.bogart-butor.hu/murano-rtv-1-tv-asztal---kezmuves-tolgyfa---fekete-p-54810-1061-1061.html', 'https://files.catbox.moe/fb72c4.png', 10, 5, 1),
(255, 'Olin', 131711, 'https://www.bogart-butor.hu/olin-192-nagy-tv-szekreny---appenzeller-fichte---matt-fekete-p-56162-1061-1061.html', 'https://files.catbox.moe/hdlx2x.png', 10, 5, 1),
(256, 'Rozalio', 573050, 'https://www.bogart-butor.hu/rozalio-loft-faasztal-200x100---termeszetes-tolgy-p-155188-1073-1073.html', 'https://files.catbox.moe/n03jt7.png', 10, 21, 5),
(257, 'Bonello', 111300, 'https://www.bogart-butor.hu/bonello-asztal---hamvas-marvany---sarga-p-38742-1073-1073.html', 'https://files.catbox.moe/46omin.png', 10, 21, 5),
(258, 'Allegro', 55000, 'https://www.bogart-butor.hu/asztal-allegro---fekete---bukk-p-29937-1073-1073.html', 'https://files.catbox.moe/xnvuhb.png', 10, 21, 5),
(259, 'Neryt', 74927, 'https://www.bogart-butor.hu/asztal-kor-alaku-osszecsukhato-102-neryt---fekete-p-152793-1073-1073.html', 'https://files.catbox.moe/gv06wi.png', 10, 21, 5),
(260, 'Cyrjo', 82600, 'https://www.bogart-butor.hu/cyrjo-kihuzhato-asztal-80-160x80-cm---sonoma-tolgy-p-31581-1073-1073.html', 'https://files.catbox.moe/o93cvs.png', 10, 21, 5),
(261, 'Salvador', 35373, 'https://www.bogart-butor.hu/modern-5-karpitozott-szek--fa-labakon---bezs-salvador-02---bukkfa-labak-p-153522-1016-1016.html', 'https://files.catbox.moe/pji0e4.png', 10, 23, 5),
(262, 'Rozalio', 90690, 'https://www.bogart-butor.hu/rozalio-karpitozott-karosszek---szurke-cloud-83---fekete-labak-p-152975-1016-1016.html', 'https://files.catbox.moe/9or2tm.png', 10, 23, 5),
(263, 'Tucara', 35492, 'https://www.bogart-butor.hu/tucara-fabol-keszult-szek-karpitozott-ulessel---inari-91---feher-p-152733-1016-1016.html', 'https://files.catbox.moe/y5rrxz.png', 10, 23, 5),
(264, 'K436', 53900, 'https://www.bogart-butor.hu/k436-szek---hamu-sarga-p-49843-1016-1016.html', 'https://files.catbox.moe/m9uuoe.png', 10, 23, 5),
(265, 'Alda', 48200, 'https://www.bogart-butor.hu/alda-szek-hamu-p-157988-1016-1016.html', 'https://files.catbox.moe/5gkuv1.png', 10, 23, 5),
(266, 'Asha', 90690, 'https://www.bogart-butor.hu/asha-polc-50-cm---artisan---rivier-stone-matt-p-149634-1064-1064.html', 'https://files.catbox.moe/zveijn.png', 10, 22, 5),
(267, 'Provence', 118630, 'https://www.bogart-butor.hu/provence-k4s-komod---130-cm---andersen-fenyo-p-13800-1012-1012.html', 'https://files.catbox.moe/rkjrcd.png', 10, 22, 5),
(268, 'Sonatia', 238490, 'https://www.bogart-butor.hu/sonatia-ii-negyajtos-komod--gomb-labakon---200-cm---oliva-szinu-p-157164-1012-1012.html', 'https://files.catbox.moe/hymgf3.png', 10, 22, 5),
(269, 'Provence R2D', 57923, 'https://www.bogart-butor.hu/provence-r2d-fiokos-komod---130-cm---andersen-fenyofa-p-13803-1012-1012.html', 'https://files.catbox.moe/rdol8r.png', 10, 22, 5),
(270, 'Kora', 153754, 'https://www.bogart-butor.hu/kora-kk7-ketajtos-komod--negy-fiokkal-es-akaszto-ruddal---158-cm---andersen-fenyo-p-15858-1012-1012.html', 'https://files.catbox.moe/14htsn.png', 10, 22, 5),
(271, 'Loft', 424906, 'https://www.bogart-butor.hu/agy-do-haloszoba-loft-160x200-tarolokkal---tolgyfa-lancelot-p-158429-1023-1023.html', 'https://files.catbox.moe/zarzfh.png', 10, 11, 3),
(272, 'Basic', 408893, 'https://www.bogart-butor.hu/basic-fuggoleges-osszecsukhato-agy-140x200---matt-feher-p-39594-1023-1023.html', 'https://files.catbox.moe/baygle.png', 10, 11, 3),
(273, 'Smart', 190118, 'https://www.bogart-butor.hu/smart-haloszobai-agy-160x200-taroloval-es-racsos-agykerettel---sonoma-tolgy-p-158402-1023-1023.html', 'https://files.catbox.moe/ebn45t.png', 10, 11, 3),
(274, 'Arcano', 187602, 'https://www.bogart-butor.hu/keszlet-do-haloszoba-arcano-agy-i-szafki-nocne---kezmuves-tolgy-grafitszurke-p-157163-1095-1095.html', 'https://files.catbox.moe/cei4s3.png', 10, 11, 3),
(275, 'Bali', 32905, 'https://www.bogart-butor.hu/bali-ejjeliszekreny--fiokokkal---halvanykek-p-51397-1064-1064.html', 'https://files.catbox.moe/eqcql8.png', 10, 13, 3),
(276, 'Euras', 56414, 'https://www.bogart-butor.hu/euras-06-ejjeliszekreny---labrador---sarga-p-152858-1064-1064.html', 'https://files.catbox.moe/pbcpwy.png', 10, 13, 3),
(277, 'Mezo Km1', 42200, 'https://www.bogart-butor.hu/mezo-km1-ejjeliszekreny---tobbszinu-p-30997-1064-1064.html', 'https://files.catbox.moe/mweobx.png', 10, 13, 3),
(278, 'Loft', 68149, 'https://www.bogart-butor.hu/loft-fiokos-ejjeliszekreny---50-cm---lancelot-tolgy-p-42615-1064-1064.html', 'https://files.catbox.moe/gf802w.png', 10, 13, 3),
(279, 'Siena d4', 174435, 'https://www.bogart-butor.hu/siena-d4-negyajtos-szekreny--3-fiokkal-es-tukorrel---196-cm---fekete-p-156936-1085-1085.html', 'https://files.catbox.moe/vln5n5.png', 10, 14, 3),
(280, 'Smart sr1', 182740, 'https://www.bogart-butor.hu/smart-sr1-negyajtos-ruhasszekreny-ket-fiokkal-p-25914-1085-1085.html', 'https://files.catbox.moe/ru02t3.png', 10, 14, 3),
(281, 'Smart SRN4', 116085, 'https://www.bogart-butor.hu/smart-srn4-sarokszekreny-p-25934-1085-1085.html', 'https://files.catbox.moe/62r0bj.png', 10, 14, 3),
(282, 'Smart SRL3', 112340, 'https://www.bogart-butor.hu/smart-srl3-ketajtos-ruhasszekreny-ket-fiokkal--tukorrel-p-25938-1085-1085.html', 'https://files.catbox.moe/37cpqf.png', 10, 14, 3),
(283, 'Jamuzi', 31525, 'https://www.bogart-butor.hu/jamuzi-11-fuggotukor---64-cm---kasmir-p-157278-1215-1206.1215.html', 'https://files.catbox.moe/xfdkxg.png', 10, 16, 4),
(284, 'Kora', 44729, 'https://www.bogart-butor.hu/kora-kc2-tukor---andersen-fenyo-p-15831-1206-1206.html', 'https://files.catbox.moe/1p85rz.png', 10, 16, 4),
(285, 'Provence', 29633, 'https://www.bogart-butor.hu/provence-ls2-tukor---andersen-fenyo-p-24960-1206-1206.html', 'https://files.catbox.moe/3r7qk9.png', 10, 16, 4),
(286, 'Loft', 86545, 'https://www.bogart-butor.hu/loft-tukor-150-cm---fekete-p-42670-1206-1206.html', 'https://files.catbox.moe/2ybte2.png', 10, 16, 4),
(287, 'Alabama', 199900, 'https://alaba.hu/kanape-agyfunkcioval-es-agynemutartoval-szovet-piros-alabama', 'https://files.catbox.moe/f5ldmi.png', 9, 1, 1),
(288, 'Bolivia', 278900, 'https://alaba.hu/kanape-sotetszurkevilagosszurke-bolivia', 'https://files.catbox.moe/00jw4a.png', 9, 1, 1),
(289, 'Alida', 89900, 'https://alaba.hu/kanape-szethuzhatos-smaragdtolgy-alida', 'https://files.catbox.moe/njm9hu.png', 9, 1, 1),
(290, 'Brigi', 106900, 'https://alaba.hu/brigi-kanape-14', 'https://files.catbox.moe/nmpiam.png', 9, 1, 1),
(291, 'Julien', 89900, 'https://alaba.hu/dohanyzoasztal-uvegfeher-extra-magas-fenyu-hg-julien', 'https://files.catbox.moe/dty3qh.png', 9, 3, 1),
(292, 'Dohányzóasztal', 35900, 'https://alaba.hu/dohanyzoasztal-feher-extra-magas-fenyu-hg-uveg-sven', 'https://files.catbox.moe/88jhxu.png', 9, 3, 1),
(293, 'Samoa King', 43900, 'https://alaba.hu/dohanyzoasztal-samoa-king-kora-kl', 'https://files.catbox.moe/1251ws.png', 9, 3, 1),
(294, 'Provance', 52900, 'https://alaba.hu/dohanyzoasztal-zold-provance-st2', 'https://files.catbox.moe/7q3fgd.png', 9, 3, 1),
(295, 'Quido', 28900, 'https://alaba.hu/tv-asztal-feketeezust-quido', 'https://files.catbox.moe/bnjfx8.png', 9, 5, 1),
(296, 'RTV', 89900, 'https://alaba.hu/rtv-asztalszekreny-vilagos-koris-infinity-i-09', 'https://files.catbox.moe/ekslbo.png', 9, 5, 1),
(297, 'RTV Infinity', 89900, 'https://alaba.hu/rtv-asztalszekreny-koris-feher-infinity-i-09', 'https://files.catbox.moe/4veiv7.png', 9, 5, 1),
(298, 'Grandson', 84900, 'https://alaba.hu/rtv-asztal-187-fehertolgy-grandsonmagasfenyu-feher-city', 'https://files.catbox.moe/hc4w35.png', 9, 5, 1),
(299, 'Cocktail', 37200, 'https://alaba.hu/cocktail-asztal-80-4-szemelyes', 'https://i.postimg.cc/xTSPnb9X/cocktail-asztal-sonoma-removebg-preview.png', 9, 21, 5),
(300, 'Dorka', 86100, 'https://alaba.hu/dorka-asztal-130-4-szemelyes', 'https://i.postimg.cc/65Lf35QY/product-36958-2018-06-11-4-X19-E3-removebg-preview.png', 9, 21, 5),
(301, 'Perak', 221900, 'https://alaba.hu/etkezoasztal-nyithato-feher-extra-magasfenyuacel-160-220x90-cm-perak', 'https://i.postimg.cc/Zn6F6JxY/16345-perak-01-removebg-preview.png', 9, 21, 5),
(302, 'Paster', 62900, 'https://alaba.hu/etkezoasztal-edzett-uvegacel-150x90-cm-paster', 'https://i.postimg.cc/3rGZsZQM/16923-zahradny-stol-paster-removebg-preview.png', 9, 21, 5),
(303, 'Berta', 26000, 'https://alaba.hu/berta-szek-zsakszovet', 'https://i.postimg.cc/76GNY3C2/berta-szek-sonoma-vilagosbarna-zsakszovet-1-2-3-removebg-preview.png\r\n', 9, 23, 5),
(304, 'London', 21500, 'https://alaba.hu/london-szek', 'https://i.postimg.cc/W3BwDdrf/london-szek-wenge-removebg-preview.png', 9, 23, 5),
(305, 'Tamora', 23900, 'https://alaba.hu/szek-fekete-tamora', 'https://i.postimg.cc/k5hcm15C/17085-stolicka-cierna-tamora-removebg-preview.png', 9, 23, 5),
(306, 'Oleg', 22500, 'https://alaba.hu/etkezoszek-diobezs-oleg-new', 'https://i.postimg.cc/vmmzCFbX/17101-oleg-stolicka-new-orech-bezova-hlavny-removebg-preview.png', 9, 23, 5),
(307, 'Hazal', 30900, 'https://alaba.hu/szek-zoldfekete-hazal', 'https://i.postimg.cc/pLCC0Xbp/18378-hazal-stolicka-zelena-hlavna-removebg-preview.png', 9, 23, 5),
(308, 'Trufla', 207900, 'https://alaba.hu/vitrin-feher-extra-magas-fenyu-hgtrufla-sonoma-tolgy-lynatet-33', 'https://i.postimg.cc/NjBb72n3/15157-lynatet-vitrina-33-upr-removebg-preview.png', 9, 22, 5),
(309, 'Panama', 127900, 'https://alaba.hu/vitrin-2d2s-tolgyfa-sonoma-panama-typ-03', 'https://i.postimg.cc/WbR5zHwb/15347-panama-skrinka-removebg-preview.png\r\n', 9, 22, 5),
(310, 'Infinity', 175500, 'https://alaba.hu/vitrines-szekreny-vilagos-koris-infinity-i-03', 'https://i.postimg.cc/TYrCDJtj/15801-jase-svetly-l3-removebg-preview.png', 9, 22, 5),
(311, 'Riviera', 225900, 'https://alaba.hu/vitrines-szekreny-lyov03p-tolgy-rivierafeher-extra-magasfenyu-leonardo', 'https://i.postimg.cc/D0G55rnT/16387-vitrina-dub-leonardo-hlavna-removebg-preview.png', 9, 22, 5),
(312, 'Provance', 176900, 'https://alaba.hu/vitrin-zold-provance-w2s', 'https://i.postimg.cc/Pfv6tjZR/18845-provance-zelena-vesiakova-vitrina-w2s-removebg-preview.png', 9, 22, 5),
(313, 'Edit', 127900, 'https://alaba.hu/edit-franciaagy-04-02', 'https://i.postimg.cc/R0v8FD9n/edit-franciaagy-04-02-removebg-preview.png\r\n', 9, 11, 3),
(314, 'Zeus', 161900, 'https://alaba.hu/zeus-franciaagy-23-32', 'https://i.postimg.cc/4x6qXgCg/zeus-franciaagy-23-32-removebg-preview.png\r\n', 9, 11, 3),
(315, 'BoxSpring', 377500, 'https://alaba.hu/boxspring-tipusu-agy-180x200-vilagosszurke-ferata-komfort', 'https://i.postimg.cc/tCV8m627/18394-ferata-komfort-postel-180x200-hlavna-removebg-preview.png', 9, 11, 3),
(316, 'Amanda', 125900, 'https://alaba.hu/amanda-magasfekhelyes-franciaagy-ajandek-parnaval', 'https://i.postimg.cc/SxFH0Kvd/amanda-magasfekhelyes-franciaagy-fekete-bezs-removebg-preview.png', 9, 11, 3),
(317, 'Angel', 33500, 'https://alaba.hu/ejjeliszekreny-typ-95-feher-craft-angel', 'https://i.postimg.cc/1Xb23R59/15910-nocny-stolik-craft-angel-01-removebg-preview.png\r\n', 9, 13, 3),
(318, 'Betty', 25500, 'https://alaba.hu/ejjeliszekreny-tolgy-sonoma-betty-2-be02-017-00', 'https://i.postimg.cc/SQPwrdLw/17259-nocny-stolik-dub-sonoma-betty-02-removebg-preview.png', 9, 13, 3),
(319, 'Kaboto', 44900, 'https://alaba.hu/ejjeliszekreny-tolgy-kaboto', 'https://i.postimg.cc/2y1gYLYc/18212-nocny-stolik-dub-kaboto-hlavna-removebg-preview.png', 9, 13, 3),
(320, 'Paris', 53900, 'https://alaba.hu/ejeliszekreny-szurke-paris-70302', 'https://i.postimg.cc/d1HggmbZ/18787-paris-01-removebg-preview.png', 9, 13, 3),
(321, 'Alysandra', 24900, 'https://alaba.hu/kisasztalejjeliszekreny-tolgyfekete-alysandra-typ-1', 'https://i.postimg.cc/Jn49Td2W/19525-001-alysandra-removebg-preview.png', 9, 13, 3),
(322, 'Főnix', 217700, 'https://alaba.hu/fonix-gardrob-154-cm', 'https://i.postimg.cc/P51sNDw0/fonix-gardrob-154-cm-nero-san-remo-removebg-preview.png', 9, 14, 3),
(323, 'City', 129100, 'https://alaba.hu/city-gardrob-160-cm', 'https://i.postimg.cc/1zPxFz0X/city-gardrob-160-cm-grafikaval-feher-6163-removebg-preview.png', 9, 14, 3),
(324, 'Infinity', 119500, 'https://alaba.hu/szekreny-koris-sotet-infinity-i-02', 'https://i.postimg.cc/GpjWx1zQ/15780-jase-tmavy-l2-min-removebg-preview.png', 9, 14, 3),
(325, 'Denal', 26900, 'https://alaba.hu/ruhaszarito-feher-denal', 'https://i.postimg.cc/Vst3KM7v/17112-susiak-bielizen-fialova-denal-01-removebg-preview.png', 9, 36, 4),
(326, 'Kramel', 7900, 'https://alaba.hu/szennyeskosar-feketefeher-kramel', 'https://i.postimg.cc/G2W6chpb/19433-pojazdny-kos-na-bielizen-kramel-hlavna-removebg-preview.png', 9, 36, 4),
(327, 'Keri', 28900, 'https://alaba.hu/szennyeskosar-natur-bambuszszurke-keri-new', 'https://i.postimg.cc/6qCgTJ7n/19577-kerinew-01-removebg-preview.png', 9, 36, 4),
(328, 'Dalem', 20500, 'https://alaba.hu/mozgathato-polcallvany-feher-dalem', 'https://i.postimg.cc/mr605Sfz/19461-dalem-01-removebg-preview.png', 9, 36, 4),
(329, 'Arven', 12900, 'https://alaba.hu/tarolo-polc-fehertermeszetes-arven', 'https://i.postimg.cc/50YZdFbP/18495-arven-regal-biela-14-01-removebg-preview.png', 9, 36, 4),
(330, 'York', 69790, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/asztal/york-asztal', 'https://i.postimg.cc/FRZbshm2/york-removebg-preview.png', 4, 21, 5),
(331, 'Royal', 147990, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/asztal/royal-st-etkezoasztal-eszaki-fenyo-vadtolgy', 'https://i.postimg.cc/QdTpKQhg/royal-removebg-preview.png', 4, 21, 5),
(332, 'Ate', 79790, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/asztal/ate-etkezoasztal-160-200cm-47394', 'https://i.postimg.cc/wMMNqJwm/ate-removebg-preview.png', 4, 21, 5),
(333, 'Castello', 57090, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/asztal/remi-etkezoasztal-castello-tolgy-szinben-47658', 'https://i.postimg.cc/XNtPRgHd/castello-removebg-preview.png', 4, 21, 5),
(334, 'Evoke', 57090, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/asztal/remi-etkezoasztal-feher-evoke-tolgy-szinben-47649', 'https://i.postimg.cc/Nf7xd8Wg/evoke-removebg-preview.png', 4, 21, 5),
(335, 'Andersen', 37190, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/szek/kora-etkezoszek-parma-b', 'https://i.postimg.cc/Gmjd3fVZ/andersen.png', 4, 23, 5),
(336, 'Samoa', 37190, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/szek/kora-etkezoszek-samoa-king-barna-parma-b', 'https://i.postimg.cc/1trpvsjv/samoa.png', 4, 23, 5),
(337, 'Parma', 37190, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/szek/kora-etkezoszek-sosna-andersen-vilagosszurke-parma-b', 'https://i.postimg.cc/d1Y2RL47/parma.png', 4, 23, 5),
(338, 'Dorian', 115990, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/talaloszekreny/dorian-talaloszekreny-2-uvegezett-es-2-normal-ajtoval-led-es-diszvilagitassal', 'https://i.postimg.cc/pTW9X8sB/dorian.png', 4, 22, 5),
(339, 'Gray', 98990, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/talaloszekreny/gray-talaloszekreny-1-uvegezett-es-2-normal-ajtoval', 'https://i.postimg.cc/ZqhB2X32/gray.png', 4, 22, 5),
(340, 'Sandy', 107990, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/talaloszekreny/sandy-talaloszekreny-2-uvegezett-es-2-normal-ajtoval-beepitett-disz-es-belso-vilagitassal', 'https://i.postimg.cc/RFgW3F8x/sandy.png', 4, 22, 5),
(341, 'Marco', 115990, 'https://www.brwbutorhaz.hu/konyha/etkezo-butorok-216/talaloszekreny/marco-talaloszekreny-2-uvegezett-es-2-normal-ajtoval-beepitett-diszvilagitassal', 'https://i.postimg.cc/vmLgsXtB/marco.png', 4, 22, 5),
(342, 'Lionel', 42190, 'https://www.brwbutorhaz.hu/nappali-butorok-213/dohanyzoasztalok/lionel-dohanyzoasztal', 'https://i.postimg.cc/C1SvhPy6/lionel.png\r\n', 4, 3, 1),
(343, 'Frida', 33390, 'https://www.brwbutorhaz.hu/nappali-butorok-213/dohanyzoasztalok/frida-st-dohanyzoasztal-shirin-dio-parma-d', 'https://i.postimg.cc/s2p6RFLh/frida.png', 4, 3, 1),
(344, 'Aris', 37890, 'https://www.brwbutorhaz.hu/nappali-butorok-213/dohanyzoasztalok/aris-dohanyzoasztal-41504', 'https://i.postimg.cc/B6pmXT4Z/aris.png', 4, 3, 1),
(345, 'Orient', 97390, 'https://www.brwbutorhaz.hu/nappali-butorok-213/dohanyzoasztalok/orient-st-dohanyzoasztal-1-fiokkal-feher-parma-e', 'https://i.postimg.cc/ZnDjLJW1/orient.png\r\n', 4, 3, 1),
(346, 'Madison', 41490, 'https://www.brwbutorhaz.hu/nappali-butorok-213/dohanyzoasztalok/madison-system-14-dohanyzoasztal-31814', 'https://i.postimg.cc/NF0pTKj6/madison.png', 4, 3, 1),
(347, 'Gray', 66890, 'https://www.brwbutorhaz.hu/nappali-butorok-213/tv-allvany/gray-teveszekreny-2-ajtoval-es-1-fiokkal', 'https://i.postimg.cc/qBY8QbbV/gray.png', 4, 5, 1),
(348, 'Boston', 80990, 'https://www.brwbutorhaz.hu/nappali-butorok-213/tv-allvany/boston-rtv-teveszekreny-3-fiokkal-es-3-rekesszel-eszaki-fenyo-lefkas-tolgy', 'https://i.postimg.cc/FHb3r99N/boston.png', 4, 5, 1),
(349, 'Brillo', 66690, 'https://www.brwbutorhaz.hu/nappali-butorok-213/tv-allvany/brillo-rtv-tv-szekreny-2-ajtoval-es-2-rekesszel-szurke-feher', 'https://i.postimg.cc/hPdVYL6J/brillo.png', 4, 3, 1),
(350, 'Aris', 66190, 'https://www.brwbutorhaz.hu/nappali-butorok-213/tv-allvany/aris-tv-szekreny', 'https://i.postimg.cc/NjvRvyvd/aris.png', 4, 5, 1),
(351, 'Monsun', 78090, 'https://www.brwbutorhaz.hu/nappali-butorok-213/tv-allvany/monsun-system-8-tv-allvany-31598', 'https://i.postimg.cc/Jh1Jt9nJ/monsun.png', 4, 5, 1),
(352, 'Kora', 148990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/agy/kora-180x200-cm-agykeret-parma-b', 'https://i.postimg.cc/mkw3dBtb/kora.png', 4, 11, 3),
(353, 'Next', 138990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/agy/next-system-19-agykeret-32696', 'https://i.postimg.cc/ZnZFFCY7/next.png', 4, 11, 3),
(354, 'Planet', 148990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/agy/planet-system-14-agykeret-32276', 'https://i.postimg.cc/gcqKcq4f/planet.png', 4, 11, 3);
INSERT INTO `products` (`id`, `name`, `price`, `shoplink`, `imageurl`, `shopid`, `product_type_id`, `roomid`) VALUES
(355, 'Lionel', 118990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/agy/lionel-agykeret-160', 'https://i.postimg.cc/HLqtn6qC/lionel.png', 4, 11, 3),
(356, 'Bergen', 138990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/agy/bergen-system-13-agykeret-31715', 'https://i.postimg.cc/FR0VLjvk/bergen.png', 4, 11, 3),
(357, 'Naomi', 36290, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/ejjeli-szekreny/naomi-ejjeliszekreny-orlando-d', 'https://i.postimg.cc/bvxRGxpD/naomi.png', 4, 13, 3),
(358, 'York', 37990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/ejjeli-szekreny/york-ejjeliszekreny', 'https://i.postimg.cc/MHF0ktb4/york.png', 4, 13, 3),
(359, 'Málta', 28790, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/ejjeli-szekreny/malta-sn-ejjeliszekreny-1-fiokkal-szurke-artisan-tolgy-parma-c', 'https://i.postimg.cc/mDVNjTcT/m-lta.png', 4, 13, 3),
(360, 'Indygo', 19690, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/ejjeli-szekreny/indygo-sn-ejjeliszekreny-wotan-tolgy-zold-szinben-48636', 'https://i.postimg.cc/sxXP0bS7/indygo.png', 4, 13, 3),
(361, 'Wotan', 19690, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/ejjeli-szekreny/indygo-sn-ejjeliszekreny-wotan-tolgy-bezs-szinben-48633', 'https://i.postimg.cc/85TmL7zy/wotan.png', 4, 13, 3),
(362, 'Brando', 148990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/gardrob/brando-akasztos-szekreny-4-ajtoval', 'https://i.postimg.cc/xTmNT00q/brando.png', 4, 14, 3),
(363, 'Delta', 257990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/gardrob/delta-system-1-gardrobsziget-135-x-135-cm-tolgy-antracit-szinu', 'https://i.postimg.cc/GpL4QGvs/delta.png', 4, 14, 3),
(364, 'Kora', 243990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/gardrob/kora-ks3-gardrobszekreny-2-tukros-es-2-normal-ajtoval-2-fiokkal-parma-b', 'https://i.postimg.cc/cLMKwXtS/ks3.png', 4, 14, 3),
(365, 'Planet', 280990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/gardrob/planet-system-1-gardrobsziget-135-x-135-cm-fekete-tolgy-bezs-szinu', 'https://i.postimg.cc/R0gNbhTp/planet.png', 4, 14, 3),
(366, 'Kora', 114990, 'https://www.brwbutorhaz.hu/haloszoba-butorok-135/gardrob/kora-gardrobszekreny-2-ajtoval-es-2-fiokkal-parma-b', 'https://i.postimg.cc/0yqMzLQn/kora.png', 4, 14, 3),
(367, 'Naomi', 39290, 'https://www.brwbutorhaz.hu/eloszoba-butorok-94/tukor/naomi-tukor-orlando-d', 'https://i.postimg.cc/ryrP1Pc3/naomi.png', 4, 16, 4),
(368, 'Kora', 40590, 'https://www.brwbutorhaz.hu/eloszoba-butorok-94/tukor/kora-tukor-131x84-cm-parma-b', 'https://i.postimg.cc/GhnSqxm2/kora.png', 4, 16, 4),
(369, 'Kora', 40590, 'https://www.brwbutorhaz.hu/eloszoba-butorok-94/tukor/kora-tukor-131-x-84-cm-sosna-andersen-parma-b', 'https://i.postimg.cc/RhKpvNX4/fkora.png', 4, 16, 4),
(370, 'Alling', 54900, 'https://jysk.hu/etkezo/etkezoasztalok/etkezoasztalok/etkezoasztal-alling-80x100/163-tolgyszinu', 'https://i.postimg.cc/LsV1FRzw/alling.png', 1, 21, 5),
(371, 'Foldingbro', 54900, 'https://jysk.hu/etkezo/etkezoasztalok/etkezoasztalok/etkezoasztal-foldingbro-75x38/84/130-tolgyszinu', 'https://i.postimg.cc/28Pv40kc/foldingbro.png', 1, 21, 5),
(372, 'Ringsted', 69900, 'https://jysk.hu/etkezo/etkezoasztalok/etkezoasztalok/etkezoasztal-ringsted-atm100-fekete-koris-furner', 'https://i.postimg.cc/V6LbYTg6/ringsted.png', 1, 21, 5),
(373, 'Krondal', 69900, 'https://jysk.hu/etkezo/etkezoasztalok/etkezoasztalok/etkezoasztal-krondal-90x180-marvany-fekete-szinu', 'https://i.postimg.cc/DzhXNmb1/krondal.png', 1, 21, 5),
(374, 'Krondal', 69900, 'https://jysk.hu/etkezo/etkezoasztalok/etkezoasztalok/etkezoasztal-krondal-atm110-marvany-fekete', 'https://i.postimg.cc/P5YDK1Nt/kkrondal.png', 1, 21, 5),
(375, 'Staby', 11000, 'https://jysk.hu/etkezo/etkezoszekek/etkezoszek-staby-rakasolhato-fekete', 'https://i.postimg.cc/FHNSW7S3/staby.png\r\n', 1, 23, 5),
(376, 'Bistrup', 19900, 'https://jysk.hu/etkezo/etkezoszekek/etkezoszek-bistrup-olivazold/tolgy', 'https://i.postimg.cc/dt8dj8hJ/bistrup.png', 1, 23, 5),
(377, 'Jegind', 26900, 'https://jysk.hu/etkezo/etkezoszekek/etkezoszek-jegind-tolgy/fekete-0', 'https://i.postimg.cc/qvw394cY/jegind.png\r\n', 1, 23, 5),
(378, 'Sneslev', 64900, 'https://jysk.hu/etkezo/talalok-es-vitrinek/talaloszekrenyek/talalo-sneslev-2-polcos-fekete', 'https://i.postimg.cc/W1y2Dysz/sneslev.png\r\n', 1, 22, 5),
(379, 'Markskel', 229800, 'https://jysk.hu/etkezo/talalok-es-vitrinek/talaloszekrenyek/talalo-markskelfelso-szekreny-markskel', 'https://i.postimg.cc/hPp4njw9/markskel.png', 1, 22, 5),
(380, 'Langeline', 149900, 'https://jysk.hu/etkezo/talalok-es-vitrinek/vitrin-szekrenyek/vitrin-langelinie-2-ajtos-tolgy', 'https://i.postimg.cc/htvDtnWN/langelinie.png', 1, 22, 5),
(381, 'Markskel', 154900, 'https://jysk.hu/etkezo/talalok-es-vitrinek/vitrin-szekrenyek/vitrin-markskel-2-ajtos-1-fiokos-szurke/tolgyszinu', 'https://jysk.hu/etkezo/talalok-es-vitrinek/talaloszekrenyek/talalo-markskelfelso-szekreny-markskel', 1, 22, 5),
(382, 'Vesterby', 179900, 'https://jysk.hu/etkezo/talalok-es-vitrinek/vitrin-szekrenyek/vitrin-vesterby-magas-2-ajtos-sotet-tolgy', 'https://i.postimg.cc/cJ8dfcJm/verterby.png\r\n', 1, 22, 5),
(383, 'Gedved', 259900, 'https://jysk.hu/nappali/kanapek/sarokkanape-gedved-szurke', 'https://i.postimg.cc/MpH9PPVy/gedved.png', 1, 1, 1),
(384, 'Gistrup', 125000, 'https://jysk.hu/nappali/kanapek/kanape-gistrup-2-szemelyes-sotetkek-szovet', 'https://i.postimg.cc/FFbC7JhJ/gistrup.png', 1, 1, 1),
(385, 'Egense', 189900, 'https://jysk.hu/nappali/kanapek/sarokkanape-egense-homok-szovet/tolgyszinu', 'https://i.postimg.cc/282HxRbk/egense.png\n', 1, 1, 1),
(386, 'Hundige', 169900, 'https://jysk.hu/nappali/kanapek/kanape-hundige-2-szemelyes-bezs-szovet', 'https://i.postimg.cc/nLQ0ZXdr/hundige.png', 1, 1, 1),
(387, 'Egedal', 159900, 'https://jysk.hu/nappali/kanapek/kanape-egedal-25-szemelyes-zold-barsony-szovet', 'https://i.postimg.cc/dtqHdt0N/egedal.png', 1, 1, 1),
(388, 'Turup', 7500, 'https://jysk.hu/nappali/kisasztal/dohanyzoasztal/sarokasztal-turup-atm40-marvany/fekete', 'https://i.postimg.cc/3JRqVxH4/turup.png', 1, 3, 1),
(389, 'Dokkedal', 34900, 'https://jysk.hu/nappali/kisasztal/dohanyzoasztal/dohanyzoasztal-dokkedal-75x115-betonszurke', 'https://i.postimg.cc/qv65BDqp/dokkedal.png', 1, 3, 1),
(390, 'Falsled', 29900, 'https://jysk.hu/nappali/kisasztal/dohanyzoasztal/kisasztal-szett-falsled-atm50/40-uveg/tolgy-2-db', 'https://i.postimg.cc/kXpHmPnj/falsled.png', 1, 3, 1),
(391, 'Nyborg', 44900, 'https://jysk.hu/nappali/kisasztal/dohanyzoasztal/dohanyzoasztal-nyborg-60x110-1-polccal-barna/uveg', 'https://i.postimg.cc/3wMbkj0m/nyborg.png', 1, 3, 1),
(392, 'Sneslev', 59900, 'https://jysk.hu/nappali/tv-allvanyok/tv-allvany-sneslev-1-polcos-fekete', 'https://i.postimg.cc/15qGfkG7/sneslev.png', 1, 3, 1),
(393, 'Sneslev', 59900, 'https://jysk.hu/nappali/tv-allvanyok/tv-allvany-sneslev-1-polcos-tolgyszinu', 'https://i.postimg.cc/T3jncnHr/sneslevt.png', 1, 3, 1),
(394, 'Evetofte', 54900, 'https://jysk.hu/nappali/tv-allvanyok/tv-allvany-evetofte-vilagos-tolgyszinu', 'https://i.postimg.cc/131p6vMm/evetofte.png', 1, 3, 1),
(395, 'Krondal', 74900, 'https://jysk.hu/nappali/tv-allvanyok/tv-allvany-krondal-2-ajtos-fekete-marvanyszinu', 'https://i.postimg.cc/y65h61ZS/krondal.png', 1, 3, 1),
(396, 'Sandby', 144900, 'https://jysk.hu/nappali/tv-allvanyok/tv-allvany-sandby-2-ajtos-natur-tolgy/fekete', 'https://i.postimg.cc/Y0JQdRHx/sandby.png', 1, 3, 1),
(397, 'Abildro', 55000, 'https://jysk.hu/haloszoba/agykeretek/agykeret-abildro-140x200-fekete', 'https://i.postimg.cc/MHT890DX/abildro.png', 1, 11, 3),
(398, 'Kongsberg', 119900, 'https://jysk.hu/haloszoba/agykeretek/agykeret-kongsberg-140x200-szurke', 'https://i.postimg.cc/G37RHNLD/kongsberg.png', 1, 11, 3),
(399, 'Markskel', 149900, 'https://jysk.hu/haloszoba/agykeretek/agykeret-markskel-140x200-tolgy/feher', 'https://i.postimg.cc/wMGYZtf2/markskel.png', 1, 11, 3),
(400, 'Egeby', 24900, 'https://jysk.hu/haloszoba/ejjeliszekrenyek/ejjeliszekreny-egeby-1-fiokos-feher', 'https://i.postimg.cc/50txrM9x/egeby.png', 1, 13, 3),
(401, 'Odense', 29900, 'https://jysk.hu/haloszoba/ejjeliszekrenyek/ejjeliszekreny-odense-2-fiokos-tolgyszinu/fekete', 'https://i.postimg.cc/mZJbmqvs/odense.png', 1, 13, 3),
(402, 'Hokksund', 22900, 'https://jysk.hu/haloszoba/ejjeliszekrenyek/ejjeliszekreny-hokksund-1-fiokos-sotet-tolgy', 'https://i.postimg.cc/NF9Qg7rS/hokksund.png', 1, 13, 3),
(403, 'Hemdrup', 29900, 'https://jysk.hu/haloszoba/ejjeliszekrenyek/ejjeliszekreny-hemdrup-1-fiokos-tolgyszinu/fekete', 'https://i.postimg.cc/3RbK5bW2/hemdrup.png', 1, 13, 3),
(404, 'Lyngvig', 39900, 'https://jysk.hu/haloszoba/ejjeliszekrenyek/ejjeliszekreny-lyngvig-2-toloajtoval-natur-tolgy', 'https://i.postimg.cc/5yhbjYB0/lyngvig.png', 1, 13, 3),
(405, 'Fundrup', 32500, 'https://jysk.hu/tarolas/ruhasszekrenyek/ruhasszekrenyek/ruhasszekreny-fandrup-50x176-1-ajtos-vilagos-tolgy', 'https://i.postimg.cc/Z5VYxRZf/fandrup.png', 1, 14, 3),
(406, 'Billund', 79900, 'https://jysk.hu/tarolas/ruhasszekrenyek/ruhasszekrenyek/ruhasszekreny-billund-80x193-feher/szur', 'https://i.postimg.cc/kgnXS8r6/billund.png', 1, 14, 3),
(407, 'Vellerup', 119900, 'https://jysk.hu/tarolas/ruhasszekrenyek/ruhasszekrenyek/ruhasszekreny-vellerup-101x200-kombi-vilagos-tolgyszinu', 'https://i.postimg.cc/9fkWsnDZ/vellerup.png', 1, 14, 3),
(408, 'Manderup', 129900, 'https://jysk.hu/tarolas/ruhasszekrenyek/ruhasszekrenyek/ruhasszekreny-manderup-88x199-2-ajtos-sotet-tolgyszinu', 'https://i.postimg.cc/1zXmCQ3y/manderup.png', 1, 14, 3),
(409, 'Manderup', 189900, 'https://jysk.hu/tarolas/ruhasszekrenyek/ruhasszekrenyek/ruhasszekreny-manderup-128x199-3-ajtos-sotet-tolgy', 'https://i.postimg.cc/RFnMmLt8/manderupp.png', 1, 14, 3),
(410, 'Nordborg', 24900, 'https://jysk.hu/lakberendezes/tukrok/tukor-nordborg-70x90-feher', 'https://i.postimg.cc/tJKnyg7d/nordborg.png', 1, 16, 4),
(411, 'Kalvehuse', 6500, 'https://jysk.hu/lakberendezes/tukrok/tukor-szett-kalvehuse-ellipszis-7-db/szett', 'https://i.postimg.cc/d1STH6Yx/kalvehuse.png', 1, 16, 4),
(412, 'Strudstrup', 69900, 'https://jysk.hu/lakberendezes/tukrok/tukor-studstrup-80x180-fekete', 'https://i.postimg.cc/G3VyvXzB/studstrup.png', 1, 16, 4),
(413, 'Iljberg', 24900, 'https://jysk.hu/lakberendezes/tukrok/tukor-ilbjerg-40x160-fekete', 'https://i.postimg.cc/tTgxNfL6/ilbjerg.png', 1, 16, 4),
(414, 'Nordborg', 39900, 'https://jysk.hu/lakberendezes/tukrok/tukor-nordborg-40x160-ezust', 'https://i.postimg.cc/0jMKLS52/nordborgg.png', 1, 16, 4),
(415, 'Infinity', 6000, 'https://jysk.hu/lakberendezes/mosokonyha/szennyeskosarak/szennyeskosar-infinity-muanyag-szurke', 'https://i.postimg.cc/ry3hZXqM/infinity.png', 1, 36, 4),
(416, 'Curt', 11500, 'https://jysk.hu/lakberendezes/mosokonyha/szennyeskosarak/szennyeskosar-curt-atm40xma55cm-tetovel', 'https://i.postimg.cc/ZYC7LKtw/curt.png', 1, 36, 4),
(417, 'Axel', 7500, 'https://jysk.hu/lakberendezes/mosokonyha/ruhaszaritok-stb/ruhaszarito-axel-sz55xh171xma89/99cm-szurke', 'https://i.postimg.cc/Z0zn2DDV/axel.png', 1, 36, 4),
(418, 'Leifheit', 17500, 'https://jysk.hu/lakberendezes/mosokonyha/ruhaszaritok-stb/ruhaszarito-leifheit-pegasus-160-16-m-szarito-felulettel', 'https://i.postimg.cc/NfXdWJ0T/leifheit.png', 1, 36, 4),
(419, 'Bert', 12500, 'https://jysk.hu/lakberendezes/mosokonyha/vasalodeszkak/vasalodeszka-bert-sz30xh110xma73-89cm', 'https://i.postimg.cc/brtd6jLZ/bert.png', 1, 36, 4),
(420, 'Bold', 399865, 'https://www.zondo.hu/univerzalis-uelogarnitura-bold-itaka-10-1063801', 'https://files.catbox.moe/bhhoxc.png', 12, 1, 1),
(421, 'Kenfast', 506293, 'https://www.zondo.hu/sarokkanape-kenfast-smaragd-j-1034045', 'https://files.catbox.moe/jv5h98.png', 12, 1, 1),
(422, 'Nolano', 176873, 'https://www.zondo.hu/kanape-nolano-1020822', 'https://files.catbox.moe/mbx2e2.png\r\n', 12, 1, 1),
(423, 'Broken', 121125, 'https://www.zondo.hu/hevero-broken-b-1002507', 'https://files.catbox.moe/o3m7lh.png\r\n', 12, 1, 1),
(424, 'Petoria', 222485, 'https://www.zondo.hu/sarokkanape-petoria-new-barna-j-794301', 'https://files.catbox.moe/itu2r1.png', 12, 1, 1),
(425, 'Kendal', 84900, 'https://www.zondo.hu/dohanyzoasztal-kendal-elaw-130-gesztenye-880787', 'https://files.catbox.moe/8q1spn.png', 12, 3, 1),
(426, 'Gary', 45105, 'https://www.zondo.hu/dohanyzoasztal-gary-typ-19-772106', 'https://files.catbox.moe/hrhwxs.png', 12, 3, 1),
(427, 'Bilsby', 101900, 'https://www.zondo.hu/dohanyzoasztal-bilsby-typ-97-ribbec-toelgy-szuerke-1030331', 'https://files.catbox.moe/9j645n.png', 12, 3, 1),
(428, 'Rocco', 40037, 'https://www.zondo.hu/dohanyzoasztal-rocco-751031', 'https://files.catbox.moe/1vlj47.png', 12, 3, 1),
(429, 'Camber', 64900, 'https://www.zondo.hu/dohanyzoasztal-camber-c19-sonoma-toelgy-606037', 'https://files.catbox.moe/2ymulj.png', 12, 3, 1),
(430, 'Faro', 146465, 'https://www.zondo.hu/etkezoasztal-faro-cseresznye-4-10-fo-szamara-752810', 'https://files.catbox.moe/ybygcp.png', 12, 21, 5),
(431, 'Gideron', 56000, 'https://www.zondo.hu/etkezoasztal-80-cm-gideron-kiarusitas-1033589', 'https://files.catbox.moe/r9qh65.png\r\n', 12, 21, 5),
(432, 'Sentos', 115900, 'https://www.zondo.hu/etkezoasztal-sentos-6-8-fo-reszere-608058', 'https://files.catbox.moe/1cdjdz.png', 12, 21, 5),
(433, 'Solus', 92900, 'https://www.zondo.hu/etkezoasztal-solus-4-6-fo-reszere-608002', 'https://files.catbox.moe/7ln21a.png', 12, 21, 5),
(434, 'Allan', 75900, 'https://www.zondo.hu/etkezoasztal-allan-120-sonoma-toelgy-4-6-szemelyes-787142', 'https://files.catbox.moe/4jxmk3.png\r\n', 12, 21, 5),
(435, 'PK', 23900, 'https://www.zondo.hu/polc-pk-118-753390', 'https://files.catbox.moe/de2o1g.png\r\n', 12, 22, 5),
(436, 'Camber', 31900, 'https://www.zondo.hu/polc-camber-c27-sonoma-toelgy-606046', 'https://files.catbox.moe/2ejhpz.png', 12, 22, 5),
(437, 'Dessi', 11150, 'https://www.zondo.hu/polc-dessi-typ-2-1015705', 'https://files.catbox.moe/wkjaln.png', 12, 22, 5),
(438, 'Rihana', 10643, 'https://www.zondo.hu/polc-rihana-typ-19-90-794463', 'https://files.catbox.moe/uhqgsz.png', 12, 22, 5),
(439, 'Cyzara', 31900, 'https://www.zondo.hu/falipolc-cyzara-001-wotan-1054281', 'https://files.catbox.moe/jstdi0.png', 12, 22, 5),
(440, 'Étkezőszék', 46900, 'https://www.zondo.hu/etkezoszek-1039623', 'https://files.catbox.moe/jhdp4m.png', 12, 23, 5),
(441, 'Santa', 34969, 'https://www.zondo.hu/etkezoszek-santa-new-soetetszuerke-feher-772783', 'https://files.catbox.moe/b2jah2.png', 12, 23, 5),
(442, 'Abalia', 30357, 'https://www.zondo.hu/etkezoszek-abalia-new-feher-krom-808095', 'https://files.catbox.moe/hg7ip2.png', 12, 23, 5),
(443, 'Michigin', 70445, 'https://www.zondo.hu/egyszemelyes-agy-90-cm-michigin-grafit-tarolohellyel-1096897', 'https://files.catbox.moe/3erp5g.png', 12, 11, 3),
(444, 'Greta', 237689, 'https://www.zondo.hu/egyszemelyes-szetnyithato-agy-90-cm-greta-agyracsokkal-1001753', 'https://files.catbox.moe/mjwom1.png', 12, 11, 3),
(445, 'Bagira', 212349, 'https://www.zondo.hu/emeletes-agy-90-cm-bagira-agyraccsal-744968', 'https://files.catbox.moe/tehv8j.png', 12, 11, 3),
(446, 'Timlu', 75513, 'https://www.zondo.hu/egyszemelyes-agy-90-cm-timlu-agyraccsal-1017209', 'https://files.catbox.moe/t8lekb.png', 12, 11, 3),
(447, 'Margery', 88690, 'https://www.zondo.hu/egyszemelyes-agy-90-cm-margery-agyraccsal-794107', 'https://files.catbox.moe/o82xw0.png', 12, 11, 3),
(448, 'Glynda', 59900, 'https://www.zondo.hu/ejjeliszekreny-glynda-typ-22-monastery-toelgy-fenyes-fekete-1030090', 'https://files.catbox.moe/04b95x.png', 12, 13, 3),
(449, 'Camber', 41900, 'https://www.zondo.hu/ejjeliszekreny-camber-c21-sonoma-toelgy-j-606040', 'https://files.catbox.moe/9d3x48.png\r\n', 12, 13, 3),
(450, 'Cleania', 27900, 'https://www.zondo.hu/ejjeliszekreny-cleania-cl2-wenge-1067843', 'https://files.catbox.moe/w2t98w.png', 12, 13, 3),
(451, 'Kasey', 42900, 'https://www.zondo.hu/ejjeliszekreny-kasey-kom1s-sonoma-toelgy-798003', 'https://files.catbox.moe/83qw28.png\r\n', 12, 13, 3),
(452, 'Perry', 29901, 'https://www.zondo.hu/ejjeliszekreny-perry-70070-feher-751961', 'https://files.catbox.moe/mbjxxd.png', 12, 13, 3),
(453, 'Wopim', 176900, 'https://www.zondo.hu/gardrobszekreny-wopim-i-trueffel-786027', 'https://files.catbox.moe/1t8bmd.png', 12, 14, 3),
(454, 'Coletta', 162900, 'https://www.zondo.hu/ruhasszekreny-coletta-iii-fekete-artisan-toelgy-1047521', 'https://files.catbox.moe/q7vi2s.png', 12, 14, 3),
(455, 'Elvina', 354900, 'https://www.zondo.hu/ruhasszekreny-tuekoerrel-elvina-s-typ-19-zoeld-lefkas-toelgy-1031003', 'https://files.catbox.moe/8pl4wl.png', 12, 14, 3),
(456, 'Delena', 172900, 'https://www.zondo.hu/ruhasszekreny-delana-iii-fekete-artisan-toelgy-1047531', 'https://files.catbox.moe/o65pr2.png', 12, 14, 3),
(457, 'Rivkah', 72900, 'https://www.zondo.hu/fali-tuekoer-rivkah-arany-1075687', 'https://files.catbox.moe/587mjw.png', 12, 16, 4),
(458, 'Rionisio', 36900, 'https://www.zondo.hu/fali-tuekoer-rionisio-feher-1075548', 'https://files.catbox.moe/z4ooos.png', 12, 16, 4),
(459, 'Shell', 27900, 'https://www.zondo.hu/fali-tuekoer-shell-arany-1075799', 'https://files.catbox.moe/x3c0ra.png', 12, 16, 4),
(460, 'Tarazed', 22900, 'https://www.zondo.hu/fali-tuekoer-tarazed-fekete-1076025', 'https://files.catbox.moe/7nixeg.png', 12, 16, 4),
(461, 'Tempest', 33900, 'https://www.zondo.hu/fali-tuekoer-tempest-fekete-1076136', 'https://files.catbox.moe/yx02m9.png', 12, 16, 4),
(462, 'Britannia', 349990, 'https://www.rs.hu/iroda/irodabutorok/iroda/irodabutorok/britannia_kanape-27', 'https://i.postimg.cc/bJLDmJ6m/britannia.png', 3, 1, 1),
(463, 'Amsterdam', 409990, 'https://www.rs.hu/iroda/irodabutorok/iroda/irodabutorok/amsterdam_kanape-25', 'https://i.postimg.cc/nVR97X9z/amsterdam.png', 3, 1, 1),
(464, 'Manhattan', 499990, 'https://www.rs.hu/iroda/irodabutorok/iroda/irodabutorok/manhattan_kanape-6', 'https://i.postimg.cc/T1wyF6Ff/manhattan.png', 3, 1, 1),
(465, 'New C', 539990, 'https://www.rs.hu/iroda/irodabutorok/iroda/irodabutorok/new-c_kanape-15', 'https://i.postimg.cc/7Y5GNqSN/newc.png', 3, 1, 1),
(466, 'Cleveland', 301300, 'https://www.rs.hu/iroda/irodabutorok/iroda/irodabutorok/cleveland_kanape-1', 'https://i.postimg.cc/ZnM9hQz3/cleveland.png', 3, 1, 1),
(467, 'Azzura', 39100, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/azzura_dohanyzoasztal_feher', 'https://i.postimg.cc/j5W24X7S/azzura.png', 3, 3, 1),
(468, 'Praga', 107080, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/praga_dohanyzoasztal-14', 'https://i.postimg.cc/J0Zh9zKw/praga.png', 3, 3, 1),
(469, 'Tokyo', 47900, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/tokyo_dohanyzoasztal', 'https://i.postimg.cc/1tLtCqGc/tokyo.png', 3, 3, 1),
(470, 'Capri', 55500, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/capri_dohanyzoasztal-1', 'https://i.postimg.cc/HWyjJ6mS/capri.png\r\n', 3, 3, 1),
(471, 'Lexa', 145990, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/lexa_tv_allvany_147_cm', 'https://i.postimg.cc/L5xP8VGk/lexa.png', 3, 5, 1),
(472, 'Kaspian', 32990, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/kaspian_tv_allvany_144_cm', 'https://i.postimg.cc/0QdmLvfB/kaspian.png', 3, 5, 1),
(473, 'Anikó', 98500, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/aniko_tv_allvany_125_cm-6', 'https://i.postimg.cc/jdjNkGJM/aniko.png', 3, 5, 1),
(474, 'Vanessa', 100990, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/vanessa_tv_allvany_150_cm-9', 'https://i.postimg.cc/tRkWkX71/vanessa.png', 3, 5, 1),
(475, 'Dávid', 58400, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/david_tv_allvany_130_cm-7', 'https://i.postimg.cc/T1dmxsNY/david.png', 3, 5, 1),
(476, 'Anton', 82100, 'https://www.rs.hu/konyha/etkezobutorok/konyha/etkezobutorok/anton_etkezoasztal_80x140_cm', 'https://i.postimg.cc/Jhhz1LMF/anton.png', 3, 21, 5),
(477, 'Yohann', 117600, 'https://www.rs.hu/konyha/etkezobutorok/konyha/etkezobutorok/yohann_etkezoasztal_90x170_cm', 'https://i.postimg.cc/0QTkdKDg/yohann.png', 3, 21, 5),
(478, 'Firmino', 156900, 'https://www.rs.hu/konyha/etkezobutorok/konyha/etkezobutorok/firmino_etkezoasztal_90x180_cm', 'https://i.postimg.cc/0QM5w06d/firmino.png', 3, 21, 5),
(479, 'Oslo c', 329260, 'https://www.rs.hu/konyha/etkezobutorok/konyha/etkezobutorok/oslo-c_etkezoasztal_115x220_cm-21', 'https://i.postimg.cc/6Q15qmQp/osloc.png', 3, 21, 5),
(480, 'Vida', 249610, 'https://www.rs.hu/konyha/etkezobutorok/konyha/etkezobutorok/vida_etkezoasztal_100x190_cm-1', 'https://i.postimg.cc/kgs53438/vida.png', 3, 21, 5),
(481, 'Tokyo', 33990, 'https://www.rs.hu/konyha/etkezobutorok/konyha/etkezobutorok/tokyo_etkezoszek-52', 'https://i.postimg.cc/j28r3WJd/tokyo.png', 3, 23, 5),
(482, 'Toledo', 51990, 'https://www.rs.hu/konyha/etkezobutorok/konyha/etkezobutorok/toledo_etkezoszek-12', 'https://i.postimg.cc/HnWgt0nh/toledok.png', 3, 23, 5),
(483, 'Toledo', 53990, 'https://www.rs.hu/konyha/etkezobutorok/konyha/etkezobutorok/toledo_etkezoszek-13', 'https://i.postimg.cc/Tw6GKv6G/toledo.png', 3, 23, 5),
(484, 'Alberta', 45060, 'https://www.rs.hu/konyha/etkezobutorok/konyha/etkezobutorok/alberta_etkezoszek-33', 'https://i.postimg.cc/Kctf7Shw/albartab.png', 3, 23, 5),
(485, 'Alberta', 46480, 'https://www.rs.hu/konyha/etkezobutorok/konyha/etkezobutorok/alberta_etkezoszek-65', 'https://i.postimg.cc/CLYNmPF1/alberta.png', 3, 23, 5),
(486, 'Vanessa', 77400, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/vanessa_polc_120x124x31_cm-3', 'https://i.postimg.cc/RCTfVMBS/vanessa.png', 3, 22, 5),
(487, 'Rovere', 146990, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/rovere_polc_75x200x35_cm-1', 'https://i.postimg.cc/x8gbsPRJ/rovere.png', 3, 22, 5),
(488, 'Lili', 18490, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/lili_polc_80x18x18_cm', 'https://i.postimg.cc/ZR8NNmvL/lili.png', 3, 22, 5),
(489, 'Dove', 12990, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/dove_polc_150x20x20_cm-13', 'https://i.postimg.cc/yd49Wxxd/dove.png', 3, 22, 5),
(490, 'Marcus', 25800, 'https://www.rs.hu/otthon/nappali_butorok/otthon/nappali_butorok/marcus_polc_80x40x30_cm-3', 'https://i.postimg.cc/hvKdbY9R/marcus.png', 3, 22, 5),
(491, 'Lotus', 229990, 'https://www.rs.hu/otthon/gyermek_es_ifjusagi_szoba_butorok/otthon/gyermek_es_ifjusagi_szoba_butorok/lotus_hevero_90_cm-11', 'https://i.postimg.cc/9QK0mfFn/lotus.png', 3, 11, 3),
(492, 'Eger', 119990, 'https://www.rs.hu/otthon/gyermek_es_ifjusagi_szoba_butorok/otthon/gyermek_es_ifjusagi_szoba_butorok/eger_hevero_68_cm_drapp', 'https://i.postimg.cc/mr9DtGP2/eger.png', 3, 11, 3),
(493, 'Sonja', 209990, 'https://www.rs.hu/otthon/gyermek_es_ifjusagi_szoba_butorok/otthon/gyermek_es_ifjusagi_szoba_butorok/sonja_hevero_160_cm-25', 'https://i.postimg.cc/Y9fCzfN5/sonja.png', 3, 11, 3),
(494, 'Twist', 119990, 'https://www.rs.hu/otthon/gyermek_es_ifjusagi_szoba_butorok/otthon/gyermek_es_ifjusagi_szoba_butorok/twist_hevero_90_cm-7', 'https://i.postimg.cc/4yfNL7Bm/twist.png', 3, 11, 3),
(495, 'Boni', 139990, 'https://www.rs.hu/otthon/gyermek_es_ifjusagi_szoba_butorok/otthon/gyermek_es_ifjusagi_szoba_butorok/boni_hevero_90_cm-3', 'https://i.postimg.cc/hjqGm3m8/boni.png', 3, 11, 3),
(496, 'Prima', 51800, 'https://www.rs.hu/otthon/haloszoba_butorok/otthon/haloszoba_butorok/prima-2_ejjeliszekreny_szurke', 'https://i.postimg.cc/5yK1sPXR/prima.png', 3, 13, 3),
(497, 'Kaspian', 16990, 'https://www.rs.hu/otthon/haloszoba_butorok/otthon/haloszoba_butorok/kaspian_ejjeliszekreny', 'https://i.postimg.cc/hvtcbFtm/kaspian.png', 3, 13, 3),
(498, 'Vanessa', 43600, 'https://www.rs.hu/otthon/haloszoba_butorok/otthon/haloszoba_butorok/vanessa_ejjeliszekreny-6', 'https://i.postimg.cc/ZKg43Mt9/vanessa.png', 3, 13, 3),
(499, 'Henkrik', 30990, 'https://www.rs.hu/otthon/haloszoba_butorok/otthon/haloszoba_butorok/henrik_ejjeliszekreny', 'https://i.postimg.cc/sD13MR8d/henrik.png', 3, 13, 3),
(500, 'Alba', 54990, 'https://www.rs.hu/otthon/haloszoba_butorok/otthon/haloszoba_butorok/alba_ejjeliszekreny', 'https://i.postimg.cc/gcgYc0gH/alba.png', 3, 13, 3),
(501, 'Gála', 34990, 'https://www.rs.hu/otthon/eloszoba_butorok/otthon/eloszoba_butorok/gala_tukor_45x90_cm', 'https://i.postimg.cc/GpPCW3BY/gala.png', 3, 16, 4),
(502, 'Concerto', 82990, 'https://www.rs.hu/otthon/eloszoba_butorok/otthon/eloszoba_butorok/concerto_tukor_67x138_cm-4', 'https://i.postimg.cc/k4nmqr8H/concerto.png', 3, 16, 4),
(503, 'Koen', 23990, 'https://www.rs.hu/otthon/eloszoba_butorok/otthon/eloszoba_butorok/koen-ii_tukor_59x110_cm', 'https://i.postimg.cc/FRDQKPVH/koen.png', 3, 16, 4),
(504, 'Kaspian', 19990, 'https://www.rs.hu/otthon/eloszoba_butorok/otthon/eloszoba_butorok/kaspian_tukor_49x116_cm-1', 'https://i.postimg.cc/8CgGXfCN/kaspian.png', 3, 16, 4);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `producttype`
--

CREATE TABLE `producttype` (
  `id` int(11) NOT NULL,
  `categoryid` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `producttype`
--

INSERT INTO `producttype` (`id`, `categoryid`, `name`) VALUES
(1, 1, 'Kanapé'),
(3, 1, 'Dohányzóasztal'),
(5, 1, 'Tv állvány'),
(11, 3, 'Ágy'),
(13, 3, 'Éjjeli szekrény'),
(14, 3, 'Ruhásszekrény'),
(16, 4, 'Tükör'),
(21, 5, 'Étkezőasztal'),
(22, 5, 'Polc és szekrény'),
(23, 5, 'Szék'),
(34, 4, 'Zuhanyzó'),
(35, 4, 'Fürdőszobai szekrény'),
(36, 4, 'Mosókonyhai eszközök');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `role`
--

CREATE TABLE `role` (
  `id` int(11) NOT NULL,
  `name` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `role`
--

INSERT INTO `role` (`id`, `name`) VALUES
(1, 'User'),
(2, 'Admin');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `shops`
--

CREATE TABLE `shops` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'weboldal neve',
  `websiteurl` varchar(255) DEFAULT NULL COMMENT 'weboldal url',
  `PhoneNumber` varchar(20) NOT NULL,
  `Email` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `shops`
--

INSERT INTO `shops` (`id`, `name`, `websiteurl`, `PhoneNumber`, `Email`) VALUES
(1, 'JYSK', 'https://jysk.hu/search?query=%C3%A1gy&type=product', '+3617014222', 'vevoszolgalat-hu@jysk.com'),
(2, 'Möbelix', 'https://www.moebelix.hu/', '+3646814113', 'info@moebelix.hu'),
(3, 'RS BÚTOR', 'https://www.rs.hu/', '+3613290050', 'rsinfo@rs.hu'),
(4, 'BRW bútorház', 'https://www.brwbutorhaz.hu/', '+36704012044', 'rob.butorhaz@gmail.com'),
(9, 'Alaba', 'https://alaba.hu/', '+36303661576', 'info@alaba.hu'),
(10, 'Bogart bútor', 'https://www.bogart-butor.hu/', '+3618089860', 'info@bogart-butor.hu'),
(12, 'Zondo.hu', 'https://www.zondo.hu/', '+3615507605', 'info@zondo.hu'),
(13, 'Bútorline', 'https://butorline.hu/', '+36202730605', 'info@butorline.hu'),
(14, 'Soma bútor', 'https://somabutor.hu/', '+36707975817', 'info@somabutor.hu');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `userplan`
--

CREATE TABLE `userplan` (
  `id` int(11) NOT NULL,
  `userid` int(255) NOT NULL,
  `plandata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Termék ára' CHECK (json_valid(`plandata`)),
  `createdat` timestamp NULL DEFAULT current_timestamp() COMMENT 'Bolt linkje  '
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `userplan`
--

INSERT INTO `userplan` (`id`, `userid`, `plandata`, `createdat`) VALUES
(71, 1, '[{\"productId\":53,\"x\":-198,\"y\":534,\"scale\":0.6},{\"productId\":73,\"x\":-68,\"y\":569,\"scale\":0.5},{\"productId\":174,\"x\":195,\"y\":485,\"scale\":0.7},{\"productId\":347,\"x\":946,\"y\":439,\"scale\":0.7999999999999999}]', '2025-03-13 20:09:41');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `userroles`
--

CREATE TABLE `userroles` (
  `Userid` int(11) NOT NULL,
  `Roleid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `userroles`
--

INSERT INTO `userroles` (`Userid`, `Roleid`) VALUES
(1, 1),
(4, 2);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `Id` int(11) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `UserName` varchar(255) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `fullname` varchar(40) NOT NULL,
  `datet` timestamp NOT NULL DEFAULT current_timestamp(),
  `ProfilePictureUrl` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`Id`, `Email`, `UserName`, `PasswordHash`, `fullname`, `datet`, `ProfilePictureUrl`) VALUES
(1, 'liptakr@kkszki.hu', 'admin', '$2a$11$zRttTfinJA9jvZuyvwsoL.c/gmnUL9Q4b27.tRw5ugAEQ/iROsqFe', 'Admin', '2025-03-13 17:58:46', '/profile_pictures/69f3dc9f-cc8a-4fa7-859a-1b23401616ad_tatra-mountains-landscape-foggy-morning-scenic-poland-europe-3840x2160-8023.jpg'),
(4, 'roomlabservice@gmail.com', 'admin', '$2a$11$1PvSDqce.OaZMB/XiQ88lOzsd5yUx7MNTMtoB93XixuF9kbxpgBqG', 'admin', '2025-03-13 18:55:27', '/profile_pictures/1d47ee50-4b68-492a-9164-b9ae3e6782aa_237604.jpg');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `__efmigrationshistory`
--

CREATE TABLE `__efmigrationshistory` (
  `MigrationId` varchar(150) NOT NULL,
  `ProductVersion` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `__efmigrationshistory`
--

INSERT INTO `__efmigrationshistory` (`MigrationId`, `ProductVersion`) VALUES
('20240921131732_Linkhandler', '8.0.10'),
('20240921155034_LoginRegisterValidatation', '8.0.10'),
('20250127200858_AddAccessFailedCount', '8.0.10'),
('20250127201800_updateduser', '8.0.10'),
('20250313172518_uj', '8.0.11');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `achievements`
--
ALTER TABLE `achievements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users` (`user_Id`);

--
-- A tábla indexei `kategories`
--
ALTER TABLE `kategories`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `planproducts`
--
ALTER TABLE `planproducts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Products` (`userplanid`),
  ADD KEY `product` (`productid`),
  ADD KEY `IX_planproducts_productid` (`productid`),
  ADD KEY `IX_planproducts_userplanid` (`userplanid`);

--
-- A tábla indexei `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bolt` (`shopid`),
  ADD KEY `szoba` (`roomid`),
  ADD KEY `tip` (`product_type_id`),
  ADD KEY `IX_products_product_type_id` (`product_type_id`),
  ADD KEY `IX_products_roomid` (`roomid`),
  ADD KEY `IX_products_shopid` (`shopid`);

--
-- A tábla indexei `producttype`
--
ALTER TABLE `producttype`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoryid` (`categoryid`),
  ADD KEY `IX_producttype_categoryid` (`categoryid`);

--
-- A tábla indexei `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `userplan`
--
ALTER TABLE `userplan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userid` (`userid`),
  ADD KEY `IX_userplan_userid` (`userid`);

--
-- A tábla indexei `userroles`
--
ALTER TABLE `userroles`
  ADD KEY `user` (`Userid`),
  ADD KEY `roles` (`Roleid`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`Id`);

--
-- A tábla indexei `__efmigrationshistory`
--
ALTER TABLE `__efmigrationshistory`
  ADD PRIMARY KEY (`MigrationId`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `kategories`
--
ALTER TABLE `kategories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT a táblához `planproducts`
--
ALTER TABLE `planproducts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- AUTO_INCREMENT a táblához `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=505;

--
-- AUTO_INCREMENT a táblához `producttype`
--
ALTER TABLE `producttype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT a táblához `role`
--
ALTER TABLE `role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `shops`
--
ALTER TABLE `shops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT a táblához `userplan`
--
ALTER TABLE `userplan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `achievements`
--
ALTER TABLE `achievements`
  ADD CONSTRAINT `uuu` FOREIGN KEY (`user_Id`) REFERENCES `users` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `planproducts`
--
ALTER TABLE `planproducts`
  ADD CONSTRAINT `plan` FOREIGN KEY (`userplanid`) REFERENCES `userplan` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product` FOREIGN KEY (`productid`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Megkötések a táblához `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `bolt` FOREIGN KEY (`shopid`) REFERENCES `shops` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `szoba` FOREIGN KEY (`roomid`) REFERENCES `kategories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tip` FOREIGN KEY (`product_type_id`) REFERENCES `producttype` (`id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `producttype`
--
ALTER TABLE `producttype`
  ADD CONSTRAINT `producttype_ibfk_1` FOREIGN KEY (`categoryid`) REFERENCES `kategories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `userplan`
--
ALTER TABLE `userplan`
  ADD CONSTRAINT `userplan_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `users` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `userroles`
--
ALTER TABLE `userroles`
  ADD CONSTRAINT `roles` FOREIGN KEY (`Roleid`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user` FOREIGN KEY (`Userid`) REFERENCES `users` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
