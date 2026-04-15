from pathlib import Path
import json, re, shutil, subprocess, sys
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / 'second_hand_trading.sql'
USER_FILE_DIR = ROOT / 'userFile'
BASE_URL = 'http://127.0.0.1:8080'
IMG_BASE = BASE_URL + '/image?imageName='
FONT_REGULAR = 'C:/Windows/Fonts/segoeui.ttf'
FONT_BOLD = 'C:/Windows/Fonts/bahnschrift.ttf'
MYSQL_BIN = r'C:\\wamp64\\bin\\mysql\\mysql8.4.7\\bin\\mysql.exe'
MYSQL_DB = 'second_hand_trading'

USERS = [
    (1,'17322611234','123456','Emily Carter','avatar_emily_carter.png','2024-09-03 10:49:01',0,'#5B8CFF','#8EECF5'),
    (23,'17322611235','123456','Daniel Wu','avatar_daniel_wu.png','2024-10-12 18:12:19',0,'#FF7A59','#FFD166'),
    (24,'17322611236','123456','Sofia Ramirez','avatar_sofia_ramirez.png','2024-10-28 09:24:30',0,'#F15BB5','#FEE440'),
    (26,'17322611237','123456','Marcus Reed','avatar_marcus_reed.png','2024-11-07 20:53:15',0,'#06D6A0','#118AB2'),
    (27,'17322611238','123456','Nina Patel','avatar_nina_patel.png','2024-11-18 11:21:50',0,'#9B5DE5','#F15BB5'),
    (28,'17322611239','123456','Leo Bennett','avatar_leo_bennett.png','2024-12-02 14:22:33',0,'#277DA1','#90E0EF'),
    (29,'17322611230','123456','Chloe Kim','avatar_chloe_kim.png','2024-12-12 17:03:15',0,'#43AA8B','#B7E4C7'),
    (30,'17322611231','123456','Ethan Brooks','avatar_ethan_brooks.png','2024-12-18 11:23:36',1,'#F94144','#F8961E'),
    (31,'17322611232','123456','Grace Liu','avatar_grace_liu.png','2024-12-18 11:24:04',1,'#577590','#A9DEF9'),
    (33,'17322611240','123456','Ava Morgan','avatar_ava_morgan.png','2025-01-09 08:35:21',0,'#F9844A','#F9C74F'),
]

ADMINS = [
    (1,'root','123456','Mia'),
    (3,'ops01','123456','Noah'),
    (5,'ops02','123456','Ivy'),
]

ADDRESSES = [
    (20,'Emily Carter','17322611234','Bei Jing Shi','Shi Xia Qu','Chao Yang Qu','Jiu Xian Qiao Bei Lu 12 Hao 3-702',0,1),
    (21,'Emily Carter','17322610001','Bei Jing Shi','Shi Xia Qu','Hai Dian Qu','Zhong Guan Cun Da Jie 88 Hao A-1605',1,1),
    (22,'Emily Carter','17322612356','Bei Jing Shi','Shi Xia Qu','Xi Cheng Qu','De Sheng Men Wai Da Jie 18 Hao 2-301',0,1),
    (23,'Emily Carter','17322614567','Bei Jing Shi','Shi Xia Qu','Tong Zhou Qu','Li Yuan Zhong Lu 66 Hao 5-1002',0,1),
]

