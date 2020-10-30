module.exports = class extends think.Controller {
  async __before() {
    const isTokenValide = await this.isTokenValide();
    if (!isTokenValide) {
      return this.failNeedLogin();
    }
  }
  
  async isTokenValide() {
    const token = this.header('token');
    const isTokenValide = await this.model('user_token').isTokenValide(token);
    return isTokenValide;
  }

  failNeedLogin() {
    return this.fail(500, "无效token，请重新登录");
  }
  failCorrectAccountOrPassword() {
    return this.fail(500, "请输入正确的账户名或密码");
  }
  failAccountDisabled() {
    return this.fail(501, "该账户已被禁用");
  }

  __call() {
    return this.fail(404, "该接口不存在");
  }
};
