

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

DROP TABLE IF EXISTS `sh_address`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `sh_address` (

  `id` bigint NOT NULL AUTO_INCREMENT,

  `consignee_name` varchar(32) NOT NULL,

  `consignee_phone` varchar(16) NOT NULL,

  `province_name` varchar(32) NOT NULL,

  `city_name` varchar(32) NOT NULL,

  `region_name` varchar(32) NOT NULL,

  `detail_address` varchar(64) NOT NULL,

  `default_flag` tinyint NOT NULL,

  `user_id` bigint NOT NULL,

  PRIMARY KEY (`id`),

  KEY `user_id_index` (`user_id`)

) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET character_set_client = @saved_cs_client */;



LOCK TABLES `sh_address` WRITE;

/*!40000 ALTER TABLE `sh_address` DISABLE KEYS */;

INSERT INTO `sh_address` VALUES (20,'Emily Carter','17322611234','Bei Jing Shi','Shi Xia Qu','Chao Yang Qu','Jiu Xian Qiao Bei Lu 12 Hao 3-702',0,1),(21,'Emily Carter','17322610001','Bei Jing Shi','Shi Xia Qu','Hai Dian Qu','Zhong Guan Cun Da Jie 88 Hao A-1605',1,1),(22,'Emily Carter','17322612356','Bei Jing Shi','Shi Xia Qu','Xi Cheng Qu','De Sheng Men Wai Da Jie 18 Hao 2-301',0,1),(23,'Emily Carter','17322614567','Bei Jing Shi','Shi Xia Qu','Tong Zhou Qu','Li Yuan Zhong Lu 66 Hao 5-1002',0,1);/*!40000 ALTER TABLE `sh_address` ENABLE KEYS */;

UNLOCK TABLES;

DROP TABLE IF EXISTS `sh_admin`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `sh_admin` (

  `id` bigint NOT NULL AUTO_INCREMENT,

  `account_number` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,

  `admin_password` varchar(16) NOT NULL,

  `admin_name` varchar(8) NOT NULL,

  PRIMARY KEY (`id`),

  UNIQUE KEY `account_number` (`account_number`)

) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET character_set_client = @saved_cs_client */;



LOCK TABLES `sh_admin` WRITE;

/*!40000 ALTER TABLE `sh_admin` DISABLE KEYS */;

INSERT INTO `sh_admin` VALUES (1,'root','123456','Mia'),(3,'ops01','123456','Noah'),(5,'ops02','123456','Ivy');/*!40000 ALTER TABLE `sh_admin` ENABLE KEYS */;

UNLOCK TABLES;

DROP TABLE IF EXISTS `sh_favorite`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `sh_favorite` (

  `id` bigint NOT NULL AUTO_INCREMENT,

  `create_time` datetime NOT NULL,

  `user_id` bigint NOT NULL,

  `idle_id` bigint NOT NULL,

  PRIMARY KEY (`id`),

  UNIQUE KEY `user_id` (`user_id`,`idle_id`)

) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET character_set_client = @saved_cs_client */;



LOCK TABLES `sh_favorite` WRITE;

/*!40000 ALTER TABLE `sh_favorite` DISABLE KEYS */;

INSERT INTO `sh_favorite` VALUES (32,'2026-04-12 10:28:00',1,17),(33,'2026-04-12 10:29:11',1,25),(34,'2026-04-12 11:28:51',1,29),(38,'2026-04-12 12:34:03',1,33),(39,'2026-04-12 12:42:19',1,31),(40,'2026-04-12 13:04:27',1,36),(41,'2026-04-12 13:26:18',1,44),(42,'2026-04-12 13:42:55',1,46),(43,'2026-04-12 14:11:09',1,53),(44,'2026-04-12 14:38:27',1,55),(45,'2026-04-12 15:05:41',1,57),(46,'2026-04-12 15:28:09',1,60),(47,'2026-04-12 15:59:18',1,67),(48,'2026-04-12 16:22:47',1,72),(49,'2026-04-13 10:02:11',1,76),(50,'2026-04-13 10:28:09',1,80),(51,'2026-04-13 10:46:55',1,83),(52,'2026-04-13 11:14:20',1,84),(53,'2026-04-13 11:39:37',1,88),(54,'2026-04-13 12:05:49',1,89);/*!40000 ALTER TABLE `sh_favorite` ENABLE KEYS */;

UNLOCK TABLES;

DROP TABLE IF EXISTS `sh_idle_item`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `sh_idle_item` (

  `id` bigint NOT NULL AUTO_INCREMENT,

  `idle_name` varchar(64) NOT NULL,

  `idle_details` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,

  `picture_list` varchar(1024) NOT NULL,

  `idle_price` decimal(10,2) NOT NULL,

  `idle_place` varchar(32) NOT NULL,

  `idle_label` int NOT NULL,

  `release_time` datetime NOT NULL,

  `idle_status` tinyint NOT NULL,

  `user_id` bigint NOT NULL,

  PRIMARY KEY (`id`),

  KEY `user_id_index` (`user_id`)

) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET character_set_client = @saved_cs_client */;



LOCK TABLES `sh_idle_item` WRITE;

/*!40000 ALTER TABLE `sh_idle_item` DISABLE KEYS */;

