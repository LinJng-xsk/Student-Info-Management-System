package com.rabbiter.si.controller;

import com.rabbiter.si.entity.Teacher;
import com.rabbiter.si.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin("*")
@RequestMapping("/teacher")
public class TeacherController {

    @Autowired
    private TeacherService teacherService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @PostMapping("/addTeacher")
    public boolean addTeacher(@RequestBody Teacher teacher) {
        // 新增教师时密码也要加密再存
        teacher.setPassword(passwordEncoder.encode(teacher.getPassword()));
        return teacherService.save(teacher);
    }

    @PostMapping("/login")
    public boolean login(@RequestBody Teacher teacher) {
        System.out.println("正在验证教师登陆 " + teacher);
        Teacher t = teacherService.findById(teacher.getTid());
        System.out.println("数据库教师信息" + t);
        if (t == null) {
            return false;
        }
        return passwordEncoder.matches(teacher.getPassword(), t.getPassword());
    }

    @GetMapping("/findById/{tid}")
    public Teacher findById(@PathVariable("tid") Integer tid) {
        System.out.println("正在查询教师信息 By id " + tid);
        return teacherService.findById(tid);
    }

    @PostMapping("/findBySearch")
    public List<Teacher> findBySearch(@RequestBody Map<String, String> map) {
        return teacherService.findBySearch(map);
    }

    @GetMapping("/deleteById/{tid}")
    public boolean deleteById(@PathVariable("tid") int tid) {
        System.out.println("正在删除教师 tid：" + tid);
        return teacherService.deleteById(tid);
    }

    @PostMapping("/updateTeacher")
    public boolean updateTeacher(@RequestBody Teacher teacher) {
        System.out.println("更新 " + teacher);
        return teacherService.updateById(teacher);
    }
}
