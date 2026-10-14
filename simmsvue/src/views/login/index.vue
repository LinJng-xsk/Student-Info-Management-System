<template>
  <div>
    <el-container>
      <el-header id="title">
        <span style="font-weight: bolder">
          学生信息管理系统
        </span>
      </el-header>
      <el-main style="display: flex; justify-content: center; align-items: center; min-height: calc(100vh - 60px); padding: 0;">
        <el-card style="width: 420px;">
          <div slot="header" class="clearfix" style="width: 100%;">
            <span style="text-align: center; font-size: 26px;">
              <p style="color: black;font-weight: bolder;font-size: larger;">登录</p>
            </span>
          </div>
          <div style="width: 95%;">
            <el-form :model="ruleForm" :rules="rules" ref="ruleForm" label-width="100px" class="login-info-wrapper"
              label-position="left">
              <el-form-item label="用户 id" prop="id" style="width: 85%;">
                <el-input v-model.number="ruleForm.id" prefix-icon="iconfont icon-r-user2"></el-input>
              </el-form-item>
              <el-form-item label="用户密码" prop="password" style="width: 85%;">
                <el-input v-model="ruleForm.password" placeholder="请输入密码" show-password
                  prefix-icon="iconfont icon-r-lock"></el-input>
              </el-form-item>
              <el-form-item label="登录角色" prop="type" style="width: 85%;">
                <el-radio-group v-model="ruleForm.type">
                  <el-radio label="student" value="student">学生</el-radio>
                  <el-radio label="teacher" value="teacher">老师</el-radio>
                  <el-radio label="admin" value="admin">管理员</el-radio>
                </el-radio-group>
              </el-form-item>
              <el-form-item class="btns-wrapper" style="width: 100%; text-align: center;">
                <el-button type="primary" @click="submitForm('ruleForm')">登录</el-button>
                <el-button @click="resetForm('ruleForm')" type="warning">重置</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-card>
      </el-main>
    </el-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      ruleForm: {
        id: null,
        password: null,
        type: null,
      },
      rules: {
        id: [
          { required: true, message: '请输入用户id', trigger: 'blur' },
          { type: 'number', message: '用户id只包含数字', trigger: 'blur' },
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ],
        type: [
          { required: true, message: '请选择用户类型', trigger: 'change' }
        ],
      }
    };
  },
  methods: {
    submitForm(formName) {
      const that = this
      this.$refs[formName].validate((valid) => {
        if (valid) {
          let check = false
          let name = null
          axios.get('http://localhost:9451/info/getCurrentTerm').then(function (resp) {
            sessionStorage.setItem("currentTerm", resp.data)
          })
          axios.get('http://localhost:9451/info/getForbidCourseSelection').then(function (resp) {
            sessionStorage.setItem("ForbidCourseSelection", resp.data)
          })
          if (that.ruleForm.type === 'admin' || that.ruleForm.type === 'teacher') {
            let form = { tid: that.ruleForm.id, password: that.ruleForm.password }
            axios.post("http://localhost:9451/teacher/login", form).then(function (resp) {
              check = resp.data
              if (check === true) {
                axios.get("http://localhost:9451/teacher/findById/" + that.ruleForm.id).then(function (resp) {
                  name = resp.data.tname
                  sessionStorage.setItem("token", 'true')
                  sessionStorage.setItem("type", that.ruleForm.type)
                  sessionStorage.setItem("name", name)
                  sessionStorage.setItem("tid", resp.data.tid)
                  if (that.ruleForm.type === 'admin' && name === 'admin') {
                    that.$message({ showClose: true, message: '登录成功，欢迎 ' + name + '!', type: 'success' });
                    that.$router.push('/admin')
                  } else if (that.ruleForm.type === 'teacher' && name !== 'admin') {
                    that.$message({ showClose: true, message: '登录成功，欢迎 ' + name + '!', type: 'success' });
                    that.$router.push('/teacher')
                  } else {
                    that.$message({ showClose: true, message: 'admin 登录失败，检查登录类型', type: 'error' });
                  }
                })
              } else {
                that.$message({ showClose: true, message: '登录失败，检查账号密码', type: 'error' });
              }
            })
          } else if (that.ruleForm.type === 'student') {
            let form = { sid: that.ruleForm.id, password: that.ruleForm.password }
            axios.post("http://localhost:9451/student/login", form).then(function (resp) {
              check = resp.data
              if (check === true) {
                axios.get("http://localhost:9451/student/findById/" + that.ruleForm.id).then(function (resp) {
                  name = resp.data.sname
                  sessionStorage.setItem("token", 'true')
                  sessionStorage.setItem("type", that.ruleForm.type)
                  sessionStorage.setItem("name", name)
                  sessionStorage.setItem("sid", resp.data.sid)
                  that.$message({ showClose: true, message: '登录成功，欢迎 ' + name + '!', type: 'success' });
                  that.$router.push({ path: '/' + that.ruleForm.type, query: {} })
                })
              } else {
                that.$message({ showClose: true, message: '您输入的账号或密码错误，请联系管理员找回账号。', type: 'error' });
              }
            })
          }
        } else {
          return false;
        }
      });
    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
  }
}
</script>

<style>
.el-header {
  background-color: black;
  color: #ffffff;
  line-height: 60px;
}
.login-info-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
}
.el-card__header {
  height: 20%;
  display: flex;
  flex-direction: row;
  align-items: center;
}
.el-card__body {
  height: 80%;
  flex-direction: column;
  align-items: center;
}
.btns-wrapper .el-form-item__content {
  margin: 0px !important;
  padding-right: 5px
}
.btns-wrapper button {
  margin: 0 20px;
}
#title {
  text-align: center;
  font-size: 25px;
}
</style>
