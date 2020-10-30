module.exports = class extends think.Logic {
  loginAction() {
    this.allowMethods = 'post';
    const account = this.post('name');
    const password = this.post('password');
    if (!account || !password || account.length > 64 || password.length > 64) {
      return this.fail(500, "请输入正确的用户名或密码")
    }
  }
  getUserInfoAction() {
    const token = this.header('token');
    if (think.isEmpty(token)) {
      return this.fail(500, "请先登录");      
    }
  }
};