ITEMS = [
    (16,'Apple iPhone 13 128GB',1,3899.00,'Hai Dian Qu',1,'2026-04-08 19:01:01',1,26,'Midnight finish. Battery health is still strong for a full day and the frame is clean. Includes original box, charging cable, and a clear case.','#101827','#60A5FA'),
    (17,'Sony WH-1000XM4 Headphones',1,179.00,'Chao Yang Qu',1,'2026-04-08 20:03:48',1,26,'Used mainly at home and always stored in the hard case. Ear pads are clean, hinge is solid, and noise canceling works perfectly. Includes pouch and 3.5 mm cable.','#0F172A','#38BDF8'),
    (18,'Nintendo Switch OLED Console',1,229.00,'Xu Hui Qu',1,'2026-04-09 09:06:56',1,27,'White Joy-Con edition with bright screen and no dead pixels. Dock, straps, HDMI cable, and charger are all included. Great for couch co-op and travel.','#0B1220','#EF4444'),
    (19,'Dyson V8 Slim Vacuum',2,168.00,'Pu Dong Xin Qu',1,'2026-04-09 10:10:57',1,24,'Works well on hardwood and low-pile rugs. Battery lasts about 25 minutes on standard mode. Comes with wall dock, crevice tool, and soft brush.','#111827','#F59E0B'),
    (20,'Midea 1.7L Electric Kettle',2,39.00,'Chang Ping Qu',1,'2026-04-09 13:13:08',1,24,'Simple stainless model with fast boil and auto shut-off. Interior is clean and the lid spring still opens smoothly. Good backup kettle for office or dorm use.','#0F172A','#E5E7EB'),
    (21,'The Design of Everyday Things',4,18.50,'Xi Cheng Qu',1,'2026-04-09 14:15:05',1,23,'Hardcover copy with a crisp jacket and only light shelf wear. Pages are clean with no notes or highlights. Ideal if you want a thoughtful design classic for your desk.','#F8FAFC','#2563EB'),
    (22,'Logitech MX Mechanical Keyboard',1,119.00,'Pu Dong Xin Qu',1,'2026-04-09 15:48:22',1,24,'Tactile quiet switch version. Keys are clean, backlight is even, and Bluetooth still pairs quickly with both Windows and macOS. Includes receiver and USB-C cable.','#111827','#A3E635'),
    (23,'Apple iPad Air 5 64GB',1,539.00,'Hai Dian Qu',1,'2026-04-10 08:50:49',1,1,'Blue finish with a clean display and no major dents. Perfect for notes, Netflix, and travel editing. Includes folio case and the original charging cable.','#0F172A','#93C5FD'),
    (24,'Fujifilm Instax Mini Evo',1,198.00,'Nan Shan Qu',1,'2026-04-10 10:55:39',1,26,'Great condition instant camera with retro controls and fun film looks. Lens cover opens smoothly and the battery still holds a charge. Includes strap and charging cable.','#111827','#F59E0B'),
    (25,'Decathlon 45L Hiking Backpack',3,68.00,'Long Gang Qu',1,'2026-04-10 11:59:34',1,29,'Used on a few weekend hikes and kept dry between trips. Hip belt, rain cover, and chest strap are all intact. Plenty of room for a two-day summer trip.','#0F172A','#86EFAC'),
]
ITEMS += [
    (26,'Coleman Two-Person Camping Tent',3,96.00,'Shun Yi Qu',1,'2026-04-10 12:02:18',1,29,'No broken poles and the rainfly still seals well. Best for spring through early autumn camping. Includes stakes, guylines, and original carry bag.','#0B1220','#FDBA74'),
    (27,'Muji Walnut Side Table',5,189.00,'Chao Yang Qu',1,'2026-04-10 13:04:39',1,23,'Compact bedside table in walnut tone with a clean top surface and sturdy legs. Fits well next to a sofa or reading chair. Easy pickup because it is already assembled.','#1C1917','#F5DEB3'),
    (28,'Mid-century Floor Lamp',5,84.00,'Xu Hui Qu',2,'2026-04-10 14:07:28',24,'Warm linen shade with a slim black stem and brass accent. Works well in a reading corner, but the shade has one small crease. Currently kept offline after moving furniture around.','#1F2937','#FDE68A'),
    (29,'Atomic Habits Hardcover',4,24.00,'Shi Jing Shan Qu',1,'2026-04-11 09:33:11',26,'Very tidy copy with sharp corners and no highlighting. Nice desk book if you want an easy motivational read that still looks presentable on a shelf.','#F8FAFC','#10B981'),
    (30,'Dune Deluxe Edition',4,32.00,'Min Hang Qu',1,'2026-04-11 10:34:05',27,'Hardcover with foil title and clean pages. Jacket has a light rub on one corner, but it still presents beautifully. Great copy for science fiction collectors.','#111827','#FDE68A'),
    (31,'Canon EOS M50 Mark II',1,615.00,'Hai Dian Qu',1,'2026-04-11 11:38:16',1,'Body and kit lens are both in very good condition. Flip screen, autofocus, and card slot all work normally. Includes battery, charger, strap, and a 32GB SD card.','#0F172A','#E5E7EB'),
    (32,'Trek Marlin 6 Mountain Bike',3,720.00,'Bao An Qu',1,'2026-04-11 12:45:22',28,'Medium frame with recently replaced chain and brake pads. Good option for city rides and light trail weekends. Pickup recommended because shipping would be expensive.','#111827','#86EFAC'),
    (33,'Yamaha Acoustic Guitar F310',5,145.00,'Gu Lou Qu',1,'2026-04-11 13:46:54',31,'Classic beginner-friendly acoustic with a warm sound and a comfortable neck. A few light pick marks near the sound hole. Includes gig bag and spare strings.','#1C1917','#FCD34D'),
    (34,'Philips Air Fryer 4.1L',2,92.00,'Tong Zhou Qu',2,'2026-04-11 14:50:45',23,'Basket is clean and the controls still click firmly. Great for quick dinners, but I upgraded to a larger model. Temporarily hidden while I decide whether to relist it.','#111827','#FECDD3'),
    (35,'Dell 27-inch USB-C Monitor',1,249.00,'Hai Dian Qu',2,'2026-04-11 15:52:46',1,'Sharp 1440p panel with one-cable laptop charging. Stand is sturdy, and the ports are all working. Marked offline because I may keep it as a second display.','#0F172A','#E0F2FE'),
    (36,'Yeti Hopper Soft Cooler',3,129.00,'Shun Yi Qu',1,'2026-04-11 16:55:09',29,'Holds ice surprisingly well for day trips and beach afternoons. Zipper works smoothly and the shell has no tears. Includes shoulder strap and bottle opener clip.','#0F172A','#BAE6FD'),
    (39,'Samsung Galaxy Watch 6 Classic',1,185.00,'Xi Cheng Qu',1,'2026-04-12 09:10:14',1,'Bluetooth version with rotating bezel, two straps, and original charger. Battery still lasts a full day with notifications and sleep tracking. Minor wear on the clasp only.','#0F172A','#DDD6FE'),
]
ITEMS += [
    (40,'Kindle Paperwhite Signature Edition',1,135.00,'Hai Dian Qu',1,'2026-04-12 10:18:12',1,23,'Latest generation Kindle with warm light and wireless charging. The screen is clean, battery is excellent, and the back only has light desk wear. Includes a charcoal fabric case.','#111827','#FDE68A'),
    (41,'Marshall Acton III Bluetooth Speaker',1,188.00,'Chao Yang Qu',1,'2026-04-12 10:40:33',1,26,'Compact speaker with strong bass and a clean cream finish. Kept on a media shelf with no outdoor use. Includes power cable and original carton.','#1C1917','#F5E6C8'),
    (42,'AeroPress Coffee Maker Kit',5,32.00,'Xu Hui Qu',1,'2026-04-12 11:08:25',1,24,'Complete travel coffee kit with AeroPress, scoop, stirrer, paper filters, and a stainless mug. Perfect if you want a compact brew setup for office or short trips.','#0F172A','#FCA5A5'),
    (43,'IKEA Poang Lounge Chair',5,95.00,'Tong Zhou Qu',2,'2026-04-12 11:32:18',1,23,'Birch frame with dark grey cushion. Still comfortable and stable, but I do not have room after moving. Kept offline while deciding whether to relist or donate.','#1F2937','#EAB308'),
    (44,'GoPro HERO 11 Black',1,269.00,'Long Gang Qu',1,'2026-04-12 12:01:44',1,28,'Action camera with one original battery, extra enduro battery, shorty grip, and 64GB card. Lens cover is clear and stabilization works perfectly.','#0B1220','#38BDF8'),
    (45,'Anker 737 Power Bank 24000mAh',1,89.00,'Hai Dian Qu',1,'2026-04-12 12:29:58',1,1,'Fast charging power bank with bright status screen and clean shell. Great for laptop + phone travel days. Includes braided USB-C cable and carrying pouch.','#111827','#A3E635'),
    (46,'Bose SoundLink Flex Speaker',1,109.00,'Pu Dong Xin Qu',1,'2026-04-12 13:06:10',1,26,'Portable waterproof speaker with surprisingly full sound for its size. Mostly used indoors and charged carefully. Includes USB-C cable.','#0F172A','#67E8F9'),
    (47,'Patagonia Nano Puff Jacket',3,120.00,'Xi Cheng Qu',1,'2026-04-12 13:30:22',1,27,'Men size M in black. Lightweight, warm, and easy to pack. No tears, zipper works smoothly, and insulation is still lofted.','#111827','#94A3B8'),
    (48,'Decathlon Folding Camping Chair',3,26.00,'Shun Yi Qu',1,'2026-04-12 14:02:54',1,29,'Simple folding chair with cup holder and stable frame. Good for camping, fishing, or a balcony setup. Stored dry after use.','#0F172A','#86EFAC'),
    (49,'Nespresso Essenza Mini',2,88.00,'Nan Shan Qu',1,'2026-04-12 14:35:17',1,24,'Small espresso machine with quick heat-up and consistent shots. Descaled recently and kept in a smoke-free home. Includes a box of mixed capsules.','#111827','#F9A8D4'),
    (50,'Xiaomi Smart Projector 2',1,339.00,'Hai Dian Qu',1,'2026-04-12 15:05:49',1,1,'Compact projector that works well for bedroom movie nights. Focus and keystone are working normally, and the body is clean. Includes remote and power brick.','#0F172A','#93C5FD'),
    (51,'Blueair Air Purifier 3410',2,118.00,'Chao Yang Qu',2,'2026-04-12 15:31:28',1,23,'Quiet bedroom air purifier with recently replaced filter. Body is clean and app pairing still works. Currently offline because I may keep it for allergy season.','#111827','#BAE6FD'),
    (52,'Anglepoise Desk Lamp',5,68.00,'Xu Hui Qu',2,'2026-04-12 16:02:05',1,1,'Matte black adjustable desk lamp with smooth springs and a warm bulb included. Hidden for now while I reorganize my workspace.','#1F2937','#FDE68A'),
    (53,'Herman Miller Sayl Chair',5,325.00,'Pu Dong Xin Qu',1,'2026-04-12 16:28:51',1,33,'Fully working task chair with breathable back and adjustable arms. Wheels roll smoothly and the seat foam is still supportive. Pickup strongly preferred.','#111827','#7DD3FC'),
    (54,'Onyx Boox Note Air 2',1,279.00,'Hai Dian Qu',1,'2026-04-12 17:05:34',1,1,'E-ink note-taking tablet with pen, folio case, and extra nibs. Great for reading PDFs and hand-written planning. Screen is clean and battery life is excellent.','#0F172A','#C4B5FD'),
    (55,'LEGO NASA Saturn V Set',5,86.00,'Min Hang Qu',1,'2026-04-12 17:42:40',1,27,'Collector set with all major parts packed by section and instruction booklet included. Looks great on a shelf once built and can be shipped carefully.','#111827','#FDE68A'),
]
ITEMS += [
    (56,'Sonos Roam Portable Speaker',1,149.00,'Chao Yang Qu',1,'2026-04-12 18:05:12',1,26,'Portable speaker with balanced sound and strong battery life. Mostly used on a bookshelf and charged carefully. Includes cable and protective sleeve.','#111827','#67E8F9'),
    (57,'DJI Mini 3 Drone Fly More Kit',1,489.00,'Hai Dian Qu',1,'2026-04-12 18:24:26',1,1,'Lightweight drone kit with controller, three batteries, charging hub, and spare props. Great for travel footage and easy to carry in a small sling.','#0B1220','#93C5FD'),
    (58,'Breville Smart Grinder Pro',2,132.00,'Xu Hui Qu',1,'2026-04-12 18:43:17',1,24,'Burr grinder with tidy body and clear hopper. Dosing collar and grounds tray are included, and it still works smoothly for both espresso and pour-over settings.','#111827','#FCA5A5'),
    (59,'Fellow Stagg EKG Kettle',2,89.00,'Pu Dong Xin Qu',1,'2026-04-12 19:02:41',1,23,'Matte black electric kettle with precise temperature control. Ideal for pour-over brewing and still heats quickly. Minor wear on the base only.','#0F172A','#E5E7EB'),
    (60,'Steelcase Series 1 Office Chair',5,179.00,'Tong Zhou Qu',1,'2026-04-12 19:25:04',1,33,'Compact ergonomic chair with mesh back, adjustable arms, and a supportive seat. Good choice for a small home office. Pickup preferred because it is assembled.','#111827','#7DD3FC'),
    (61,'Muji Adjustable Desk Lamp',5,42.00,'Xi Cheng Qu',1,'2026-04-12 19:44:52',1,1,'Simple white desk lamp with smooth joints and warm light. Great for reading corners or a clean work desk. Includes the original power adapter.','#1F2937','#FDE68A'),
    (62,'Logitech StreamCam',1,78.00,'Hai Dian Qu',1,'2026-04-12 20:03:33',1,1,'USB-C webcam with good daylight image and stable clip mount. Ideal for Zoom, streaming, or remote interviews. Includes the small tripod adapter.','#0F172A','#38BDF8'),
    (63,'TP-Link Deco X50 Mesh Router Set',1,118.00,'Chao Yang Qu',1,'2026-04-12 20:22:09',1,26,'Three-node mesh kit that still covers a medium apartment very well. Each unit is clean and the app setup remains easy. Includes power adapters for all nodes.','#111827','#BAE6FD'),
    (64,'Osprey Daylite Travel Pack',3,55.00,'Shun Yi Qu',1,'2026-04-12 20:41:45',1,29,'Lightweight travel pack with padded straps and plenty of organization. Great for city trips or an everyday carry setup. Zippers and buckles are all intact.','#0F172A','#86EFAC'),
    (65,'Snow Peak Folding Table',3,112.00,'Bao An Qu',1,'2026-04-12 21:03:27',1,28,'Compact folding table with aluminum top and neat locking legs. Packs flat and works well for camping, balcony coffee, or a portable photo setup.','#1C1917','#F5DEB3'),
    (66,'Kindle Oasis 32GB',1,165.00,'Hai Dian Qu',2,'2026-04-12 21:21:13',1,1,'Premium Kindle with warm light, page buttons, and slim metal body. Hidden for now while I compare it against the Paperwhite, but the condition is excellent.','#111827','#FDE68A'),
    (67,'Garmin Forerunner 255',1,218.00,'Xi Cheng Qu',1,'2026-04-12 21:44:36',1,27,'Running watch with strong GPS lock and clean display. Includes charging cable and one silicone strap. Great if you want a dedicated training watch.','#0F172A','#DDD6FE'),
    (68,'JBL Charge 5 Bluetooth Speaker',1,118.00,'Nan Shan Qu',1,'2026-04-12 22:03:58',1,24,'Portable speaker with punchy bass and reliable battery. Still sounds great outdoors and the shell only has very light wear. Includes USB-C cable.','#111827','#67E8F9'),
    (69,'Nintendo Switch Pro Controller',1,48.00,'Xu Hui Qu',1,'2026-04-12 22:23:14',1,27,'Official controller with smooth sticks and responsive triggers. Battery still lasts well and the shell is clean. Includes charging cable.','#0B1220','#EF4444'),
    (70,'Ergotron LX Monitor Arm',5,88.00,'Hai Dian Qu',1,'2026-04-12 22:44:02',1,1,'Gas spring arm with desk clamp and VESA plate included. Helps clear desk space and still moves very smoothly. Minor cosmetic wear on the clamp.','#0F172A','#E0F2FE'),
    (71,'ASUS ZenScreen Portable Monitor',1,158.00,'Pu Dong Xin Qu',1,'2026-04-12 23:05:47',1,24,'Portable USB-C monitor that works well as a travel second screen. Panel is clean and includes the smart cover stand. Great for hybrid work.','#0F172A','#93C5FD'),
    (72,'DeLonghi Dedica Espresso Machine',2,146.00,'Min Hang Qu',1,'2026-04-12 23:26:21',1,23,'Slim stainless espresso machine with steam wand and quick warm-up. Descaled recently and still pulls very respectable shots for daily home use.','#111827','#FCA5A5'),
    (73,'Beats Fit Pro Earbuds',1,96.00,'Long Gang Qu',1,'2026-04-12 23:49:18',1,28,'True wireless earbuds with wing tips and strong workout fit. Case has minor marks but the buds are clean and battery life is still solid.','#111827','#F9A8D4'),
]
ITEMS += [
    (74,'Apple Magic Keyboard for iPad Pro',1,168.00,'Hai Dian Qu',1,'2026-04-13 09:10:16',1,1,'Black floating keyboard case with clean keys and responsive trackpad. The hinge still feels firm and the surface has only light desk wear.','#111827','#93C5FD'),
    (75,'Peak Design Everyday Sling 6L',3,72.00,'Chao Yang Qu',1,'2026-04-13 09:34:40',1,29,'Compact sling bag that fits a small camera kit, water bottle, and tech pouch. Straps and zippers are in good shape, and the dividers are included.','#0F172A','#86EFAC'),
    (76,'Kindle Scribe 64GB',1,298.00,'Xi Cheng Qu',1,'2026-04-13 09:58:25',1,1,'Large-screen Kindle with premium pen and folio cover. Excellent for reading PDFs and hand-written planning, with no scratches on the screen.','#111827','#FDE68A'),
    (77,'Audio-Technica AT-LP60XBT Turntable',5,158.00,'Pu Dong Xin Qu',1,'2026-04-13 10:22:11',1,23,'Bluetooth turntable with dust cover, RCA cable, and power adapter. Platter runs smoothly and the stylus has not seen much use.','#1C1917','#FCD34D'),
    (78,'Xiaomi Smart Air Fryer Pro 4L',2,76.00,'Nan Shan Qu',1,'2026-04-13 10:44:56',1,24,'Clean basket, quiet fan, and app control still works. Great for quick dinners and reheating leftovers without heating up the whole kitchen.','#111827','#FCA5A5'),
    (79,'Muji Oak Drawer Cabinet',5,118.00,'Tong Zhou Qu',1,'2026-04-13 11:08:18',1,23,'Small oak storage cabinet with three drawers and minimal wear on the top. Good fit for stationery, cables, or coffee gear.','#1C1917','#F5DEB3'),
    (80,'Nanoleaf Shapes Hexagon Starter Kit',5,108.00,'Hai Dian Qu',1,'2026-04-13 11:31:07',1,1,'Smart wall lights with connector plates, controller, and power supply included. Panels are clean and still look great in a work setup or gaming room.','#111827','#C4B5FD'),
    (81,'Owala 24oz Insulated Bottle',3,19.00,'Shun Yi Qu',1,'2026-04-13 11:57:42',1,29,'Leakproof insulated bottle with flip straw and only minor scuffs on the base. Keeps drinks cold well and fits most cup holders.','#0F172A','#67E8F9'),
    (82,'JBL Clip 4 Speaker',1,39.00,'Bao An Qu',1,'2026-04-13 12:25:14',1,28,'Small speaker with integrated carabiner and surprisingly strong volume for day trips or showers. Includes charging cable.','#111827','#67E8F9'),
    (83,'PlayStation DualSense Controller',1,56.00,'Xu Hui Qu',1,'2026-04-13 12:52:29',1,27,'White controller with clean sticks, adaptive triggers, and good battery life. Used mainly for story games and kept away from greasy hands.','#0B1220','#EF4444'),
    (84,'BenQ ScreenBar Halo',1,112.00,'Hai Dian Qu',1,'2026-04-13 13:14:57',1,1,'Monitor light bar with wireless controller and soft backlight. Great for reducing eye strain during late-night work.','#0F172A','#E0F2FE'),
    (85,'Eufy RoboVac 11S',2,118.00,'Min Hang Qu',1,'2026-04-13 13:42:11',1,24,'Slim robot vacuum with remote, charging dock, side brushes, and boundary strips. Works best on hard floors and low rugs.','#111827','#BAE6FD'),
    (86,'Hydro Flask Cooler Tote',3,64.00,'Long Gang Qu',1,'2026-04-13 14:06:33',1,29,'Soft cooler tote with shoulder strap and insulated lining. Great for beach afternoons, grocery runs, or picnic setups.','#0F172A','#86EFAC'),
    (87,'Kinto Travel Tumbler Set',5,28.00,'Chao Yang Qu',1,'2026-04-13 14:27:50',1,26,'Pair of insulated tumblers in black and sand color. Clean lids, no leaks, and a nice fit for office coffee or tea.','#111827','#E5E7EB'),
    (88,'Microsoft Surface Go 3',1,235.00,'Hai Dian Qu',1,'2026-04-13 14:55:18',1,1,'Compact Windows tablet with keyboard cover and charger. Perfect for light travel work, note taking, and media on the go.','#0F172A','#93C5FD'),
    (89,'Aputure MC RGB Light Kit',1,168.00,'Pu Dong Xin Qu',1,'2026-04-13 15:22:44',1,33,'RGB magnetic lights with charging case and soft diffusers. Great for desk ambiance, photo accents, or product videos.','#111827','#F9A8D4'),
]

