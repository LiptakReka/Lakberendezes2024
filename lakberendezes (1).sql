-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Feb 16. 19:33
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
-- Tábla szerkezet ehhez a táblához `aspnetroleclaims`
--

CREATE TABLE `aspnetroleclaims` (
  `Id` int(11) NOT NULL,
  `RoleId` varchar(255) NOT NULL,
  `ClaimType` longtext DEFAULT NULL,
  `ClaimValue` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetroles`
--

CREATE TABLE `aspnetroles` (
  `Id` varchar(255) NOT NULL,
  `Name` varchar(256) DEFAULT NULL,
  `NormalizedName` varchar(256) DEFAULT NULL,
  `ConcurrencyStamp` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `aspnetroles`
--

INSERT INTO `aspnetroles` (`Id`, `Name`, `NormalizedName`, `ConcurrencyStamp`) VALUES
('1a2a8d81-37dc-4d8b-91f0-c3777b6c52b7', 'Admin', 'ADMIN', NULL),
('da3f5225-f1dd-4f84-bbe0-be88737050a6', 'User', 'USER', NULL);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetuserclaims`
--

CREATE TABLE `aspnetuserclaims` (
  `Id` int(11) NOT NULL,
  `UserId` varchar(255) NOT NULL,
  `ClaimType` longtext DEFAULT NULL,
  `ClaimValue` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetuserlogins`
--

CREATE TABLE `aspnetuserlogins` (
  `LoginProvider` varchar(255) NOT NULL,
  `ProviderKey` varchar(255) NOT NULL,
  `ProviderDisplayName` longtext DEFAULT NULL,
  `UserId` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetuserroles`
--

CREATE TABLE `aspnetuserroles` (
  `UserId` varchar(255) NOT NULL,
  `RoleId` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `aspnetuserroles`
--

INSERT INTO `aspnetuserroles` (`UserId`, `RoleId`) VALUES
('1cd1b3ea-afc7-4b11-b7ee-a1657c6281c9', 'da3f5225-f1dd-4f84-bbe0-be88737050a6'),
('bc6f0ee3-c821-4bc9-939f-13af624db253', 'da3f5225-f1dd-4f84-bbe0-be88737050a6');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetusers`
--

CREATE TABLE `aspnetusers` (
  `Id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `Email` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PASSWORD_hash` varchar(255) NOT NULL COMMENT 'Titkosított jelszó ',
  `fullname` varchar(255) DEFAULT NULL COMMENT 'teljes neve ',
  `datet` timestamp NULL DEFAULT current_timestamp() COMMENT 'Mikor regisztrált',
  `AccessFailedCount` int(11) NOT NULL DEFAULT 0,
  `ConcurrencyStamp` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `EmailConfirmed` tinyint(1) NOT NULL DEFAULT 0,
  `LockoutEnabled` tinyint(1) NOT NULL DEFAULT 0,
  `LockoutEnd` datetime(6) DEFAULT NULL,
  `NormalizedEmail` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NormalizedUserName` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PasswordHash` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PhoneNumber` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PhoneNumberConfirmed` tinyint(1) NOT NULL DEFAULT 0,
  `SecurityStamp` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TwoFactorEnabled` tinyint(1) NOT NULL DEFAULT 0,
  `UserName` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ProfilePictureUrl` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `aspnetusers`
--

INSERT INTO `aspnetusers` (`Id`, `Email`, `PASSWORD_hash`, `fullname`, `datet`, `AccessFailedCount`, `ConcurrencyStamp`, `EmailConfirmed`, `LockoutEnabled`, `LockoutEnd`, `NormalizedEmail`, `NormalizedUserName`, `PasswordHash`, `PhoneNumber`, `PhoneNumberConfirmed`, `SecurityStamp`, `TwoFactorEnabled`, `UserName`, `ProfilePictureUrl`) VALUES
('1cd1b3ea-afc7-4b11-b7ee-a1657c6281c9', 'liptakr@kkszki.hu', '', 'Liptakreka', '2025-02-13 18:01:14', 0, '629bdd4a-c2b1-468b-9ccd-6f5b8eea8bdb', 0, 1, NULL, 'LIPTAKR@KKSZKI.HU', 'ADMIN', 'AQAAAAIAAYagAAAAEGFkRpjvsif8z63NVX0gXn85VV4HEZvaL1hAJUGM//u+Gm2QE/A9yKLc4ibDlaWHDA==', NULL, 0, 'NJJMDITFHJGVTWN23MIIIEDFE5ZCM7XI', 0, 'Admin', '/profile_pictures/83445db8-6157-4125-9339-d05155380777_aaa.jpg'),
('bc6f0ee3-c821-4bc9-939f-13af624db253', 'liptakreka4@gmail.com', '', 'Liptakr', '2025-02-02 10:57:33', 0, '78f30ea7-f6f1-4f27-a05b-b5c8734375fc', 0, 1, NULL, 'LIPTAKREKA4@GMAIL.COM', 'LIPTAKREKA4@GMAIL.COM', 'AQAAAAIAAYagAAAAECUODUkcc2eD8ABInNUtThSROitFTjsr/HD+Wg3qv7mabscFC0GZr4P16Pg09Wdevw==', NULL, 0, '4DOXM6GZ2U7VB5OQ3EEREKCXM7TF45XD', 0, 'liptakreka4@gmail.com', '');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetusertokens`
--

CREATE TABLE `aspnetusertokens` (
  `UserId` varchar(255) NOT NULL,
  `LoginProvider` varchar(255) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Value` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `aspnetusertokens`
--

INSERT INTO `aspnetusertokens` (`UserId`, `LoginProvider`, `Name`, `Value`) VALUES
('1cd1b3ea-afc7-4b11-b7ee-a1657c6281c9', 'ResetPassword', 'PasswordResetToken', 'CfDJ8CoTY2mQXxVKp2okMJV9kUW2ddXlYqyF/u8MIsHlKxXuXb9uhFEg15Kl+SK4oJoNARrJuX+i6Ef+r/FJvvaF9eILS6qwYbJ035aKmKo64KwD8zQAs4cQ1tVCAI7rewM0mb3yg00rrnNjMGA5vhYBHYWJ2OJGFdacSzKFn68emBjVwsIJ4K6fFrrAuqZ8s9GMacDOVqYFwDpnMZO3HJJz8cX6rEHg9Cw9+rtUtbP938R2'),
('bc6f0ee3-c821-4bc9-939f-13af624db253', 'ResetPassword', 'PasswordResetToken', 'CfDJ8CoTY2mQXxVKp2okMJV9kUUAJYRDuIAEjdfUtIDQsQ53DDdFsB6PYTLOQ8HvGA/2xVqWo55ebc5sjPljh28+sP+5cPyUHfvL7Rr6gYrh9W+oQJmNTfn+dGKI4aTEHraP+qK9ewH8gLEubzv6hsm14ibmfoip3VpqWaxNbNOiECuz0sToZbGRlYjaRQR93eGUk9VifXC5SaEQSk4cVzoasyEUx0ytSRWyhwo1QyN9X4rn');

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
(1, 'Livingroom'),
(3, 'Bedroom'),
(4, 'Bathroom'),
(5, 'Lunchroom');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `planproducts`
--

CREATE TABLE `planproducts` (
  `id` int(11) NOT NULL,
  `productid` int(11) NOT NULL,
  `position` varchar(255) NOT NULL,
  `userplanid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `planproducts`
--

INSERT INTO `planproducts` (`id`, `productid`, `position`, `userplanid`) VALUES
(6, 52, '100, 100', 15),
(7, 53, '-164, -77', 15),
(8, 132, '100, 100', 16),
(9, 133, '-152, -73', 16),
(10, 52, '100, 100', 17),
(11, 53, '-139, -62', 17),
(14, 132, '100, 100', 19),
(15, 133, '804, 125', 19),
(16, 53, '-169, 558', 20),
(17, 53, '-169, 558', 20),
(18, 57, '14, 321', 20),
(19, 53, '-96, 465', 21),
(20, 53, '-96, 465', 21),
(21, 57, '-11, 14', 21),
(22, 59, '-83, 505', 22),
(23, 72, '113, 546', 22);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL COMMENT 'Egyedi azonosító bútoroknak',
  `name` varchar(255) NOT NULL COMMENT 'A bútor neve',
  `price` decimal(10,2) DEFAULT NULL COMMENT 'Termék ára',
  `shoplink` varchar(255) DEFAULT NULL COMMENT 'Bolt linkje  ',
  `imageurl` varchar(255) DEFAULT NULL COMMENT 'termék képe',
  `shopid` int(11) DEFAULT NULL,
  `product_type_id` int(11) DEFAULT NULL,
  `roomid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `shoplink`, `imageurl`, `shopid`, `product_type_id`, `roomid`) VALUES
(1, 'Kihúzható Asztal Coburg 140/80 Cm', 69990.00, 'https://www.moebelix.hu/p/kihuzhato-asztal-coburg-140-80-cm-002478005115', 'https://i.postimg.cc/LX0791xk/coburg-removebg-preview.png', 2, 21, 5),
(2, 'Étkezőasztal Juliette', 59990.00, 'https://www.moebelix.hu/p/tkezoasztal-juliette-000055013601', 'https://i.postimg.cc/pLvHKn3k/a-removebg-preview.png', 2, 21, 5),
(3, 'Kihúzható Étkezőasztal Elara', 99990.00, 'https://www.moebelix.hu/p/kihuzhato-etkezoasztal-elara-000687071007', 'https://i.postimg.cc/CKSsW-xsF/Elara-tkez-asztal-removebg-preview.png', 2, 21, 5),
(4, 'Étkezőasztal Severin 138', 79990.00, 'https://www.moebelix.hu/p/tkezoasztal-severin-138-002647007606', 'https://i.postimg.cc/Pf3Rd8SV/Severin-138-removebg-preview.png', 2, 21, 5),
(5, 'Étkezőasztal Aron 138', 56990.00, 'https://www.moebelix.hu/p/tkezoasztal-aron-138-002647009201', 'https://i.postimg.cc/ZqfJZ528/Aron138-removebg-preview.png', 2, 21, 5),
(6, 'Étkezőasztal Wood 160', 229900.00, 'https://www.moebelix.hu/p/james-wood-tkezoasztal-wood-160-002730002503', 'https://i.postimg.cc/fLGynbSH/James-wood-removebg-preview.png', 2, 21, 5),
(7, 'Étkezőasztal Brick 80', 27990.00, 'https://www.moebelix.hu/p/tkezoasztal-brick-80-002647011202', 'https://i.postimg.cc/wTs5mtkB/Brick-removebg-preview.png', 2, 21, 5),
(8, 'Kihúzható Asztal Charme 160/90 Cm', 139900.00, 'https://www.moebelix.hu/p/kihuzhato-asztal-charme-160-90-cm-002546002001', 'https://i.postimg.cc/C170JLHB/Charme-removebg-preview.png', 2, 21, 5),
(9, 'Étkezőasztal Köln 75', 18990.00, 'https://www.moebelix.hu/p/tkezoasztal-koeln-75-001606005501', 'https://i.postimg.cc/4xWF87rT/Koeln-removebg-preview.png', 2, 21, 5),
(10, 'Étkezőasztal Bonny T', 89990.00, 'https://www.moebelix.hu/p/tkezoasztal-bonny-t-001606009706', 'https://i.postimg.cc/W3YNT1FR/Bonny-t-removebg-preview.png', 2, 21, 5),
(21, 'Szék Lech', 14990.00, 'https://www.moebelix.hu/p/szek-lech-001125019702', 'https://i.postimg.cc/LXT0z5KJ/lech-removebg-preview.png', 2, 23, 5),
(22, 'Szék Franzi', 7990.00, 'https://www.moebelix.hu/p/szek-franzi-001634010501', 'https://i.postimg.cc/mDzyrrZx/franzi-removebg-preview.png', 2, 23, 5),
(23, 'Szék John', 15990.00, 'https://www.moebelix.hu/p/szek-john-001013002911', 'https://i.postimg.cc/W4tHMTp8/jhon-removebg-preview.png', 2, 23, 5),
(24, 'Szék Basti Giga-S', 19990.00, 'https://www.moebelix.hu/p/szek-basti-giga-s-001634006201', 'https://i.postimg.cc/jqkCXhhh/basti-giga-removebg-preview.png', 2, 23, 5),
(25, 'Szék Anne Ii', 19990.00, 'https://www.moebelix.hu/p/szek-anne-ii-000758019902', 'https://i.postimg.cc/nzRCjKzM/anne-ii-removebg-preview.png', 2, 23, 5),
(26, 'Szék Anne\r\n', 15990.00, 'https://www.moebelix.hu/p/szek-anne-000758019802', 'https://i.postimg.cc/yYZ935zR/anne-removebg-preview.png', 2, 23, 5),
(27, 'Szánkótalpas Szék Teddy Giga-S', 29990.00, 'https://www.moebelix.hu/p/szankotalpas-szek-teddy-giga-s-000289015201', 'https://i.postimg.cc/L4BhdpRN/teddy-removebg-preview.png', 2, 23, 5),
(28, 'Szék Olivia Giga-S', 39990.00, 'https://www.moebelix.hu/p/szek-olivia-giga-s-000039003202', 'https://i.postimg.cc/vB4jrMhM/olivia-removebg-preview.png', 2, 23, 5),
(29, 'Szánkótalpas Szék Phil Giga-S', 37990.00, 'https://www.moebelix.hu/p/szankotalpas-szek-phil-giga-s-001634010601', 'https://i.postimg.cc/25bMvr2Y/phil-removebg-preview.png', 2, 23, 5),
(30, 'Szánkótalpas Szék Nick', 44990.00, 'https://www.moebelix.hu/p/szankotalpas-szek-nick-002540022501', 'https://i.postimg.cc/HWX8pNDP/nick-removebg-preview.png', 2, 23, 5),
(42, 'Falipolc Szett Simple', 4990.00, 'https://www.moebelix.hu/p/falipolc-szett-simple-007326001604', 'https://i.postimg.cc/rFD72rP8/simpeszett-removebg-preview.png', 2, 22, 5),
(43, 'Falipolc Isola\r\n', 11990.00, 'https://www.moebelix.hu/p/falipolc-isola-001803072102', 'https://i.postimg.cc/1txDXL9C/isola-removebg-preview.png', 2, 22, 5),
(44, 'Falipolc Bc 3105', 39990.00, 'https://www.moebelix.hu/p/falipolc-bc-3105-000887057201', 'https://i.postimg.cc/wjC1QLS3/bc-removebg-preview.png', 2, 22, 5),
(45, 'Falipolc Linate', 19990.00, 'https://www.moebelix.hu/p/falipolc-linate-001803072907\r\n', 'https://i.postimg.cc/8zmCM9BX/linate-removebg-preview.png', 2, 22, 5),
(46, 'Falipolc Elke', 9990.00, 'https://www.moebelix.hu/p/falipolc-elke-001803038601', 'https://i.postimg.cc/R022FV6k/elke-removebg-preview.png', 2, 22, 5),
(47, 'Falipolc Szett Sven', 19990.00, 'https://www.moebelix.hu/p/moebelix-falipolc-szett-sven-000366002501\r\n', 'https://i.postimg.cc/C1VJXZfx/sven-removebg-preview.png', 2, 22, 5),
(48, 'Falipolc Kashmir New', 12990.00, 'https://www.moebelix.hu/p/james-wood-falipolc-kashmir-new-001803052805', 'https://i.postimg.cc/QMWhSzpr/jamesw-ood-removebg-preview.png', 2, 22, 5),
(49, 'Falipolc Alassio', 18990.00, 'https://www.moebelix.hu/p/luca-bessoni-falipolc-alassio-001803056907', 'https://i.postimg.cc/VN7ZrsSf/lucabessoni-removebg-preview.png', 2, 22, 5),
(50, 'Falipolc Auris', 19990.00, 'https://www.moebelix.hu/p/luca-bessoni-falipolc-auris-001803063113', 'https://i.postimg.cc/tTxdq9Wm/lucabessoniauris-removebg-preview.png', 2, 22, 5),
(51, 'Falipolc Szett Nizza', 14990.00, 'https://www.moebelix.hu/p/falipolc-szett-nizza-007326059701', 'https://i.postimg.cc/5ymCyy0p/nizza-removebg-preview.png', 2, 22, 5),
(52, 'Kétüléses Kanapé Monaco', 159900.00, 'https://www.moebelix.hu/p/luca-bessoni-ketueleses-kanape-monaco-002694000902', 'https://i.postimg.cc/ZYfgL7vq/monaco-removebg-preview.png', 2, 1, 1),
(53, 'Kanapé Monaco', 189900.00, 'https://www.moebelix.hu/p/luca-bessoni-kanape-monaco-002694000903', 'https://i.postimg.cc/9QHBPZbM/monaco2-removebg-preview.png', 2, 1, 1),
(54, 'Kanapéágy Cadiz New', 289900.00, 'https://www.moebelix.hu/p/kanapeagy-cadiz-new-001204002406', 'https://i.postimg.cc/kXKHdnh2/cadiz-removebg-preview.png', 2, 1, 1),
(55, 'KANAPÉÁGY Levi B: Ca. 208 Cm', 179900.00, 'https://www.moebelix.hu/p/ondega-kanapeagy-levi-b-ca-208-cm-000317001701', 'https://i.postimg.cc/KzC0dVP7/levi-removebg-preview.png', 2, 1, 1),
(56, 'Kanapéágy Malcolm Hellgrau', 399900.00, 'https://www.moebelix.hu/p/kanapeagy-malcolm-hellgrau-000295005701', 'https://i.postimg.cc/rpPjrbP6/malcolm-removebg-preview.png', 2, 1, 1),
(57, 'Kanapéágy Beta New', 339900.00, 'https://www.moebelix.hu/p/kanapeagy-beta-new-002427014701', 'https://i.postimg.cc/nhLqG27n/beta-removebg-preview.png', 2, 1, 1),
(58, 'Óriás Kanapé Aruba', 349900.00, 'https://www.moebelix.hu/p/rias-kanape-aruba-000552031906', 'https://i.postimg.cc/Hkj7yxDx/aruba-removebg-preview.png', 2, 1, 1),
(59, 'Boxpring Kanapé Emily', 299900.00, 'https://www.moebelix.hu/p/ondega-boxpring-kanape-emily-001174000701', 'https://i.postimg.cc/CLrRSgBV/emily-removebg-preview.png', 2, 1, 1),
(60, 'Kanapé Ibiza', 189900.00, 'https://www.moebelix.hu/p/kanape-ibiza-001204003509', 'https://i.postimg.cc/3NVQfnRz/ibiza-removebg-preview.png', 2, 1, 1),
(61, 'Kanapéágy Anna', 379900.00, 'https://www.moebelix.hu/p/kanapeagy-anna-002990004301', 'https://i.postimg.cc/bJvXzKSK/anna-removebg-preview.png', 2, 1, 1),
(72, 'Dohányzóasztal Silvia', 39990.00, 'https://www.moebelix.hu/p/dohanyzoasztal-silvia-001973001702', 'https://i.postimg.cc/V6GtVkbG/silvia-removebg-preview.png', 2, 21, 1),
(73, 'Dohányzóasztal Silvia/2', 39990.00, 'https://www.moebelix.hu/p/dohanyzoasztal-silvia-001973001701', 'https://i.postimg.cc/nrXmbf4H/silvia2-removebg-preview.png', 2, 21, 1),
(74, 'Dohányzóasztal Cala Luna', 26990.00, 'https://www.moebelix.hu/p/dohanyzoasztal-cala-luna-001803035301', 'https://i.postimg.cc/zv4gq27T/luna-removebg-preview.png', 2, 21, 1),
(75, 'Dohányzóasztal Gina Sonoma Tölgy Dekorral', 17990.00, 'https://www.moebelix.hu/p/dohanyzoasztal-gina-sonoma-toelgy-dekorral-002140003003', 'https://i.postimg.cc/59rv5jJj/sonoma-removebg-preview.png', 2, 21, 1),
(76, 'Dohányzóasztal Cestino', 59990.00, 'https://www.moebelix.hu/p/dohanyzoasztal-cestino-001803072308', 'https://i.postimg.cc/NfrXdYGD/cestino-removebg-preview.png', 2, 21, 1),
(77, 'Dohányzóasztal Cala Luna/2', 26990.00, 'https://www.moebelix.hu/p/dohanyzoasztal-cala-luna-001803035302', 'https://i.postimg.cc/XYSChhpb/luna2-removebg-preview.png', 2, 21, 1),
(78, 'Dohányzóasztal Laura', 19990.00, 'https://www.moebelix.hu/p/dohanyzoasztal-laura-001803023910', 'https://i.postimg.cc/W4p6WKH4/laura-removebg-preview.png', 2, 21, 1),
(79, 'Dohányzóasztal Saba', 14990.00, 'https://www.moebelix.hu/p/moebelix-dohanyzoasztal-saba-001973000101', 'https://i.postimg.cc/3wLjPBsF/saba-removebg-preview.png', 2, 21, 1),
(80, 'Dohányzóasztal Paolo', 11990.00, 'https://www.moebelix.hu/p/dohanyzoasztal-paolo-001555000508', 'https://i.postimg.cc/qMfcVg5S/paolo-removebg-preview.png', 2, 21, 1),
(81, 'Dohányzóasztal Paolo/2', 11990.00, 'https://www.moebelix.hu/p/dohanyzoasztal-paolo-001555000509', 'https://i.postimg.cc/pXDf2RNT/paolo2-removebg-preview.png', 2, 21, 1),
(92, 'Tv-elem Genetic', 89990.00, 'https://www.moebelix.hu/p/tv-elem-genetic-000687037402', 'https://i.postimg.cc/5yhzqKZn/genetic-removebg-preview.png', 2, 5, 1),
(93, 'Médiaállvány Tico', 29990.00, 'https://www.moebelix.hu/p/mediaallvany-tico-001803030204', 'https://i.postimg.cc/3wFsvdkc/tico-removebg-preview.png', 2, 5, 1),
(94, 'Tv-elem Yoris', 54990.00, 'https://www.moebelix.hu/p/tv-elem-yoris-000241005205', 'https://i.postimg.cc/GtgKw1HK/yoris-removebg-preview.png', 2, 5, 1),
(95, 'Tv-elem Bretagne', 59990.00, 'https://www.moebelix.hu/p/tv-elem-bretagne-000834009603', 'https://i.postimg.cc/vHDX7DNN/bretagne-removebg-preview.png', 2, 5, 1),
(96, 'Tv-elem Alassio', 99990.00, 'https://www.moebelix.hu/p/luca-bessoni-tv-elem-alassio-001803056902', 'https://i.postimg.cc/yNhT6RDk/ucabessonialassio-removebg-preview.png', 2, 5, 1),
(97, 'Tv-elem Alassio/2', 119900.00, 'https://www.moebelix.hu/p/luca-bessoni-tv-elem-alassio-001803056906', 'https://i.postimg.cc/kg2bhbQk/alassio2-removebg-preview.png', 2, 5, 1),
(98, 'Tv-elem Tonale', 89990.00, 'https://www.moebelix.hu/p/tv-elem-tonale-001803057308', 'https://i.postimg.cc/HnSr6YVY/tonale-removebg-preview.png', 2, 5, 1),
(99, 'Tv-elem Venedig', 59990.00, 'https://www.moebelix.hu/p/tv-elem-venedig-001803053302', 'https://i.postimg.cc/yYbJ98Mn/venedig-removebg-preview.png', 2, 5, 1),
(100, 'Tv-elem Malta', 49990.00, 'https://www.moebelix.hu/p/tv-elem-malta-001803031815', 'https://i.postimg.cc/mrxtX62H/malta-removebg-preview.png', 2, 5, 1),
(101, 'Médiaállvány Bernd 2 Mx 144', 89990.00, 'https://www.moebelix.hu/p/mediaallvany-bernd-2-mx-144-002698012302', 'https://i.postimg.cc/Wp9tL41j/bernd-removebg-preview.png', 2, 5, 1),
(102, 'Tükör Alassio', 39990.00, 'https://www.moebelix.hu/p/luca-bessoni-tuekoer-alassio-001803058705', 'https://i.postimg.cc/DzNzQh2C/alassio-removebg-preview.png', 2, 16, 4),
(103, 'Tükör Salve', 29990.00, 'https://www.moebelix.hu/p/tuekoer-salve-001803072501', 'https://i.postimg.cc/NFgZ5yWZ/salve-removebg-preview.png', 2, 16, 4),
(104, 'Fali Tükör Bonny', 4990.00, 'https://www.moebelix.hu/p/ondega-fali-tuekoer-bonny-002757019001', 'https://i.postimg.cc/NFgZ5yWZ/salve-removebg-preview.png', 2, 16, 4),
(105, 'Fali Tükör Rom', 5490.00, 'https://www.moebelix.hu/p/fali-tuekoer-rom-008103023401', 'https://i.postimg.cc/GpdP0kG0/rom-removebg-preview.png', 2, 16, 4),
(106, 'Tükör Vancouver', 34990.00, 'https://www.moebelix.hu/p/tuekoer-vancouver-000196087002', 'https://i.postimg.cc/BQFVcf0m/vancouver-removebg-preview.png', 2, 16, 4),
(107, 'Fali Tükör Jakob', 6990.00, 'https://www.moebelix.hu/p/fali-tuekoer-jakob-007326007601', 'https://i.postimg.cc/XvYLPTRS/jakob-removebg-preview.png', 2, 16, 4),
(108, 'Fali Tükör Attack', 12990.00, 'https://www.moebelix.hu/p/fali-tuekoer-attack-001803044905', 'https://i.postimg.cc/SxD7cgJZ/attack-removebg-preview.png', 2, 16, 4),
(109, 'Fali Tükör Malta', 24990.00, 'https://www.moebelix.hu/p/fali-tuekoer-malta-001803031823', 'https://i.postimg.cc/MpQqQFPw/malta-removebg-preview.png', 2, 16, 4),
(110, 'Fali Tükör Kastor', 9990.00, 'https://www.moebelix.hu/p/ondega-fali-tuekoer-kastor-002757019401', 'https://i.postimg.cc/rm3LsG1s/kastor-removebg-preview.png', 2, 16, 4),
(111, 'Tükör Spring\r\n', 24990.00, 'https://www.moebelix.hu/p/tuekoer-spring-001803071305', 'https://i.postimg.cc/HWyq3y00/spring-removebg-preview.png', 2, 16, 4),
(112, 'Törölköző Katharina', 4990.00, 'https://www.moebelix.hu/p/toeroelkoezo-katharina-007659000406', 'https://i.postimg.cc/dQyy0KpB/Kathrina-removebg-preview.png', 2, 19, 4),
(113, 'Törölköző Flora', 3990.00, 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-flora-006792010806', 'https://i.postimg.cc/HkxWVwjg/jamesw-oodflora-removebg-preview.png', 2, 19, 4),
(114, 'Törölköző Sandra', 3000.00, 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-sandra-003002000204', 'https://i.postimg.cc/7Yhjzm1m/sandra-removebg-preview.png', 2, 19, 4),
(115, 'Törölköző Rocky 70/140cm', 4990.00, 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-rocky-70-140cm-003520000202', 'https://i.postimg.cc/CxVt2ST6/rocky-removebg-preview.png', 2, 19, 4),
(116, 'Törölköző Liliane', 3490.00, 'https://www.moebelix.hu/p/ondega-toeroelkoezo-liliane-003520000802', 'https://i.postimg.cc/MHV50fTZ/liliane-removebg-preview.png', 2, 19, 4),
(117, 'Törölköző Liliane/2', 3490.00, 'https://www.moebelix.hu/p/ondega-toeroelkoezo-liliane-003520000803', 'https://i.postimg.cc/fT5XGf6n/liliane2-removebg-preview.png', 2, 19, 4),
(118, 'TÖRÖLKÖZŐ Flora/2', 3990.00, 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-flora-006792010805', 'https://i.postimg.cc/rw3dTnjb/flora-removebg-preview.png', 2, 19, 4),
(119, 'Törölköző Liliane/3', 3490.00, 'https://www.moebelix.hu/p/ondega-toeroelkoezo-liliane-003520000804', 'https://i.postimg.cc/9fHW1vJW/liliane3-removebg-preview.png', 2, 19, 4),
(120, 'Törölköző Rocky 70/140cm /2', 4990.00, 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-rocky-70-140cm-003520000204', 'https://i.postimg.cc/52LJHs1D/rocky2-removebg-preview.png', 2, 19, 4),
(121, 'Törölköző Flora/3', 3990.00, 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-flora-006792010804', 'https://i.postimg.cc/Wz0RD3cg/flora2-removebg-preview.png', 2, 19, 4),
(122, 'Szappanadagoló Allstar Minas 23030100', 1690.00, 'https://www.moebelix.hu/p/szappanadagolo-allstar-minas-23030100-004332074201', 'https://i.postimg.cc/J7HXPdVG/alistar-removebg-preview.png', 2, 20, 4),
(123, 'Szappanadagoló Basic 24759100', 7490.00, 'https://www.moebelix.hu/p/szappanadagolo-basic-24759100-004332074401', 'https://i.postimg.cc/02MFcvZh/basic-removebg-preview.png', 2, 20, 4),
(124, 'Szappanadagoló Allstar Olinda 70192400/2', 2290.00, 'https://www.moebelix.hu/p/szappanadagolo-allstar-olinda-70192400-004332073901', 'https://i.postimg.cc/6pws3SLS/olinda-removebg-preview.png', 2, 20, 4),
(125, 'Szappanadagoló Static Loc Plus Pavia 24896100', 6490.00, 'https://www.moebelix.hu/p/szappanadagolo-static-loc-plus-pavia-24896100-004332074501', 'https://i.postimg.cc/nLzP9tsd/pavia-removebg-preview.png', 2, 20, 4),
(126, 'Szenzoros Szappanadagoló Kader', 4990.00, 'https://www.moebelix.hu/p/bono-szenzoros-szappanadagolo-kader-0079070148', 'https://i.postimg.cc/CMD6q71V/kader-removebg-preview.png', 2, 20, 4),
(127, 'Szappanadagoló Delia', 3790.00, 'https://www.moebelix.hu/p/luca-bessoni-szappanadagolo-delia-0046281426', 'https://i.postimg.cc/TPptYqSF/delia-removebg-preview.png', 2, 20, 4),
(128, 'Folyékonyszappan Adagoló Line Chilly Family', 1990.00, 'https://www.moebelix.hu/p/folyekonyszappan-adagolo-line-chilly-family-000283002001', 'https://i.postimg.cc/6pTrd60G/chillyfam-removebg-preview.png', 2, 20, 4),
(129, 'Szappantartó Allstar Olinda 70201400/3', 1290.00, 'https://www.moebelix.hu/p/szappantarto-allstar-olinda-70201400-004332074003', 'https://i.postimg.cc/7hpBpCXd/olinda2-removebg-preview.png', 2, 20, 4),
(130, 'Szappantartó Allstar Olinda 70193400/4', 1290.00, 'https://www.moebelix.hu/p/szappantarto-allstar-olinda-70193400-004332073903', 'https://i.postimg.cc/prTTgryf/olinda3-removebg-preview.png', 2, 20, 4),
(131, 'Szappantartó Line Chilly Family/2', 2290.00, 'https://www.moebelix.hu/p/szappantarto-line-chilly-family-000283002003', 'https://i.postimg.cc/wvxTmMXC/chillyfam2-removebg-preview.png', 2, 20, 4),
(132, 'Kárpitozott Ágy Padua 180/200 Cm', 179900.00, 'https://www.moebelix.hu/p/karpitozott-agy-padua-180-200-cm-002216001301', 'https://i.postimg.cc/GhTGMLV0/padua-removebg-preview.png', 2, 11, 3),
(133, 'Kihúzható Ágy Storm', 149900.00, 'https://www.moebelix.hu/p/kihuzhato-agy-storm-002561000101', 'https://i.postimg.cc/RVtXD5bY/storm-removebg-preview.png', 2, 11, 3),
(134, 'Tárolós Ágy Till 140/200 Cm', 229900.00, 'https://www.moebelix.hu/p/tarolos-agy-till-140-200-cm-000528021003', 'https://i.postimg.cc/v8Jv92Ht/till-removebg-preview.png', 2, 11, 3),
(135, 'Boxspring-ágy Ancona 180/200 Cm', 449900.00, 'https://www.moebelix.hu/p/boxspring-agy-ancona-180-200-cm-002366000801', 'https://i.postimg.cc/139wckxw/ancona-removebg-preview.png', 2, 11, 3),
(136, 'Tárolós Ágy Saturn 180/200 Cm', 139900.00, 'https://www.moebelix.hu/p/tarolos-agy-saturn-180-200-cm-002427003718', 'https://i.postimg.cc/xjvXx63R/saturn-removebg-preview.png', 2, 11, 3),
(137, 'Kihúzható Ágy Timmi', 229900.00, 'https://www.moebelix.hu/p/kihuzhato-agy-timmi-000423004701', 'https://i.postimg.cc/26p5TWqM/timmi-removebg-preview.png', 2, 11, 3),
(138, 'Kárpitozott Ágy Lucy 180/200 Cm', 139900.00, 'https://www.moebelix.hu/p/karpitozott-agy-lucy-180-200-cm-002216002401', 'https://i.postimg.cc/9f9m4fxp/lucy-removebg-preview.png', 2, 11, 3),
(139, 'Tárolós Ágy Till 90/200 Cm/2', 159900.00, 'https://www.moebelix.hu/p/tarolos-agy-till-90-200-cm-000528021004', 'https://i.postimg.cc/VNXwfV6Z/till2-removebg-preview.png', 2, 11, 3),
(140, 'Tárolós Ágy Bonny 90/200 Cm', 99990.00, 'https://www.moebelix.hu/p/tarolos-agy-bonny-90-200-cm-000423010702', 'https://i.postimg.cc/TY54vWhC/bonny-removebg-preview.png', 2, 11, 3),
(141, 'Tárolós ágy Cindy 2', 109900.00, 'https://www.moebelix.hu/p/tarolos-agy-cindy-2-001787084903', 'https://i.postimg.cc/MpD49JnS/cindy-removebg-preview.png', 2, 11, 3),
(142, 'Éjjeliszekrény Ella', 14990.00, 'https://www.moebelix.hu/p/jjeliszekreny-ella-000778006901', 'https://i.postimg.cc/zB03TZPv/ella-removebg-preview.png', 2, 13, 3),
(143, 'Éjjeliszekrény Tölgy Dekor', 29990.00, 'https://www.moebelix.hu/p/jjeliszekreny-toelgy-dekor-002522029403', 'https://i.postimg.cc/Z5bbFDpy/tolgy-removebg-preview.png', 2, 13, 3),
(144, 'Éjjeliszekrény Billund', 39990.00, 'https://www.moebelix.hu/p/jjeliszekreny-billund-001787029018', 'https://i.postimg.cc/NMgkgtHj/billund-removebg-preview.png', 2, 13, 3),
(145, 'Éjjeliszekrény Ella/2\r\n', 14990.00, 'https://www.moebelix.hu/p/jjeliszekreny-ella-000778006902', 'https://i.postimg.cc/26ZLRXHS/ella2-removebg-preview.png', 2, 13, 3),
(146, 'Éjjeliszekrény Saturn', 29990.00, 'https://www.moebelix.hu/p/jjeliszekreny-saturn-002427003705', 'https://i.postimg.cc/qR4H4Nw6/saturn-removebg-preview.png', 2, 13, 3),
(147, 'Éjjeliszekrény 4-You', 14990.00, 'https://www.moebelix.hu/p/jjeliszekreny-4-you-001803027111', 'https://i.postimg.cc/YCddhhtm/4you-removebg-preview.png', 2, 13, 3),
(148, 'Éjjeliszekrény Saturn/2', 29990.00, 'https://www.moebelix.hu/p/jjeliszekreny-saturn-002427003713', 'https://i.postimg.cc/wjR1srpc/saturn2-removebg-preview.png', 2, 13, 3),
(149, 'Éjjeliszekrény Box', 24990.00, 'https://www.moebelix.hu/p/ondega-jjeliszekreny-box-001803018732', 'https://i.postimg.cc/wTLvqmc0/ondega-removebg-preview.png', 2, 13, 3),
(150, 'Éjjeliszekrény Avensis New', 39990.00, 'https://www.moebelix.hu/p/luca-bessoni-jjeliszekreny-avensis-new-001803037803', 'https://i.postimg.cc/0Q0n1QXQ/avensis-removebg-preview.png', 2, 13, 3),
(151, 'Éjjeliszekrény 4-You New/2', 19990.00, 'https://www.moebelix.hu/p/jjeliszekreny-4-you-new-001803044804', 'https://i.postimg.cc/52563CX6/4you2-removebg-preview.png', 2, 13, 3),
(152, 'Tolóajtós Szekrény Time 170/195 Cm', 99990.00, 'https://www.moebelix.hu/p/toloajtos-szekreny-time-170-195-cm-002522035901', 'https://i.postimg.cc/Y9MYGWzN/time-removebg-preview.png', 2, 14, 3),
(153, 'Tolóajtós Szekrény Starter B 125/196 Cm', 79990.00, 'https://www.moebelix.hu/p/toloajtos-szekreny-starter-b-125-196-cm-002522031501', 'https://i.postimg.cc/XYgCMJbp/starterb-removebg-preview.png', 2, 14, 3),
(154, 'Nyílóajtós Szekrény Karl 159/196 Cm', 129900.00, 'https://www.moebelix.hu/p/nyiloajtos-szekreny-karl-159-196-cm-002522018202', 'https://i.postimg.cc/Qx8D4x06/karl-removebg-preview.png', 2, 14, 3),
(155, 'Nyílóajtós Szekrény Landwood 80/200 Cm', 89990.00, 'https://www.moebelix.hu/p/nyiloajtos-szekreny-landwood-80-200-cm-002478007907', 'https://i.postimg.cc/G9wyRTts/landwood-removebg-preview.png', 2, 14, 3),
(156, 'Tolóajtós Szekrény Oldenburg 180/198 Cm', 199900.00, 'https://www.moebelix.hu/p/toloajtos-szekreny-oldenburg-180-198-cm-001787071601', 'https://i.postimg.cc/T3PD6xY0/oldenburg-removebg-preview.png', 2, 14, 3),
(157, 'Nyílóajtós szekrény Base 3 121/177 Cm', 79990.00, 'https://www.moebelix.hu/p/nyiloajtos-szekreny-base-3-121-177-cm-002522000804', 'https://i.postimg.cc/zfFZSsTm/base-removebg-preview.png', 2, 14, 3),
(158, 'Tolóajtós Szekrény Sinfonie Sand 249/221 Cm', 339900.00, 'https://www.moebelix.hu/p/toloajtos-szekreny-sinfonie-sand-249-221-cm-000531041102', 'https://i.postimg.cc/Yq65Hcyv/sinfone-removebg-preview.png', 2, 14, 3),
(159, 'Tolóajtós Szekrény Navara 242/215,5 Cm', 269900.00, 'https://www.moebelix.hu/p/toloajtos-szekreny-navara-242-215-5-cm-000834009001', 'https://i.postimg.cc/cJwYDmJG/navara-removebg-preview.png', 2, 14, 3),
(160, 'Tolóajtós Szekrény Mega 312/226 Cm', 279900.00, 'https://www.moebelix.hu/p/toloajtos-szekreny-mega-312-226-cm-002522035502', 'https://i.postimg.cc/vBDyYPxp/mega-removebg-preview.png', 2, 14, 3),
(161, 'Bejárható Sarokszekrény Yoris 146,4/199 Cm', 249900.00, 'https://www.moebelix.hu/p/bejarhato-sarokszekreny-yoris-146-4-199-cm-000241005201', 'https://i.postimg.cc/jqHTsJDq/yoris-removebg-preview.png', 2, 14, 3),
(162, 'Texas tv állvány', 74900.00, 'https://somabutor.hu/texas-tv-allvany', 'https://i.postimg.cc/4ynfVxrt/texas-removebg-preview.png', 14, 5, 1),
(163, 'Pixie tv állvány', 45900.00, 'https://somabutor.hu/pixie-tv-allvany', 'https://i.postimg.cc/y8hHJRkt/Pixie-removebg-preview.png', 14, 5, 1),
(164, 'Velence TV állvány (John TV állvány)', 46700.00, 'https://somabutor.hu/velence-tv-allvany', 'https://i.postimg.cc/9032RYY3/Velence-removebg-preview.png', 14, 5, 1),
(165, 'Maldív fiókos tv állvány', 49500.00, 'https://somabutor.hu/maldiv-fiokos-tv-allvany', 'https://i.postimg.cc/5yPmKn7T/maldiv-removebg-preview.png', 14, 5, 1),
(166, 'Toledo tv állvány', 74900.00, 'https://somabutor.hu/toledo-tv-allvany', 'https://i.postimg.cc/JnpJRtNB/toledo-removebg-preview.png', 14, 5, 1),
(167, 'Dohányzó asztal c 1 dohányzóasztal (40.5 × 80 × 50 cm)', 29900.00, 'https://somabutor.hu/dohanyzo-asztal-c-1-dohanyzoasztal', 'https://i.postimg.cc/CLbFTXHj/c1-removebg-preview.png', 14, 3, 1),
(168, 'Dubai 2 dohányzóasztal', 39000.00, 'https://somabutor.hu/dubai-2-dohanyzoasztal', 'https://i.postimg.cc/vTfdyx9Q/dubai2-removebg-preview.png', 14, 3, 1),
(169, 'Capri 2 dohányzóasztal', 39000.00, 'https://somabutor.hu/capri-2-dohanyzoasztal', 'https://i.postimg.cc/HLNG799Y/capri2-removebg-preview.png', 14, 3, 1),
(170, 'EVEREST FIÓKOS DOHÁNYZÓASZTAL', 44200.00, 'https://somabutor.hu/everest-fiokos-dohanyzoasztal', 'https://i.postimg.cc/ZYpkC3Bm/everest-removebg-preview.png', 14, 3, 1),
(171, 'Baldo 2 dohányzóasztal', 39000.00, 'https://somabutor.hu/baldo-dohanyzo', 'https://i.postimg.cc/JnXFHVhx/baldo-removebg-preview.png', 14, 3, 1),
(172, 'MEGAN kanapé', 129500.00, 'https://somabutor.hu/megan-kanape', 'https://i.postimg.cc/SRdJ6KQf/megan-removebg-preview.png', 14, 1, 1),
(173, 'CHERRY 2-es kanapé', 147900.00, 'https://somabutor.hu/cherry-2-es-kanape', 'https://i.postimg.cc/ZqNnfHKR/cherry2-removebg-preview.png', 14, 1, 1),
(174, 'BENIAMIN 2-es szófa', 148900.00, 'https://somabutor.hu/beniamin-2-es-szofa', 'https://i.postimg.cc/Qd9dtm7b/beniamin-removebg-preview.png', 14, 1, 1),
(175, 'MILANO kanapé', 154900.00, 'https://somabutor.hu/milano-kanape', 'https://i.postimg.cc/VN91rVkj/milano-removebg-preview.png', 14, 1, 1),
(176, 'Noel ortopéd rugós/szivacsos sarokülő', 169900.00, 'https://somabutor.hu/noel-ortoped-rugosszivacsos-sarokulo', 'https://i.postimg.cc/nc6tdJs4/noel-removebg-preview.png', 14, 1, 1),
(177, 'Könyvespolc', 44900.00, 'https://somabutor.hu/konyvespolc', 'https://i.postimg.cc/Qxrp3BWV/k-nyvespolc-removebg-preview.png', 14, 22, 5),
(178, 'Joker falipolc', 17400.00, 'https://somabutor.hu/joker-falipolc', 'https://i.postimg.cc/QCZWhPCv/joker-removebg-preview.png', 14, 22, 5),
(179, 'Térelválasztó', 59600.00, 'https://somabutor.hu/terelvalaszto', 'https://i.postimg.cc/rsTzvrYk/t-relvalaszto-removebg-preview.png', 14, 22, 5),
(180, 'Taipei könyvespolc', 38900.00, 'https://somabutor.hu/taipei-konyvespolc', 'https://i.postimg.cc/1XMR2YqG/taipei-removebg-preview.png', 14, 22, 5),
(181, 'Lucky falipolc', 20800.00, 'https://somabutor.hu/lucky-falipolc', 'https://i.postimg.cc/FRVhknGM/lucky-removebg-preview.png', 14, 22, 5),
(182, 'Niki szék', 20300.00, 'https://somabutor.hu/niki-szek', 'https://i.postimg.cc/zfcqCg1j/niki-removebg-preview.png', 14, 23, 5),
(183, 'Kitty szék', 21600.00, 'https://somabutor.hu/kitty-szek', 'https://i.postimg.cc/cLDWWn6S/Ktty-removebg-preview.png', 14, 23, 5),
(184, 'Herman szék', 22000.00, 'https://somabutor.hu/herman-szek', 'https://i.postimg.cc/7hMvWCjj/herman-removebg-preview.png', 14, 23, 5),
(185, 'LARA szék', 28300.00, 'https://somabutor.hu/lara-szek-132', 'https://i.postimg.cc/mgrxmgj6/lara-removebg-preview.png', 14, 23, 5),
(186, 'Inez szék', 34200.00, 'https://somabutor.hu/inez-szek', 'https://i.postimg.cc/sxzq7j1m/inez-removebg-preview.png', 14, 23, 5),
(187, 'Debora asztal - székek nélkül (160 cm x 88 cm + 40 cm)', 62400.00, 'https://somabutor.hu/debora-asztal-160-cm-x-88-cm-40-cm', 'https://i.postimg.cc/DyJp04Ch/debora-removebg-preview.png', 14, 21, 5),
(188, 'Hanna asztal - székek nélkül (160 cm x 88 cm + 40 cm)', 68900.00, 'https://somabutor.hu/hanna-asztal-160-cm-x-88-cm-40-cm', 'https://i.postimg.cc/C12Hpmpq/Hanna-removebg-preview.png', 14, 21, 5),
(189, 'Magasfényű Flóra asztal - székek nélkül (160 CM X 88 CM + 40 CM)', 112700.00, 'https://somabutor.hu/fenyes-flora-asztal-szekek-nelkul-160-cm-x-88-cm-40-cm', 'https://i.postimg.cc/7LWmqxgh/fl-ra-removebg-preview.png', 14, 21, 5),
(190, 'BERTA asztal - székek nélkül (120 cm x 70 cm + 40 cm)', 48600.00, 'https://somabutor.hu/berta-asztal-159', 'https://i.postimg.cc/tT6tyFqv/berta-removebg-preview.png', 14, 21, 5),
(191, 'Tony asztal - székek nélkül (160 cm x 90 + 40 cm)', 73500.00, 'https://somabutor.hu/tony-asztal-szekek-nelkul-160-cm-x-90-40-cm', 'https://i.postimg.cc/dt5Cb5Rt/tony-removebg-preview.png', 14, 21, 5),
(192, 'Diablo szekrénysor (320cm)', 201000.00, 'https://somabutor.hu/diablo-szekrenysor-1200', 'https://i.postimg.cc/cHj3KCHg/diablo-removebg-preview.png', 14, 14, 3),
(193, 'Uni Viktória szekrénysor (320 cm)', 234900.00, 'https://somabutor.hu/uni-viktoria-szekrenysor-320-cm', 'https://i.postimg.cc/fb8gkG9t/univiktoria-removebg-preview.png', 14, 14, 3),
(194, 'DUBALUX szekrénysor (375 cm)', 326400.00, 'https://somabutor.hu/dubalux-szekrenysor-1314', 'https://i.postimg.cc/4xZ8PfvH/dubalux-removebg-preview.png', 14, 14, 3),
(195, 'Golden szekrénysor (360 cm)', 207600.00, 'https://somabutor.hu/golden-szekrenysor-1357', 'https://i.postimg.cc/vHwX8YN2/golden-removebg-preview.png', 14, 14, 3),
(196, 'Peremes 1 fiókos éjjeliszekrény', 22900.00, 'https://somabutor.hu/peremes-1-fiokos-ejjeliszekreny', 'https://i.postimg.cc/DmVb6wtW/peremes-removebg-preview.png', 14, 13, 3),
(197, '2 fiókos alsó polcos éjjeliszekrény', 23900.00, 'https://somabutor.hu/2-fiokos-also-polcos-ejjeliszekreny', 'https://i.postimg.cc/KYgjq2DB/2fiokos-removebg-preview.png', 14, 13, 3),
(198, 'TYP07 ágyrácsos ágy', 249900.00, 'https://somabutor.hu/typ07-agyracsos-agy', 'https://i.postimg.cc/T2k9vjX0/typ07-removebg-preview.png', 14, 11, 3),
(199, 'ST3 (140/160/180/200 x 200 cm) ágyrácsos ágy', 249900.00, 'https://somabutor.hu/st3-140160180200-x-200-agyracsos-agy', 'https://i.postimg.cc/Cxbk5k9W/st3-removebg-preview.png', 14, 11, 3),
(200, 'TYP50 boxspring ágy', 321900.00, 'https://somabutor.hu/typ50-boxspring-agy', 'https://i.postimg.cc/VsTCFK8x/typ50-removebg-preview.png', 14, 11, 3),
(201, 'TYP58 boxspring ágy', 355900.00, 'https://somabutor.hu/typ58-boxspring-agy', 'https://i.postimg.cc/QC5177H9/typ58-removebg-preview.png', 14, 11, 3),
(202, 'Danilo extra bonell rugós franciaágy (160 X 200 cm)', 132200.00, 'https://somabutor.hu/danilo-extra-bonell-rugos-franciaagy-160-x-200-cm', 'https://i.postimg.cc/SxQYS37z/danilo-removebg-preview.png', 14, 11, 3),
(203, 'Komód FASO 180 kandallóval fehér', 241300.00, 'https://butorline.hu/komod-faso-180-kandalloval-feher', 'https://i.postimg.cc/2yzSxYBC/komod-removebg-preview.png', 13, 5, 1),
(204, 'TV komód INEZA IN02 artisan tölgy / fekete', 63000.00, 'https://butorline.hu/tv-komod-ineza-in02-artisan-toelgy-fekete', 'https://i.postimg.cc/bJy7CwLV/ineza-removebg-preview.png', 13, 5, 1),
(205, 'Szekrény RTV POWER Fehér / Sandal / Fehér fényes', 53400.00, 'https://butorline.hu/szekreny-rtv-power-feher-sandal-feher-fenyes-kiarusitas', 'https://i.postimg.cc/tCFH4w15/trv-removebg-preview.png', 13, 5, 1),
(206, 'TV szekrény BERAM 01 artisan tölgy', 76000.00, 'https://butorline.hu/tv-szekreny-beram-01-artisan-toelgy', 'https://i.postimg.cc/bwvLB2jt/beram-removebg-preview.png', 13, 5, 1),
(207, 'TV szekrény 180 GOVI VG1G fekete / wotan tölgy', 66900.00, 'https://butorline.hu/tv-szekreny-180-govi-vg1g-fekete-wotan-toelgy', 'https://i.postimg.cc/65Mfn5G5/govi-removebg-preview.png', 13, 5, 1),
(208, 'Dohányzóasztal ALVARO 10 kasmír', 64900.00, 'https://butorline.hu/dohanyzoasztal-alvaro-10-kasmir', 'https://i.postimg.cc/wvCgWs45/alvaro-removebg-preview.png', 13, 3, 1),
(209, 'Dohányzóasztal DANTE 06 fekete', 72000.00, 'https://butorline.hu/dohanyzoasztal-dante-06-fekete', 'https://i.postimg.cc/GtfYgzw7/dante-removebg-preview.png', 13, 3, 1),
(210, 'Dohányzóasztal CIMER 04 fekete / artisan', 71500.00, 'https://butorline.hu/dohanyzoasztal-cimer-04-fekete-artisan', 'https://i.postimg.cc/5Nvqkdy8/cimer-removebg-preview.png', 13, 3, 1),
(211, 'Dohányzóasztal DANTE 07 fekete', 55100.00, 'https://butorline.hu/dohanyzoasztal-dante-07-fekete', 'https://i.postimg.cc/mZ9HT34s/dante2-removebg-preview.png', 13, 3, 1),
(212, 'Dohányzóasztal DENVI DV10 monastery tölgy / fekete fényes', 78300.00, 'https://butorline.hu/dohanyzoasztal-denvi-dv10-monastery-toelgy-fekete-fenyes', 'https://i.postimg.cc/mgnLcq36/denvi-removebg-preview.png', 13, 3, 1),
(213, 'Kanapé BERGI tiffany 10', 312900.00, 'https://butorline.hu/kanape-bergi-tiffany-10', 'https://i.postimg.cc/y6XssW-Dd/tiffany-removebg-preview.png', 13, 1, 1),
(214, 'Kanapé DART 2 soft 66 / kreta 07', 212900.00, 'https://butorline.hu/kanape-dart-2-soft-66-kreta-07', 'https://i.postimg.cc/Ghg0mDdc/dart2-removebg-preview.png', 13, 1, 1),
(215, 'Kanapé LAKCHOS 2 monolith 85', 223900.00, 'https://butorline.hu/kanape-lakchos-2-monolith-85', 'https://i.postimg.cc/sxf8VjLQ/Lakchos-removebg-preview.png', 13, 1, 1),
(216, 'Kanapé DART kreta 05 / soft 66', 212900.00, 'https://butorline.hu/kanape-dart-kreta-05-soft-66', 'https://i.postimg.cc/SRtZkW83/dart-removebg-preview.png', 13, 1, 1),
(217, 'Kanapé SELVA A - manila sötét szürke, króm', 248000.00, 'https://butorline.hu/kanape-selva-a-manila-soetet-szuerke-krom', 'https://i.postimg.cc/0Qydjz8s/selva-removebg-preview.png', 13, 1, 1),
(218, 'Alsó konyhai sarokpolc 30 STILL ST50 fehér', 27000.00, 'https://butorline.hu/also-konyhai-sarokpolc-30-still-st50-feher', 'https://i.postimg.cc/NGH7M9T1/still-removebg-preview.png', 13, 22, 5),
(219, 'Fali polc MAMONE ME01 arany tölgy / fehér / grafit', 12000.00, 'https://butorline.hu/fali-polc-mamone-me01-arany-toelgy-feher-grafit', 'https://i.postimg.cc/hjwrYVmG/mamone-removebg-preview.png', 13, 22, 5),
(220, 'Fali szekrény MALTIS MT03 világosszürke', 35900.00, 'https://butorline.hu/fali-szekreny-maltis-mt03-vilagosszuerke', 'https://i.postimg.cc/J7GYQzXn/maltis-removebg-preview.png', 13, 22, 5),
(221, 'Fali polc CIMER 06 fekete / artisan', 24400.00, 'https://butorline.hu/fali-polc-cimer-06-fekete-artisan', 'https://i.postimg.cc/nLF9nNkj/cimer-removebg-preview.png', 13, 22, 5),
(222, 'Fali polc CALABRIA CL15 artisan tölgy', 32500.00, 'https://butorline.hu/fali-polc-calabria-cl15-artisan-toelgy', 'https://i.postimg.cc/15VpTxCy/calabria-removebg-preview.png', 13, 22, 5),
(223, 'Szék BOS 10 fehér / 8B', 20400.00, 'https://butorline.hu/szek-bos-10-feher-8b', 'https://i.postimg.cc/7ZSqZynH/bos10-removebg-preview.png', 13, 23, 5),
(224, 'Szék BOS 10D grafit', 24800.00, 'https://butorline.hu/szek-bos-10d-grafit', 'https://i.postimg.cc/44vMyNrF/bos10d-removebg-preview.png', 13, 23, 5),
(225, 'Szék BOS 4D fekete', 23900.00, 'https://butorline.hu/szek-bos-4d-fekete', 'https://i.postimg.cc/Xq84kKXr/bos-4d-removebg-preview.png', 13, 23, 5),
(226, 'Szék LUNA 1 sonoma tölgy / 16B', 29500.00, 'https://butorline.hu/szek-luna-1-sonoma-toelgy-16b', 'https://i.postimg.cc/TPY7KVvk/luna-removebg-preview.png', 13, 23, 5),
(227, 'Szék KD49D dió', 23200.00, 'https://butorline.hu/szek-kd49d-dio', 'https://i.postimg.cc/9QpV3YB1/kd49d-removebg-preview.png', 13, 22, 5);

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
(1, 1, 'Sofa'),
(3, 1, 'coffeetable'),
(5, 1, 'TVBench'),
(11, 3, 'Bed'),
(13, 3, 'Bedside table'),
(14, 3, 'Wardrobe'),
(16, 4, 'Mirror'),
(19, 4, 'Towel'),
(20, 4, 'Accessories'),
(21, 5, 'Dining Table'),
(22, 5, 'Shelf'),
(23, 5, 'Chair');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `shops`
--

CREATE TABLE `shops` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'weboldal neve',
  `websiteurl` varchar(255) DEFAULT NULL COMMENT 'weboldal url'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `shops`
--

INSERT INTO `shops` (`id`, `name`, `websiteurl`) VALUES
(1, 'JYSK', 'https://jysk.hu/search?query=%C3%A1gy&type=product'),
(2, 'Möbelix', 'https://www.moebelix.hu/'),
(3, 'RS BÚTOR', 'https://www.rs.hu/'),
(4, 'BRW bútorház', 'https://www.brwbutorhaz.hu/'),
(5, 'Megfizethető bútor', 'https://megfizethetobutor.hu/'),
(6, 'XXXLutz', 'https://www.xxxlutz.hu/'),
(7, 'Butlers', 'https://www.butlers.hu/'),
(8, 'Magyar bútorbolt', 'https://magyarbutorbolt.hu/kategoriak'),
(9, 'Alaba', 'https://alaba.hu/'),
(10, 'Bogart bútor', 'https://www.bogart-butor.hu/'),
(11, 'Bútor7', 'https://butor7.hu/'),
(12, 'Zondo.hu', 'https://www.zondo.hu/'),
(13, 'Bútorline', 'https://butorline.hu/'),
(14, 'Soma bútor', 'https://somabutor.hu/');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `userplan`
--

CREATE TABLE `userplan` (
  `id` int(11) NOT NULL,
  `userid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `plandata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Termék ára' CHECK (json_valid(`plandata`)),
  `createdat` timestamp NULL DEFAULT current_timestamp() COMMENT 'Bolt linkje  '
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `userplan`
--

INSERT INTO `userplan` (`id`, `userid`, `plandata`, `createdat`) VALUES
(19, '1cd1b3ea-afc7-4b11-b7ee-a1657c6281c9', '[{\"productId\":132,\"x\":100,\"y\":100},{\"productId\":133,\"x\":804,\"y\":125}]', '2025-02-16 14:46:46'),
(20, '1cd1b3ea-afc7-4b11-b7ee-a1657c6281c9', '[{\"productId\":53,\"x\":-169,\"y\":558},{\"productId\":53,\"x\":-169,\"y\":558},{\"productId\":57,\"x\":14,\"y\":321}]', '2025-02-16 15:03:38'),
(21, '1cd1b3ea-afc7-4b11-b7ee-a1657c6281c9', '[{\"productId\":53,\"x\":-96,\"y\":465},{\"productId\":53,\"x\":-96,\"y\":465},{\"productId\":57,\"x\":-11,\"y\":14}]', '2025-02-16 15:04:08'),
(22, '1cd1b3ea-afc7-4b11-b7ee-a1657c6281c9', '[{\"productId\":59,\"x\":-83,\"y\":505},{\"productId\":72,\"x\":113,\"y\":546}]', '2025-02-16 16:19:39');

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
('20250127201800_updateduser', '8.0.10');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `aspnetroleclaims`
--
ALTER TABLE `aspnetroleclaims`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_AspNetRoleClaims_RoleId` (`RoleId`);

--
-- A tábla indexei `aspnetroles`
--
ALTER TABLE `aspnetroles`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `RoleNameIndex` (`NormalizedName`);

--
-- A tábla indexei `aspnetuserclaims`
--
ALTER TABLE `aspnetuserclaims`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_AspNetUserClaims_UserId` (`UserId`);

--
-- A tábla indexei `aspnetuserlogins`
--
ALTER TABLE `aspnetuserlogins`
  ADD PRIMARY KEY (`LoginProvider`,`ProviderKey`),
  ADD KEY `IX_AspNetUserLogins_UserId` (`UserId`);

--
-- A tábla indexei `aspnetuserroles`
--
ALTER TABLE `aspnetuserroles`
  ADD PRIMARY KEY (`UserId`,`RoleId`),
  ADD KEY `IX_AspNetUserRoles_RoleId` (`RoleId`);

--
-- A tábla indexei `aspnetusers`
--
ALTER TABLE `aspnetusers`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `email` (`Email`),
  ADD UNIQUE KEY `UserNameIndex` (`NormalizedUserName`),
  ADD KEY `EmailIndex` (`NormalizedEmail`);

--
-- A tábla indexei `aspnetusertokens`
--
ALTER TABLE `aspnetusertokens`
  ADD PRIMARY KEY (`UserId`,`LoginProvider`,`Name`);

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
  ADD KEY `Products` (`userplanid`);

--
-- A tábla indexei `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shopid` (`shopid`),
  ADD KEY `product_type_id` (`product_type_id`),
  ADD KEY `roomid` (`roomid`);

--
-- A tábla indexei `producttype`
--
ALTER TABLE `producttype`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoryid` (`categoryid`);

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
  ADD KEY `userid` (`userid`);

--
-- A tábla indexei `__efmigrationshistory`
--
ALTER TABLE `__efmigrationshistory`
  ADD PRIMARY KEY (`MigrationId`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `aspnetroleclaims`
--
ALTER TABLE `aspnetroleclaims`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `aspnetuserclaims`
--
ALTER TABLE `aspnetuserclaims`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `kategories`
--
ALTER TABLE `kategories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `planproducts`
--
ALTER TABLE `planproducts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT a táblához `userplan`
--
ALTER TABLE `userplan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `aspnetroleclaims`
--
ALTER TABLE `aspnetroleclaims`
  ADD CONSTRAINT `FK_AspNetRoleClaims_AspNetRoles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `aspnetroles` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `aspnetuserclaims`
--
ALTER TABLE `aspnetuserclaims`
  ADD CONSTRAINT `FK_AspNetUserClaims_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `aspnetuserlogins`
--
ALTER TABLE `aspnetuserlogins`
  ADD CONSTRAINT `FK_AspNetUserLogins_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `aspnetuserroles`
--
ALTER TABLE `aspnetuserroles`
  ADD CONSTRAINT `FK_AspNetUserRoles_AspNetRoles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `aspnetroles` (`Id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_AspNetUserRoles_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `aspnetusertokens`
--
ALTER TABLE `aspnetusertokens`
  ADD CONSTRAINT `FK_AspNetUserTokens_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `userplan`
--
ALTER TABLE `userplan`
  ADD CONSTRAINT `FK_userplan_AspNetUsers_userid` FOREIGN KEY (`userid`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
