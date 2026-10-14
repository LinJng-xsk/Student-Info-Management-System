package com.rabbiter.si.config;

import com.rabbiter.si.mapper.StudentMapper;
import com.rabbiter.si.mapper.TeacherMapper;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 项目启动时自动把明文密码(123456)升级成 BCrypt 加密
 * 只跑一次：判断密码长度=6 就加密，加密后是60位，下次启动跳过
 */
@Component
public class PasswordInitRunner implements CommandLineRunner {

    @Resource
    private StudentMapper studentMapper;

    @Resource
    private TeacherMapper teacherMapper;

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @Override
    public void run(String... args) {
        // 处理学生表
        List<Map<String, Object>> students = studentMapper.findAllPwd();
        for (Map<String, Object> s : students) {
            Object pwd = s.get("password");
            if (pwd != null && pwd.toString().length() == 6) {  // 明文密码长度=6
                String encoded = encoder.encode(pwd.toString());
                studentMapper.updatePwd((Integer) s.get("sid"), encoded);
                System.out.println("学生[" + s.get("sname") + "]密码已加密");
            }
        }
        // 处理教师表
        List<Map<String, Object>> teachers = teacherMapper.findAllPwd();
        for (Map<String, Object> t : teachers) {
            Object pwd = t.get("password");
            if (pwd != null && pwd.toString().length() == 6) {
                String encoded = encoder.encode(pwd.toString());
                teacherMapper.updatePwd((Integer) t.get("tid"), encoded);
                System.out.println("教师[" + t.get("tname") + "]密码已加密");
            }
        }
    }
}
