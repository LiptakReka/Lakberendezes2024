-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2024. Okt 07. 11:45
-- Kiszolgáló verziója: 10.4.20-MariaDB
-- PHP verzió: 7.3.29

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

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetroleclaims`
--

CREATE TABLE `aspnetroleclaims` (
  `Id` int(11) NOT NULL,
  `RoleId` varchar(255) NOT NULL,
  `ClaimType` longtext DEFAULT NULL,
  `ClaimValue` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetroles`
--

CREATE TABLE `aspnetroles` (
  `Id` varchar(255) NOT NULL,
  `Name` varchar(256) DEFAULT NULL,
  `NormalizedName` varchar(256) DEFAULT NULL,
  `ConcurrencyStamp` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `aspnetroles`
--

INSERT INTO `aspnetroles` (`Id`, `Name`, `NormalizedName`, `ConcurrencyStamp`) VALUES
('2ec2bb79-1a42-4b7b-9353-fdcfc041a164', 'USER', 'USER', NULL),
('9d689ce8-4933-4f43-a485-8a6362cc2e33', 'ADMIN', 'ADMIN', NULL);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetuserclaims`
--

CREATE TABLE `aspnetuserclaims` (
  `Id` int(11) NOT NULL,
  `UserId` varchar(255) NOT NULL,
  `ClaimType` longtext DEFAULT NULL,
  `ClaimValue` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetuserlogins`
--

CREATE TABLE `aspnetuserlogins` (
  `LoginProvider` varchar(255) NOT NULL,
  `ProviderKey` varchar(255) NOT NULL,
  `ProviderDisplayName` longtext DEFAULT NULL,
  `UserId` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetuserroles`
--

CREATE TABLE `aspnetuserroles` (
  `UserId` varchar(255) NOT NULL,
  `RoleId` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `aspnetuserroles`
--

INSERT INTO `aspnetuserroles` (`UserId`, `RoleId`) VALUES
('23dda6ac-3fb1-49c6-af8f-c49978bca972', '2ec2bb79-1a42-4b7b-9353-fdcfc041a164'),
('23dda6ac-3fb1-49c6-af8f-c49978bca972', '9d689ce8-4933-4f43-a485-8a6362cc2e33');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetusers`
--

CREATE TABLE `aspnetusers` (
  `Id` varchar(255) NOT NULL,
  `fullname` varchar(255) NOT NULL,
  `UserName` varchar(256) DEFAULT NULL,
  `NormalizedUserName` varchar(256) DEFAULT NULL,
  `Email` varchar(256) DEFAULT NULL,
  `NormalizedEmail` varchar(256) DEFAULT NULL,
  `EmailConfirmed` tinyint(1) NOT NULL,
  `PasswordHash` longtext DEFAULT NULL,
  `SecurityStamp` longtext DEFAULT NULL,
  `ConcurrencyStamp` longtext DEFAULT NULL,
  `PhoneNumber` longtext DEFAULT NULL,
  `PhoneNumberConfirmed` tinyint(1) NOT NULL,
  `TwoFactorEnabled` tinyint(1) NOT NULL,
  `LockoutEnd` datetime(6) DEFAULT NULL,
  `LockoutEnabled` tinyint(1) NOT NULL,
  `AccessFailedCount` int(11) NOT NULL,
  `dateat` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `aspnetusers`
--

INSERT INTO `aspnetusers` (`Id`, `fullname`, `UserName`, `NormalizedUserName`, `Email`, `NormalizedEmail`, `EmailConfirmed`, `PasswordHash`, `SecurityStamp`, `ConcurrencyStamp`, `PhoneNumber`, `PhoneNumberConfirmed`, `TwoFactorEnabled`, `LockoutEnd`, `LockoutEnabled`, `AccessFailedCount`, `dateat`) VALUES
('23dda6ac-3fb1-49c6-af8f-c49978bca972', 'liptak reka', 'tesztelek', 'TESZTELEK', 'liptakr@kkszki.hu', 'LIPTAKR@KKSZKI.HU', 0, 'AQAAAAIAAYagAAAAEGVyC4vePbP4WVrrsPt/jbS+0vI1X979pcM5sK5HBS11wmGTv8vQaFCijqpwvOSfwA==', 'DVFSCUTKKXZJKGTCMMWDHKIWBSGSEIWA', '4749150a-8ee8-4961-8463-6eea48187aa4', NULL, 0, 0, NULL, 1, 0, '2024-10-07 06:26:24');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `aspnetusertokens`
--

CREATE TABLE `aspnetusertokens` (
  `UserId` varchar(255) NOT NULL,
  `LoginProvider` varchar(255) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Value` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kategories`
--

CREATE TABLE `kategories` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_hungarian_ci NOT NULL
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
  `position` varchar(255) COLLATE utf8_hungarian_ci NOT NULL,
  `userplanid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL COMMENT 'Egyedi azonosító bútoroknak',
  `name` varchar(255) COLLATE utf8_hungarian_ci NOT NULL COMMENT 'A bútor neve',
  `price` decimal(10,2) DEFAULT NULL COMMENT 'Termék ára',
  `shoplink` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL COMMENT 'Bolt linkje  ',
  `imageurl` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL COMMENT 'termék képe',
  `shopid` int(11) DEFAULT NULL,
  `product_type_id` int(11) DEFAULT NULL,
  `roomid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `shoplink`, `imageurl`, `shopid`, `product_type_id`, `roomid`) VALUES
(1, 'Kihúzható Asztal Coburg 140/80 Cm', '69990.00', 'https://www.moebelix.hu/p/kihuzhato-asztal-coburg-140-80-cm-002478005115', 'https://postimg.cc/62nzzyJT', 2, 21, 5),
(2, 'Étkezőasztal Juliette', '59990.00', 'https://www.moebelix.hu/p/tkezoasztal-juliette-000055013601', 'https://postimg.cc/KKW6kkFW', 2, 21, 5),
(3, 'Kihúzható Étkezőasztal Elara', '99990.00', 'https://www.moebelix.hu/p/kihuzhato-etkezoasztal-elara-000687071007', 'https://postimg.cc/4Y2ccZ0M', 2, 21, 5),
(4, 'Étkezőasztal Severin 138', '79990.00', 'https://www.moebelix.hu/p/tkezoasztal-severin-138-002647007606', 'https://postimg.cc/nMmkkMbq', 2, 21, 5),
(5, 'Étkezőasztal Aron 138', '56990.00', 'https://www.moebelix.hu/p/tkezoasztal-aron-138-002647009201', 'https://postimg.cc/1gNkrs9X', 2, 21, 5),
(6, 'Étkezőasztal Wood 160', '229900.00', 'https://www.moebelix.hu/p/james-wood-tkezoasztal-wood-160-002730002503', 'https://postimg.cc/tZzpFp5P', 2, 21, 5),
(7, 'Étkezőasztal Brick 80', '27990.00', 'https://www.moebelix.hu/p/tkezoasztal-brick-80-002647011202', 'https://postimg.cc/w7gsKjZK', 2, 21, 5),
(8, 'Kihúzható Asztal Charme 160/90 Cm', '139900.00', 'https://www.moebelix.hu/p/kihuzhato-asztal-charme-160-90-cm-002546002001', 'https://postimg.cc/PpC05H7T', 2, 21, 5),
(9, 'Étkezőasztal Köln 75', '18990.00', 'https://www.moebelix.hu/p/tkezoasztal-koeln-75-001606005501', 'https://postimg.cc/Yvm309rX', 2, 21, 5),
(10, 'Étkezőasztal Bonny T', '89990.00', 'https://www.moebelix.hu/p/tkezoasztal-bonny-t-001606009706', 'https://postimg.cc/yg94TByn', 2, 21, 5),
(21, 'Szék Lech', '14990.00', 'https://www.moebelix.hu/p/szek-lech-001125019702', 'https://postimg.cc/Kk1NbZYb', 2, 23, 5),
(22, 'Szék Franzi', '7990.00', 'https://www.moebelix.hu/p/szek-franzi-001634010501', 'https://postimg.cc/7G42swTX', 2, 23, 5),
(23, 'Szék John', '15990.00', 'https://www.moebelix.hu/p/szek-john-001013002911', 'https://postimg.cc/bGcgPXtS', 2, 23, 5),
(24, 'Szék Basti Giga-S', '19990.00', 'https://www.moebelix.hu/p/szek-basti-giga-s-001634006201', 'https://postimg.cc/c6ws1w2K', 2, 23, 5),
(25, 'Szék Anne Ii', '19990.00', 'https://www.moebelix.hu/p/szek-anne-ii-000758019902', 'https://postimg.cc/34GKzv2H', 2, 23, 5),
(26, 'Szék Anne\r\n', '15990.00', 'https://www.moebelix.hu/p/szek-anne-000758019802', 'https://postimg.cc/PPdNBSJf', 2, 23, 5),
(27, 'Szánkótalpas Szék Teddy Giga-S', '29990.00', 'https://www.moebelix.hu/p/szankotalpas-szek-teddy-giga-s-000289015201', 'https://postimg.cc/grjGR1xZ', 2, 23, 5),
(28, 'Szék Olivia Giga-S', '39990.00', 'https://www.moebelix.hu/p/szek-olivia-giga-s-000039003202', 'https://postimg.cc/MM8dwCgr', 2, 23, 5),
(29, 'Szánkótalpas Szék Phil Giga-S', '37990.00', 'https://www.moebelix.hu/p/szankotalpas-szek-phil-giga-s-001634010601', 'https://postimg.cc/zLNxYms2', 2, 23, 5),
(30, 'Szánkótalpas Szék Nick', '44990.00', 'https://www.moebelix.hu/p/szankotalpas-szek-nick-002540022501', 'https://postimg.cc/SjQxdDKW', 2, 23, 5),
(42, 'Falipolc Szett Simple', '4990.00', 'https://www.moebelix.hu/p/falipolc-szett-simple-007326001604', 'https://postimg.cc/ykzLFkK5', 2, 22, 5),
(43, 'Falipolc Isola\r\n', '11990.00', 'https://www.moebelix.hu/p/falipolc-isola-001803072102', 'https://postimg.cc/1gH8Y7Vw', 2, 22, 5),
(44, 'Falipolc Bc 3105', '39990.00', 'https://www.moebelix.hu/p/falipolc-bc-3105-000887057201', 'https://postimg.cc/21xjzbjf', 2, 22, 5),
(45, 'Falipolc Linate', '19990.00', 'https://www.moebelix.hu/p/falipolc-linate-001803072907\r\n', 'https://postimg.cc/sM1yRnL5', 2, 22, 5),
(46, 'Falipolc Elke', '9990.00', 'https://www.moebelix.hu/p/falipolc-elke-001803038601', 'https://postimg.cc/d7m5NF96', 2, 22, 5),
(47, 'Falipolc Szett Sven', '19990.00', 'https://www.moebelix.hu/p/moebelix-falipolc-szett-sven-000366002501\r\n', 'https://postimg.cc/sBwpZgck', 2, 22, 5),
(48, 'Falipolc Kashmir New', '12990.00', 'https://www.moebelix.hu/p/james-wood-falipolc-kashmir-new-001803052805', 'https://postimg.cc/7CDFZmsB', 2, 22, 5),
(49, 'Falipolc Alassio', '18990.00', 'https://www.moebelix.hu/p/luca-bessoni-falipolc-alassio-001803056907', 'https://postimg.cc/wtmQnpcZ', 2, 22, 5),
(50, 'Falipolc Auris', '19990.00', 'https://www.moebelix.hu/p/luca-bessoni-falipolc-auris-001803063113', 'https://postimg.cc/ZBJvjtfr', 2, 22, 5),
(51, 'Falipolc Szett Nizza', '14990.00', 'https://www.moebelix.hu/p/falipolc-szett-nizza-007326059701', 'https://postimg.cc/jnL5ksyJ', 2, 22, 5),
(52, 'Kétüléses Kanapé Monaco', '159900.00', 'https://www.moebelix.hu/p/luca-bessoni-ketueleses-kanape-monaco-002694000902', 'https://postimg.cc/fk9BzvK4', 2, 1, 1),
(53, 'Kanapé Monaco', '189900.00', 'https://www.moebelix.hu/p/luca-bessoni-kanape-monaco-002694000903', 'https://postimg.cc/KRQLxKdS', 2, 1, 1),
(54, 'Kanapéágy Cadiz New', '289900.00', 'https://www.moebelix.hu/p/kanapeagy-cadiz-new-001204002406', 'https://postimg.cc/svfmYRzz', 2, 1, 1),
(55, 'KANAPÉÁGY Levi B: Ca. 208 Cm', '179900.00', 'https://www.moebelix.hu/p/ondega-kanapeagy-levi-b-ca-208-cm-000317001701', 'https://postimg.cc/Q9kg7fnV', 2, 1, 1),
(56, 'Kanapéágy Malcolm Hellgrau', '399900.00', 'https://www.moebelix.hu/p/kanapeagy-malcolm-hellgrau-000295005701', 'https://postimg.cc/jWyyV8Tv', 2, 1, 1),
(57, 'Kanapéágy Beta New', '339900.00', 'https://www.moebelix.hu/p/kanapeagy-beta-new-002427014701', 'https://postimg.cc/4mrKJzB0', 2, 1, 1),
(58, 'Óriás Kanapé Aruba', '349900.00', 'https://www.moebelix.hu/p/rias-kanape-aruba-000552031906', 'https://postimg.cc/zyZBmqfZ', 2, 1, 1),
(59, 'Boxpring Kanapé Emily', '299900.00', 'https://www.moebelix.hu/p/ondega-boxpring-kanape-emily-001174000701', 'https://postimg.cc/svSj4b4n', 2, 1, 1),
(60, 'Kanapé Ibiza', '189900.00', 'https://www.moebelix.hu/p/kanape-ibiza-001204003509', 'https://postimg.cc/jnH1L6yh', 2, 1, 1),
(61, 'Kanapéágy Anna', '379900.00', 'https://www.moebelix.hu/p/kanapeagy-anna-002990004301', 'https://postimg.cc/LqGQDQTT', 2, 1, 1),
(72, 'Dohányzóasztal Silvia', '39990.00', 'https://www.moebelix.hu/p/dohanyzoasztal-silvia-001973001702', 'https://postimg.cc/BLFt8spH', 2, 21, 1),
(73, 'Dohányzóasztal Silvia/2', '39990.00', 'https://www.moebelix.hu/p/dohanyzoasztal-silvia-001973001701', 'https://postimg.cc/BPGbHy7y', 2, 21, 1),
(74, 'Dohányzóasztal Cala Luna', '26990.00', 'https://www.moebelix.hu/p/dohanyzoasztal-cala-luna-001803035301', 'https://postimg.cc/n9Yzkk6L', 2, 21, 1),
(75, 'Dohányzóasztal Gina Sonoma Tölgy Dekorral', '17990.00', 'https://www.moebelix.hu/p/dohanyzoasztal-gina-sonoma-toelgy-dekorral-002140003003', 'https://postimg.cc/3WgdY8dH', 2, 21, 1),
(76, 'Dohányzóasztal Cestino', '59990.00', 'https://www.moebelix.hu/p/dohanyzoasztal-cestino-001803072308', 'https://postimg.cc/ppRydwF5', 2, 21, 1),
(77, 'Dohányzóasztal Cala Luna/2', '26990.00', 'https://www.moebelix.hu/p/dohanyzoasztal-cala-luna-001803035302', 'https://postimg.cc/XpLqBsfH', 2, 21, 1),
(78, 'Dohányzóasztal Laura', '19990.00', 'https://www.moebelix.hu/p/dohanyzoasztal-laura-001803023910', 'https://postimg.cc/21JZ3Hmp', 2, 21, 1),
(79, 'Dohányzóasztal Saba', '14990.00', 'https://www.moebelix.hu/p/moebelix-dohanyzoasztal-saba-001973000101', 'https://postimg.cc/xkzbmKTX', 2, 21, 1),
(80, 'Dohányzóasztal Paolo', '11990.00', 'https://www.moebelix.hu/p/dohanyzoasztal-paolo-001555000508', 'https://postimg.cc/yWP306By', 2, 21, 1),
(81, 'Dohányzóasztal Paolo/2', '11990.00', 'https://www.moebelix.hu/p/dohanyzoasztal-paolo-001555000509', 'https://postimg.cc/Wh1F8R1L', 2, 21, 1),
(92, 'Tv-elem Genetic', '89990.00', 'https://www.moebelix.hu/p/tv-elem-genetic-000687037402', 'https://postimg.cc/GTj9bK3y', 2, 5, 1),
(93, 'Médiaállvány Tico', '29990.00', 'https://www.moebelix.hu/p/mediaallvany-tico-001803030204', 'https://postimg.cc/7CbtvPM3', 2, 5, 1),
(94, 'Tv-elem Yoris', '54990.00', 'https://www.moebelix.hu/p/tv-elem-yoris-000241005205', 'https://postimg.cc/XBFddmKB', 2, 5, 1),
(95, 'Tv-elem Bretagne', '59990.00', 'https://www.moebelix.hu/p/tv-elem-bretagne-000834009603', 'https://postimg.cc/hfW9c4gL', 2, 5, 1),
(96, 'Tv-elem Alassio', '99990.00', 'https://www.moebelix.hu/p/luca-bessoni-tv-elem-alassio-001803056902', 'https://postimg.cc/GB2DqHJC', 2, 5, 1),
(97, 'Tv-elem Alassio/2', '119900.00', 'https://www.moebelix.hu/p/luca-bessoni-tv-elem-alassio-001803056906', 'https://postimg.cc/BjGbjtwg', 2, 5, 1),
(98, 'Tv-elem Tonale', '89990.00', 'https://www.moebelix.hu/p/tv-elem-tonale-001803057308', 'https://postimg.cc/MfQZT87N', 2, 5, 1),
(99, 'Tv-elem Venedig', '59990.00', 'https://www.moebelix.hu/p/tv-elem-venedig-001803053302', 'https://postimg.cc/Wh0bcTbJ', 2, 5, 1),
(100, 'Tv-elem Malta', '49990.00', 'https://www.moebelix.hu/p/tv-elem-malta-001803031815', 'https://postimg.cc/9Dpmzb9m', 2, 5, 1),
(101, 'Médiaállvány Bernd 2 Mx 144', '89990.00', 'https://www.moebelix.hu/p/mediaallvany-bernd-2-mx-144-002698012302', 'https://postimg.cc/yWZ70sRr', 2, 5, 1),
(102, 'Tükör Alassio', '39990.00', 'https://www.moebelix.hu/p/luca-bessoni-tuekoer-alassio-001803058705', 'https://postimg.cc/nsvZZ697', 2, 16, 4),
(103, 'Tükör Salve', '29990.00', 'https://www.moebelix.hu/p/tuekoer-salve-001803072501', 'https://postimg.cc/mz5mnrZS', 2, 16, 4),
(104, 'Fali Tükör Bonny', '4990.00', 'https://www.moebelix.hu/p/ondega-fali-tuekoer-bonny-002757019001', 'https://postimg.cc/gwrRTHxf', 2, 16, 4),
(105, 'Fali Tükör Rom', '5490.00', 'https://www.moebelix.hu/p/fali-tuekoer-rom-008103023401', 'https://postimg.cc/v42xfx0X', 2, 16, 4),
(106, 'Tükör Vancouver', '34990.00', 'https://www.moebelix.hu/p/tuekoer-vancouver-000196087002', 'https://postimg.cc/RNMd48qt', 2, 16, 4),
(107, 'Fali Tükör Jakob', '6990.00', 'https://www.moebelix.hu/p/fali-tuekoer-jakob-007326007601', 'https://postimg.cc/LJGjY04N', 2, 16, 4),
(108, 'Fali Tükör Attack', '12990.00', 'https://www.moebelix.hu/p/fali-tuekoer-attack-001803044905', 'https://postimg.cc/RWJHBQ1f', 2, 16, 4),
(109, 'Fali Tükör Malta', '24990.00', 'https://www.moebelix.hu/p/fali-tuekoer-malta-001803031823', 'https://postimg.cc/Xr4RMQ61', 2, 16, 4),
(110, 'Fali Tükör Kastor', '9990.00', 'https://www.moebelix.hu/p/ondega-fali-tuekoer-kastor-002757019401', 'https://postimg.cc/cgRz5n5G', 2, 16, 4),
(111, 'Tükör Spring\r\n', '24990.00', 'https://www.moebelix.hu/p/tuekoer-spring-001803071305', 'https://postimg.cc/G9bgm959', 2, 16, 4),
(112, 'Törölköző Katharina', '4990.00', 'https://www.moebelix.hu/p/toeroelkoezo-katharina-007659000406', 'https://postimg.cc/LhmXyGHY', 2, 19, 4),
(113, 'Törölköző Flora', '3990.00', 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-flora-006792010806', 'https://postimg.cc/MvCJLjyP', 2, 19, 4),
(114, 'Törölköző Sandra', '3000.00', 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-sandra-003002000204', 'https://postimg.cc/mtxdf35H', 2, 19, 4),
(115, 'Törölköző Rocky 70/140cm', '4990.00', 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-rocky-70-140cm-003520000202', 'https://postimg.cc/8jttJ8Ch', 2, 19, 4),
(116, 'Törölköző Liliane', '3490.00', 'https://www.moebelix.hu/p/ondega-toeroelkoezo-liliane-003520000802', 'https://postimg.cc/D4f1nZLR', 2, 19, 4),
(117, 'Törölköző Liliane/2', '3490.00', 'https://www.moebelix.hu/p/ondega-toeroelkoezo-liliane-003520000803', 'https://postimg.cc/svQvS7jw', 2, 19, 4),
(118, 'TÖRÖLKÖZŐ Flora/2', '3990.00', 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-flora-006792010805', 'https://postimg.cc/TKj2qcZq', 2, 19, 4),
(119, 'Törölköző Liliane/3', '3490.00', 'https://www.moebelix.hu/p/ondega-toeroelkoezo-liliane-003520000804', 'https://postimg.cc/RWG5Zpk8', 2, 19, 4),
(120, 'Törölköző Rocky 70/140cm /2', '4990.00', 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-rocky-70-140cm-003520000204', 'https://postimg.cc/21kMMF1x', 2, 19, 4),
(121, 'Törölköző Flora/3', '3990.00', 'https://www.moebelix.hu/p/james-wood-toeroelkoezo-flora-006792010804', 'https://postimg.cc/gLctQGJ2', 2, 19, 4),
(122, 'Szappanadagoló Allstar Minas 23030100', '1690.00', 'https://www.moebelix.hu/p/szappanadagolo-allstar-minas-23030100-004332074201', 'https://postimg.cc/SjqjKdKh', 2, 20, 4),
(123, 'Szappanadagoló Basic 24759100', '7490.00', 'https://www.moebelix.hu/p/szappanadagolo-basic-24759100-004332074401', 'https://postimg.cc/ppvsLgwB', 2, 20, 4),
(124, 'Szappanadagoló Allstar Olinda 70192400/2', '2290.00', 'https://www.moebelix.hu/p/szappanadagolo-allstar-olinda-70192400-004332073901', 'https://postimg.cc/JGTYYpFc', 2, 20, 4),
(125, 'Szappanadagoló Static Loc Plus Pavia 24896100', '6490.00', 'https://www.moebelix.hu/p/szappanadagolo-static-loc-plus-pavia-24896100-004332074501', 'https://postimg.cc/BjrgRkBD', 2, 20, 4),
(126, 'Szenzoros Szappanadagoló Kader', '4990.00', 'https://www.moebelix.hu/p/bono-szenzoros-szappanadagolo-kader-0079070148', 'https://postimg.cc/K4GNXnB9', 2, 20, 4),
(127, 'Szappanadagoló Delia', '3790.00', 'https://www.moebelix.hu/p/luca-bessoni-szappanadagolo-delia-0046281426', 'https://postimg.cc/PLnWSZdQ', 2, 20, 4),
(128, 'Folyékonyszappan Adagoló Line Chilly Family', '1990.00', 'https://www.moebelix.hu/p/folyekonyszappan-adagolo-line-chilly-family-000283002001', 'https://postimg.cc/ZWtvmSXT', 2, 20, 4),
(129, 'Szappantartó Allstar Olinda 70201400/3', '1290.00', 'https://www.moebelix.hu/p/szappantarto-allstar-olinda-70201400-004332074003', 'https://postimg.cc/ZvxFN5Gx', 2, 20, 4),
(130, 'Szappantartó Allstar Olinda 70193400/4', '1290.00', 'https://www.moebelix.hu/p/szappantarto-allstar-olinda-70193400-004332073903', 'https://postimg.cc/xJwnm0v8', 2, 20, 4),
(131, 'Szappantartó Line Chilly Family/2', '2290.00', 'https://www.moebelix.hu/p/szappantarto-line-chilly-family-000283002003', 'https://postimg.cc/4KMgCJFP', 2, 20, 4),
(132, 'Kárpitozott Ágy Padua 180/200 Cm', '179900.00', 'https://www.moebelix.hu/p/karpitozott-agy-padua-180-200-cm-002216001301', 'https://postimg.cc/BXsjb0JN', 2, 11, 3),
(133, 'Kihúzható Ágy Storm', '149900.00', 'https://www.moebelix.hu/p/kihuzhato-agy-storm-002561000101', 'https://postimg.cc/SJy6n54L', 2, 11, 3),
(134, 'Tárolós Ágy Till 140/200 Cm', '229900.00', 'https://www.moebelix.hu/p/tarolos-agy-till-140-200-cm-000528021003', 'https://postimg.cc/kDy8PcS2', 2, 11, 3),
(135, 'Boxspring-ágy Ancona 180/200 Cm', '449900.00', 'https://www.moebelix.hu/p/boxspring-agy-ancona-180-200-cm-002366000801', 'https://postimg.cc/CzQRw6xx', 2, 11, 3),
(136, 'Tárolós Ágy Saturn 180/200 Cm', '139900.00', 'https://www.moebelix.hu/p/tarolos-agy-saturn-180-200-cm-002427003718', 'https://postimg.cc/7bLPbMcG', 2, 11, 3),
(137, 'Kihúzható Ágy Timmi', '229900.00', 'https://www.moebelix.hu/p/kihuzhato-agy-timmi-000423004701', 'https://postimg.cc/3yB7xdFF', 2, 11, 3),
(138, 'Kárpitozott Ágy Lucy 180/200 Cm', '139900.00', 'https://www.moebelix.hu/p/karpitozott-agy-lucy-180-200-cm-002216002401', 'https://postimg.cc/v1QFkGwg', 2, 11, 3),
(139, 'Tárolós Ágy Till 90/200 Cm/2', '159900.00', 'https://www.moebelix.hu/p/tarolos-agy-till-90-200-cm-000528021004', 'https://postimg.cc/GB3Vzzvv', 2, 11, 3),
(140, 'Tárolós Ágy Bonny 90/200 Cm', '99990.00', 'https://www.moebelix.hu/p/tarolos-agy-bonny-90-200-cm-000423010702', 'https://postimg.cc/kB9cxGQb', 2, 11, 3),
(141, 'Tárolós ágy Cindy 2', '109900.00', 'https://www.moebelix.hu/p/tarolos-agy-cindy-2-001787084903', 'https://postimg.cc/21125Jdc', 2, 11, 3),
(142, 'Éjjeliszekrény Ella', '14990.00', 'https://www.moebelix.hu/p/jjeliszekreny-ella-000778006901', 'https://postimg.cc/hzQSqwnR', 2, 23, 3),
(143, 'Éjjeliszekrény Tölgy Dekor', '29990.00', 'https://www.moebelix.hu/p/jjeliszekreny-toelgy-dekor-002522029403', 'https://postimg.cc/mtnWTjdb', 2, 23, 3),
(144, 'Éjjeliszekrény Billund', '39990.00', 'https://www.moebelix.hu/p/jjeliszekreny-billund-001787029018', 'https://postimg.cc/HJhy2fzq', 2, 23, 3),
(145, 'Éjjeliszekrény Ella/2\r\n', '14990.00', 'https://www.moebelix.hu/p/jjeliszekreny-ella-000778006902', 'https://postimg.cc/MMzp1t2C', 2, 23, 3),
(146, 'Éjjeliszekrény Saturn', '29990.00', 'https://www.moebelix.hu/p/jjeliszekreny-saturn-002427003705', 'https://postimg.cc/QB4yqxRj', 2, 23, 3),
(147, 'Éjjeliszekrény 4-You', '14990.00', 'https://www.moebelix.hu/p/jjeliszekreny-4-you-001803027111', 'https://postimg.cc/gx6V7cXY', 2, 23, 3),
(148, 'Éjjeliszekrény Saturn/2', '29990.00', 'https://www.moebelix.hu/p/jjeliszekreny-saturn-002427003713', 'https://postimg.cc/0zxkTcrb', 2, 23, 3),
(149, 'Éjjeliszekrény Box', '24990.00', 'https://www.moebelix.hu/p/ondega-jjeliszekreny-box-001803018732', 'https://postimg.cc/cr1ZT6zn', 2, 23, 3),
(150, 'Éjjeliszekrény Avensis New', '39990.00', 'https://www.moebelix.hu/p/luca-bessoni-jjeliszekreny-avensis-new-001803037803', 'https://postimg.cc/CBdkjFgT', 2, 23, 3),
(151, 'Éjjeliszekrény 4-You New/2', '19990.00', 'https://www.moebelix.hu/p/jjeliszekreny-4-you-new-001803044804', 'https://postimg.cc/18tmR4cQ', 2, 23, 3),
(152, 'Tolóajtós Szekrény Time 170/195 Cm', '99990.00', 'https://www.moebelix.hu/p/toloajtos-szekreny-time-170-195-cm-002522035901', 'https://postimg.cc/VSZd25T5', 2, 23, 3),
(153, 'Tolóajtós Szekrény Starter B 125/196 Cm', '79990.00', 'https://www.moebelix.hu/p/toloajtos-szekreny-starter-b-125-196-cm-002522031501', 'https://postimg.cc/FY7R3h14', 2, 23, 3),
(154, 'Nyílóajtós Szekrény Karl 159/196 Cm', '129900.00', 'https://www.moebelix.hu/p/nyiloajtos-szekreny-karl-159-196-cm-002522018202', 'https://postimg.cc/z3c435mW', 2, 23, 3),
(155, 'Nyílóajtós Szekrény Landwood 80/200 Cm', '89990.00', 'https://www.moebelix.hu/p/nyiloajtos-szekreny-landwood-80-200-cm-002478007907', 'https://postimg.cc/dZ61m18q', 2, 23, 3),
(156, 'Tolóajtós Szekrény Oldenburg 180/198 Cm', '199900.00', 'https://www.moebelix.hu/p/toloajtos-szekreny-oldenburg-180-198-cm-001787071601', 'https://postimg.cc/CzW1GW8n', 2, 23, 3),
(157, 'Nyílóajtós szekrény Base 3 121/177 Cm', '79990.00', 'https://www.moebelix.hu/p/nyiloajtos-szekreny-base-3-121-177-cm-002522000804', 'https://postimg.cc/67qmB1Hz', 2, 23, 3),
(158, 'Tolóajtós Szekrény Sinfonie Sand 249/221 Cm', '339900.00', 'https://www.moebelix.hu/p/toloajtos-szekreny-sinfonie-sand-249-221-cm-000531041102', 'https://postimg.cc/HVLZwNmm', 2, 23, 3),
(159, 'Tolóajtós Szekrény Navara 242/215,5 Cm', '269900.00', 'https://www.moebelix.hu/p/toloajtos-szekreny-navara-242-215-5-cm-000834009001', 'https://postimg.cc/Jy7G0jJp', 2, 23, 3),
(160, 'Tolóajtós Szekrény Mega 312/226 Cm', '279900.00', 'https://www.moebelix.hu/p/toloajtos-szekreny-mega-312-226-cm-002522035502', 'https://postimg.cc/S203Vfrr', 2, 23, 3),
(161, 'Bejárható Sarokszekrény Yoris 146,4/199 Cm', '249900.00', 'https://www.moebelix.hu/p/bejarhato-sarokszekreny-yoris-146-4-199-cm-000241005201', 'https://postimg.cc/1432BX0b', 2, 23, 3),
(162, 'Texas tv állvány', '74900.00', 'https://somabutor.hu/texas-tv-allvany', 'https://postimg.cc/zHZY18DX', 14, 5, 1),
(163, 'Pixie tv állvány', '45900.00', 'https://somabutor.hu/pixie-tv-allvany', 'https://postimg.cc/SnK53JLf', 14, 5, 1),
(164, 'Velence TV állvány (John TV állvány)', '46700.00', 'https://somabutor.hu/velence-tv-allvany', 'https://postimg.cc/xJPhBHZg', 14, 5, 1),
(165, 'Maldív fiókos tv állvány', '49500.00', 'https://somabutor.hu/maldiv-fiokos-tv-allvany', 'https://postimg.cc/ctnYrMNB', 14, 5, 1),
(166, 'Toledo tv állvány', '74900.00', 'https://somabutor.hu/toledo-tv-allvany', 'https://postimg.cc/wys3Vqb6', 14, 5, 1),
(167, 'Dohányzó asztal c 1 dohányzóasztal (40.5 × 80 × 50 cm)', '29900.00', 'https://somabutor.hu/dohanyzo-asztal-c-1-dohanyzoasztal', 'https://postimg.cc/QHxLc6zt', 14, 3, 1),
(168, 'Dubai 2 dohányzóasztal', '39000.00', 'https://somabutor.hu/dubai-2-dohanyzoasztal', 'https://postimg.cc/Mf6LbTd4', 14, 3, 1),
(169, 'Capri 2 dohányzóasztal', '39000.00', 'https://somabutor.hu/capri-2-dohanyzoasztal', 'https://postimg.cc/67CbkRPg', 14, 3, 1),
(170, 'EVEREST FIÓKOS DOHÁNYZÓASZTAL', '44200.00', 'https://somabutor.hu/everest-fiokos-dohanyzoasztal', 'https://postimg.cc/jCx31D43', 14, 3, 1),
(171, 'Baldo 2 dohányzóasztal', '39000.00', 'https://somabutor.hu/baldo-dohanyzo', 'https://postimg.cc/ph2C3Sz5', 14, 3, 1),
(172, 'MEGAN kanapé', '129500.00', 'https://somabutor.hu/megan-kanape', 'https://postimg.cc/zHLz58gy', 14, 1, 1),
(173, 'CHERRY 2-es kanapé', '147900.00', 'https://somabutor.hu/cherry-2-es-kanape', 'https://postimg.cc/PLtdJmDs', 14, 1, 1),
(174, 'BENIAMIN 2-es szófa', '148900.00', 'https://somabutor.hu/beniamin-2-es-szofa', 'https://postimg.cc/hXnBZ9pz', 14, 1, 1),
(175, 'MILANO kanapé', '154900.00', 'https://somabutor.hu/milano-kanape', 'https://postimg.cc/xkdBBgHC', 14, 1, 1),
(176, 'Noel ortopéd rugós/szivacsos sarokülő', '169900.00', 'https://somabutor.hu/noel-ortoped-rugosszivacsos-sarokulo', 'https://postimg.cc/zVSMB4Fv', 14, 1, 1),
(177, 'Könyvespolc', '44900.00', 'https://somabutor.hu/konyvespolc', 'https://postimg.cc/WtXDm18P', 14, 22, 5),
(178, 'Joker falipolc', '17400.00', 'https://somabutor.hu/joker-falipolc', 'https://postimg.cc/cgTJcFQc', 14, 22, 5),
(179, 'Térelválasztó', '59600.00', 'https://somabutor.hu/terelvalaszto', 'https://postimg.cc/LYyHPnpC', 14, 22, 5),
(180, 'Taipei könyvespolc', '38900.00', 'https://somabutor.hu/taipei-konyvespolc', 'https://postimg.cc/9wRjqb10', 14, 22, 5),
(181, 'Lucky falipolc', '20800.00', 'https://somabutor.hu/lucky-falipolc', 'https://postimg.cc/ftyG6CGC', 14, 22, 5),
(182, 'Niki szék', '20300.00', 'https://somabutor.hu/niki-szek', 'https://postimg.cc/rd56czs0', 14, 23, 5),
(183, 'Kitty szék', '21600.00', 'https://somabutor.hu/kitty-szek', 'https://postimg.cc/JsBvctb6', 14, 23, 5),
(184, 'Herman szék', '22000.00', 'https://somabutor.hu/herman-szek', 'https://postimg.cc/YL9y4Srx', 14, 23, 5),
(185, 'LARA szék', '28300.00', 'https://somabutor.hu/lara-szek-132', 'https://postimg.cc/mtK6DR0Q', 14, 23, 5),
(186, 'Inez szék', '34200.00', 'https://somabutor.hu/inez-szek', 'https://postimg.cc/N9Ndww62', 14, 23, 5),
(187, 'Debora asztal - székek nélkül (160 cm x 88 cm + 40 cm)', '62400.00', 'https://somabutor.hu/debora-asztal-160-cm-x-88-cm-40-cm', 'https://postimg.cc/kBCvhG3Y', 14, 21, 5),
(188, 'Hanna asztal - székek nélkül (160 cm x 88 cm + 40 cm)', '68900.00', 'https://somabutor.hu/hanna-asztal-160-cm-x-88-cm-40-cm', 'https://postimg.cc/YG1m1N9r', 14, 21, 5),
(189, 'Magasfényű Flóra asztal - székek nélkül (160 CM X 88 CM + 40 CM)', '112700.00', 'https://somabutor.hu/fenyes-flora-asztal-szekek-nelkul-160-cm-x-88-cm-40-cm', 'https://postimg.cc/Z96rczsz', 14, 21, 5),
(190, 'BERTA asztal - székek nélkül (120 cm x 70 cm + 40 cm)', '48600.00', 'https://somabutor.hu/berta-asztal-159', 'https://postimg.cc/JD1B5DBj', 14, 21, 5),
(191, 'Tony asztal - székek nélkül (160 cm x 90 + 40 cm)', '73500.00', 'https://somabutor.hu/tony-asztal-szekek-nelkul-160-cm-x-90-40-cm', 'https://postimg.cc/F7J1cgn2', 14, 21, 5),
(192, 'Diablo szekrénysor (320cm)', '201000.00', 'https://somabutor.hu/diablo-szekrenysor-1200', 'https://postimg.cc/bDxrWz1p', 14, 14, 3),
(193, 'Uni Viktória szekrénysor (320 cm)', '234900.00', 'https://somabutor.hu/uni-viktoria-szekrenysor-320-cm', 'https://postimg.cc/GBsj5Szd', 14, 14, 3),
(194, 'DUBALUX szekrénysor (375 cm)', '326400.00', 'https://somabutor.hu/dubalux-szekrenysor-1314', 'https://postimg.cc/VdGBLcVz', 14, 14, 3),
(195, 'Golden szekrénysor (360 cm)', '207600.00', 'https://somabutor.hu/golden-szekrenysor-1357', 'https://postimg.cc/9z1yJhVy', 14, 14, 3),
(196, 'Peremes 1 fiókos éjjeliszekrény', '22900.00', 'https://somabutor.hu/peremes-1-fiokos-ejjeliszekreny', 'https://postimg.cc/q6LRM4B0', 14, 13, 3),
(197, '2 fiókos alsó polcos éjjeliszekrény', '23900.00', 'https://somabutor.hu/2-fiokos-also-polcos-ejjeliszekreny', 'https://postimg.cc/v1bGTCjZ', 14, 13, 3),
(198, 'TYP07 ágyrácsos ágy', '249900.00', 'https://somabutor.hu/typ07-agyracsos-agy', 'https://postimg.cc/5jCvwCyQ', 14, 11, 3),
(199, 'ST3 (140/160/180/200 x 200 cm) ágyrácsos ágy', '249900.00', 'https://somabutor.hu/st3-140160180200-x-200-agyracsos-agy', 'https://postimg.cc/218VXbkw', 14, 11, 3),
(200, 'TYP50 boxspring ágy', '321900.00', 'https://somabutor.hu/typ50-boxspring-agy', 'https://postimg.cc/qgsqJXgw', 14, 11, 3),
(201, 'TYP58 boxspring ágy', '355900.00', 'https://somabutor.hu/typ58-boxspring-agy', 'https://postimg.cc/7JH58f1w', 14, 11, 3),
(202, 'Danilo extra bonell rugós franciaágy (160 X 200 cm)', '132200.00', 'https://somabutor.hu/danilo-extra-bonell-rugos-franciaagy-160-x-200-cm', 'https://postimg.cc/w7PjFWr6', 14, 11, 3),
(203, 'Komód FASO 180 kandallóval fehér', '241300.00', 'https://butorline.hu/komod-faso-180-kandalloval-feher', 'https://postimg.cc/0MBv8Lf4', 13, 5, 1),
(204, 'TV komód INEZA IN02 artisan tölgy / fekete', '63000.00', 'https://butorline.hu/tv-komod-ineza-in02-artisan-toelgy-fekete', 'https://postimg.cc/McL3XxC1', 13, 5, 1),
(205, 'Szekrény RTV POWER Fehér / Sandal / Fehér fényes', '53400.00', 'https://butorline.hu/szekreny-rtv-power-feher-sandal-feher-fenyes-kiarusitas', 'https://postimg.cc/tYRcrrNZ', 13, 5, 1),
(206, 'TV szekrény BERAM 01 artisan tölgy', '76000.00', 'https://butorline.hu/tv-szekreny-beram-01-artisan-toelgy', 'https://postimg.cc/Lnrzq559', 13, 5, 1),
(207, 'TV szekrény 180 GOVI VG1G fekete / wotan tölgy', '66900.00', 'https://butorline.hu/tv-szekreny-180-govi-vg1g-fekete-wotan-toelgy', 'https://postimg.cc/Xpy50W8T', 13, 5, 1),
(208, 'Dohányzóasztal ALVARO 10 kasmír', '64900.00', 'https://butorline.hu/dohanyzoasztal-alvaro-10-kasmir', 'https://postimg.cc/34FsNWTW', 13, 3, 1),
(209, 'Dohányzóasztal DANTE 06 fekete', '72000.00', 'https://butorline.hu/dohanyzoasztal-dante-06-fekete', 'https://postimg.cc/jnzLLHjP', 13, 3, 1),
(210, 'Dohányzóasztal CIMER 04 fekete / artisan', '71500.00', 'https://butorline.hu/dohanyzoasztal-cimer-04-fekete-artisan', 'https://postimg.cc/bsyts5Qv', 13, 3, 1),
(211, 'Dohányzóasztal DANTE 07 fekete', '55100.00', 'https://butorline.hu/dohanyzoasztal-dante-07-fekete', 'https://postimg.cc/6T930vTj', 13, 3, 1),
(212, 'Dohányzóasztal DENVI DV10 monastery tölgy / fekete fényes', '78300.00', 'https://butorline.hu/dohanyzoasztal-denvi-dv10-monastery-toelgy-fekete-fenyes', 'https://postimg.cc/3kg5Vtcg', 13, 3, 1),
(213, 'Kanapé BERGI tiffany 10', '312900.00', 'https://butorline.hu/kanape-bergi-tiffany-10', 'https://postimg.cc/hhjH0DbW', 13, 1, 1),
(214, 'Kanapé DART 2 soft 66 / kreta 07', '212900.00', 'https://butorline.hu/kanape-dart-2-soft-66-kreta-07', 'https://postimg.cc/56zKP6XG', 13, 1, 1),
(215, 'Kanapé LAKCHOS 2 monolith 85', '223900.00', 'https://butorline.hu/kanape-lakchos-2-monolith-85', 'https://postimg.cc/DJD56Tnn', 13, 1, 1),
(216, 'Kanapé DART kreta 05 / soft 66', '212900.00', 'https://butorline.hu/kanape-dart-kreta-05-soft-66', 'https://postimg.cc/QK1gqKfJ', 13, 1, 1),
(217, 'Kanapé SELVA A - manila sötét szürke, króm', '248000.00', 'https://butorline.hu/kanape-selva-a-manila-soetet-szuerke-krom', 'https://postimg.cc/yJ2SrYgQ', 13, 1, 1),
(218, 'Alsó konyhai sarokpolc 30 STILL ST50 fehér', '27000.00', 'https://butorline.hu/also-konyhai-sarokpolc-30-still-st50-feher', 'https://postimg.cc/Sjmz1Kgs', 13, 22, 5),
(219, 'Fali polc MAMONE ME01 arany tölgy / fehér / grafit', '12000.00', 'https://butorline.hu/fali-polc-mamone-me01-arany-toelgy-feher-grafit', 'https://postimg.cc/PpWYpp2G', 13, 22, 5),
(220, 'Fali szekrény MALTIS MT03 világosszürke', '35900.00', 'https://butorline.hu/fali-szekreny-maltis-mt03-vilagosszuerke', 'https://postimg.cc/Cdp4hYmT', 13, 22, 5),
(221, 'Fali polc CIMER 06 fekete / artisan', '24400.00', 'https://butorline.hu/fali-polc-cimer-06-fekete-artisan', 'https://postimg.cc/PC75430T', 13, 22, 5),
(222, 'Fali polc CALABRIA CL15 artisan tölgy', '32500.00', 'https://butorline.hu/fali-polc-calabria-cl15-artisan-toelgy', 'https://postimg.cc/vcMggKwK', 13, 22, 5),
(223, 'Szék BOS 10 fehér / 8B', '20400.00', 'https://butorline.hu/szek-bos-10-feher-8b', 'https://postimg.cc/PCfgS979', 13, 23, 5),
(224, 'Szék BOS 10D grafit', '24800.00', 'https://butorline.hu/szek-bos-10d-grafit', 'https://postimg.cc/Bt6NwsZx', 13, 23, 5),
(225, 'Szék BOS 4D fekete', '23900.00', 'https://butorline.hu/szek-bos-4d-fekete', 'https://postimg.cc/8fj216RG', 13, 23, 5),
(226, 'Szék LUNA 1 sonoma tölgy / 16B', '29500.00', 'https://butorline.hu/szek-luna-1-sonoma-toelgy-16b', 'https://postimg.cc/zy6SMRBW', 13, 23, 5),
(227, 'Szék KD49D dió', '23200.00', 'https://butorline.hu/szek-kd49d-dio', 'https://postimg.cc/DS8RLsHb', 13, 22, 5);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `producttype`
--

CREATE TABLE `producttype` (
  `id` int(11) NOT NULL,
  `categoryid` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_hungarian_ci NOT NULL
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
  `name` varchar(255) COLLATE utf8_hungarian_ci NOT NULL COMMENT 'weboldal neve',
  `websiteurl` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL COMMENT 'weboldal url'
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
  `id` int(11) NOT NULL COMMENT 'Egyedi azonosító bútoroknak',
  `userid` int(11) DEFAULT NULL COMMENT 'A bútor neve',
  `plandata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Termék ára' CHECK (json_valid(`plandata`)),
  `createdat` timestamp NULL DEFAULT current_timestamp() COMMENT 'Bolt linkje  '
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL COMMENT 'Egyedi azonosító minden felhasználónak',
  `email` varchar(255) COLLATE utf8_hungarian_ci NOT NULL COMMENT 'A felhasználó emailje',
  `PASSWORD_hash` varchar(255) COLLATE utf8_hungarian_ci NOT NULL COMMENT 'Titkosított jelszó ',
  `fullname` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL COMMENT 'teljes neve ',
  `datet` timestamp NULL DEFAULT current_timestamp() COMMENT 'Mikor regisztrált'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`id`, `email`, `PASSWORD_hash`, `fullname`, `datet`) VALUES
(1, 'bela@gmail.com', 'AQAAAAIAAYagAAAAEGL5TIjaQX1XzLoOpCDhsF/ozs73tVal86vy61UKFZxhGWV4P4zX3SL93EV+OkrUvA==', 'Béla', '2024-09-22 13:39:54');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `__efmigrationshistory`
--

CREATE TABLE `__efmigrationshistory` (
  `MigrationId` varchar(150) NOT NULL,
  `ProductVersion` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `__efmigrationshistory`
--

INSERT INTO `__efmigrationshistory` (`MigrationId`, `ProductVersion`) VALUES
('20240921131732_Linkhandler', '8.0.8'),
('20240921155034_LoginRegisterValidatation', '8.0.8'),
('20241007063621_User', '8.0.8'),
('20241007064053_User', '8.0.8');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `aspnetroleclaims`
--
ALTER TABLE `aspnetroleclaims`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `RoleId` (`RoleId`);

--
-- A tábla indexei `aspnetroles`
--
ALTER TABLE `aspnetroles`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `IX_AspNetRoles_NormalizedName` (`NormalizedName`);

--
-- A tábla indexei `aspnetuserclaims`
--
ALTER TABLE `aspnetuserclaims`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `UserId` (`UserId`);

--
-- A tábla indexei `aspnetuserlogins`
--
ALTER TABLE `aspnetuserlogins`
  ADD PRIMARY KEY (`LoginProvider`,`ProviderKey`),
  ADD KEY `UserId` (`UserId`);

--
-- A tábla indexei `aspnetuserroles`
--
ALTER TABLE `aspnetuserroles`
  ADD PRIMARY KEY (`UserId`,`RoleId`),
  ADD KEY `RoleId` (`RoleId`);

--
-- A tábla indexei `aspnetusers`
--
ALTER TABLE `aspnetusers`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `IX_AspNetUsers_NormalizedUserName` (`NormalizedUserName`),
  ADD KEY `IX_AspNetUsers_NormalizedEmail` (`NormalizedEmail`);

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
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Egyedi azonosító bútoroknak', AUTO_INCREMENT=228;

--
-- AUTO_INCREMENT a táblához `producttype`
--
ALTER TABLE `producttype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT a táblához `shops`
--
ALTER TABLE `shops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT a táblához `userplan`
--
ALTER TABLE `userplan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Egyedi azonosító bútoroknak';

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Egyedi azonosító minden felhasználónak', AUTO_INCREMENT=2;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `aspnetroleclaims`
--
ALTER TABLE `aspnetroleclaims`
  ADD CONSTRAINT `aspnetroleclaims_ibfk_1` FOREIGN KEY (`RoleId`) REFERENCES `aspnetroles` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `aspnetuserclaims`
--
ALTER TABLE `aspnetuserclaims`
  ADD CONSTRAINT `aspnetuserclaims_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `aspnetuserlogins`
--
ALTER TABLE `aspnetuserlogins`
  ADD CONSTRAINT `aspnetuserlogins_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `aspnetuserroles`
--
ALTER TABLE `aspnetuserroles`
  ADD CONSTRAINT `aspnetuserroles_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE,
  ADD CONSTRAINT `aspnetuserroles_ibfk_2` FOREIGN KEY (`RoleId`) REFERENCES `aspnetroles` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `aspnetusertokens`
--
ALTER TABLE `aspnetusertokens`
  ADD CONSTRAINT `aspnetusertokens_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `aspnetusers` (`Id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `planproducts`
--
ALTER TABLE `planproducts`
  ADD CONSTRAINT `Products` FOREIGN KEY (`userplanid`) REFERENCES `userplan` (`id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`shopid`) REFERENCES `shops` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`product_type_id`) REFERENCES `producttype` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_ibfk_3` FOREIGN KEY (`roomid`) REFERENCES `kategories` (`id`) ON DELETE SET NULL;

--
-- Megkötések a táblához `producttype`
--
ALTER TABLE `producttype`
  ADD CONSTRAINT `producttype_ibfk_1` FOREIGN KEY (`categoryid`) REFERENCES `kategories` (`id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `userplan`
--
ALTER TABLE `userplan`
  ADD CONSTRAINT `userplan_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