FAVORITES = [
    (32,'2026-04-12 10:28:00',1,17),
    (33,'2026-04-12 10:29:11',1,25),
    (34,'2026-04-12 11:28:51',1,29),
    (38,'2026-04-12 12:34:03',1,33),
    (39,'2026-04-12 12:42:19',1,31),
    (40,'2026-04-12 13:04:27',1,36),
    (41,'2026-04-12 13:26:18',1,44),
    (42,'2026-04-12 13:42:55',1,46),
    (43,'2026-04-12 14:11:09',1,53),
    (44,'2026-04-12 14:38:27',1,55),
    (45,'2026-04-12 15:05:41',1,57),
    (46,'2026-04-12 15:28:09',1,60),
    (47,'2026-04-12 15:59:18',1,67),
    (48,'2026-04-12 16:22:47',1,72),
    (49,'2026-04-13 10:02:11',1,76),
    (50,'2026-04-13 10:28:09',1,80),
    (51,'2026-04-13 10:46:55',1,83),
    (52,'2026-04-13 11:14:20',1,84),
    (53,'2026-04-13 11:39:37',1,88),
    (54,'2026-04-13 12:05:49',1,89),
]

MESSAGES = [
    (1,1,27,'Hi, are there any visible dents on the top surface?','2026-04-10 09:15:12',23,None),
    (2,23,27,'The top is clean. There is only one tiny mark on the inner leg.','2026-04-10 09:22:18',1,1),
    (3,1,27,'Thanks. Could you share the table height in centimeters?','2026-04-10 09:34:16',23,2),
    (4,23,27,'It is 45 cm tall and 37 cm wide.','2026-04-10 09:40:42',1,3),
    (5,29,23,'Is the battery still strong enough for note-taking all day?','2026-04-10 13:50:42',1,None),
    (6,1,23,'Yes, I still get a full workday with Wi-Fi and Apple Pencil notes.','2026-04-10 13:53:53',29,5),
    (7,1,33,'Are the frets smooth, or does it need a basic setup?','2026-04-10 14:00:39',31,None),
    (8,31,33,'A simple setup would help, but it is fully playable right now.','2026-04-10 14:02:54',1,7),
    (9,1,25,'Has this backpack been used on long hikes or mostly commuting?','2026-04-10 14:13:50',29,None),
    (10,29,25,'Mostly weekend hikes. No tears and every zipper still works well.','2026-04-10 14:30:16',1,9),
    (11,28,39,'Can you include the charger and the extra strap?','2026-04-12 11:10:26',1,None),
    (12,1,39,'Yes, both are included in the box.','2026-04-12 11:18:33',28,11),
    (13,24,31,'Does the camera come with the original battery and charger?','2026-04-12 12:05:11',1,None),
    (14,1,31,'Yes, both are included, and I can also add a 32GB SD card.','2026-04-12 12:16:48',24,13),
    (15,26,31,'How many shutter actuations roughly?','2026-04-12 12:28:05',1,None),
    (16,1,31,'Just under twelve thousand based on the last check in the menu.','2026-04-12 12:31:37',26,15),
    (17,1,36,'Would you be open to 115 if I can pick it up this weekend?','2026-04-12 13:02:44',29,None),
    (18,29,36,'I can do 119 and include the shoulder strap.','2026-04-12 13:09:50',1,17),
    (19,1,17,'Can the Sony headphones still fold tightly without any looseness?','2026-04-12 13:25:32',26,None),
    (20,26,17,'Yes, the hinges still feel firm and the case fits normally.','2026-04-12 13:32:14',1,19),
    (21,27,23,'Is the iPad screen free from bright spots?','2026-04-12 14:11:03',1,None),
    (22,1,23,'No bright spots. I can send a close-up under white background if needed.','2026-04-12 14:17:46',27,21),
    (23,1,33,'Can you hold the guitar for one day while I confirm transport?','2026-04-12 15:03:42',31,None),
    (24,31,33,'Sure, I can hold it until tomorrow evening.','2026-04-12 15:18:11',1,23),
    (25,1,44,'Is the GoPro body free from cracks near the battery door?','2026-04-12 15:42:12',28,None),
    (26,28,44,'Yes, the seal area is clean and the door closes tightly.','2026-04-12 15:49:31',1,25),
    (27,23,40,'Does the Kindle still support wireless charging on the dock?','2026-04-12 16:05:08',1,None),
    (28,1,40,'Yes, I tested it last night and it charges normally on a Qi stand.','2026-04-12 16:12:57',23,27),
    (29,33,53,'Could you share whether the lumbar support feels softer than an Aeron?','2026-04-12 16:41:26',33,None),
    (30,33,53,'The back flexes more and feels friendlier for long laptop sessions.','2026-04-12 16:48:09',33,29),
    (31,1,54,'How much handwriting latency do you notice on the Boox tablet?','2026-04-12 17:15:42',1,None),
    (32,24,54,'Very little with the native notes app. It feels fine for meeting notes.','2026-04-12 17:22:18',1,31),
    (33,1,49,'Do you still have the original Nespresso capsule tray insert?','2026-04-12 17:40:03',24,None),
    (34,24,49,'Yes, I kept both the tray and the small welcome manual.','2026-04-12 17:45:36',1,33),
    (35,29,55,'Can the LEGO Saturn V be separated into stages after assembly?','2026-04-12 18:01:11',27,None),
    (36,27,55,'Yes, it still separates into the display stages just like the manual shows.','2026-04-12 18:08:42',29,35),
    (37,1,57,'How noisy is the DJI Mini 3 compared with the older Mini 2?','2026-04-12 18:26:18',1,None),
    (38,1,57,'It is slightly quieter in my experience, especially when hovering low.','2026-04-12 18:33:49',1,37),
    (39,33,60,'Do the arm rests still adjust smoothly on the Steelcase chair?','2026-04-12 18:55:05',33,None),
    (40,33,60,'Yes, they move fine and lock in place without wobble.','2026-04-12 19:01:44',33,39),
    (41,1,70,'Does the Ergotron arm include both desk clamp and grommet parts?','2026-04-12 19:25:07',1,None),
    (42,1,70,'I only have the desk clamp, but it is the standard one most people use.','2026-04-12 19:31:58',1,41),
    (43,24,72,'Have you descaled the Dedica recently?','2026-04-12 19:48:33',23,None),
    (44,23,72,'Yes, I ran a descale cycle about two weeks ago.','2026-04-12 19:55:20',24,43),
    (45,27,67,'Can the Garmin sync both runs and cycling rides to Strava?','2026-04-12 20:11:06',27,None),
    (46,27,67,'Yes, it syncs both through Garmin Connect without any issue.','2026-04-12 20:17:45',27,45),
    (47,1,76,'Does the Kindle Scribe still include the premium pen and spare nibs?','2026-04-13 10:18:42',1,None),
    (48,1,76,'Yes, the premium pen, spare nibs, and folio are all included.','2026-04-13 10:24:37',1,47),
    (49,27,83,'Any stick drift on the DualSense controller?','2026-04-13 10:58:11',27,None),
    (50,27,83,'No drift at all. I tested it in Astro and Rocket League last weekend.','2026-04-13 11:04:53',27,49),
    (51,1,84,'Can the ScreenBar Halo fit a 27-inch curved monitor?','2026-04-13 11:22:04',1,None),
    (52,1,84,'It fits most curved monitors, and I was using it on a 27-inch Dell.','2026-04-13 11:29:44',1,51),
    (53,24,88,'How is the Surface Go battery now for web browsing?','2026-04-13 11:51:15',1,None),
    (54,1,88,'Around six hours in mixed browser and document use with mid brightness.','2026-04-13 11:58:33',24,53),
    (55,33,89,'Do the Aputure MC lights still hold charge in the case?','2026-04-13 12:16:27',33,None),
    (56,33,89,'Yes, the case still tops both units up without any issue.','2026-04-13 12:23:52',33,55),
    (57,29,75,'Will the Peak Design sling fit a mirrorless camera plus one extra lens?','2026-04-13 12:41:36',29,None),
    (58,29,75,'Yes, I used it with an X-T30 and a small extra lens comfortably.','2026-04-13 12:48:19',29,57),
]