INSERT INTO `sh_idle_item` VALUES (16,'Apple iPhone 13 128GB','Midnight finish. Battery health is still strong for a full day and the frame is clean. Includes original box, charging cable, and a clear case.','["http://127.0.0.1:8080/image?imageName=item_16_hero.png", "http://127.0.0.1:8080/image?imageName=item_16_detail.png"]',3899.00,'Hai Dian Qu',1,'2026-04-08 19:01:01',1,26),(17,'Sony WH-1000XM4 Headphones','Used mainly at home and always stored in the hard case. Ear pads are clean, hinge is solid, and noise canceling works perfectly. Includes pouch and 3.5 mm cable.','["http://127.0.0.1:8080/image?imageName=item_17_hero.png", "http://127.0.0.1:8080/image?imageName=item_17_detail.png"]',179.00,'Chao Yang Qu',1,'2026-04-08 20:03:48',1,26),(18,'Nintendo Switch OLED Console','White Joy-Con edition with bright screen and no dead pixels. Dock, straps, HDMI cable, and charger are all included. Great for couch co-op and travel.','["http://127.0.0.1:8080/image?imageName=item_18_hero.png", "http://127.0.0.1:8080/image?imageName=item_18_detail.png"]',229.00,'Xu Hui Qu',1,'2026-04-09 09:06:56',1,27),(19,'Dyson V8 Slim Vacuum','Works well on hardwood and low-pile rugs. Battery lasts about 25 minutes on standard mode. Comes with wall dock, crevice tool, and soft brush.','["http://127.0.0.1:8080/image?imageName=item_19_hero.png", "http://127.0.0.1:8080/image?imageName=item_19_detail.png"]',168.00,'Pu Dong Xin Qu',2,'2026-04-09 10:10:57',1,24),(20,'Midea 1.7L Electric Kettle','Simple stainless model with fast boil and auto shut-off. Interior is clean and the lid spring still opens smoothly. Good backup kettle for office or dorm use.','["http://127.0.0.1:8080/image?imageName=item_20_hero.png", "http://127.0.0.1:8080/image?imageName=item_20_detail.png"]',39.00,'Chang Ping Qu',2,'2026-04-09 13:13:08',1,24),(21,'The Design of Everyday Things','Hardcover copy with a crisp jacket and only light shelf wear. Pages are clean with no notes or highlights. Ideal if you want a thoughtful design classic for your desk.','["http://127.0.0.1:8080/image?imageName=item_21_hero.png", "http://127.0.0.1:8080/image?imageName=item_21_detail.png"]',18.50,'Xi Cheng Qu',4,'2026-04-09 14:15:05',1,23),(22,'Logitech MX Mechanical Keyboard','Tactile quiet switch version. Keys are clean, backlight is even, and Bluetooth still pairs quickly with both Windows and macOS. Includes receiver and USB-C cable.','["http://127.0.0.1:8080/image?imageName=item_22_hero.png", "http://127.0.0.1:8080/image?imageName=item_22_detail.png"]',119.00,'Pu Dong Xin Qu',1,'2026-04-09 15:48:22',1,24),(23,'Apple iPad Air 5 64GB','Blue finish with a clean display and no major dents. Perfect for notes, Netflix, and travel editing. Includes folio case and the original charging cable.','["http://127.0.0.1:8080/image?imageName=item_23_hero.png", "http://127.0.0.1:8080/image?imageName=item_23_detail.png"]',539.00,'Hai Dian Qu',1,'2026-04-10 08:50:49',1,1),(24,'Fujifilm Instax Mini Evo','Great condition instant camera with retro controls and fun film looks. Lens cover opens smoothly and the battery still holds a charge. Includes strap and charging cable.','["http://127.0.0.1:8080/image?imageName=item_24_hero.png", "http://127.0.0.1:8080/image?imageName=item_24_detail.png"]',198.00,'Nan Shan Qu',1,'2026-04-10 10:55:39',1,26),(25,'Decathlon 45L Hiking Backpack','Used on a few weekend hikes and kept dry between trips. Hip belt, rain cover, and chest strap are all intact. Plenty of room for a two-day summer trip.','["http://127.0.0.1:8080/image?imageName=item_25_hero.png", "http://127.0.0.1:8080/image?imageName=item_25_detail.png"]',68.00,'Long Gang Qu',3,'2026-04-10 11:59:34',1,29),(26,'Coleman Two-Person Camping Tent','No broken poles and the rainfly still seals well. Best for spring through early autumn camping. Includes stakes, guylines, and original carry bag.','["http://127.0.0.1:8080/image?imageName=item_26_hero.png", "http://127.0.0.1:8080/image?imageName=item_26_detail.png"]',96.00,'Shun Yi Qu',3,'2026-04-10 12:02:18',1,29),(27,'Muji Walnut Side Table','Compact bedside table in walnut tone with a clean top surface and sturdy legs. Fits well next to a sofa or reading chair. Easy pickup because it is already assembled.','["http://127.0.0.1:8080/image?imageName=item_27_hero.png", "http://127.0.0.1:8080/image?imageName=item_27_detail.png"]',189.00,'Chao Yang Qu',5,'2026-04-10 13:04:39',1,23),(28,'Mid-century Floor Lamp','Warm linen shade with a slim black stem and brass accent. Works well in a reading corner, but the shade has one small crease. Currently kept offline after moving furniture around.','["http://127.0.0.1:8080/image?imageName=item_28_hero.png", "http://127.0.0.1:8080/image?imageName=item_28_detail.png"]',84.00,'Xu Hui Qu',5,'2026-04-10 14:07:28',2,24),(29,'Atomic Habits Hardcover','Very tidy copy with sharp corners and no highlighting. Nice desk book if you want an easy motivational read that still looks presentable on a shelf.','["http://127.0.0.1:8080/image?imageName=item_29_hero.png", "http://127.0.0.1:8080/image?imageName=item_29_detail.png"]',24.00,'Shi Jing Shan Qu',4,'2026-04-11 09:33:11',1,26),(30,'Dune Deluxe Edition','Hardcover with foil title and clean pages. Jacket has a light rub on one corner, but it still presents beautifully. Great copy for science fiction collectors.','["http://127.0.0.1:8080/image?imageName=item_30_hero.png", "http://127.0.0.1:8080/image?imageName=item_30_detail.png"]',32.00,'Min Hang Qu',4,'2026-04-11 10:34:05',1,27),(31,'Canon EOS M50 Mark II','Body and kit lens are both in very good condition. Flip screen, autofocus, and card slot all work normally. Includes battery, charger, strap, and a 32GB SD card.','["http://127.0.0.1:8080/image?imageName=item_31_hero.png", "http://127.0.0.1:8080/image?imageName=item_31_detail.png"]',615.00,'Hai Dian Qu',1,'2026-04-11 11:38:16',1,1),(32,'Trek Marlin 6 Mountain Bike','Medium frame with recently replaced chain and brake pads. Good option for city rides and light trail weekends. Pickup recommended because shipping would be expensive.','["http://127.0.0.1:8080/image?imageName=item_32_hero.png", "http://127.0.0.1:8080/image?imageName=item_32_detail.png"]',720.00,'Bao An Qu',3,'2026-04-11 12:45:22',1,28),(33,'Yamaha Acoustic Guitar F310','Classic beginner-friendly acoustic with a warm sound and a comfortable neck. A few light pick marks near the sound hole. Includes gig bag and spare strings.','["http://127.0.0.1:8080/image?imageName=item_33_hero.png", "http://127.0.0.1:8080/image?imageName=item_33_detail.png"]',145.00,'Gu Lou Qu',5,'2026-04-11 13:46:54',1,31),(34,'Philips Air Fryer 4.1L','Basket is clean and the controls still click firmly. Great for quick dinners, but I upgraded to a larger model. Temporarily hidden while I decide whether to relist it.','["http://127.0.0.1:8080/image?imageName=item_34_hero.png", "http://127.0.0.1:8080/image?imageName=item_34_detail.png"]',92.00,'Tong Zhou Qu',2,'2026-04-11 14:50:45',2,23),(35,'Dell 27-inch USB-C Monitor','Sharp 1440p panel with one-cable laptop charging. Stand is sturdy, and the ports are all working. Marked offline because I may keep it as a second display.','["http://127.0.0.1:8080/image?imageName=item_35_hero.png", "http://127.0.0.1:8080/image?imageName=item_35_detail.png"]',249.00,'Hai Dian Qu',1,'2026-04-11 15:52:46',2,1),(36,'Yeti Hopper Soft Cooler','Holds ice surprisingly well for day trips and beach afternoons. Zipper works smoothly and the shell has no tears. Includes shoulder strap and bottle opener clip.','["http://127.0.0.1:8080/image?imageName=item_36_hero.png", "http://127.0.0.1:8080/image?imageName=item_36_detail.png"]',129.00,'Shun Yi Qu',3,'2026-04-11 16:55:09',1,29),(39,'Samsung Galaxy Watch 6 Classic','Bluetooth version with rotating bezel, two straps, and original charger. Battery still lasts a full day with notifications and sleep tracking. Minor wear on the clasp only.','["http://127.0.0.1:8080/image?imageName=item_39_hero.png", "http://127.0.0.1:8080/image?imageName=item_39_detail.png"]',185.00,'Xi Cheng Qu',1,'2026-04-12 09:10:14',1,1),(40,'Kindle Paperwhite Signature Edition','Latest generation Kindle with warm light and wireless charging. The screen is clean, battery is excellent, and the back only has light desk wear. Includes a charcoal fabric case.','["http://127.0.0.1:8080/image?imageName=item_40_hero.png", "http://127.0.0.1:8080/image?imageName=item_40_detail.png"]',135.00,'Hai Dian Qu',1,'2026-04-12 10:18:12',1,23),(41,'Marshall Acton III Bluetooth Speaker','Compact speaker with strong bass and a clean cream finish. Kept on a media shelf with no outdoor use. Includes power cable and original carton.','["http://127.0.0.1:8080/image?imageName=item_41_hero.png", "http://127.0.0.1:8080/image?imageName=item_41_detail.png"]',188.00,'Chao Yang Qu',1,'2026-04-12 10:40:33',1,26),(42,'AeroPress Coffee Maker Kit','Complete travel coffee kit with AeroPress, scoop, stirrer, paper filters, and a stainless mug. Perfect if you want a compact brew setup for office or short trips.','["http://127.0.0.1:8080/image?imageName=item_42_hero.png", "http://127.0.0.1:8080/image?imageName=item_42_detail.png"]',32.00,'Xu Hui Qu',5,'2026-04-12 11:08:25',1,24),(43,'IKEA Poang Lounge Chair','Birch frame with dark grey cushion. Still comfortable and stable, but I do not have room after moving. Kept offline while deciding whether to relist or donate.','["http://127.0.0.1:8080/image?imageName=item_43_hero.png", "http://127.0.0.1:8080/image?imageName=item_43_detail.png"]',95.00,'Tong Zhou Qu',5,'2026-04-12 11:32:18',2,23),(44,'GoPro HERO 11 Black','Action camera with one original battery, extra enduro battery, shorty grip, and 64GB card. Lens cover is clear and stabilization works perfectly.','["http://127.0.0.1:8080/image?imageName=item_44_hero.png", "http://127.0.0.1:8080/image?imageName=item_44_detail.png"]',269.00,'Long Gang Qu',1,'2026-04-12 12:01:44',1,28),(45,'Anker 737 Power Bank 24000mAh','Fast charging power bank with bright status screen and clean shell. Great for laptop + phone travel days. Includes braided USB-C cable and carrying pouch.','["http://127.0.0.1:8080/image?imageName=item_45_hero.png", "http://127.0.0.1:8080/image?imageName=item_45_detail.png"]',89.00,'Hai Dian Qu',1,'2026-04-12 12:29:58',1,1),(46,'Bose SoundLink Flex Speaker','Portable waterproof speaker with surprisingly full sound for its size. Mostly used indoors and charged carefully. Includes USB-C cable.','["http://127.0.0.1:8080/image?imageName=item_46_hero.png", "http://127.0.0.1:8080/image?imageName=item_46_detail.png"]',109.00,'Pu Dong Xin Qu',1,'2026-04-12 13:06:10',1,26),(47,'Patagonia Nano Puff Jacket','Men size M in black. Lightweight, warm, and easy to pack. No tears, zipper works smoothly, and insulation is still lofted.','["http://127.0.0.1:8080/image?imageName=item_47_hero.png", "http://127.0.0.1:8080/image?imageName=item_47_detail.png"]',120.00,'Xi Cheng Qu',3,'2026-04-12 13:30:22',1,27),(48,'Decathlon Folding Camping Chair','Simple folding chair with cup holder and stable frame. Good for camping, fishing, or a balcony setup. Stored dry after use.','["http://127.0.0.1:8080/image?imageName=item_48_hero.png", "http://127.0.0.1:8080/image?imageName=item_48_detail.png"]',26.00,'Shun Yi Qu',3,'2026-04-12 14:02:54',1,29),(49,'Nespresso Essenza Mini','Small espresso machine with quick heat-up and consistent shots. Descaled recently and kept in a smoke-free home. Includes a box of mixed capsules.','["http://127.0.0.1:8080/image?imageName=item_49_hero.png", "http://127.0.0.1:8080/image?imageName=item_49_detail.png"]',88.00,'Nan Shan Qu',2,'2026-04-12 14:35:17',1,24),(50,'Xiaomi Smart Projector 2','Compact projector that works well for bedroom movie nights. Focus and keystone are working normally, and the body is clean. Includes remote and power brick.','["http://127.0.0.1:8080/image?imageName=item_50_hero.png", "http://127.0.0.1:8080/image?imageName=item_50_detail.png"]',339.00,'Hai Dian Qu',1,'2026-04-12 15:05:49',1,1),(51,'Blueair Air Purifier 3410','Quiet bedroom air purifier with recently replaced filter. Body is clean and app pairing still works. Currently offline because I may keep it for allergy season.','["http://127.0.0.1:8080/image?imageName=item_51_hero.png", "http://127.0.0.1:8080/image?imageName=item_51_detail.png"]',118.00,'Chao Yang Qu',2,'2026-04-12 15:31:28',2,23),(52,'Anglepoise Desk Lamp','Matte black adjustable desk lamp with smooth springs and a warm bulb included. Hidden for now while I reorganize my workspace.','["http://127.0.0.1:8080/image?imageName=item_52_hero.png", "http://127.0.0.1:8080/image?imageName=item_52_detail.png"]',68.00,'Xu Hui Qu',5,'2026-04-12 16:02:05',2,1),(53,'Herman Miller Sayl Chair','Fully working task chair with breathable back and adjustable arms. Wheels roll smoothly and the seat foam is still supportive. Pickup strongly preferred.','["http://127.0.0.1:8080/image?imageName=item_53_hero.png", "http://127.0.0.1:8080/image?imageName=item_53_detail.png"]',325.00,'Pu Dong Xin Qu',5,'2026-04-12 16:28:51',1,33),(54,'Onyx Boox Note Air 2','E-ink note-taking tablet with pen, folio case, and extra nibs. Great for reading PDFs and hand-written planning. Screen is clean and battery life is excellent.','["http://127.0.0.1:8080/image?imageName=item_54_hero.png", "http://127.0.0.1:8080/image?imageName=item_54_detail.png"]',279.00,'Hai Dian Qu',1,'2026-04-12 17:05:34',1,1),(55,'LEGO NASA Saturn V Set','Collector set with all major parts packed by section and instruction booklet included. Looks great on a shelf once built and can be shipped carefully.','["http://127.0.0.1:8080/image?imageName=item_55_hero.png", "http://127.0.0.1:8080/image?imageName=item_55_detail.png"]',86.00,'Min Hang Qu',5,'2026-04-12 17:42:40',1,27),(56,'Sonos Roam Portable Speaker','Portable speaker with balanced sound and strong battery life. Mostly used on a bookshelf and charged carefully. Includes cable and protective sleeve.','["http://127.0.0.1:8080/image?imageName=item_56_hero.png", "http://127.0.0.1:8080/image?imageName=item_56_detail.png"]',149.00,'Chao Yang Qu',1,'2026-04-12 18:05:12',1,26),(57,'DJI Mini 3 Drone Fly More Kit','Lightweight drone kit with controller, three batteries, charging hub, and spare props. Great for travel footage and easy to carry in a small sling.','["http://127.0.0.1:8080/image?imageName=item_57_hero.png", "http://127.0.0.1:8080/image?imageName=item_57_detail.png"]',489.00,'Hai Dian Qu',1,'2026-04-12 18:24:26',1,1),(58,'Breville Smart Grinder Pro','Burr grinder with tidy body and clear hopper. Dosing collar and grounds tray are included, and it still works smoothly for both espresso and pour-over settings.','["http://127.0.0.1:8080/image?imageName=item_58_hero.png", "http://127.0.0.1:8080/image?imageName=item_58_detail.png"]',132.00,'Xu Hui Qu',2,'2026-04-12 18:43:17',1,24),(59,'Fellow Stagg EKG Kettle','Matte black electric kettle with precise temperature control. Ideal for pour-over brewing and still heats quickly. Minor wear on the base only.','["http://127.0.0.1:8080/image?imageName=item_59_hero.png", "http://127.0.0.1:8080/image?imageName=item_59_detail.png"]',89.00,'Pu Dong Xin Qu',2,'2026-04-12 19:02:41',1,23),(60,'Steelcase Series 1 Office Chair','Compact ergonomic chair with mesh back, adjustable arms, and a supportive seat. Good choice for a small home office. Pickup preferred because it is assembled.','["http://127.0.0.1:8080/image?imageName=item_60_hero.png", "http://127.0.0.1:8080/image?imageName=item_60_detail.png"]',179.00,'Tong Zhou Qu',5,'2026-04-12 19:25:04',1,33),(61,'Muji Adjustable Desk Lamp','Simple white desk lamp with smooth joints and warm light. Great for reading corners or a clean work desk. Includes the original power adapter.','["http://127.0.0.1:8080/image?imageName=item_61_hero.png", "http://127.0.0.1:8080/image?imageName=item_61_detail.png"]',42.00,'Xi Cheng Qu',5,'2026-04-12 19:44:52',1,1),(62,'Logitech StreamCam','USB-C webcam with good daylight image and stable clip mount. Ideal for Zoom, streaming, or remote interviews. Includes the small tripod adapter.','["http://127.0.0.1:8080/image?imageName=item_62_hero.png", "http://127.0.0.1:8080/image?imageName=item_62_detail.png"]',78.00,'Hai Dian Qu',1,'2026-04-12 20:03:33',1,1),(63,'TP-Link Deco X50 Mesh Router Set','Three-node mesh kit that still covers a medium apartment very well. Each unit is clean and the app setup remains easy. Includes power adapters for all nodes.','["http://127.0.0.1:8080/image?imageName=item_63_hero.png", "http://127.0.0.1:8080/image?imageName=item_63_detail.png"]',118.00,'Chao Yang Qu',1,'2026-04-12 20:22:09',1,26),(64,'Osprey Daylite Travel Pack','Lightweight travel pack with padded straps and plenty of organization. Great for city trips or an everyday carry setup. Zippers and buckles are all intact.','["http://127.0.0.1:8080/image?imageName=item_64_hero.png", "http://127.0.0.1:8080/image?imageName=item_64_detail.png"]',55.00,'Shun Yi Qu',3,'2026-04-12 20:41:45',1,29),(65,'Snow Peak Folding Table','Compact folding table with aluminum top and neat locking legs. Packs flat and works well for camping, balcony coffee, or a portable photo setup.','["http://127.0.0.1:8080/image?imageName=item_65_hero.png", "http://127.0.0.1:8080/image?imageName=item_65_detail.png"]',112.00,'Bao An Qu',3,'2026-04-12 21:03:27',1,28),(66,'Kindle Oasis 32GB','Premium Kindle with warm light, page buttons, and slim metal body. Hidden for now while I compare it against the Paperwhite, but the condition is excellent.','["http://127.0.0.1:8080/image?imageName=item_66_hero.png", "http://127.0.0.1:8080/image?imageName=item_66_detail.png"]',165.00,'Hai Dian Qu',1,'2026-04-12 21:21:13',2,1),(67,'Garmin Forerunner 255','Running watch with strong GPS lock and clean display. Includes charging cable and one silicone strap. Great if you want a dedicated training watch.','["http://127.0.0.1:8080/image?imageName=item_67_hero.png", "http://127.0.0.1:8080/image?imageName=item_67_detail.png"]',218.00,'Xi Cheng Qu',1,'2026-04-12 21:44:36',1,27),(68,'JBL Charge 5 Bluetooth Speaker','Portable speaker with punchy bass and reliable battery. Still sounds great outdoors and the shell only has very light wear. Includes USB-C cable.','["http://127.0.0.1:8080/image?imageName=item_68_hero.png", "http://127.0.0.1:8080/image?imageName=item_68_detail.png"]',118.00,'Nan Shan Qu',1,'2026-04-12 22:03:58',1,24),(69,'Nintendo Switch Pro Controller','Official controller with smooth sticks and responsive triggers. Battery still lasts well and the shell is clean. Includes charging cable.','["http://127.0.0.1:8080/image?imageName=item_69_hero.png", "http://127.0.0.1:8080/image?imageName=item_69_detail.png"]',48.00,'Xu Hui Qu',1,'2026-04-12 22:23:14',1,27),(70,'Ergotron LX Monitor Arm','Gas spring arm with desk clamp and VESA plate included. Helps clear desk space and still moves very smoothly. Minor cosmetic wear on the clamp.','["http://127.0.0.1:8080/image?imageName=item_70_hero.png", "http://127.0.0.1:8080/image?imageName=item_70_detail.png"]',88.00,'Hai Dian Qu',5,'2026-04-12 22:44:02',1,1),(71,'ASUS ZenScreen Portable Monitor','Portable USB-C monitor that works well as a travel second screen. Panel is clean and includes the smart cover stand. Great for hybrid work.','["http://127.0.0.1:8080/image?imageName=item_71_hero.png", "http://127.0.0.1:8080/image?imageName=item_71_detail.png"]',158.00,'Pu Dong Xin Qu',1,'2026-04-12 23:05:47',1,24),(72,'DeLonghi Dedica Espresso Machine','Slim stainless espresso machine with steam wand and quick warm-up. Descaled recently and still pulls very respectable shots for daily home use.','["http://127.0.0.1:8080/image?imageName=item_72_hero.png", "http://127.0.0.1:8080/image?imageName=item_72_detail.png"]',146.00,'Min Hang Qu',2,'2026-04-12 23:26:21',1,23),(73,'Beats Fit Pro Earbuds','True wireless earbuds with wing tips and strong workout fit. Case has minor marks but the buds are clean and battery life is still solid.','["http://127.0.0.1:8080/image?imageName=item_73_hero.png", "http://127.0.0.1:8080/image?imageName=item_73_detail.png"]',96.00,'Long Gang Qu',1,'2026-04-12 23:49:18',1,28),(74,'Apple Magic Keyboard for iPad Pro','Black floating keyboard case with clean keys and responsive trackpad. The hinge still feels firm and the surface has only light desk wear.','["http://127.0.0.1:8080/image?imageName=item_74_hero.png", "http://127.0.0.1:8080/image?imageName=item_74_detail.png"]',168.00,'Hai Dian Qu',1,'2026-04-13 09:10:16',1,1),(75,'Peak Design Everyday Sling 6L','Compact sling bag that fits a small camera kit, water bottle, and tech pouch. Straps and zippers are in good shape, and the dividers are included.','["http://127.0.0.1:8080/image?imageName=item_75_hero.png", "http://127.0.0.1:8080/image?imageName=item_75_detail.png"]',72.00,'Chao Yang Qu',3,'2026-04-13 09:34:40',1,29),(76,'Kindle Scribe 64GB','Large-screen Kindle with premium pen and folio cover. Excellent for reading PDFs and hand-written planning, with no scratches on the screen.','["http://127.0.0.1:8080/image?imageName=item_76_hero.png", "http://127.0.0.1:8080/image?imageName=item_76_detail.png"]',298.00,'Xi Cheng Qu',1,'2026-04-13 09:58:25',1,1),(77,'Audio-Technica AT-LP60XBT Turntable','Bluetooth turntable with dust cover, RCA cable, and power adapter. Platter runs smoothly and the stylus has not seen much use.','["http://127.0.0.1:8080/image?imageName=item_77_hero.png", "http://127.0.0.1:8080/image?imageName=item_77_detail.png"]',158.00,'Pu Dong Xin Qu',5,'2026-04-13 10:22:11',1,23),(78,'Xiaomi Smart Air Fryer Pro 4L','Clean basket, quiet fan, and app control still works. Great for quick dinners and reheating leftovers without heating up the whole kitchen.','["http://127.0.0.1:8080/image?imageName=item_78_hero.png", "http://127.0.0.1:8080/image?imageName=item_78_detail.png"]',76.00,'Nan Shan Qu',2,'2026-04-13 10:44:56',1,24),(79,'Muji Oak Drawer Cabinet','Small oak storage cabinet with three drawers and minimal wear on the top. Good fit for stationery, cables, or coffee gear.','["http://127.0.0.1:8080/image?imageName=item_79_hero.png", "http://127.0.0.1:8080/image?imageName=item_79_detail.png"]',118.00,'Tong Zhou Qu',5,'2026-04-13 11:08:18',1,23),(80,'Nanoleaf Shapes Hexagon Starter Kit','Smart wall lights with connector plates, controller, and power supply included. Panels are clean and still look great in a work setup or gaming room.','["http://127.0.0.1:8080/image?imageName=item_80_hero.png", "http://127.0.0.1:8080/image?imageName=item_80_detail.png"]',108.00,'Hai Dian Qu',5,'2026-04-13 11:31:07',1,1),(81,'Owala 24oz Insulated Bottle','Leakproof insulated bottle with flip straw and only minor scuffs on the base. Keeps drinks cold well and fits most cup holders.','["http://127.0.0.1:8080/image?imageName=item_81_hero.png", "http://127.0.0.1:8080/image?imageName=item_81_detail.png"]',19.00,'Shun Yi Qu',3,'2026-04-13 11:57:42',1,29),(82,'JBL Clip 4 Speaker','Small speaker with integrated carabiner and surprisingly strong volume for day trips or showers. Includes charging cable.','["http://127.0.0.1:8080/image?imageName=item_82_hero.png", "http://127.0.0.1:8080/image?imageName=item_82_detail.png"]',39.00,'Bao An Qu',1,'2026-04-13 12:25:14',1,28),(83,'PlayStation DualSense Controller','White controller with clean sticks, adaptive triggers, and good battery life. Used mainly for story games and kept away from greasy hands.','["http://127.0.0.1:8080/image?imageName=item_83_hero.png", "http://127.0.0.1:8080/image?imageName=item_83_detail.png"]',56.00,'Xu Hui Qu',1,'2026-04-13 12:52:29',1,27),(84,'BenQ ScreenBar Halo','Monitor light bar with wireless controller and soft backlight. Great for reducing eye strain during late-night work.','["http://127.0.0.1:8080/image?imageName=item_84_hero.png", "http://127.0.0.1:8080/image?imageName=item_84_detail.png"]',112.00,'Hai Dian Qu',1,'2026-04-13 13:14:57',1,1),(85,'Eufy RoboVac 11S','Slim robot vacuum with remote, charging dock, side brushes, and boundary strips. Works best on hard floors and low rugs.','["http://127.0.0.1:8080/image?imageName=item_85_hero.png", "http://127.0.0.1:8080/image?imageName=item_85_detail.png"]',118.00,'Min Hang Qu',2,'2026-04-13 13:42:11',1,24),(86,'Hydro Flask Cooler Tote','Soft cooler tote with shoulder strap and insulated lining. Great for beach afternoons, grocery runs, or picnic setups.','["http://127.0.0.1:8080/image?imageName=item_86_hero.png", "http://127.0.0.1:8080/image?imageName=item_86_detail.png"]',64.00,'Long Gang Qu',3,'2026-04-13 14:06:33',1,29),(87,'Kinto Travel Tumbler Set','Pair of insulated tumblers in black and sand color. Clean lids, no leaks, and a nice fit for office coffee or tea.','["http://127.0.0.1:8080/image?imageName=item_87_hero.png", "http://127.0.0.1:8080/image?imageName=item_87_detail.png"]',28.00,'Chao Yang Qu',5,'2026-04-13 14:27:50',1,26),(88,'Microsoft Surface Go 3','Compact Windows tablet with keyboard cover and charger. Perfect for light travel work, note taking, and media on the go.','["http://127.0.0.1:8080/image?imageName=item_88_hero.png", "http://127.0.0.1:8080/image?imageName=item_88_detail.png"]',235.00,'Hai Dian Qu',1,'2026-04-13 14:55:18',1,1),(89,'Aputure MC RGB Light Kit','RGB magnetic lights with charging case and soft diffusers. Great for desk ambiance, photo accents, or product videos.','["http://127.0.0.1:8080/image?imageName=item_89_hero.png", "http://127.0.0.1:8080/image?imageName=item_89_detail.png"]',168.00,'Pu Dong Xin Qu',1,'2026-04-13 15:22:44',1,33);/*!40000 ALTER TABLE `sh_idle_item` ENABLE KEYS */;

