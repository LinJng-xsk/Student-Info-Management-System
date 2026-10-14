-- ============================================================
-- 学生信息管理系统 - 优化版建库脚本
-- 优化点：
--   1. 密码字段改 varchar(60)，支持 BCrypt 加密
--   2. student_course_teacher 改为引用 ctid，消除冗余 cid/tid/term
--   3. grade 改 DECIMAL(4,1)，避免 float 精度问题
--   4. 所有表加审计字段：create_time / update_time / deleted
--   5. 加联合索引，覆盖高频查询
--       原因：初始密码仍是明文 123456，启动 SpringBoot 后跑一次
--       PasswordInitRunner 会自动把所有明文密码 BCrypt 加密
-- ============================================================

DROP DATABASE IF EXISTS `student_info_manager`;
CREATE DATABASE `student_info_manager` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `student_info_manager`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. course 课程表
-- ----------------------------
CREATE TABLE `course` (
  `cid`        INT NOT NULL AUTO_INCREMENT,
  `cname`      VARCHAR(30) NOT NULL COMMENT '课程名',
  `ccredit`    TINYINT COMMENT '学分',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`    TINYINT DEFAULT 0 COMMENT '逻辑删除 0未删1已删',
  PRIMARY KEY (`cid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

INSERT INTO `course` (`cid`, `cname`, `ccredit`) VALUES
(7,  '数据结构与算法',     6),
(8,  '离散数学',           3),
(9,  '计算机网络',         5),
(10, '计算机组成原理',     5),
(11, 'Java程序设计',      10),
(12, '数据库原理',         4),
(13, '操作系统',           5),
(14, '软件工程',           3),
(15, '编译原理',           4),
(16, '概率论与数理统计',   3),
(17, '线性代数',           3);

-- ----------------------------
-- 2. teacher 教师表（密码 varchar(60)）
-- ----------------------------
CREATE TABLE `teacher` (
  `tid`        INT NOT NULL AUTO_INCREMENT,
  `tname`      VARCHAR(30) NOT NULL COMMENT '教师姓名',
  `password`   VARCHAR(60) NOT NULL COMMENT 'BCrypt加密后的密码',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`    TINYINT DEFAULT 0,
  PRIMARY KEY (`tid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- 初始密码仍是明文，启动后由 PasswordInitRunner 自动加密
INSERT INTO `teacher` (`tid`, `tname`, `password`) VALUES
(1,  'admin', '123456'),
(4,  '张三', '123456'),
(13, '李四', '123456'),
(14, '王五', '123456'),
(15, '赵六', '123456'),
(16, '钱七', '123456'),
(17, '孙八', '123456');

-- ----------------------------
-- 3. student 学生表（密码 varchar(60)）
-- ----------------------------
CREATE TABLE `student` (
  `sid`        INT NOT NULL AUTO_INCREMENT,
  `sname`      VARCHAR(30) NOT NULL COMMENT '学生姓名',
  `password`   VARCHAR(60) NOT NULL COMMENT 'BCrypt加密后的密码',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`    TINYINT DEFAULT 0,
  PRIMARY KEY (`sid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

INSERT INTO `student` (`sid`, `sname`, `password`) VALUES
(1,  '陈小明', '123456'),
(2,  '张小四', '123456'),
(3,  '李小四', '123456'),
(4,  '彭小辉', '123456'),
(6,  '林小霞', '123456'),
(7,  '董小超', '123456'),
(8,  '王二小', '123456'),
(9,  '张小千', '123456'),
(10, '李小万', '123456'),
(14, '陈小柳', '123456'),
(21, '庄小亮', '123456'),
(22, '钟小平', '123456'),
(23, '李小豪', '123456'),
(24, '周杰',   '123456'),
(25, '吴磊',   '123456'),
(26, '郑爽',   '123456'),
(27, '冯琳',   '123456'),
(28, '陈俊杰', '123456'),
(29, '褚亮',   '123456'),
(30, '卫青',   '123456'),
(31, '蒋欣怡', '123456'),
(32, '沈腾',   '123456'),
(33, '韩梅梅', '123456'),
(34, '杨柳',   '123456'),
(35, '黄子韬', '123456');

-- ----------------------------
-- 4. course_teacher 开课表
-- ----------------------------
CREATE TABLE `course_teacher` (
  `ctid`       INT NOT NULL AUTO_INCREMENT,
  `cid`        INT NOT NULL,
  `tid`        INT NOT NULL,
  `term`       VARCHAR(30) NOT NULL COMMENT '学期，如 2025上学期',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`    TINYINT DEFAULT 0,
  PRIMARY KEY (`ctid`) USING BTREE,
  -- 联合索引：高频按 (cid,tid,term) 查某次开课
  INDEX `idx_cid_tid_term` (`cid`, `tid`, `term`) USING BTREE,
  CONSTRAINT `ct_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `course` (`cid`),
  CONSTRAINT `ct_ibfk_2` FOREIGN KEY (`tid`) REFERENCES `teacher` (`tid`)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- 2024 上学期
INSERT INTO `course_teacher` (`ctid`, `cid`, `tid`, `term`) VALUES
(10, 7,  4,  '2024上学期'),
(11, 8,  13, '2024上学期');
-- 2024 下学期
INSERT INTO `course_teacher` (`ctid`, `cid`, `tid`, `term`) VALUES
(12, 9,  4,  '2024下学期'),
(13, 10, 13, '2024下学期'),
(14, 12, 14, '2024下学期');
-- 2025 上学期
INSERT INTO `course_teacher` (`ctid`, `cid`, `tid`, `term`) VALUES
(5,  8,  4,  '2025上学期'),
(6,  7,  4,  '2025上学期'),
(7,  10, 13, '2025上学期'),
(8,  9,  13, '2025上学期'),
(9,  11, 4,  '2025上学期'),
(15, 13, 15, '2025上学期'),
(16, 14, 16, '2025上学期'),
(21, 8,  13, '2025上学期');   -- 李四开离散数学
-- 2025 下学期
INSERT INTO `course_teacher` (`ctid`, `cid`, `tid`, `term`) VALUES
(17, 11, 17, '2025下学期'),
(18, 15, 4,  '2025下学期'),
(19, 16, 13, '2025下学期'),
(20, 17, 14, '2025下学期');

-- ----------------------------
-- 5. student_course_teacher 选课成绩表（优化版：只存 ctid + sid）
-- ----------------------------
CREATE TABLE `student_course_teacher` (
  `sctid`      INT NOT NULL AUTO_INCREMENT,
  `ctid`       INT NOT NULL COMMENT '关联哪次开课',
  `sid`        INT NOT NULL COMMENT '学生',
  `grade`      DECIMAL(4,1) COMMENT '成绩，0.0~100.0',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`    TINYINT DEFAULT 0,
  PRIMARY KEY (`sctid`) USING BTREE,
  -- 联合索引：查"我这学期选了什么课"
  INDEX `idx_sid_ctid` (`sid`, `ctid`) USING BTREE,
  -- 联合索引：查"这门课谁选了/成绩排序"
  INDEX `idx_ctid_grade` (`ctid`, `grade`) USING BTREE,
  CONSTRAINT `sct_ibfk_1` FOREIGN KEY (`sid`)  REFERENCES `student` (`sid`),
  CONSTRAINT `sct_ibfk_2` FOREIGN KEY (`ctid`) REFERENCES `course_teacher` (`ctid`)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- 原有数据（ctid 对应 course_teacher.ctid）
INSERT INTO `student_course_teacher` (`sctid`, `ctid`, `sid`, `grade`) VALUES
(10, 5,  2,  1.0),
(11, 7,  2,  NULL),
(12, 6,  2,  NULL),
(13, 5,  4,  10.0),
(14, 6,  4,  NULL),
(15, 7,  4,  NULL),
(17, 5,  1,  59.0);

-- 新增数据
INSERT INTO `student_course_teacher` (`sctid`, `ctid`, `sid`, `grade`) VALUES
-- 学生 1 陈小明
(18, 6,  1,  88.0),
(19, 8,  1,  NULL),
(20, 15, 1,  76.0),
-- 学生 2 张小四
(21, 9,  2,  92.0),
(22, 15, 2,  58.0),
(23, 16, 2,  NULL),
-- 学生 4 彭小辉
(24, 8,  4,  95.0),
(25, 15, 4,  82.0),
-- 学生 24 周杰
(26, 6,  24, 67.0),
(27, 21, 24, 73.0),
(28, 9,  24, 85.0),
-- 学生 25 吴磊
(29, 6,  25, 55.0),
(30, 7,  25, 78.0),
(31, 15, 25, 91.0),
-- 学生 26 郑爽
(32, 21, 26, 89.0),
(33, 9,  26, NULL),
(34, 16, 26, 66.0),
-- 学生 27 冯琳
(35, 8,  27, 74.0),
(36, 7,  27, 81.0),
(37, 15, 27, 90.0),
-- 学生 28 陈俊杰
(38, 6,  28, 48.0),
(39, 9,  28, 77.0),
(40, 16, 28, NULL),
-- 学生 29 褚亮
(41, 21, 29, 93.0),
(42, 15, 29, 86.0),
-- 学生 30 卫青
(43, 7,  30, 62.0),
(44, 9,  30, 71.0),
-- 学生 31 蒋欣怡
(45, 6,  31, 84.0),
(46, 8,  31, 97.0),
(47, 16, 31, 88.0);

SET FOREIGN_KEY_CHECKS = 1;