ORDERS = [
    (17,'ORD202604100001',1,27,189.00,1,'Alipay','2026-04-10 10:05:55','2026-04-10 10:07:29',3,None),
    (18,'ORD202604100002',1,20,39.00,1,'Alipay','2026-04-10 10:15:34','2026-04-10 10:16:03',1,None),
    (19,'ORD202604100003',23,23,539.00,1,'Alipay','2026-04-10 10:24:38','2026-04-10 10:25:12',2,None),
    (20,'ORD202604100004',29,31,615.00,1,'Alipay','2026-04-10 10:29:17','2026-04-10 10:31:02',3,None),
    (21,'ORD202604100005',1,17,179.00,1,'Alipay','2026-04-10 11:25:31','2026-04-10 11:28:07',2,None),
    (22,'ORD202604100006',28,35,249.00,1,'Alipay','2026-04-10 11:37:33','2026-04-10 11:39:13',1,None),
    (23,'ORD202604100007',1,29,24.00,0,None,'2026-04-10 12:13:44',None,0,None),
    (24,'ORD202604100008',27,39,185.00,0,None,'2026-04-10 12:44:46',None,4,None),
    (25,'ORD202604100009',1,32,720.00,1,'Alipay','2026-04-10 13:19:59','2026-04-10 13:27:59',3,None),
    (26,'ORD202604100010',24,23,539.00,1,'Alipay','2026-04-10 14:15:42','2026-04-10 14:16:08',1,None),
    (27,'ORD202604100011',1,30,32.00,1,'Alipay','2026-04-11 09:05:22','2026-04-11 09:06:01',3,None),
    (28,'ORD202604100012',29,39,185.00,1,'Alipay','2026-04-11 10:11:49','2026-04-11 10:12:36',2,None),
    (29,'ORD202604100013',1,36,129.00,1,'Alipay','2026-04-11 11:24:09','2026-04-11 11:25:14',1,None),
    (30,'ORD202604100014',23,31,615.00,0,None,'2026-04-11 12:08:55',None,0,None),
    (31,'ORD202604100015',1,18,229.00,1,'Alipay','2026-04-11 13:18:03','2026-04-11 13:19:48',2,None),
    (32,'ORD202604100016',28,23,539.00,1,'Alipay','2026-04-11 14:42:16','2026-04-11 14:43:08',3,None),
    (33,'ORD202604100017',1,21,18.50,1,'Alipay','2026-04-11 15:05:47','2026-04-11 15:06:21',3,None),
    (34,'ORD202604100018',26,39,185.00,0,None,'2026-04-11 16:22:10',None,1,None),
    (35,'ORD202604100019',1,44,269.00,1,'Alipay','2026-04-12 09:05:42','2026-04-12 09:06:30',3,None),
    (36,'ORD202604100020',1,49,88.00,1,'Alipay','2026-04-12 09:42:18','2026-04-12 09:43:02',1,None),
    (37,'ORD202604100021',29,40,135.00,1,'Alipay','2026-04-12 10:11:36','2026-04-12 10:12:09',2,None),
    (38,'ORD202604100022',1,53,325.00,0,None,'2026-04-12 10:37:27',None,0,None),
    (39,'ORD202604100023',23,45,89.00,1,'Alipay','2026-04-12 11:04:58','2026-04-12 11:05:34',3,None),
    (40,'ORD202604100024',1,55,86.00,0,None,'2026-04-12 11:29:41',None,4,None),
    (41,'ORD202604100025',28,50,339.00,1,'Alipay','2026-04-12 12:18:55','2026-04-12 12:19:37',1,None),
    (42,'ORD202604100026',1,46,109.00,1,'Alipay','2026-04-12 12:53:10','2026-04-12 12:53:58',3,None),
    (43,'ORD202604100027',1,48,26.00,1,'Alipay','2026-04-12 13:22:48','2026-04-12 13:23:11',2,None),
    (44,'ORD202604100028',24,54,279.00,0,None,'2026-04-12 14:05:26',None,0,None),
    (45,'ORD202604100029',1,57,489.00,1,'Alipay','2026-04-12 18:35:27','2026-04-12 18:36:10',1,None),
    (46,'ORD202604100030',33,60,179.00,1,'Alipay','2026-04-12 19:06:44','2026-04-12 19:07:22',2,None),
    (47,'ORD202604100031',1,63,118.00,1,'Alipay','2026-04-12 19:41:03','2026-04-12 19:41:49',3,None),
    (48,'ORD202604100032',1,68,118.00,0,None,'2026-04-12 20:08:56',None,0,None),
    (49,'ORD202604100033',24,72,146.00,1,'Alipay','2026-04-12 20:31:28','2026-04-12 20:32:05',1,None),
    (50,'ORD202604100034',27,67,218.00,1,'Alipay','2026-04-12 20:55:10','2026-04-12 20:55:48',3,None),
    (51,'ORD202604100035',1,71,158.00,1,'Alipay','2026-04-12 21:18:25','2026-04-12 21:19:06',2,None),
    (52,'ORD202604100036',28,73,96.00,0,None,'2026-04-12 21:42:39',None,1,None),
    (53,'ORD202604130001',1,76,298.00,1,'Alipay','2026-04-13 10:27:03','2026-04-13 10:27:48',2,None),
    (54,'ORD202604130002',27,83,56.00,1,'Alipay','2026-04-13 11:06:19','2026-04-13 11:06:47',3,None),
    (55,'ORD202604130003',1,84,112.00,1,'Alipay','2026-04-13 11:31:22','2026-04-13 11:31:55',1,None),
    (56,'ORD202604130004',24,88,235.00,0,None,'2026-04-13 12:00:40',None,0,None),
    (57,'ORD202604130005',33,89,168.00,1,'Alipay','2026-04-13 12:25:47','2026-04-13 12:26:16',1,None),
    (58,'ORD202604130006',29,75,72.00,1,'Alipay','2026-04-13 12:49:58','2026-04-13 12:50:27',3,None),
    (59,'ORD202604130007',1,82,39.00,1,'Alipay','2026-04-13 13:15:29','2026-04-13 13:15:50',2,None),
    (60,'ORD202604130008',1,85,118.00,0,None,'2026-04-13 13:42:55',None,1,None),
    (61,'ORD202604130009',23,79,118.00,1,'Alipay','2026-04-13 14:03:31','2026-04-13 14:04:06',3,None),
    (62,'ORD202604130010',1,87,28.00,1,'Alipay','2026-04-13 14:25:08','2026-04-13 14:25:29',3,None),
]

