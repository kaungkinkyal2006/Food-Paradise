-- MySQL dump 10.13  Distrib 9.4.0, for macos14.7 (arm64)
--
-- Host: localhost    Database: food_paradise
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `user_id` int NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (11,'321 Example Street, Yangon','0976543210'),(12,'No 470, 7st','12121212');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_categories`
--

DROP TABLE IF EXISTS `menu_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` enum('FOOD','DRINK') NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_categories`
--

LOCK TABLES `menu_categories` WRITE;
/*!40000 ALTER TABLE `menu_categories` DISABLE KEYS */;
INSERT INTO `menu_categories` VALUES (1,'FOOD','Myanmar Food'),(2,'FOOD','Thai Food'),(3,'FOOD','Chinese Food'),(4,'DRINK','Cafe'),(5,'DRINK','Fruit Juice & Yogurt'),(6,'DRINK','Bubble Tea & Smoothie');
/*!40000 ALTER TABLE `menu_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_items`
--

DROP TABLE IF EXISTS `menu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `name` varchar(120) NOT NULL,
  `price` decimal(8,2) NOT NULL DEFAULT '0.00',
  `img_url` varchar(300) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `menu_items_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `menu_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_items`
--

LOCK TABLES `menu_items` WRITE;
/*!40000 ALTER TABLE `menu_items` DISABLE KEYS */;
INSERT INTO `menu_items` VALUES (14,1,'ရှမ်းခေါက်ဆွဲ',5000.00,'uploads/1755968143497_1544440767-social.jpg',''),(15,1,'ရေစိမ်ခေါက်ဆွဲ',5000.00,'uploads/1755968446295_325.jpg',''),(16,1,'မုန့်ဟင်းခါး',3500.00,'uploads/1755968546473_A5A48E2A-5072-489B-B768-95EB2EAB65F3.webp',''),(17,1,'တို့ဟူးနွေး',4000.00,'uploads/1755968606949_tofu_nway9-450x337.jpg',''),(18,1,'နန်းကြီးသုပ်',4000.00,'uploads/1755968714203_hq720.jpg',''),(19,1,'မုန့်တီသုပ်',3000.00,'uploads/1755968851214_510277262_754280970501688_6305769738676910272_n.jpg',''),(20,1,'ဟင်းထုပ်',3000.00,'uploads/1755968912660_ဟင်း.jpg',''),(21,1,'ပဲပြားအစာသွပ်',3000.00,'uploads/1755969033641_ပဲပြား.jpg',''),(22,1,'သင်္ဘောသီးထောင်း',6000.00,'uploads/1755969147749_သဘော.jpg',''),(23,1,'မုယောထောင်း',4000.00,'uploads/1755969206248_မုယော.jpg',''),(24,1,'အပ်မှိုထောင်း',4500.00,'uploads/1755969280725_အပ်မှို.jpg',''),(25,1,'ပြောင်းဖူးထောင်း',5500.00,'uploads/1755969315678_ပြောင်းဖူး.jpg',''),(26,1,'ပင်လယ်စာထောင်း',10000.00,'uploads/1755969377159_ပင်လယ်.jpg',''),(27,1,'ရေဘဝဲထောင်း',6500.00,'uploads/1755969435705_ရေဘဝံ.jpg',''),(28,1,'ဂဏန်းထောင်း',8500.00,'uploads/1755969485381_ဂဏန်း.jpg',''),(29,1,'မုန့်တီထောင်း',4500.00,'uploads/1755969533377_မုန့်တီထောင်း.jpg',''),(30,1,'သရက်သီးထောင်း',3000.00,'uploads/1755969570408_သရက်သီး.jpg',''),(31,2,'ကွေ့တီယိုသုပ်',4000.00,'uploads/1755969633127_ကွေ့တီယို.jpg',''),(32,2,'ကွေ့တီယိုအရည်',4000.00,'uploads/1755969693297_ကွေ့တီယိုအရည်.jpg',''),(33,2,'ပင်လယ်စာထမင်းကြော်',9000.00,'uploads/1755969762112_ပင်လယ်ထမင်း.jpg',''),(34,2,'တုံယမ်းဟင်းချို',8000.00,'uploads/1755969816227_tom_yam_soupchickenprawn.jpg',''),(35,2,'ပသျှူးထမင်းကြော်',7000.00,'uploads/1755969856213_ပသျှုး.jpeg',''),(36,2,'သီးစုံထမင်းကြော်',5000.00,'uploads/1755969922061_သီးစုံ.jpg',''),(37,2,'ဆန်ပြားကြော်',4000.00,'uploads/1755969958477_ဆန်ပြား.jpg',''),(38,2,'ငါးသံပုရာပေါင်း',7000.00,'uploads/1755970001342_ငါးသံပုရာ.jpg',''),(39,2,'ငါးချိုချဉ်ကြော်',8000.00,'uploads/1755970043776_ငါးချိုချဉ်.jpg',''),(40,2,'ခေါက်ဆင့်ပလာတူး',12000.00,'uploads/1755970093757_ခေါက်ဆင့်.jpg',''),(41,3,'မာလာမောက်ချိုက်',5500.00,'uploads/1755970146021_မာလာမောက်ချိုက်.jpg',''),(42,3,'မာလာရှမ်းကော',6000.00,'uploads/1755970214435_မာလာရှမ်းကော.jpg',''),(43,3,'မာလာဟင်း',7000.00,'uploads/1755970256862_မာလာဟင်း.jpg',''),(44,3,'မာလာငါးကင်',8000.00,'uploads/1755970294610_မာလာငါးကင်.webp',''),(45,3,'မြေအိုးမီးရှည်',13000.00,'uploads/1755970347125_မြေအိုး.jpg',''),(46,3,'ကုန်းဘောင်ကြီးကြော်',4000.00,'uploads/1755970382624_ကုန်းဘောင်.jpg',''),(47,3,'ဖက်ထုပ်(အရည်)',6000.00,'uploads/1755970420058_ဖက်ထုပ်.jpg',''),(48,3,'ဖက်ထုပ်ကြော်',6000.00,'uploads/1755970462042_ဖက်ထုပ်ကြော်.jpg',''),(49,3,'ဖက်ထုပ်အိုးကပ်',6500.00,'uploads/1755970510361_ဖက်ထုတ်အိုးကပ်.jpg',''),(50,3,'Hot Pot',25000.00,'uploads/1755970663870_hot pot.jpg',''),(51,4,'Expresso(Cold)',5000.00,'uploads/1755970734446_exprssocold.webp',''),(52,4,'Expresso(Hot)',5000.00,'uploads/1755970770311_expressohot.jpeg',''),(53,4,'Cappuccino(Hot)',7000.00,'uploads/1755970937670_cappuncinocold.jpg',''),(54,4,'Cappuccino(Hot)',8000.00,'uploads/1755970981416_Cappuccinohot.webp',''),(55,4,'Doppio(Cold)',7500.00,'uploads/1755971033683_doppiocold.webp',''),(56,4,'Doppio(Hot)',7000.00,'uploads/1755971076996_doppiohot.jpg',''),(57,4,'Americano(Cold)',8000.00,'uploads/1755971125361_ameracanocold.jpg',''),(58,4,'Americano(Hot)',8000.00,'uploads/1755971159279_ameracanohot.jpeg',''),(59,4,'Vanilla Latte(Cold)',9000.00,'uploads/1755971214546_vanilla latte cold.jpg',''),(60,4,'Vanilla Latte(Hot)',8000.00,'uploads/1755971255427_vanillahot.jpg',''),(61,5,'သံပုရာဖျော်ရည်',3500.00,'uploads/1755971320218_သံပုရာ.jpg',''),(62,5,'နဂါးမောက်သီးဖျော်ရည်',5000.00,'uploads/1755971370978_နဂါးမောက်သီး.webp',''),(63,5,'ထောပတ်သီးဖျော်ရည်',6000.00,'uploads/1755971414697_ထောပတ်သီး.jpg',''),(64,5,'စတော်ဘယ်ရီဖျော်ရည်',4000.00,'uploads/1755971454791_စတော်ဘယ်ရီ.jpg',''),(65,5,'ပန်းသီးဖျော်ရည်',3500.00,'uploads/1755971497808_ပန်းသီး.png',''),(66,5,'နာနတ်သီးဖျော်ရည်',3500.00,'uploads/1755971546963_နာနတ်သီး.jpeg',''),(67,5,'သရက်သီးဖျော်ရည်',4000.00,'uploads/1755971591967_သရက်သီးဖျော်ရည်.jpg',''),(68,5,'သီးစုံဒိန်ချဉ်',6500.00,'uploads/1755971641929_သီးစုံဒိန်ချဉ်.jpg',''),(69,5,'ငှက်ပျောဒိန်ချဉ်',4000.00,'uploads/1755971694177_ငှက်ပျော.jpg',''),(70,5,'စတော်ဘယ်ရီဒိန်ချဉ်',5000.00,'uploads/1755971747966_စတော်ဘယ်ရီဒိန်ချဉ်.webp',''),(71,6,'Butterfly blue boba tea',6000.00,'uploads/1755971803079_butterfly.webp',''),(72,6,'Purple sweet potato milk tea',7000.00,'uploads/1755971848782_purple.jpg',''),(73,6,'Taiwan milk tea with bubble',5000.00,'uploads/1755971894295_taiwan.webp',''),(74,6,'Coffee milk bubble tea',6500.00,'uploads/1755971956130_coffeemilk.jpeg',''),(75,6,'Matcha strawberry boba',7000.00,'uploads/1755972005665_matcha.webp',''),(76,6,'Oreo match latte',6000.00,'uploads/1755972036079_oreo.jpeg',''),(77,6,'Thai tea',4500.00,'uploads/1755972070014_thaitesa.webp',''),(78,6,'Green tea latte with bubble',5500.00,'uploads/1755972112579_greentea.jpg',''),(79,6,'Strawberry smoothie',5500.00,'uploads/1755972156228_strawsmoothie.jpeg',''),(80,6,'Blueberry smoothie',6000.00,'uploads/1755972191280_blueberry smoothie.webp',''),(81,6,'Dragon fruit smoothie',7500.00,'uploads/1755972239166_dragonfruit smoothe.jpeg',''),(82,6,'Avocado smoothie',8500.00,'uploads/1755972277114_avocado smoothie.jpg','');
/*!40000 ALTER TABLE `menu_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `item_id` int NOT NULL,
  `qty` int NOT NULL DEFAULT '1',
  `price` decimal(8,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `fk_item` (`item_id`),
  CONSTRAINT `fk_item` FOREIGN KEY (`item_id`) REFERENCES `menu_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `menu_items` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (25,20,15,3,5000.00),(26,21,15,2,5000.00),(27,22,15,1,5000.00),(28,22,16,2,3500.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` enum('PENDING','PAID','PREPARING','DELIVERING','DONE','CANCELLED','ARRIVED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,11,7.50,'PENDING','2025-08-23 03:45:08'),(2,11,27.50,'ARRIVED','2025-08-23 03:47:41'),(3,12,10.00,'ARRIVED','2025-08-23 04:19:50'),(4,12,17.00,'ARRIVED','2025-08-23 04:21:33'),(5,11,15.00,'PENDING','2025-08-23 04:23:42'),(6,11,5.00,'PENDING','2025-08-23 04:36:23'),(7,11,2.50,'PENDING','2025-08-23 04:36:59'),(8,11,2.50,'PENDING','2025-08-23 04:38:48'),(9,11,5.00,'PENDING','2025-08-23 04:45:14'),(10,12,2.40,'ARRIVED','2025-08-23 06:44:07'),(11,12,2.40,'ARRIVED','2025-08-23 06:44:25'),(12,12,11.00,'ARRIVED','2025-08-23 06:44:46'),(13,12,11.00,'ARRIVED','2025-08-23 06:44:58'),(14,12,2.40,'ARRIVED','2025-08-23 06:57:53'),(15,12,2.40,'PENDING','2025-08-23 07:06:03'),(16,12,4.60,'PENDING','2025-08-23 07:06:15'),(17,12,3.50,'PENDING','2025-08-23 07:06:29'),(18,12,4.60,'PENDING','2025-08-23 07:13:55'),(19,12,9.20,'ARRIVED','2025-08-23 16:48:27'),(20,12,15000.00,'PENDING','2025-08-23 18:13:47'),(21,12,9000.00,'PENDING','2025-12-10 18:14:30'),(22,12,12000.00,'ARRIVED','2025-08-23 18:18:14');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` enum('ADMIN','USER') NOT NULL DEFAULT 'USER',
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(200) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (10,'ADMIN','Admin Three','admin3@foodparadise.com','admin345','2025-08-21 15:45:50'),(11,'USER','Bob Johnson','bob@example.com','bob123','2025-08-21 16:03:21'),(12,'USER','testCustomer','testcus@gmail.com','123','2025-08-23 03:16:51');
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

-- Dump completed on 2025-08-24 22:27:17
