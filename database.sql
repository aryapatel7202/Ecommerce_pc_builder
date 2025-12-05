-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: pcbuilder
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cart_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `build_id` int DEFAULT NULL,
  `prebuilt_id` bigint DEFAULT NULL,
  `cpu_id` int DEFAULT NULL,
  `gpu_id` int DEFAULT NULL,
  `ram_id` int DEFAULT NULL,
  `storage_id` int DEFAULT NULL,
  `quantity` int DEFAULT '1',
  `price` int NOT NULL,
  PRIMARY KEY (`cart_id`),
  KEY `user_id` (`user_id`),
  KEY `build_id` (`build_id`),
  KEY `prebuilt_id` (`prebuilt_id`),
  KEY `cpu_id` (`cpu_id`),
  KEY `gpu_id` (`gpu_id`),
  KEY `ram_id` (`ram_id`),
  KEY `storage_id` (`storage_id`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`build_id`) REFERENCES `pc_builds` (`build_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_ibfk_3` FOREIGN KEY (`prebuilt_id`) REFERENCES `prebuilt_pcs` (`prebuilt_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_ibfk_4` FOREIGN KEY (`cpu_id`) REFERENCES `cpu` (`cpu_id`) ON DELETE SET NULL,
  CONSTRAINT `cart_ibfk_5` FOREIGN KEY (`gpu_id`) REFERENCES `gpu` (`gpu_id`) ON DELETE SET NULL,
  CONSTRAINT `cart_ibfk_6` FOREIGN KEY (`ram_id`) REFERENCES `ram` (`ram_id`) ON DELETE SET NULL,
  CONSTRAINT `cart_ibfk_7` FOREIGN KEY (`storage_id`) REFERENCES `storage_unit` (`storage_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart1`
--

DROP TABLE IF EXISTS `cart1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart1` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `product_id` varchar(255) NOT NULL,
  `address` text,
  `status` varchar(50) DEFAULT 'IN_CART',
  `quantity` int DEFAULT '1',
  `total_price` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart1`
--

LOCK TABLES `cart1` WRITE;
/*!40000 ALTER TABLE `cart1` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `computer_case`
--

DROP TABLE IF EXISTS `computer_case`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `computer_case` (
  `case_id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `form_factor` varchar(50) DEFAULT NULL,
  `rgb` tinyint(1) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`case_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `computer_case`
--

LOCK TABLES `computer_case` WRITE;
/*!40000 ALTER TABLE `computer_case` DISABLE KEYS */;
/*!40000 ALTER TABLE `computer_case` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cooler`
--

DROP TABLE IF EXISTS `cooler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cooler` (
  `cooler_id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `supported_socket` varchar(255) DEFAULT NULL,
  `performance_rating` float DEFAULT NULL,
  `price` int DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`cooler_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cooler`
--

LOCK TABLES `cooler` WRITE;
/*!40000 ALTER TABLE `cooler` DISABLE KEYS */;
/*!40000 ALTER TABLE `cooler` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cpu`
--

DROP TABLE IF EXISTS `cpu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cpu` (
  `cpu_id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `generation` int DEFAULT NULL,
  `series` varchar(255) DEFAULT NULL,
  `model_number` int DEFAULT NULL,
  `performance_rating` float DEFAULT NULL,
  `price` int DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`cpu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cpu`
--

LOCK TABLES `cpu` WRITE;
/*!40000 ALTER TABLE `cpu` DISABLE KEYS */;
INSERT INTO `cpu` VALUES (1,'Intel','Core i3-1215U',12,'U-Series',1215,7.2,23379,'i3-1215U.jpg',15),(2,'Intel','Core i3-1115GRE',11,'U-Series',1115,7,28142,'i3-1115GRE.jpg',12),(3,'Intel','Core i3-14100F',14,'Desktop',14100,8,9568,'i3-14100F.jpg',20),(4,'Intel','Core i3-14100',14,'Desktop',14100,8.1,9906,'i3-14100.jpg',18),(5,'Intel','Core i3-13100',13,'Desktop',13100,7.8,9989,'i3-13100.jpg',22),(12,'Intel','Core i5-14600K',14,'K',14600,9,15936,'i5-14600K.jpg',10),(13,'Intel','Core i5-13600K',13,'K',13600,8.8,18675,'i5-13600K.jpg',12),(14,'Intel','Core i5-13500',13,'H',13500,8.5,16517,'i5-13500.jpg',15),(15,'Intel','Core i5-13400',13,'H',13400,8,11371,'i5-13400.jpg',20),(16,'Intel','Core i5-120',12,'U',120,7.5,20418,'i5-120.jpg',5),(17,'Intel','Core i5-120F',12,'U/F',120,7.4,17990,'i5-120F.jpg',5),(18,'Intel','Core i5-14600K',14,'K',14600,9,19090,'i5-14600K.jpg',10),(19,'Intel','Core i5-13600K',13,'K',13600,8.8,18675,'i5-13600K.jpg',12),(20,'Intel','Core i5-13500',13,'H',13500,8.5,16517,'i5-13500.jpg',15),(21,'Intel','Core i5-13400',13,'H',13400,8.2,18343,'i5-13400.jpg',20),(22,'Intel','Core Ultra 120',14,'U',120,7.5,20420,'i5-120.jpg',5),(23,'Intel','Core i5-1245U',12,'U',1245,7.8,25647,'i5-1245U.jpg',8),(24,'Intel','Core i5-1235U',12,'U',1235,7.6,25647,'i5-1235U.jpg',8),(25,'Intel','Core i5-1145G7',11,'U',1145,7,16000,'i5-1145G7.jpg',10),(26,'Intel','Core i5-1135G7',11,'U',1135,6.8,15500,'i5-1135G7.jpg',12),(27,'Intel','Core i5-11300H',11,'H',11300,8,17500,'i5-11300H.jpg',10),(28,'Intel','Core i5-12500U',12,'U',12500,7.9,24000,'i5-12500U.jpg',9),(29,'Intel','Core i5-12600H',12,'H',12600,8.3,26000,'i5-12600H.jpg',7),(30,'Intel','Core i5-13600HX',13,'H',13600,9,30000,'i5-13600HX.jpg',6),(31,'Intel','Core i5-14400F',14,'F',14400,8.7,22000,'i5-14400F.jpg',5),(32,'Intel','Core i7-14700K',14,'K',14700,9.4,22576,'i7-14700K.jpg',8),(33,'Intel','Core i7-13700K',13,'K',13700,9.2,25813,'i7-13700K.jpg',10),(34,'Intel','Core i7-12700K',12,'K',12700,9,18260,'i7-12700K.jpg',12),(35,'Intel','Core i7-12700F',12,'F',12700,8.9,16600,'i7-12700F.jpg',10),(36,'Intel','Core i7-10510U',10,'U',10510,7.5,29050,'i7-10510U.jpg',8),(37,'Intel','Core i7-1260U',12,'U',1260,8,24500,'i7-1260U.jpg',9),(38,'Intel','Core i7-1255U',12,'U',1255,7.8,23000,'i7-1255U.jpg',10),(39,'Intel','Core i7-11390H',11,'H',11390,8.5,22000,'i7-11390H.jpg',7),(40,'Intel','Core i7-1165G7',11,'U',1165,7.2,21000,'i7-1165G7.jpg',12),(41,'Intel','Core i7-13700F',13,'F',13700,9.1,22000,'i7-13700F.jpg',5),(42,'Intel','Core i9-14900K',14,'K',14900,9.5,36354,'i9-14900K.jpg',5),(43,'Intel','Core i9-13900K',13,'K',13900,9.4,35524,'i9-13900K.jpg',7),(44,'Intel','Core i9-14900KF',14,'F',14900,9.5,35607,'i9-14900KF.jpg',4),(45,'Intel','Core i9-13900F',13,'F',13900,9.3,45567,'i9-13900F.jpg',6),(46,'Intel','Core i9-13900',13,'H',13900,9.2,48472,'i9-13900.jpg',8),(47,'Intel','Core Ultra i9-285K',14,'U',285,9.6,50547,'i9-285K.jpg',3),(48,'AMD','Ryzen 3 1200',1,'H',1200,5.5,4500,'ryzen3-1200.jpg',8),(49,'AMD','Ryzen 3 1300X',1,'H',1300,5.8,5200,'ryzen3-1300x.jpg',6),(50,'AMD','Ryzen 3 2200G',2,'H',2200,6.2,6500,'ryzen3-2200g.jpg',10),(51,'AMD','Ryzen 3 3200G',3,'H',3200,6.5,7200,'ryzen3-3200g.jpg',12),(52,'AMD','Ryzen 3 3100',3,'H',3100,7,8990,'ryzen3-3100.jpg',10),(53,'AMD','Ryzen 3 3300X',3,'H',3300,7.5,10500,'ryzen3-3300x.jpg',7),(54,'AMD','Ryzen 3 4300U',4,'U',4300,6.8,12000,'ryzen3-4300u.jpg',15),(55,'AMD','Ryzen 3 5300U',5,'U',5300,7.2,14500,'ryzen3-5300u.jpg',18),(56,'AMD','Ryzen 3 7320U',7,'U',7320,7.5,21000,'ryzen3-7320u.jpg',20),(57,'AMD','Ryzen 5 3600',3,'H',3600,8.5,8775,'ryzen5-3600.jpg',10),(58,'AMD','Ryzen 5 5500',5,'H',5500,8.7,6844,'ryzen5-5500.jpg',8),(59,'AMD','Ryzen 5 9600X',9,'H',9600,9.1,21900,'ryzen5-9600X.jpg',5),(60,'AMD','Ryzen 5 3400G',3,'G',3400,8.2,6364,'ryzen5-3400G.jpg',7),(61,'AMD','Ryzen 5 4600G',4,'G',4600,8.8,9499,'ryzen5-4600G.jpg',6),(62,'AMD','Ryzen 5 5600G',5,'G',5600,9,11390,'ryzen5-5600G.jpg',5),(63,'AMD','Ryzen AI 5 330',8,'U',330,7,12000,'ryzenai5-330.jpg',10),(64,'AMD','Ryzen 5 7533HS',7,'U',7533,8,18000,'ryzen5-7533HS.jpg',4),(65,'AMD','Ryzen 7 2700',2,'H',2700,7.5,17244,'ryzen7-2700.jpg',10),(66,'AMD','Ryzen 7 2700X',2,'X',2700,7.8,20376,'ryzen7-2700X.jpg',8),(67,'AMD','Ryzen 7 3700X',3,'X',3700,8.4,17500,'ryzen7-3700X.jpg',9),(68,'AMD','Ryzen 7 3800X',3,'X',3800,8.6,19800,'ryzen7-3800X.jpg',7),(69,'AMD','Ryzen 7 5700',5,'H',5700,8.5,11200,'ryzen7-5700.jpg',12),(70,'AMD','Ryzen 7 5700X',5,'X',5700,8.8,12900,'ryzen7-5700X.jpg',10),(71,'AMD','Ryzen 7 5800X',5,'X',5800,9.1,20999,'ryzen7-5800X.jpg',7),(72,'AMD','Ryzen 7 5800X3D',5,'X3D',5800,9.4,34000,'ryzen7-5800X3D.jpg',4),(73,'AMD','Ryzen 7 5700G',5,'G',5700,9,16700,'ryzen7-5700G.jpg',8),(74,'AMD','Ryzen 7 7700',7,'H',7700,9,26000,'ryzen7-7700.jpg',8),(75,'AMD','Ryzen 7 7700X',7,'X',7700,9.3,29000,'ryzen7-7700X.jpg',6),(76,'AMD','Ryzen 7 7800X3D',7,'X3D',7800,9.7,37990,'ryzen7-7800X3D.jpg',5),(77,'AMD','Ryzen 7 8700G',8,'G',8700,9.2,25095,'ryzen7-8700G.jpg',5),(78,'AMD','Ryzen 9 5900X',5,'H',5900,9.3,52500,'ryzen9-5900X.jpg',6),(79,'AMD','Ryzen 9 7900X',7,'X',7900,9.5,42600,'ryzen9-7900X.jpg',5),(80,'AMD','Ryzen 9 7950X',7,'X',7950,9.7,50900,'ryzen9-7950X.jpg',4),(81,'AMD','Ryzen 9 7900X3D',7,'X3D',7900,9.8,51000,'ryzen9-7900X3D.jpg',3),(82,'AMD','Ryzen 9 7950X3D',7,'X3D',7950,9.9,61000,'ryzen9-7950X3D.jpg',2),(83,'AMD','Ryzen 9 9950X',9,'X',9950,10,36000,'ryzen9-9950X.jpg',3),(84,'AMD','Ryzen 9 9900X',9,'X',9900,9.9,35000,'ryzen9-9900X.jpg',3);
/*!40000 ALTER TABLE `cpu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direct_buy`
--

DROP TABLE IF EXISTS `direct_buy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `direct_buy` (
  `order_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `cpu_id` int DEFAULT NULL,
  `gpu_id` int DEFAULT NULL,
  `ram_id` int DEFAULT NULL,
  `storage_id` int DEFAULT NULL,
  `price` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  KEY `cpu_id` (`cpu_id`),
  KEY `gpu_id` (`gpu_id`),
  KEY `ram_id` (`ram_id`),
  KEY `storage_id` (`storage_id`),
  CONSTRAINT `direct_buy_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `direct_buy_ibfk_2` FOREIGN KEY (`cpu_id`) REFERENCES `cpu` (`cpu_id`) ON DELETE SET NULL,
  CONSTRAINT `direct_buy_ibfk_3` FOREIGN KEY (`gpu_id`) REFERENCES `gpu` (`gpu_id`) ON DELETE SET NULL,
  CONSTRAINT `direct_buy_ibfk_4` FOREIGN KEY (`ram_id`) REFERENCES `ram` (`ram_id`) ON DELETE SET NULL,
  CONSTRAINT `direct_buy_ibfk_5` FOREIGN KEY (`storage_id`) REFERENCES `storage_unit` (`storage_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direct_buy`
--

LOCK TABLES `direct_buy` WRITE;
/*!40000 ALTER TABLE `direct_buy` DISABLE KEYS */;
/*!40000 ALTER TABLE `direct_buy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gpu`
--

DROP TABLE IF EXISTS `gpu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gpu` (
  `gpu_id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `chipset` varchar(255) DEFAULT NULL,
  `memory` int DEFAULT NULL,
  `performance_rating` float DEFAULT NULL,
  `price` int DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`gpu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gpu`
--

LOCK TABLES `gpu` WRITE;
/*!40000 ALTER TABLE `gpu` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `motherboard`
--

DROP TABLE IF EXISTS `motherboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `motherboard` (
  `motherboard_id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `chipset` varchar(255) DEFAULT NULL,
  `form_factor` varchar(255) DEFAULT NULL,
  `socket_type` varchar(255) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`motherboard_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `motherboard`
--

LOCK TABLES `motherboard` WRITE;
/*!40000 ALTER TABLE `motherboard` DISABLE KEYS */;
/*!40000 ALTER TABLE `motherboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `cart_id` bigint NOT NULL,
  `total_price` int NOT NULL,
  `shipping_address` text NOT NULL,
  `status` varchar(50) DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  KEY `cart_id` (`cart_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders1`
--

DROP TABLE IF EXISTS `orders1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders1` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `product_id` varchar(255) NOT NULL,
  `quantity` int DEFAULT '1',
  `status` enum('Pending','Processing','Shipped','Delivered') DEFAULT 'Pending',
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders1`
--

LOCK TABLES `orders1` WRITE;
/*!40000 ALTER TABLE `orders1` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pc_builds`
--

DROP TABLE IF EXISTS `pc_builds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pc_builds` (
  `build_id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `cpu_id` int DEFAULT NULL,
  `gpu_id` int DEFAULT NULL,
  `motherboard_id` int NOT NULL,
  `cooler_id` int DEFAULT NULL,
  `storage_id` int DEFAULT NULL,
  `ram_id` int DEFAULT NULL,
  `psu_id` int DEFAULT NULL,
  `case_id` int NOT NULL,
  `total_price` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`build_id`),
  KEY `fk_build_user` (`user_id`),
  KEY `fk_build_cpu` (`cpu_id`),
  KEY `fk_build_gpu` (`gpu_id`),
  KEY `fk_build_motherboard` (`motherboard_id`),
  KEY `fk_build_cooler` (`cooler_id`),
  KEY `fk_build_storage` (`storage_id`),
  KEY `fk_build_ram` (`ram_id`),
  KEY `fk_build_psu` (`psu_id`),
  KEY `fk_build_case` (`case_id`),
  CONSTRAINT `fk_build_case` FOREIGN KEY (`case_id`) REFERENCES `computer_case` (`case_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_build_cooler` FOREIGN KEY (`cooler_id`) REFERENCES `cooler` (`cooler_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_build_cpu` FOREIGN KEY (`cpu_id`) REFERENCES `cpu` (`cpu_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_build_gpu` FOREIGN KEY (`gpu_id`) REFERENCES `gpu` (`gpu_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_build_motherboard` FOREIGN KEY (`motherboard_id`) REFERENCES `motherboard` (`motherboard_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_build_psu` FOREIGN KEY (`psu_id`) REFERENCES `power_supply` (`psu_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_build_ram` FOREIGN KEY (`ram_id`) REFERENCES `ram` (`ram_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_build_storage` FOREIGN KEY (`storage_id`) REFERENCES `storage_unit` (`storage_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_build_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pc_builds`
--

LOCK TABLES `pc_builds` WRITE;
/*!40000 ALTER TABLE `pc_builds` DISABLE KEYS */;
/*!40000 ALTER TABLE `pc_builds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `power_supply`
--

DROP TABLE IF EXISTS `power_supply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `power_supply` (
  `psu_id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `wattage` int DEFAULT NULL,
  `efficiency_rating` varchar(50) DEFAULT NULL,
  `modular` tinyint(1) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`psu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `power_supply`
--

LOCK TABLES `power_supply` WRITE;
/*!40000 ALTER TABLE `power_supply` DISABLE KEYS */;
/*!40000 ALTER TABLE `power_supply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prebuilt_pcs`
--

DROP TABLE IF EXISTS `prebuilt_pcs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prebuilt_pcs` (
  `prebuilt_id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `cpu_id` int DEFAULT NULL,
  `gpu_id` int DEFAULT NULL,
  `motherboard_id` int DEFAULT NULL,
  `cooler_id` int DEFAULT NULL,
  `storage_id` int DEFAULT NULL,
  `ram_id` int DEFAULT NULL,
  `psu_id` int DEFAULT NULL,
  `case_id` int DEFAULT NULL,
  `price` int NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`prebuilt_id`),
  KEY `cpu_id` (`cpu_id`),
  KEY `gpu_id` (`gpu_id`),
  KEY `motherboard_id` (`motherboard_id`),
  KEY `cooler_id` (`cooler_id`),
  KEY `storage_id` (`storage_id`),
  KEY `ram_id` (`ram_id`),
  KEY `psu_id` (`psu_id`),
  KEY `case_id` (`case_id`),
  CONSTRAINT `prebuilt_pcs_ibfk_1` FOREIGN KEY (`cpu_id`) REFERENCES `cpu` (`cpu_id`),
  CONSTRAINT `prebuilt_pcs_ibfk_2` FOREIGN KEY (`gpu_id`) REFERENCES `gpu` (`gpu_id`),
  CONSTRAINT `prebuilt_pcs_ibfk_3` FOREIGN KEY (`motherboard_id`) REFERENCES `motherboard` (`motherboard_id`),
  CONSTRAINT `prebuilt_pcs_ibfk_4` FOREIGN KEY (`cooler_id`) REFERENCES `cooler` (`cooler_id`),
  CONSTRAINT `prebuilt_pcs_ibfk_5` FOREIGN KEY (`storage_id`) REFERENCES `storage_unit` (`storage_id`),
  CONSTRAINT `prebuilt_pcs_ibfk_6` FOREIGN KEY (`ram_id`) REFERENCES `ram` (`ram_id`),
  CONSTRAINT `prebuilt_pcs_ibfk_7` FOREIGN KEY (`psu_id`) REFERENCES `power_supply` (`psu_id`),
  CONSTRAINT `prebuilt_pcs_ibfk_8` FOREIGN KEY (`case_id`) REFERENCES `computer_case` (`case_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prebuilt_pcs`
--

LOCK TABLES `prebuilt_pcs` WRITE;
/*!40000 ALTER TABLE `prebuilt_pcs` DISABLE KEYS */;
/*!40000 ALTER TABLE `prebuilt_pcs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ram`
--

DROP TABLE IF EXISTS `ram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ram` (
  `ram_id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `speed` int DEFAULT NULL,
  `performance_rating` float DEFAULT NULL,
  `price` int DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`ram_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ram`
--

LOCK TABLES `ram` WRITE;
/*!40000 ALTER TABLE `ram` DISABLE KEYS */;
/*!40000 ALTER TABLE `ram` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saved_builds`
--

DROP TABLE IF EXISTS `saved_builds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saved_builds` (
  `saved_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `build_id` int NOT NULL,
  `saved_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`saved_id`),
  KEY `user_id` (`user_id`),
  KEY `build_id` (`build_id`),
  CONSTRAINT `saved_builds_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `saved_builds_ibfk_2` FOREIGN KEY (`build_id`) REFERENCES `pc_builds` (`build_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saved_builds`
--

LOCK TABLES `saved_builds` WRITE;
/*!40000 ALTER TABLE `saved_builds` DISABLE KEYS */;
/*!40000 ALTER TABLE `saved_builds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saved_pc`
--

DROP TABLE IF EXISTS `saved_pc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saved_pc` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `product_id` varchar(255) NOT NULL,
  `address` text,
  `price` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saved_pc`
--

LOCK TABLES `saved_pc` WRITE;
/*!40000 ALTER TABLE `saved_pc` DISABLE KEYS */;
/*!40000 ALTER TABLE `saved_pc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storage_unit`
--

DROP TABLE IF EXISTS `storage_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `storage_unit` (
  `storage_id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `interface` varchar(50) DEFAULT NULL,
  `read_speed` int DEFAULT NULL,
  `write_speed` int DEFAULT NULL,
  `price` int DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`storage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storage_unit`
--

LOCK TABLES `storage_unit` WRITE;
/*!40000 ALTER TABLE `storage_unit` DISABLE KEYS */;
/*!40000 ALTER TABLE `storage_unit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `try`
--

DROP TABLE IF EXISTS `try`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `try` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `per` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `try`
--

LOCK TABLES `try` WRITE;
/*!40000 ALTER TABLE `try` DISABLE KEYS */;
INSERT INTO `try` VALUES (1,'harsh',65.6),(2,'arya',65.6);
/*!40000 ALTER TABLE `try` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `date_` datetime DEFAULT CURRENT_TIMESTAMP,
  `otp` varchar(255) DEFAULT NULL,
  `otp_expiry` bigint DEFAULT NULL,
  `expiry` bigint DEFAULT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'USER',
  `profile_picture` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (33,'asp8460','aryapatel8460@gmail.com','$2a$10$Tk.JD8E1NRpUcPN3g0u3A.xJmlmGzr2gbTOYu08ZyiEKjH1yuj.kq','2025-11-11 08:52:40',NULL,NULL,1763781771887,'USER','/uploads/8942e46e-7fec-4e19-bc8c-17f41297fc38.jpg'),(34,'asp7202','aryapatel7202@gmail.com','$2a$10$cbTmL8aO8PqnAkmzDc3Xeu1oV//MIUmvYbrB8Velp9nH/hp1GQ8o.','2025-11-11 09:21:35',NULL,NULL,1764861138395,'USER',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-23 21:54:01
