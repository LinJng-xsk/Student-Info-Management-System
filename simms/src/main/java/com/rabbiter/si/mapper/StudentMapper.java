package com.rabbiter.si.mapper;

import com.rabbiter.si.entity.Student;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * @Author: 
 */

@Mapper
@Repository
public interface StudentMapper {

    List<Student> findAll();

    Student findById(@Param("sid") Integer sid);

    List<Student> findBySearch(@Param("student") Student student, @Param("fuzzy") Integer fuzzy);

    boolean updateById(@Param("student") Student student);

    boolean save(@Param("student") Student student);

    boolean deleteById(@Param("sid") Integer sid);

    // StudentMapper.java
    @Select("SELECT sid, sname, password FROM student WHERE deleted = 0")
    List<Map<String, Object>> findAllPwd();

    @Update("UPDATE student SET password = #{pwd} WHERE sid = #{sid}")
    void updatePwd(@Param("sid") Integer sid, @Param("pwd") String pwd);




}
