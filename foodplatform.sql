/*
 Navicat Premium Dump SQL

 Source Server         : stu
 Source Server Type    : MySQL
 Source Server Version : 80400 (8.4.0)
 Source Host           : localhost:3306
 Source Schema         : foodplatform

 Target Server Type    : MySQL
 Target Server Version : 80400 (8.4.0)
 File Encoding         : 65001

 Date: 12/06/2025 15:13:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for application
-- ----------------------------
DROP TABLE IF EXISTS `application`;
CREATE TABLE `application`  (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(100) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `shop_name` varchar(100) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `shop_location` varchar(255) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `shop_description` text CHARACTER SET utf16 COLLATE utf16_bin NULL,
  `image_path` varchar(255) CHARACTER SET utf16 COLLATE utf16_bin NULL DEFAULT NULL,
  `shop_category` enum('甜品饮品','米粉面条','炒菜盖饭','快餐小吃') CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `open_time` time NOT NULL,
  `close_time` time NOT NULL,
  `status` enum('pending','approved','rejected') CHARACTER SET utf16 COLLATE utf16_bin NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `rejection_reason` text CHARACTER SET utf16 COLLATE utf16_bin NULL,
  PRIMARY KEY (`application_id`) USING BTREE,
  INDEX `application_ibfk_1`(`user_name` ASC) USING BTREE,
  CONSTRAINT `application_ibfk_1` FOREIGN KEY (`user_name`) REFERENCES `user` (`user_name`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf16 COLLATE = utf16_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of application
-- ----------------------------
INSERT INTO `application` VALUES (45, '246', '云朵絮语', '北京三里屯太古里南区B1层', '现熬黑糖珍珠鲜奶+低卡燕麦慕斯，每日现做', '/uploads/shopImage/2025/06/12/818728bd-672d-4bfd-9dfe-dc9cb552bd6d.jpg', '甜品饮品', '09:00:15', '22:00:15', 'approved', '2025-06-12 01:07:26', NULL);
INSERT INTO `application` VALUES (46, '246', '椰林白浪', '广州天河区天环广场L218', '泰国椰青冰淇淋+斑斓叶冻撞奶，椰壳盛装超上镜。', '/uploads/shopImage/2025/06/12/bf252d02-5c90-430d-a3cf-e6385db46759.jpg', '甜品饮品', '11:40:05', '23:00:05', 'approved', '2025-06-12 01:12:27', NULL);
INSERT INTO `application` VALUES (47, '134', '雾山焙茶', '杭州西湖银泰D座1F', '现萃玉露茶拿铁+焙茶千层，配和风蕨饼三重奏。', '/uploads/shopImage/2025/06/12/b305c91a-3270-4087-9a61-2f61395fb94f.jpg', '甜品饮品', '15:00:00', '21:00:00', 'approved', '2025-06-12 01:18:41', NULL);
INSERT INTO `application` VALUES (48, '4644', '蜜窑', '成都宽窄巷子东入口右侧', '蜂巢蜜冰淇淋+桂花酒酿冻，可现场体验蜂蜜罐装。', '/uploads/shopImage/2025/06/12/d2e1eebc-0b28-4e4c-a46d-016e2eaa3168.jpg', '甜品饮品', '07:10:21', '19:10:21', 'approved', '2025-06-12 01:20:10', NULL);
INSERT INTO `application` VALUES (49, '254', '螺蛳仙生', '深圳华强北中航城君尚B1', '灵魂：每日现熬螺蛳汤+酸笋自由续，臭香暴击套餐。', '/uploads/shopImage/2025/06/12/6ea8aba6-7afc-49f4-af48-db4d2dda6586.jpg', '米粉面条', '09:15:26', '21:15:26', 'approved', '2025-06-12 14:19:02', NULL);
INSERT INTO `application` VALUES (50, '789', '面壁者', '重庆观音桥北城天街X馆', '传统竹升压面+鲜虾云吞，可观摩师傅甩面表演。', '/uploads/shopImage/2025/06/12/94e65d2b-c226-43a6-b497-83f50711087c.jpg', '米粉面条', '10:10:52', '23:10:52', 'approved', '2025-06-12 14:20:48', NULL);
INSERT INTO `application` VALUES (51, '789', '牦牛骨舞', '丽江古城四方街7号院', '特色：牦牛骨8小时慢炖汤+青稞面，配酥油茶小食。', '/uploads/shopImage/2025/06/12/5366062d-7bcc-485c-806c-816571dff1a4.jpg', '米粉面条', '07:20:59', '19:20:59', 'approved', '2025-06-12 14:21:40', NULL);
INSERT INTO `application` VALUES (52, '5656', '辣度失控', '武汉江汉路步行街中心', '魔鬼辣子鸡+双椒兔丁，提供免辣承诺书。', '/uploads/shopImage/2025/06/12/c0b85ca1-ca3b-48a0-a2cf-a6149457708d.jpg', '炒菜盖饭', '10:20:11', '23:20:11', 'approved', '2025-06-12 14:26:56', NULL);
INSERT INTO `application` VALUES (53, '343', '绿皮车记忆', '昆明火车北站旧址内', '汽锅鸡+老奶洋芋，服务员穿列车员制服。', '/uploads/shopImage/2025/06/12/a348511d-8b65-49ff-9193-bbbc76f04f9b.jpg', '炒菜盖饭', '10:27:25', '21:27:25', 'approved', '2025-06-12 14:28:05', NULL);
INSERT INTO `application` VALUES (54, '1323', '爆弹鸡排', '南京新街口地铁站15号口', '芝士瀑布鸡排+蜂蜜黄油炸鸡，提供防烫手套。', '/uploads/shopImage/2025/06/12/b70b0a8b-a7ec-49c1-8477-7fed30a70d9b.jpg', '快餐小吃', '10:40:47', '20:40:47', 'approved', '2025-06-12 14:41:26', NULL);

-- ----------------------------
-- Table structure for foodimage
-- ----------------------------
DROP TABLE IF EXISTS `foodimage`;
CREATE TABLE `foodimage`  (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int NULL DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf16 COLLATE utf16_bin NULL DEFAULT NULL,
  `image_path` varchar(255) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `price` decimal(10, 2) NULL DEFAULT NULL,
  `description` text CHARACTER SET utf16 COLLATE utf16_bin NULL,
  PRIMARY KEY (`image_id`) USING BTREE,
  INDEX `shop_id`(`shop_id` ASC) USING BTREE,
  CONSTRAINT `foodimage_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf16 COLLATE = utf16_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of foodimage
-- ----------------------------
INSERT INTO `foodimage` VALUES (17, 17, '琥珀云顶', '/uploads/foodImage/2025/06/12/b4fb1a9d-149a-4650-b31c-00d5059a75b7.jpg', 28.00, '每日现熬古法黑糖浆挂壁，手作木薯珍珠Q弹有嚼劲，搭配冷藏鲜牛乳撞出大理石纹路，顶部撒现烤焦糖脆片，建议先尝顶层焦香再搅匀饮用。');
INSERT INTO `foodimage` VALUES (18, 17, '燕麦暮色', '/uploads/foodImage/2025/06/12/c83d71b4-be07-4138-ad5e-8713f48d166c.jpg', 35.00, '48小时冷萃埃塞俄比亚咖啡基底，融入现打燕麦奶盖，杯壁涂抹海盐焦糖酱，随杯附赠现烤燕麦脆棒，可蘸取奶盖食用增加层次感。');
INSERT INTO `foodimage` VALUES (19, 17, '芋泥雪崩', '/uploads/foodImage/2025/06/12/b136f373-5945-4b20-988b-4ce4103ef16b.jpg', 38.00, '手工捶打芋泥铺满杯壁，注入现煮鲜牛乳触发雪崩效果，中心悬浮手工麻薯丸子，附赠迷你木槌可敲开顶部脆皮白巧，体验\"开凿雪山\"仪式感。');
INSERT INTO `foodimage` VALUES (20, 17, '桂雨酿心', '/uploads/foodImage/2025/06/12/e1ca5f70-a317-48dd-90f9-a0acc1a668d7.jpg', 32.00, '福建金桂现窨高山乌龙茶汤，加入手工醪糟与桂花蜜，顶部堆砌如云朵般的奶沫，插上可食用干桂花枝，建议搭配青梅果脯食用。');
INSERT INTO `foodimage` VALUES (21, 17, '雾凇玫瑰', '/uploads/foodImage/2025/06/12/667f64da-8f6a-4dfa-afe9-99e0d9bbb057.jpg', 30.00, '整朵洛神花与重瓣玫瑰低温冷泡12小时，杯壁用蜂蜜勾勒冰晶纹路，随杯赠送分子料理液氮玫瑰雪霜，倒入饮品时呈现\"雾凇消融\"视觉特效。');
INSERT INTO `foodimage` VALUES (22, 22, '银丝跃海', '/uploads/foodImage/2025/06/12/e775ffd0-0f04-465f-b0c3-61e109e621b6.jpg', 36.00, '手工竹升面如银丝弹牙，云吞裹整只鲜虾与蟹籽，汤底用大地鱼与猪骨熬制8小时，撒金蒜酥与韭黄，配师傅现场甩面表演券一张。');
INSERT INTO `foodimage` VALUES (23, 22, '龙须献瑞', '/uploads/foodImage/2025/06/12/16b1d2e9-0c2c-426e-921c-9ec734cfec5b.jpg', 48.00, '竹升面烫至恰到好处，淋现拆蟹粉与秃黄油，配姜醋碟与现焯菜心，碗底藏惊喜溏心蛋，需用筷子高挑拌匀食用。');
INSERT INTO `foodimage` VALUES (24, 22, '碧波游龙', '/uploads/foodImage/2025/06/12/6fa7c829-2563-4171-9f36-5f424a42ac38.jpg', 32.00, '清透鸡汤浮竹荪与枸杞，竹升面卧成\"龙脊\"状，配手工鱼丸与青菜，随餐附赠竹升面制作科普卡，扫码可观看非遗师傅纪录片。');

-- ----------------------------
-- Table structure for recommendation
-- ----------------------------
DROP TABLE IF EXISTS `recommendation`;
CREATE TABLE `recommendation`  (
  `recommendation_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `shop_name` varchar(100) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `title` varchar(255) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `shop_location` varchar(255) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `description` text CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`recommendation_id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `recommendation_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf16 COLLATE = utf16_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recommendation
-- ----------------------------
INSERT INTO `recommendation` VALUES (7, 28, '云朵絮语', '超绝的手工甜品坊', '北京三里屯太古里南区B1层', '主打现熬黑糖珍珠鲜奶与低卡燕麦慕斯，每日新鲜手作芋泥麻薯杯，搭配开放式空间设计，适合闺蜜小聚打卡。清新简约的装潢呼应健康理念，甜品控必冲！', '2025-06-12 01:46:53');
INSERT INTO `recommendation` VALUES (8, 37, '面壁者', '超赞的手工竹升面馆', '重庆观音桥北城天街X馆', '竹升面弹牙劲道，鲜虾云吞颗颗爆汁！看师傅甩面如舞，重庆必吃手工面馆！', '2025-06-12 14:48:00');

-- ----------------------------
-- Table structure for recommendation_image
-- ----------------------------
DROP TABLE IF EXISTS `recommendation_image`;
CREATE TABLE `recommendation_image`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `recommendation_id` int NULL DEFAULT NULL,
  `image_path` varchar(255) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `recommendation_id`(`recommendation_id` ASC) USING BTREE,
  CONSTRAINT `recommendation_image_ibfk_1` FOREIGN KEY (`recommendation_id`) REFERENCES `recommendation` (`recommendation_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf16 COLLATE = utf16_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recommendation_image
-- ----------------------------
INSERT INTO `recommendation_image` VALUES (9, 7, '/uploads/recommendationImage/2025/06/12/ad3914ff-2ec3-4ced-b5a2-b0acc2249a82.jpg', '2025-06-12 01:46:53');
INSERT INTO `recommendation_image` VALUES (10, 7, '/uploads/recommendationImage/2025/06/12/3805b7f6-609b-4351-8f6b-07f4cbf482cf.jpg', '2025-06-12 01:46:53');
INSERT INTO `recommendation_image` VALUES (11, 7, '/uploads/recommendationImage/2025/06/12/b151905d-9317-47c5-a0bb-76727ede63ff.jpg', '2025-06-12 01:46:53');
INSERT INTO `recommendation_image` VALUES (12, 8, '/uploads/recommendationImage/2025/06/12/cd182fbc-66db-4eec-803a-6e9c309fb337.jpg', '2025-06-12 14:48:00');
INSERT INTO `recommendation_image` VALUES (13, 8, '/uploads/recommendationImage/2025/06/12/fad26d43-619a-4474-9f51-a95ef6fd9fe2.jpg', '2025-06-12 14:48:00');
INSERT INTO `recommendation_image` VALUES (14, 8, '/uploads/recommendationImage/2025/06/12/2a84f048-ccdf-4e35-a3dc-bdcd270d32a0.jpg', '2025-06-12 14:48:00');

-- ----------------------------
-- Table structure for review
-- ----------------------------
DROP TABLE IF EXISTS `review`;
CREATE TABLE `review`  (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `shop_id` int NOT NULL,
  `content` text CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `rating` decimal(2, 1) NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`) USING BTREE,
  UNIQUE INDEX `unique_review`(`user_id` ASC, `shop_id` ASC) USING BTREE,
  INDEX `shop_id`(`shop_id` ASC) USING BTREE,
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `review_chk_1` CHECK (`rating` between 1 and 5)
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf16 COLLATE = utf16_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of review
-- ----------------------------
INSERT INTO `review` VALUES (6, 28, 20, '超级超级好吃！！！', 5.0, '2025-06-12 01:55:38');
INSERT INTO `review` VALUES (7, 28, 19, '挺一般的。', 3.0, '2025-06-12 02:00:08');
INSERT INTO `review` VALUES (8, 32, 20, '还不错。', 3.0, '2025-06-12 12:30:26');
INSERT INTO `review` VALUES (9, 31, 17, '100分！', 5.0, '2025-06-12 14:09:37');
INSERT INTO `review` VALUES (10, 34, 17, '哈哈哈哈哈哈哈哈哈哈，好！', 5.0, '2025-06-12 14:22:33');
INSERT INTO `review` VALUES (11, 37, 17, '五星好评', 5.0, '2025-06-12 14:43:27');
INSERT INTO `review` VALUES (12, 37, 21, '不好吃', 2.0, '2025-06-12 14:48:29');
INSERT INTO `review` VALUES (13, 37, 22, '一般', 3.0, '2025-06-12 14:48:40');
INSERT INTO `review` VALUES (14, 29, 24, '很辣', 4.0, '2025-06-12 14:49:37');
INSERT INTO `review` VALUES (15, 29, 22, '好吃', 5.0, '2025-06-12 14:50:28');

-- ----------------------------
-- Table structure for shop
-- ----------------------------
DROP TABLE IF EXISTS `shop`;
CREATE TABLE `shop`  (
  `shop_id` int NOT NULL AUTO_INCREMENT,
  `owner_name` varchar(100) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `shop_name` varchar(100) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `location` varchar(255) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `description` text CHARACTER SET utf16 COLLATE utf16_bin NULL,
  `image_path` varchar(255) CHARACTER SET utf16 COLLATE utf16_bin NULL DEFAULT 'default_shop.jpg',
  `category` enum('甜品饮品','米粉面条','炒菜盖饭','快餐小吃') CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `open_time` time NULL DEFAULT NULL,
  `close_time` time NULL DEFAULT NULL,
  `avg_rating` decimal(3, 2) NULL DEFAULT 0.00,
  `rating_count` int NULL DEFAULT 0,
  `total_rating` decimal(10, 2) NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`shop_id`) USING BTREE,
  INDEX `shop_ibfk_1`(`owner_name` ASC) USING BTREE,
  CONSTRAINT `shop_ibfk_1` FOREIGN KEY (`owner_name`) REFERENCES `user` (`user_name`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf16 COLLATE = utf16_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop
-- ----------------------------
INSERT INTO `shop` VALUES (17, '246', '云朵絮语', '北京三里屯太古里南区B1层', '现熬黑糖珍珠鲜奶+低卡燕麦慕斯，每日现做', '/uploads/shopImage/2025/06/12/818728bd-672d-4bfd-9dfe-dc9cb552bd6d.jpg', '甜品饮品', '09:00:15', '22:00:15', 5.00, 3, 15.00, '2025-06-12 01:20:27');
INSERT INTO `shop` VALUES (18, '246', '椰林白浪', '广州天河区天环广场L218', '泰国椰青冰淇淋+斑斓叶冻撞奶，椰壳盛装超上镜。', '/uploads/shopImage/2025/06/12/bf252d02-5c90-430d-a3cf-e6385db46759.jpg', '甜品饮品', '11:40:05', '23:00:05', 0.00, 0, 0.00, '2025-06-12 01:20:28');
INSERT INTO `shop` VALUES (19, '134', '雾山焙茶', '杭州西湖银泰D座1F', '现萃玉露茶拿铁+焙茶千层，配和风蕨饼三重奏。', '/uploads/shopImage/2025/06/12/b305c91a-3270-4087-9a61-2f61395fb94f.jpg', '甜品饮品', '15:00:00', '21:00:00', 3.00, 1, 3.00, '2025-06-12 01:20:29');
INSERT INTO `shop` VALUES (20, '4644', '蜜窑', '成都宽窄巷子东入口右侧', '蜂巢蜜冰淇淋+桂花酒酿冻，可现场体验蜂蜜罐装。', '/uploads/shopImage/2025/06/12/d2e1eebc-0b28-4e4c-a46d-016e2eaa3168.jpg', '甜品饮品', '07:10:21', '19:10:21', 3.67, 2, 8.00, '2025-06-12 01:20:30');
INSERT INTO `shop` VALUES (21, '254', '螺蛳仙生', '深圳华强北中航城君尚B1', '灵魂：每日现熬螺蛳汤+酸笋自由续，臭香暴击套餐。', '/uploads/shopImage/2025/06/12/6ea8aba6-7afc-49f4-af48-db4d2dda6586.jpg', '米粉面条', '09:15:26', '21:15:26', 2.00, 1, 2.00, '2025-06-12 14:28:39');
INSERT INTO `shop` VALUES (22, '789', '面壁者', '重庆观音桥北城天街X馆', '传统竹升压面+鲜虾云吞，可观摩师傅甩面表演。', '/uploads/shopImage/2025/06/12/94e65d2b-c226-43a6-b497-83f50711087c.jpg', '米粉面条', '10:10:52', '23:10:52', 4.33, 2, 8.00, '2025-06-12 14:28:41');
INSERT INTO `shop` VALUES (23, '789', '牦牛骨舞', '丽江古城四方街7号院', '特色：牦牛骨8小时慢炖汤+青稞面，配酥油茶小食。', '/uploads/shopImage/2025/06/12/5366062d-7bcc-485c-806c-816571dff1a4.jpg', '米粉面条', '07:20:59', '19:20:59', 0.00, 0, 0.00, '2025-06-12 14:28:42');
INSERT INTO `shop` VALUES (24, '5656', '辣度失控', '武汉江汉路步行街中心', '魔鬼辣子鸡+双椒兔丁，提供免辣承诺书。', '/uploads/shopImage/2025/06/12/c0b85ca1-ca3b-48a0-a2cf-a6149457708d.jpg', '炒菜盖饭', '10:20:11', '23:20:11', 4.00, 1, 4.00, '2025-06-12 14:28:44');
INSERT INTO `shop` VALUES (25, '343', '绿皮车记忆', '昆明火车北站旧址内', '汽锅鸡+老奶洋芋，服务员穿列车员制服。', '/uploads/shopImage/2025/06/12/a348511d-8b65-49ff-9193-bbbc76f04f9b.jpg', '炒菜盖饭', '10:27:25', '21:27:25', 0.00, 0, 0.00, '2025-06-12 14:28:45');
INSERT INTO `shop` VALUES (26, '1323', '爆弹鸡排', '南京新街口地铁站15号口', '芝士瀑布鸡排+蜂蜜黄油炸鸡，提供防烫手套。', '/uploads/shopImage/2025/06/12/b70b0a8b-a7ec-49c1-8477-7fed30a70d9b.jpg', '快餐小吃', '10:40:47', '20:40:47', 0.00, 0, 0.00, '2025-06-12 14:41:35');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `password` varchar(100) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `nick_name` varchar(50) CHARACTER SET utf16 COLLATE utf16_bin NOT NULL,
  `avatar` varchar(255) CHARACTER SET utf16 COLLATE utf16_bin NULL DEFAULT 'avatar0.jpg',
  `role` enum('customer','business') CHARACTER SET utf16 COLLATE utf16_bin NULL DEFAULT 'customer',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `business_status` enum('unapplied','applied','approved') CHARACTER SET utf16 COLLATE utf16_bin NULL DEFAULT 'unapplied',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`user_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf16 COLLATE = utf16_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (28, '246', '38db3aed920cf82ab059bfccbd02be6a', 'Jack', 'avatar0.jpg', 'business', '2025-06-12 00:35:30', 'unapplied');
INSERT INTO `user` VALUES (29, '123', '202cb962ac59075b964b07152d234b70', '爆爆龙', 'avatar2.jpg', 'customer', '2025-06-12 00:36:35', 'unapplied');
INSERT INTO `user` VALUES (30, '134', '02522a2b2726fb0a03bb19f2d8d9524d', '​​辣条真好吃​​', 'avatar0.jpg', 'business', '2025-06-12 01:17:00', 'unapplied');
INSERT INTO `user` VALUES (31, '4644', '30d411fdc0e6daf092a74354094359bb', '二氧化甜', 'avatar4.jpg', 'business', '2025-06-12 01:19:21', 'unapplied');
INSERT INTO `user` VALUES (32, '11111', 'b0baee9d279d34fa1dfd71aadb908c3f', '退堂鼓大师​​', 'avatar1.jpg', 'customer', '2025-06-12 12:29:56', 'unapplied');
INSERT INTO `user` VALUES (33, '254', 'c52f1bd66cc19d05628bd8bf27af3ad6', '我是个商家', 'avatar0.jpg', 'business', '2025-06-12 14:15:26', 'unapplied');
INSERT INTO `user` VALUES (34, '789', '68053af2923e00204c3ca7c6a3150cf7', '看瓜少年和猹', 'avatar3.jpg', 'business', '2025-06-12 14:19:52', 'unapplied');
INSERT INTO `user` VALUES (35, '5656', 'ae5eb824ef87499f644c3f11a7176157', '把酒祝东风', 'avatar0.jpg', 'business', '2025-06-12 14:23:10', 'unapplied');
INSERT INTO `user` VALUES (36, '343', '3ad7c2ebb96fcba7cda0cf54a2e802f5', '梦寄相思何人顾​​', 'avatar2.jpg', 'business', '2025-06-12 14:27:25', 'unapplied');
INSERT INTO `user` VALUES (37, '1323', '4671aeaf49c792689533b00664a5c3ef', '会撒尿的小鸡', 'avatar1.jpg', 'business', '2025-06-12 14:40:46', 'unapplied');

SET FOREIGN_KEY_CHECKS = 1;
