# 🎓 Student-Info-Management-System

一套面向高校教务场景的选课与成绩管理平台，基于 **Spring Boot + MyBatis + Vue 2** 实现，覆盖学生选课、教师开课/录分、管理员师生与课程维护的完整业务闭环。

## 🛠️ 技术栈

**后端**
- Spring Boot 2.6.x
- MyBatis（XML 动态 SQL + 注解 SQL 混用）
- MySQL 8（utf8mb4）
- Maven

**前端**
- Vue 2.6 + Vue Router 3 + Vuex 3
- Element UI 2.x
- Axios

## ✨ 功能模块

系统按 3 个角色组织：

| 角色 | 主要功能 |
|---|---|
| 管理员 | 学生/教师/课程的增删改查、开课记录维护、按学期/分数段查询成绩 |
| 教师 | 按学期开课、查看自己开的课、录入/修改所授课程学生成绩 |
| 学生 | 浏览可选课程、选课/退课、按学期查询个人课表与成绩 |

核心业务实体：

- `student` 学生
- `teacher` 教师（含管理员账号）
- `course` 课程
- `course_teacher` 某学期某教师开某门课（开课表）
- `student_course_teacher` 学生选课记录及成绩（SCT 表）

通过 `term` 字段区分同一门课在不同学期的开课与历史成绩，避免跨学期数据互相覆盖。

## 📂 项目结构

```
.
├── simms/                        # 后端 Spring Boot 工程
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/rabbiter/si/
│       │   ├── controller/      # 6 个 REST 控制器
│       │   ├── service/         # 业务层
│       │   ├── mapper/          # MyBatis Mapper 接口
│       │   ├── entity/          # 实体类与联表 VO
│       │   └── common/          # 全局异常、启动配置
│       └── resources/
│           ├── application.yml
│           └── mapper/          # MyBatis XML
├── simmsvue/                     # 前端 Vue 2 工程
│   ├── package.json
│   ├── vue.config.js
│   └── src/
│       ├── views/Admin/         # 管理员页面
│       ├── views/Teacher/       # 教师页面
│       ├── views/Student/       # 学生页面
│       ├── views/login/         # 登录页
│       ├── router/              # 路由配置
│       ├── store/              # Vuex
│       └── plugins/            # axios / element-ui 封装
├── simmsql/                      # 数据库脚本
│   └── simmsql.sql
└── README.md
```

## 💻 环境要求

- JDK 8+
- Maven 3.6+
- Node.js 14+
- MySQL 8.x

## 🚀 快速启动

### 1. 🗄️ 初始化数据库

直接执行 SQL 脚本（脚本内已包含 `CREATE DATABASE`、删表/建表顺序调整、utf8mb4 编码）：

```bash
mysql -u root -p < simmsql/simmsql.sql
```

### 2. ☕ 启动后端

修改 `simms/src/main/resources/application.yml` 中的数据库账号密码：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/student_info_manager?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=utf8mb4
    username: root
    password: 你的密码

server:
  port: 9451
```

启动：

```bash
cd simms
mvn spring-boot:run
```

### 3. 🖥️ 启动前端

```bash
cd simmsvue
npm install
npm run serve
```

前端默认跑在 `[http://localhost:9452](http://localhost:9452)`，后端接口在 `[http://localhost:9451](http://localhost:9451)`。

## 👤 默认账号

| 角色 | 账号（ID） | 密码 |
|---|---|---|
| 管理员 | 1（tname = admin） | 123456 |
| 教师 | 4（张三） / 13（李四） | 123456 |
| 学生 | 1 ~ 23 中任意一个 | 123456 |

> 登录页需要手动选择身份类型（管理员 / 教师 / 学生）。

## 🔌 主要接口

后端共约 30 个 REST 接口，按模块划分：

- `/student/**` 学生管理与登录
- `/teacher/**` 教师管理与登录
- `/course/**` 课程管理
- `/courseTeacher/**` 开课管理
- `/SCT/**` 学生选课与成绩
- `/info/**` 当前学期、选课开关

查询接口统一支持多条件组合、精确/模糊切换、成绩分数段范围过滤。

### ©️ 版权声明

本项目为个人---LJ-XSK---设计作品，仅供在线查阅学习，禁止直接复制源码用于其他设计。