UNLOCK TABLES;

DROP TABLE IF EXISTS `sh_message`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `sh_message` (

  `id` bigint NOT NULL AUTO_INCREMENT,

  `user_id` bigint NOT NULL,

  `idle_id` bigint NOT NULL,

  `content` varchar(256) NOT NULL,

  `create_time` datetime NOT NULL,

  `to_user` bigint NOT NULL,

  `to_message` bigint DEFAULT NULL,

  PRIMARY KEY (`id`),

  KEY `user_id_index` (`user_id`),

  KEY `idle_id_index` (`idle_id`),

  KEY `to_user_index` (`to_user`)

) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET character_set_client = @saved_cs_client */;



LOCK TABLES `sh_message` WRITE;

/*!40000 ALTER TABLE `sh_message` DISABLE KEYS */;

INSERT INTO `sh_message` VALUES (1,1,27,'Hi, are there any visible dents on the top surface?','2026-04-10 09:15:12',23,NULL),(2,23,27,'The top is clean. There is only one tiny mark on the inner leg.','2026-04-10 09:22:18',1,1),(3,1,27,'Thanks. Could you share the table height in centimeters?','2026-04-10 09:34:16',23,2),(4,23,27,'It is 45 cm tall and 37 cm wide.','2026-04-10 09:40:42',1,3),(5,29,23,'Is the battery still strong enough for note-taking all day?','2026-04-10 13:50:42',1,NULL),(6,1,23,'Yes, I still get a full workday with Wi-Fi and Apple Pencil notes.','2026-04-10 13:53:53',29,5),(7,1,33,'Are the frets smooth, or does it need a basic setup?','2026-04-10 14:00:39',31,NULL),(8,31,33,'A simple setup would help, but it is fully playable right now.','2026-04-10 14:02:54',1,7),(9,1,25,'Has this backpack been used on long hikes or mostly commuting?','2026-04-10 14:13:50',29,NULL),(10,29,25,'Mostly weekend hikes. No tears and every zipper still works well.','2026-04-10 14:30:16',1,9),(11,28,39,'Can you include the charger and the extra strap?','2026-04-12 11:10:26',1,NULL),(12,1,39,'Yes, both are included in the box.','2026-04-12 11:18:33',28,11),(13,24,31,'Does the camera come with the original battery and charger?','2026-04-12 12:05:11',1,NULL),(14,1,31,'Yes, both are included, and I can also add a 32GB SD card.','2026-04-12 12:16:48',24,13),(15,26,31,'How many shutter actuations roughly?','2026-04-12 12:28:05',1,NULL),(16,1,31,'Just under twelve thousand based on the last check in the menu.','2026-04-12 12:31:37',26,15),(17,1,36,'Would you be open to 115 if I can pick it up this weekend?','2026-04-12 13:02:44',29,NULL),(18,29,36,'I can do 119 and include the shoulder strap.','2026-04-12 13:09:50',1,17),(19,1,17,'Can the Sony headphones still fold tightly without any looseness?','2026-04-12 13:25:32',26,NULL),(20,26,17,'Yes, the hinges still feel firm and the case fits normally.','2026-04-12 13:32:14',1,19),(21,27,23,'Is the iPad screen free from bright spots?','2026-04-12 14:11:03',1,NULL),(22,1,23,'No bright spots. I can send a close-up under white background if needed.','2026-04-12 14:17:46',27,21),(23,1,33,'Can you hold the guitar for one day while I confirm transport?','2026-04-12 15:03:42',31,NULL),(24,31,33,'Sure, I can hold it until tomorrow evening.','2026-04-12 15:18:11',1,23),(25,1,44,'Is the GoPro body free from cracks near the battery door?','2026-04-12 15:42:12',28,NULL),(26,28,44,'Yes, the seal area is clean and the door closes tightly.','2026-04-12 15:49:31',1,25),(27,23,40,'Does the Kindle still support wireless charging on the dock?','2026-04-12 16:05:08',1,NULL),(28,1,40,'Yes, I tested it last night and it charges normally on a Qi stand.','2026-04-12 16:12:57',23,27),(29,33,53,'Could you share whether the lumbar support feels softer than an Aeron?','2026-04-12 16:41:26',33,NULL),(30,33,53,'The back flexes more and feels friendlier for long laptop sessions.','2026-04-12 16:48:09',33,29),(31,1,54,'How much handwriting latency do you notice on the Boox tablet?','2026-04-12 17:15:42',1,NULL),(32,24,54,'Very little with the native notes app. It feels fine for meeting notes.','2026-04-12 17:22:18',1,31),(33,1,49,'Do you still have the original Nespresso capsule tray insert?','2026-04-12 17:40:03',24,NULL),(34,24,49,'Yes, I kept both the tray and the small welcome manual.','2026-04-12 17:45:36',1,33),(35,29,55,'Can the LEGO Saturn V be separated into stages after assembly?','2026-04-12 18:01:11',27,NULL),(36,27,55,'Yes, it still separates into the display stages just like the manual shows.','2026-04-12 18:08:42',29,35),(37,1,57,'How noisy is the DJI Mini 3 compared with the older Mini 2?','2026-04-12 18:26:18',1,NULL),(38,1,57,'It is slightly quieter in my experience, especially when hovering low.','2026-04-12 18:33:49',1,37),(39,33,60,'Do the arm rests still adjust smoothly on the Steelcase chair?','2026-04-12 18:55:05',33,NULL),(40,33,60,'Yes, they move fine and lock in place without wobble.','2026-04-12 19:01:44',33,39),(41,1,70,'Does the Ergotron arm include both desk clamp and grommet parts?','2026-04-12 19:25:07',1,NULL),(42,1,70,'I only have the desk clamp, but it is the standard one most people use.','2026-04-12 19:31:58',1,41),(43,24,72,'Have you descaled the Dedica recently?','2026-04-12 19:48:33',23,NULL),(44,23,72,'Yes, I ran a descale cycle about two weeks ago.','2026-04-12 19:55:20',24,43),(45,27,67,'Can the Garmin sync both runs and cycling rides to Strava?','2026-04-12 20:11:06',27,NULL),(46,27,67,'Yes, it syncs both through Garmin Connect without any issue.','2026-04-12 20:17:45',27,45),(47,1,76,'Does the Kindle Scribe still include the premium pen and spare nibs?','2026-04-13 10:18:42',1,NULL),(48,1,76,'Yes, the premium pen, spare nibs, and folio are all included.','2026-04-13 10:24:37',1,47),(49,27,83,'Any stick drift on the DualSense controller?','2026-04-13 10:58:11',27,NULL),(50,27,83,'No drift at all. I tested it in Astro and Rocket League last weekend.','2026-04-13 11:04:53',27,49),(51,1,84,'Can the ScreenBar Halo fit a 27-inch curved monitor?','2026-04-13 11:22:04',1,NULL),(52,1,84,'It fits most curved monitors, and I was using it on a 27-inch Dell.','2026-04-13 11:29:44',1,51),(53,24,88,'How is the Surface Go battery now for web browsing?','2026-04-13 11:51:15',1,NULL),(54,1,88,'Around six hours in mixed browser and document use with mid brightness.','2026-04-13 11:58:33',24,53),(55,33,89,'Do the Aputure MC lights still hold charge in the case?','2026-04-13 12:16:27',33,NULL),(56,33,89,'Yes, the case still tops both units up without any issue.','2026-04-13 12:23:52',33,55),(57,29,75,'Will the Peak Design sling fit a mirrorless camera plus one extra lens?','2026-04-13 12:41:36',29,NULL),(58,29,75,'Yes, I used it with an X-T30 and a small extra lens comfortably.','2026-04-13 12:48:19',29,57);/*!40000 ALTER TABLE `sh_message` ENABLE KEYS */;