ORDER_ADDRESS = [
    (12,17,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),
    (13,18,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),
    (14,19,'Daniel Wu','17322611235','Bei Jing Shi Shi Xia Qu Chao Yang Qu Wangjing Jie 19 Hao 6-1802'),
    (15,20,'Chloe Kim','17322611230','Bei Jing Shi Shi Xia Qu Dong Cheng Qu Dong Si Bei Da Jie 66 Hao 2-901'),
    (16,21,'Emily Carter','17322612356','Bei Jing Shi Shi Xia Qu Xi Cheng Qu De Sheng Men Wai Da Jie 18 Hao 2-301'),
    (17,22,'Leo Bennett','17322611239','Bei Jing Shi Shi Xia Qu Shun Yi Qu Fu Qian Dong Jie 28 Hao 1-602'),
    (18,23,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),
    (19,24,'Nina Patel','17322611238','Bei Jing Shi Shi Xia Qu Chao Yang Qu Guang Hua Lu 77 Hao 9-1111'),
    (20,25,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),
    (21,26,'Sofia Ramirez','17322611236','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jian Guo Lu 120 Hao 5-2103'),
    (22,27,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),
    (23,28,'Chloe Kim','17322611230','Bei Jing Shi Shi Xia Qu Dong Cheng Qu Dong Si Bei Da Jie 66 Hao 2-901'),
    (24,29,'Emily Carter','17322612356','Bei Jing Shi Shi Xia Qu Xi Cheng Qu De Sheng Men Wai Da Jie 18 Hao 2-301'),
    (25,30,'Daniel Wu','17322611235','Bei Jing Shi Shi Xia Qu Chao Yang Qu Wangjing Jie 19 Hao 6-1802'),
    (26,31,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),
    (27,32,'Leo Bennett','17322611239','Bei Jing Shi Shi Xia Qu Shun Yi Qu Fu Qian Dong Jie 28 Hao 1-602'),
    (28,33,'Emily Carter','17322611234','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jiu Xian Qiao Bei Lu 12 Hao 3-702'),
    (29,34,'Marcus Reed','17322611237','Bei Jing Shi Shi Xia Qu Hai Dian Qu Xi Tu Cheng Lu 99 Hao 8-1501'),
    (30,35,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),
    (31,36,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),
    (32,37,'Chloe Kim','17322611230','Bei Jing Shi Shi Xia Qu Dong Cheng Qu Dong Si Bei Da Jie 66 Hao 2-901'),
    (33,38,'Emily Carter','17322612356','Bei Jing Shi Shi Xia Qu Xi Cheng Qu De Sheng Men Wai Da Jie 18 Hao 2-301'),
    (34,39,'Daniel Wu','17322611235','Bei Jing Shi Shi Xia Qu Chao Yang Qu Wangjing Jie 19 Hao 6-1802'),
    (35,40,'Emily Carter','17322611234','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jiu Xian Qiao Bei Lu 12 Hao 3-702'),
    (36,41,'Leo Bennett','17322611239','Bei Jing Shi Shi Xia Qu Shun Yi Qu Fu Qian Dong Jie 28 Hao 1-602'),
    (37,42,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),
    (38,43,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),
    (39,44,'Sofia Ramirez','17322611236','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jian Guo Lu 120 Hao 5-2103'),
    (40,45,'Emily Carter','17322612356','Bei Jing Shi Shi Xia Qu Xi Cheng Qu De Sheng Men Wai Da Jie 18 Hao 2-301'),
    (41,46,'Ava Morgan','17322611240','Bei Jing Shi Shi Xia Qu Chao Yang Qu San Li Tun Bei Jie 11 Hao 3-1206'),
    (42,47,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),
    (43,48,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),
    (44,49,'Sofia Ramirez','17322611236','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jian Guo Lu 120 Hao 5-2103'),
    (45,50,'Nina Patel','17322611238','Bei Jing Shi Shi Xia Qu Chao Yang Qu Guang Hua Lu 77 Hao 9-1111'),
    (46,51,'Emily Carter','17322611234','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jiu Xian Qiao Bei Lu 12 Hao 3-702'),
    (47,52,'Leo Bennett','17322611239','Bei Jing Shi Shi Xia Qu Shun Yi Qu Fu Qian Dong Jie 28 Hao 1-602'),
    (48,53,'Emily Carter','17322610001','Bei Jing Shi Shi Xia Qu Hai Dian Qu Zhong Guan Cun Da Jie 88 Hao A-1605'),
    (49,54,'Nina Patel','17322611238','Bei Jing Shi Shi Xia Qu Chao Yang Qu Guang Hua Lu 77 Hao 9-1111'),
    (50,55,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),
    (51,56,'Sofia Ramirez','17322611236','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jian Guo Lu 120 Hao 5-2103'),
    (52,57,'Ava Morgan','17322611240','Bei Jing Shi Shi Xia Qu Chao Yang Qu San Li Tun Bei Jie 11 Hao 3-1206'),
    (53,58,'Chloe Kim','17322611230','Bei Jing Shi Shi Xia Qu Dong Cheng Qu Dong Si Bei Da Jie 66 Hao 2-901'),
    (54,59,'Emily Carter','17322612356','Bei Jing Shi Shi Xia Qu Xi Cheng Qu De Sheng Men Wai Da Jie 18 Hao 2-301'),
    (55,60,'Emily Carter','17322611234','Bei Jing Shi Shi Xia Qu Chao Yang Qu Jiu Xian Qiao Bei Lu 12 Hao 3-702'),
    (56,61,'Daniel Wu','17322611235','Bei Jing Shi Shi Xia Qu Chao Yang Qu Wangjing Jie 19 Hao 6-1802'),
    (57,62,'Emily Carter','17322614567','Bei Jing Shi Shi Xia Qu Tong Zhou Qu Li Yuan Zhong Lu 66 Hao 5-1002'),
]
def load_font(size, bold=False):
    try:
        return ImageFont.truetype(FONT_BOLD if bold else FONT_REGULAR, size=size)
    except Exception:
        return ImageFont.load_default()