UNLOCK TABLES;

DROP TABLE IF EXISTS `sh_order`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `sh_order` (

  `id` bigint NOT NULL AUTO_INCREMENT,

  `order_number` varchar(32) NOT NULL,

  `user_id` bigint NOT NULL,

  `idle_id` bigint NOT NULL,

  `order_price` decimal(10,2) NOT NULL,

  `payment_status` tinyint NOT NULL,

  `payment_way` varchar(16) DEFAULT NULL,

  `create_time` datetime NOT NULL,

  `payment_time` datetime DEFAULT NULL,

  `order_status` tinyint NOT NULL,

  `is_deleted` tinyint DEFAULT NULL,

  PRIMARY KEY (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET character_set_client = @saved_cs_client */;



LOCK TABLES `sh_order` WRITE;

/*!40000 ALTER TABLE `sh_order` DISABLE KEYS */;

INSERT INTO `sh_order` VALUES (17,'ORD202604100001',1,27,189.00,1,'Alipay','2026-04-10 10:05:55','2026-04-10 10:07:29',3,NULL),(18,'ORD202604100002',1,20,39.00,1,'Alipay','2026-04-10 10:15:34','2026-04-10 10:16:03',1,NULL),(19,'ORD202604100003',23,23,539.00,1,'Alipay','2026-04-10 10:24:38','2026-04-10 10:25:12',2,NULL),(20,'ORD202604100004',29,31,615.00,1,'Alipay','2026-04-10 10:29:17','2026-04-10 10:31:02',3,NULL),(21,'ORD202604100005',1,17,179.00,1,'Alipay','2026-04-10 11:25:31','2026-04-10 11:28:07',2,NULL),(22,'ORD202604100006',28,35,249.00,1,'Alipay','2026-04-10 11:37:33','2026-04-10 11:39:13',1,NULL),(23,'ORD202604100007',1,29,24.00,0,NULL,'2026-04-10 12:13:44',NULL,0,NULL),(24,'ORD202604100008',27,39,185.00,0,NULL,'2026-04-10 12:44:46',NULL,4,NULL),(25,'ORD202604100009',1,32,720.00,1,'Alipay','2026-04-10 13:19:59','2026-04-10 13:27:59',3,NULL),(26,'ORD202604100010',24,23,539.00,1,'Alipay','2026-04-10 14:15:42','2026-04-10 14:16:08',1,NULL),(27,'ORD202604100011',1,30,32.00,1,'Alipay','2026-04-11 09:05:22','2026-04-11 09:06:01',3,NULL),(28,'ORD202604100012',29,39,185.00,1,'Alipay','2026-04-11 10:11:49','2026-04-11 10:12:36',2,NULL),(29,'ORD202604100013',1,36,129.00,1,'Alipay','2026-04-11 11:24:09','2026-04-11 11:25:14',1,NULL),(30,'ORD202604100014',23,31,615.00,0,NULL,'2026-04-11 12:08:55',NULL,0,NULL),(31,'ORD202604100015',1,18,229.00,1,'Alipay','2026-04-11 13:18:03','2026-04-11 13:19:48',2,NULL),(32,'ORD202604100016',28,23,539.00,1,'Alipay','2026-04-11 14:42:16','2026-04-11 14:43:08',3,NULL),(33,'ORD202604100017',1,21,18.50,1,'Alipay','2026-04-11 15:05:47','2026-04-11 15:06:21',3,NULL),(34,'ORD202604100018',26,39,185.00,0,NULL,'2026-04-11 16:22:10',NULL,1,NULL),(35,'ORD202604100019',1,44,269.00,1,'Alipay','2026-04-12 09:05:42','2026-04-12 09:06:30',3,NULL),(36,'ORD202604100020',1,49,88.00,1,'Alipay','2026-04-12 09:42:18','2026-04-12 09:43:02',1,NULL),(37,'ORD202604100021',29,40,135.00,1,'Alipay','2026-04-12 10:11:36','2026-04-12 10:12:09',2,NULL),(38,'ORD202604100022',1,53,325.00,0,NULL,'2026-04-12 10:37:27',NULL,0,NULL),(39,'ORD202604100023',23,45,89.00,1,'Alipay','2026-04-12 11:04:58','2026-04-12 11:05:34',3,NULL),(40,'ORD202604100024',1,55,86.00,0,NULL,'2026-04-12 11:29:41',NULL,4,NULL),(41,'ORD202604100025',28,50,339.00,1,'Alipay','2026-04-12 12:18:55','2026-04-12 12:19:37',1,NULL),(42,'ORD202604100026',1,46,109.00,1,'Alipay','2026-04-12 12:53:10','2026-04-12 12:53:58',3,NULL),(43,'ORD202604100027',1,48,26.00,1,'Alipay','2026-04-12 13:22:48','2026-04-12 13:23:11',2,NULL),(44,'ORD202604100028',24,54,279.00,0,NULL,'2026-04-12 14:05:26',NULL,0,NULL),(45,'ORD202604100029',1,57,489.00,1,'Alipay','2026-04-12 18:35:27','2026-04-12 18:36:10',1,NULL),(46,'ORD202604100030',33,60,179.00,1,'Alipay','2026-04-12 19:06:44','2026-04-12 19:07:22',2,NULL),(47,'ORD202604100031',1,63,118.00,1,'Alipay','2026-04-12 19:41:03','2026-04-12 19:41:49',3,NULL),(48,'ORD202604100032',1,68,118.00,0,NULL,'2026-04-12 20:08:56',NULL,0,NULL),(49,'ORD202604100033',24,72,146.00,1,'Alipay','2026-04-12 20:31:28','2026-04-12 20:32:05',1,NULL),(50,'ORD202604100034',27,67,218.00,1,'Alipay','2026-04-12 20:55:10','2026-04-12 20:55:48',3,NULL),(51,'ORD202604100035',1,71,158.00,1,'Alipay','2026-04-12 21:18:25','2026-04-12 21:19:06',2,NULL),(52,'ORD202604100036',28,73,96.00,0,NULL,'2026-04-12 21:42:39',NULL,1,NULL),(53,'ORD202604130001',1,76,298.00,1,'Alipay','2026-04-13 10:27:03','2026-04-13 10:27:48',2,NULL),(54,'ORD202604130002',27,83,56.00,1,'Alipay','2026-04-13 11:06:19','2026-04-13 11:06:47',3,NULL),(55,'ORD202604130003',1,84,112.00,1,'Alipay','2026-04-13 11:31:22','2026-04-13 11:31:55',1,NULL),(56,'ORD202604130004',24,88,235.00,0,NULL,'2026-04-13 12:00:40',NULL,0,NULL),(57,'ORD202604130005',33,89,168.00,1,'Alipay','2026-04-13 12:25:47','2026-04-13 12:26:16',1,NULL),(58,'ORD202604130006',29,75,72.00,1,'Alipay','2026-04-13 12:49:58','2026-04-13 12:50:27',3,NULL),(59,'ORD202604130007',1,82,39.00,1,'Alipay','2026-04-13 13:15:29','2026-04-13 13:15:50',2,NULL),(60,'ORD202604130008',1,85,118.00,0,NULL,'2026-04-13 13:42:55',NULL,1,NULL),(61,'ORD202604130009',23,79,118.00,1,'Alipay','2026-04-13 14:03:31','2026-04-13 14:04:06',3,NULL),(62,'ORD202604130010',1,87,28.00,1,'Alipay','2026-04-13 14:25:08','2026-04-13 14:25:29',3,NULL);/*!40000 ALTER TABLE `sh_order` ENABLE KEYS */;

UNLOCK TABLES;

DROP TABLE IF EXISTS `sh_order_address`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `sh_order_address` (

  `id` bigint NOT NULL AUTO_INCREMENT,

  `order_id` bigint NOT NULL,

  `consignee_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,

  `consignee_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,

  `detail_address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,

  PRIMARY KEY (`id`),

  UNIQUE KEY `orderId` (`order_id`),

  KEY `order_id_index` (`order_id`)

) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET character_set_client = @saved_cs_client */;



LOCK TABLES `sh_order_address` WRITE;

/*!40000 ALTER TABLE `sh_order_address` DISABLE KEYS */;

INSERT INTO `sh_order_address` VALUES (12,17,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),(13,18,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),(14,19,'Daniel Wu','17322611235','Bei Jing Shi Shi Xia Qu Chao Yang Qu Wangjing Jie 19 Hao 6-1802'),(15,20,'Chloe Kim','17322611230','Bei Jing Shi Shi Xia Qu Dong Cheng Qu Dong Si Bei Da Jie 66 Hao 2-901'),(16,21,'Emily Carter','17322612356','Bei Jing Shi Shi Xia Qu Xi Cheng Qu De Sheng Men Wai Da Jie 18 Hao 2-301'),(17,22,'Leo Bennett','17322611239','Bei Jing Shi Shi Xia Qu Shun Yi Qu Fu Qian Dong Jie 28 Hao 1-602'),(18,23,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),(19,24,'Nina Patel','17322611238','Bei Jing Shi Shi Xia Qu Chao Yang Qu Guang Hua Lu 77 Hao 9-1111'),(20,25,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),(21,26,'Sofia Ramirez','17322611236','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jian Guo Lu 120 Hao 5-2103'),(22,27,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),(23,28,'Chloe Kim','17322611230','Bei Jing Shi Shi Xia Qu Dong Cheng Qu Dong Si Bei Da Jie 66 Hao 2-901'),(24,29,'Emily Carter','17322612356','Bei Jing Shi Shi Xia Qu Xi Cheng Qu De Sheng Men Wai Da Jie 18 Hao 2-301'),(25,30,'Daniel Wu','17322611235','Bei Jing Shi Shi Xia Qu Chao Yang Qu Wangjing Jie 19 Hao 6-1802'),(26,31,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),(27,32,'Leo Bennett','17322611239','Bei Jing Shi Shi Xia Qu Shun Yi Qu Fu Qian Dong Jie 28 Hao 1-602'),(28,33,'Emily Carter','17322611234','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jiu Xian Qiao Bei Lu 12 Hao 3-702'),(29,34,'Marcus Reed','17322611237','Bei Jing Shi Shi Xia Qu Hai Dian Qu Xi Tu Cheng Lu 99 Hao 8-1501'),(30,35,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),(31,36,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),(32,37,'Chloe Kim','17322611230','Bei Jing Shi Shi Xia Qu Dong Cheng Qu Dong Si Bei Da Jie 66 Hao 2-901'),(33,38,'Emily Carter','17322612356','Bei Jing Shi Shi Xia Qu Xi Cheng Qu De Sheng Men Wai Da Jie 18 Hao 2-301'),(34,39,'Daniel Wu','17322611235','Bei Jing Shi Shi Xia Qu Chao Yang Qu Wangjing Jie 19 Hao 6-1802'),(35,40,'Emily Carter','17322611234','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jiu Xian Qiao Bei Lu 12 Hao 3-702'),(36,41,'Leo Bennett','17322611239','Bei Jing Shi Shi Xia Qu Shun Yi Qu Fu Qian Dong Jie 28 Hao 1-602'),(37,42,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),(38,43,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),(39,44,'Sofia Ramirez','17322611236','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jian Guo Lu 120 Hao 5-2103'),(40,45,'Emily Carter','17322612356','Bei Jing Shi Shi Xia Qu Xi Cheng Qu De Sheng Men Wai Da Jie 18 Hao 2-301'),(41,46,'Ava Morgan','17322611240','Bei Jing Shi Shi Xia Qu Chao Yang Qu San Li Tun Bei Jie 11 Hao 3-1206'),(42,47,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),(43,48,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),(44,49,'Sofia Ramirez','17322611236','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jian Guo Lu 120 Hao 5-2103'),(45,50,'Nina Patel','17322611238','Bei Jing Shi Shi Xia Qu Chao Yang Qu Guang Hua Lu 77 Hao 9-1111'),(46,51,'Emily Carter','17322611234','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jiu Xian Qiao Bei Lu 12 Hao 3-702'),(47,52,'Leo Bennett','17322611239','Bei Jing Shi Shi Xia Qu Shun Yi Qu Fu Qian Dong Jie 28 Hao 1-602'),(48,53,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),(49,54,'Nina Patel','17322611238','Bei Jing Shi Shi Xia Qu Chao Yang Qu Guang Hua Lu 77 Hao 9-1111'),(50,55,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),(51,56,'Sofia Ramirez','17322611236','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jian Guo Lu 120 Hao 5-2103'),(52,57,'Ava Morgan','17322611240','Bei Jing Shi Shi Xia Qu Chao Yang Qu San Li Tun Bei Jie 11 Hao 3-1206'),(53,58,'Chloe Kim','17322611230','Bei Jing Shi Shi Xia Qu Dong Cheng Qu Dong Si Bei Da Jie 66 Hao 2-901'),(54,59,'Emily Carter','17322612356','Bei Jing Shi Shi Xia Qu Xi Cheng Qu De Sheng Men Wai Da Jie 18 Hao 2-301'),(55,60,'Emily Carter','17322611234','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jiu Xian Qiao Bei Lu 12 Hao 3-702'),(56,61,'Daniel Wu','17322611235','Bei Jing Shi Shi Xia Qu Chao Yang Qu Wangjing Jie 19 Hao 6-1802'),(57,62,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002');/*!40000 ALTER TABLE `sh_order_address` ENABLE KEYS */;

UNLOCK TABLES;

DROP TABLE IF EXISTS `sh_user`;

/*!40101 SET @saved_cs_client     = @@character_set_client */;

/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `sh_user` (

  `id` bigint NOT NULL AUTO_INCREMENT,

  `account_number` varchar(16) NOT NULL,

  `user_password` varchar(16) NOT NULL,

  `nickname` varchar(32) NOT NULL,

  `avatar` varchar(256) NOT NULL,

  `sign_in_time` datetime NOT NULL,

  `user_status` tinyint DEFAULT NULL,

  PRIMARY KEY (`id`),

  UNIQUE KEY `account_number` (`account_number`)

) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET character_set_client = @saved_cs_client */;



LOCK TABLES `sh_user` WRITE;

/*!40000 ALTER TABLE `sh_user` DISABLE KEYS */;

INSERT INTO `sh_user` VALUES (1,'17322611234','123456','Emily Carter','http://127.0.0.1:8080/image?imageName=avatar_emily_carter.png','2024-09-03 10:49:01',0),(23,'17322611235','123456','Daniel Wu','http://127.0.0.1:8080/image?imageName=avatar_daniel_wu.png','2024-10-12 18:12:19',0),(24,'17322611236','123456','Sofia Ramirez','http://127.0.0.1:8080/image?imageName=avatar_sofia_ramirez.png','2024-10-28 09:24:30',0),(26,'17322611237','123456','Marcus Reed','http://127.0.0.1:8080/image?imageName=avatar_marcus_reed.png','2024-11-07 20:53:15',0),(27,'17322611238','123456','Nina Patel','http://127.0.0.1:8080/image?imageName=avatar_nina_patel.png','2024-11-18 11:21:50',0),(28,'17322611239','123456','Leo Bennett','http://127.0.0.1:8080/image?imageName=avatar_leo_bennett.png','2024-12-02 14:22:33',0),(29,'17322611230','123456','Chloe Kim','http://127.0.0.1:8080/image?imageName=avatar_chloe_kim.png','2024-12-12 17:03:15',0),(30,'17322611231','123456','Ethan Brooks','http://127.0.0.1:8080/image?imageName=avatar_ethan_brooks.png','2024-12-18 11:23:36',1),(31,'17322611232','123456','Grace Liu','http://127.0.0.1:8080/image?imageName=avatar_grace_liu.png','2024-12-18 11:24:04',1),(33,'17322611240','123456','Ava Morgan','http://127.0.0.1:8080/image?imageName=avatar_ava_morgan.png','2025-01-09 08:35:21',0);/*!40000 ALTER TABLE `sh_user` ENABLE KEYS */;

UNLOCK TABLES;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;

/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;