def rgb(code):
    code = code.lstrip('#')
    return tuple(int(code[i:i+2], 16) for i in (0,2,4))


def gradient(size, top, bottom):
    w, h = size
    a, b = rgb(top), rgb(bottom)
    img = Image.new('RGB', size, a)
    d = ImageDraw.Draw(img)
    for y in range(h):
        r = y / max(h - 1, 1)
        c = tuple(int(a[i]*(1-r)+b[i]*r) for i in range(3))
        d.line((0, y, w, y), fill=c)
    return img


def wrap(draw, text, font, width):
    words, lines, cur = text.split(), [], ''
    for word in words:
        cand = word if not cur else cur + ' ' + word
        box = draw.textbbox((0,0), cand, font=font)
        if box[2] - box[0] <= width:
            cur = cand
        else:
            if cur: lines.append(cur)
            cur = word
    if cur: lines.append(cur)
    return lines


def clear_dir():
    if USER_FILE_DIR.exists():
        for p in USER_FILE_DIR.iterdir():
            if p.is_file(): p.unlink()
            else: shutil.rmtree(p)
    USER_FILE_DIR.mkdir(parents=True, exist_ok=True)


def normalize_item(item):
    return item if len(item) == 11 else item[:7] + item[8:]


def make_avatar(uid, _, __, name, filename, ___, ____, c1, c2):
    img = gradient((512,512), c1, c2).convert('RGBA')
    glow = Image.new('RGBA', img.size, (0,0,0,0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse((60,60,460,460), fill=(15,23,42,150))
    img.alpha_composite(glow.filter(ImageFilter.GaussianBlur(24)))
    d = ImageDraw.Draw(img)
    d.ellipse((88,88,424,424), fill=(255,255,255,36), outline=(255,255,255,120), width=4)
    d.ellipse((108,108,404,404), fill=(15,23,42,210))
    initials = ''.join(part[0] for part in name.split()[:2]).upper()
    d.text((256,232), initials, anchor='mm', font=load_font(148, True), fill=(248,250,252))
    d.text((256,400), name, anchor='mm', font=load_font(42, True), fill=(248,250,252))
    d.text((256,438), 'AIEN Seller', anchor='mm', font=load_font(22), fill=(226,232,240))
    img.convert('RGB').save(USER_FILE_DIR / filename, quality=95)


def draw_shape(draw, name, label, box, fill, accent):
    x1,y1,x2,y2 = box
    kind = name.lower()
    if 'headphone' in kind:
        draw.arc((x1+40,y1-80,x2-40,y2+30), start=200, end=340, fill=accent, width=18)
        draw.rounded_rectangle((x1+30,y1+150,x1+130,y2-10), radius=40, fill=fill)
        draw.rounded_rectangle((x2-130,y1+150,x2-30,y2-10), radius=40, fill=fill)
    elif 'watch' in kind:
        mid_x = (x1+x2)//2
        draw.rounded_rectangle((mid_x-42,y1-80,mid_x+42,y1+30), radius=30, fill=accent)
        draw.rounded_rectangle((mid_x-42,y2-30,mid_x+42,y2+80), radius=30, fill=accent)
        draw.rounded_rectangle(box, radius=46, fill=fill, outline=accent, width=8)
        draw.rounded_rectangle((x1+24,y1+24,x2-24,y2-24), radius=28, fill='#0f1725')
    elif 'guitar' in kind:
        mid_x = (x1+x2)//2
        draw.ellipse((x1+40,y1+140,mid_x+40,y2), fill=fill)
        draw.ellipse((mid_x-30,y1+70,x2-60,y2-30), fill=fill)
        draw.rectangle((mid_x+10,y1-20,mid_x+70,y1+260), fill=accent)
    elif 'bike' in kind:
        draw.ellipse((x1,y2-140,x1+150,y2+10), outline=accent, width=14)
        draw.ellipse((x2-150,y2-140,x2,y2+10), outline=accent, width=14)
        draw.line((x1+75,y2-65,x1+190,y2-160,x2-120,y2-70,x1+75,y2-65), fill=fill, width=14)
    elif 'camera' in kind or 'gopro' in kind or 'instax' in kind:
        draw.rounded_rectangle(box, radius=36, fill=fill)
        draw.rounded_rectangle((x1+120,y1-40,x1+240,y1+40), radius=18, fill=fill)
        draw.ellipse((x1+150,y1+70,x2-150,y2-70), fill='#111827', outline=accent, width=8)
        draw.ellipse((x1+210,y1+130,x2-210,y2-130), fill=accent)
    elif 'drone' in kind:
        draw.rounded_rectangle((x1+170,y1+210,x2-170,y2-80), radius=40, fill=fill, outline=accent, width=6)
        draw.line((x1+120,y1+250,x1+240,y1+360), fill=accent, width=12)
        draw.line((x2-120,y1+250,x2-240,y1+360), fill=accent, width=12)
        draw.line((x1+120,y2-180,x1+240,y2-70), fill=accent, width=12)
        draw.line((x2-120,y2-180,x2-240,y2-70), fill=accent, width=12)
        for cx, cy in [(x1+100,y1+220),(x2-100,y1+220),(x1+100,y2-160),(x2-100,y2-160)]:
            draw.ellipse((cx-44, cy-44, cx+44, cy+44), outline=accent, width=10)
    elif 'keyboard' in kind:
        draw.rounded_rectangle(box, radius=28, fill=fill, outline=accent, width=6)
        cols, rows = 8, 4
        cell_w = (x2 - x1 - 60) / cols
        cell_h = (y2 - y1 - 46) / rows
        for row in range(rows):
            for col in range(cols):
                rx1 = x1 + 28 + col * cell_w
                ry1 = y1 + 18 + row * cell_h
                draw.rounded_rectangle((rx1, ry1, rx1 + cell_w - 10, ry1 + cell_h - 10), radius=10, fill='#0e1525')
    elif 'backpack' in kind or 'jacket' in kind:
        draw.arc((x1+60,y1-40,x2-60,y1+180), start=200, end=340, fill=accent, width=18)
        draw.rounded_rectangle((x1+60,y1+80,x2-60,y2), radius=90, fill=fill)
    elif 'tent' in kind:
        draw.polygon([(x1+20,y2),((x1+x2)//2,y1),(x2-20,y2)], fill=fill)
        draw.line(((x1+x2)//2,y1,(x1+x2)//2,y2), fill=accent, width=10)
    elif 'table' in kind:
        draw.rounded_rectangle((x1,y1,x2,y1+90), radius=18, fill=fill)
        for dx in [40,150,260,370]:
            draw.rectangle((x1+dx,y1+90,x1+dx+22,y2), fill=accent)
    elif 'chair' in kind:
        draw.rounded_rectangle((x1+90,y1,x2-90,y1+210), radius=60, fill=fill)
        draw.rounded_rectangle((x1+120,y1+170,x2-120,y1+260), radius=28, fill=fill)
        draw.line((x1+160,y1+260,x1+120,y2), fill=accent, width=12)
        draw.line((x2-160,y1+260,x2-120,y2), fill=accent, width=12)
    elif 'lamp' in kind:
        mid_x = (x1+x2)//2
        draw.polygon([(mid_x-140,y1+20),(mid_x+140,y1+20),(mid_x+70,y1+190),(mid_x-70,y1+190)], fill=fill)
        draw.rectangle((mid_x-10,y1+190,mid_x+10,y2-30), fill=accent)
    elif 'monitor' in kind or 'projector' in kind:
        draw.rounded_rectangle((x1,y1,x2,y2-80), radius=24, fill=fill, outline=accent, width=6)
        draw.rounded_rectangle((x1+28,y1+24,x2-28,y2-108), radius=16, fill='#101827')
        mid_x = (x1+x2)//2
        draw.rectangle((mid_x-22,y2-80,mid_x+22,y2-10), fill=accent)
    elif 'kettle' in kind or 'coffee' in kind or 'nesspresso' in kind or 'aeropress' in kind:
        draw.rounded_rectangle((x1+70,y1+30,x2-70,y2), radius=110, fill=fill)
        draw.arc((x2-140,y1+80,x2+20,y1+240), start=250, end=110, fill=accent, width=18)
    elif 'speaker' in kind:
        draw.rounded_rectangle(box, radius=42, fill=fill, outline=accent, width=6)
        draw.ellipse((x1+90,y1+100,x2-90,y1+360), fill='#0f1725', outline=accent, width=5)
        draw.ellipse((x1+150,y1+430,x2-150,y2-70), fill='#111827', outline=(255,255,255), width=4)
    elif 'power bank' in kind:
        draw.rounded_rectangle((x1+70,y1+100,x2-70,y2-40), radius=44, fill=fill, outline=accent, width=6)
        draw.rounded_rectangle((x1+160,y1+160,x2-160,y1+240), radius=16, fill='#0f1725')
        draw.rectangle((x2-140,y1+200,x2-70,y1+240), fill=accent)
    elif 'controller' in kind:
        draw.rounded_rectangle((x1+70,y1+210,x2-70,y2-80), radius=120, fill=fill, outline=accent, width=6)
        draw.ellipse((x1+170,y1+300,x1+250,y1+380), fill='#0f1725')
        draw.ellipse((x2-250,y1+300,x2-170,y1+380), fill='#0f1725')
        draw.ellipse((x2-220,y1+230,x2-180,y1+270), fill=accent)
        draw.ellipse((x2-170,y1+280,x2-130,y1+320), fill=accent)
    elif 'streamcam' in kind or 'webcam' in kind:
        draw.rounded_rectangle((x1+120,y1+180,x2-120,y2-120), radius=48, fill=fill, outline=accent, width=6)
        draw.ellipse((x1+210,y1+260,x2-210,y2-180), fill='#111827', outline=accent, width=8)
        draw.ellipse((x1+225,y1+300,x2-225,y2-220), fill=accent)
        draw.rectangle((x1+190,y2-120,x2-190,y2-40), fill=accent)
    elif 'monitor arm' in kind:
        draw.line((x1+150,y2-40,x1+150,y1+120), fill=accent, width=18)
        draw.line((x1+150,y1+180,x1+420,y1+240), fill=fill, width=20)
        draw.line((x1+420,y1+240,x2-110,y1+180), fill=fill, width=18)
        draw.rounded_rectangle((x2-170,y1+120,x2-40,y2-120), radius=24, fill='#101827', outline=accent, width=6)
    elif 'grinder' in kind:
        draw.rounded_rectangle((x1+120,y1+170,x2-120,y2), radius=50, fill=fill, outline=accent, width=6)
        draw.rounded_rectangle((x1+180,y1+60,x2-180,y1+220), radius=28, fill='#d8dde7')
        draw.rectangle((x1+220,y2-120,x2-220,y2-70), fill='#111827')
    elif 'turntable' in kind:
        draw.rounded_rectangle((x1+40,y1+110,x2-40,y2-50), radius=20, fill=fill, outline=accent, width=6)
        draw.ellipse((x1+150,y1+210,x2-180,y2-120), fill='#111827', outline=accent, width=6)
        draw.line((x2-210,y1+170,x2-120,y1+290), fill=accent, width=10)
    elif 'bottle' in kind or 'tumbler' in kind:
        draw.rounded_rectangle((x1+190,y1+80,x2-190,y2), radius=90, fill=fill, outline=accent, width=6)
        draw.rounded_rectangle((x1+240,y1+20,x2-240,y1+120), radius=30, fill=accent)
    elif 'light kit' in kind or 'rgb light' in kind:
        draw.rounded_rectangle((x1+120,y1+160,x1+260,y2-80), radius=30, fill=fill, outline=accent, width=6)
        draw.rounded_rectangle((x2-260,y1+160,x2-120,y2-80), radius=30, fill=fill, outline=accent, width=6)
        draw.ellipse((x1+150,y1+260,x1+230,y1+340), fill=accent)
        draw.ellipse((x2-230,y1+260,x2-150,y1+340), fill='#f9a8d4')
    elif 'router' in kind:
        draw.rounded_rectangle((x1+70,y1+180,x2-70,y2-20), radius=40, fill=fill, outline=accent, width=6)
        for dx in [0, 80, 160]:
            draw.line((x1+130+dx,y1+180,x1+130+dx,y1+40), fill=accent, width=12)
        for px in [x1+170, x1+250, x1+330]:
            draw.ellipse((px-10, y2-120, px+10, y2-100), fill=accent)
    elif 'air fryer' in kind or 'air purifier' in kind:
        draw.rounded_rectangle(box, radius=80, fill=fill)
        draw.rounded_rectangle((x1+110,y1+120,x2-110,y2-70), radius=26, fill='#111827')
    elif 'book' in kind or 'dune' in kind or 'atomic habits' in kind or 'design of everyday things' in kind or 'lego' in kind:
        draw.rounded_rectangle(box, radius=18, fill=fill)
        draw.rectangle((x1+26,y1,x1+64,y2), fill=accent)
        draw.rectangle((x1+110,y1+90,x2-80,y1+116), fill='#ffffff')
    elif 'ipad' in kind or 'kindle' in kind or 'boox' in kind or 'tablet' in kind:
        draw.rounded_rectangle(box, radius=30, fill=fill, outline=accent, width=6)
        draw.rounded_rectangle((x1+22,y1+22,x2-22,y2-22), radius=20, fill='#12192a')
    elif 'earbud' in kind:
        draw.ellipse((x1+110,y1+120,x1+280,y1+360), fill=fill, outline=accent, width=6)
        draw.rectangle((x1+210,y1+300,x1+250,y2-40), fill=fill)
        draw.ellipse((x2-280,y1+120,x2-110,y1+360), fill=fill, outline=accent, width=6)
        draw.rectangle((x2-250,y1+300,x2-210,y2-40), fill=fill)
    elif label == 1:
        draw.rounded_rectangle(box, radius=34, fill=fill, outline=accent, width=6)
        draw.rounded_rectangle((x1+26,y1+30,x2-26,y2-30), radius=24, fill='#101623')
    elif label == 2:
        draw.rounded_rectangle(box, radius=90, fill=fill)
        draw.rounded_rectangle((x1+110,y1+120,x2-110,y2-70), radius=26, fill='#111827')
    elif label == 3:
        draw.arc((x1+60,y1-40,x2-60,y1+180), start=200, end=340, fill=accent, width=18)
        draw.rounded_rectangle((x1+60,y1+80,x2-60,y2), radius=90, fill=fill)
    elif label == 4:
        draw.rounded_rectangle(box, radius=18, fill=fill)
        draw.rectangle((x1+26,y1,x1+64,y2), fill=accent)
        draw.rectangle((x1+110,y1+90,x2-80,y1+116), fill='#ffffff')
    else:
        draw.rounded_rectangle((x1,y1,x2,y1+90), radius=18, fill=fill)
        for dx in [40,150,260,370]:
            draw.rectangle((x1+dx,y1+90,x1+dx+22,y2), fill=accent)


def make_item_card(item, suffix):
    item = normalize_item(item)
    item_id, name, label, price, place, status, release_time, owner, details, c1, c2 = item
    seller_name = next((user[3] for user in USERS if user[0] == owner), f'Seller {owner}')
    status_text = 'Live Now' if status == 1 else 'Offline'
    img = gradient((1600,1200), c1, '#0B1020').convert('RGBA')
    d = ImageDraw.Draw(img)
    overlay = Image.new('RGBA', img.size, (0,0,0,0))
    od = ImageDraw.Draw(overlay)
    od.rounded_rectangle((74,74,1526,1126), radius=52, outline=(255,255,255,42), width=2)
    od.rounded_rectangle((110,118,1490,1082), radius=48, fill=(255,255,255,12))
    img.alpha_composite(overlay)
    shadow = Image.new('RGBA', img.size, (0,0,0,0))
    sd = ImageDraw.Draw(shadow)
    sd.ellipse((860, 740, 1380, 920), fill=(0, 0, 0, 125))
    img.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(34)))
    d.rounded_rectangle((120, 96, 250, 148), radius=18, fill=(255,255,255,22), outline=(255,255,255,55), width=2)
    d.text((142, 112), status_text.upper(), font=load_font(22, True), fill=(248,250,252), anchor='la')
    d.text((130,136), name, font=load_font(82, True), fill=(248,250,252), anchor='la')
    d.text((130,230), f'{place}  |  Category {label}', font=load_font(26, True), fill=(207,250,254), anchor='la')
    for i, line in enumerate(wrap(d, details, load_font(32), 560)[:4]):
        d.text((130,312 + i*48), line, font=load_font(32), fill=(226,232,240), anchor='la')
    d.rounded_rectangle((130,1000,380,1092), radius=26, fill=(15,23,42,200), outline=rgb(c2)+(180,), width=3)
    d.text((155,1027), 'ASK PRICE', font=load_font(26, True), fill=(148,163,184), anchor='la')
    d.text((155,1064), f'${price:.2f}', font=load_font(44, True), fill=(248,250,252), anchor='la')
    d.rounded_rectangle((820,180,1450,910), radius=58, fill=(255,255,255,18), outline=rgb(c2)+(130,), width=4)
    draw_shape(d, name, label, (880,230,1380,840), rgb(c1), rgb(c2))
    d.rounded_rectangle((130,882,430,950), radius=22, fill=(255,255,255,18), outline=(255,255,255,40), width=2)
    d.text((152,904), seller_name.upper(), font=load_font(22, True), fill=(148,163,184), anchor='la')
    d.text((152,934), 'Demo-ready curated listing', font=load_font(26, True), fill=(248,250,252), anchor='la')
    foot = 'AIEN demo image set' if suffix == 'detail' else 'Built for direct marketplace demos'
    d.rounded_rectangle((860,950,1260,1044), radius=24, fill=(15,23,42,210), outline=(255,255,255,36), width=2)
    d.text((1060,982), foot, anchor='mm', font=load_font(30), fill=(248,250,252))
    d.text((130,1128), 'AIEN curated demo inventory', font=load_font(26, True), fill=(148,163,184), anchor='la')
    img.convert('RGB').save(USER_FILE_DIR / f'item_{item_id}_{suffix}.png', quality=94)
def esc(value):
    if value is None: return 'NULL'
    if isinstance(value, int): return str(value)
    if isinstance(value, float): return f'{value:.2f}'
    return "'" + str(value).replace('\\', '\\\\').replace("'", "''") + "'"


def img_url(filename):
    return IMG_BASE + filename


def item_urls(item_id):
    return json.dumps([img_url(f'item_{item_id}_hero.png'), img_url(f'item_{item_id}_detail.png')])


def build_insert(table, rows, batch_size=200):
    statements = []
    for start in range(0, len(rows), batch_size):
        chunk = rows[start:start + batch_size]
        statements.append(
            f"INSERT INTO `{table}` VALUES " +
            ','.join('(' + ','.join(esc(v) for v in row) + ')' for row in chunk) +
            ';'
        )
    return '\n'.join(statements)


def replace_block(text, table, insert_sql):
    pattern = re.compile(rf"INSERT INTO `{table}` VALUES .*?(?=/\*!40000 ALTER TABLE `{table}` ENABLE KEYS \*/;)", re.S)
    out, n = pattern.subn(insert_sql, text, count=1)
    if n != 1:
        raise RuntimeError(f'Could not replace {table}')
    return out


def build_blocks():
    user_rows = [(u[0],u[1],u[2],u[3],img_url(u[4]),u[5],u[6]) for u in USERS]
    idle_rows = []
    for raw_item in ITEMS:
        i = normalize_item(raw_item)
        idle_rows.append((i[0], i[1], i[8], item_urls(i[0]), i[3], i[4], i[2], i[6], i[5], i[7]))
    return {
        'sh_address': ADDRESSES,
        'sh_admin': ADMINS,
        'sh_favorite': FAVORITES,
        'sh_idle_item': idle_rows,
        'sh_message': MESSAGES,
        'sh_order': ORDERS,
        'sh_order_address': ORDER_ADDRESS,
        'sh_user': user_rows,
    }


def apply_blocks_to_db(blocks):
    statements = [
        'SET FOREIGN_KEY_CHECKS=0;',
        'DELETE FROM sh_order_address;',
        'DELETE FROM sh_order;',
        'DELETE FROM sh_message;',
        'DELETE FROM sh_favorite;',
        'DELETE FROM sh_address;',
        'DELETE FROM sh_idle_item;',
        'DELETE FROM sh_admin;',
        'DELETE FROM sh_user;'
    ]
    insert_order = [
        'sh_user',
        'sh_admin',
        'sh_address',
        'sh_idle_item',
        'sh_favorite',
        'sh_message',
        'sh_order',
        'sh_order_address'
    ]
    for table in insert_order:
        rows = blocks[table]
        statements.append(build_insert(table, rows, batch_size=200))
    statements.append('SELECT COUNT(*), MIN(id), MAX(id) FROM sh_idle_item;')
    statements.append('SELECT COUNT(*) FROM sh_message;')
    statements.append('SELECT COUNT(*) FROM sh_order;')
    statements.append('SELECT COUNT(*) FROM sh_favorite;')
    statements.append('SET FOREIGN_KEY_CHECKS=1;')
    sql = '\n'.join(statements).encode('utf-8')
    proc = subprocess.run([MYSQL_BIN, '-uroot', MYSQL_DB], input=sql, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    output = proc.stdout.decode('utf-8', 'ignore')
    if proc.returncode != 0:
        raise RuntimeError(f'Database refresh failed:\n{output}')
    print('Applied demo data directly to MySQL')
    print(output.strip())


def main():
    clear_dir()
    for user in USERS:
        make_avatar(*user)
    for item in ITEMS:
        make_item_card(item, 'hero')
        make_item_card(item, 'detail')

    blocks = build_blocks()
    text = SQL_PATH.read_text(encoding='utf-8')
    for table, rows in blocks.items():
        text = replace_block(text, table, build_insert(table, rows, batch_size=200))
    SQL_PATH.write_text(text, encoding='utf-8')
    print('Generated demo assets and updated second_hand_trading.sql')
    if '--apply-db' in sys.argv:
        apply_blocks_to_db(blocks)


if __name__ == '__main__':
    main()
