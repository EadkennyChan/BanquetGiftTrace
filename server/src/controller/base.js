// const Moment = require('moment');

module.exports = class extends think.Controller {
  actionModel() {
    const action = this.model('user_action');
    action.deviceInfo = this.header('deviceInfo');
    action.userName = this.header('token');
    return action;
  }

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

  async getList(modelName, whereMapKey) {
    const model = this.model(modelName);

    const currentPage = this.get('currentPage') || 1;
    const pageSize = this.get('pageSize') || 20;
    const keyword = this.get('keyword');
    let res;
    if (think.isEmpty(keyword)) {
      res = await model.page(currentPage, pageSize).countSelect();
    } else {
      const whereMap = {};
      whereMapKey && whereMapKey.forEach && whereMapKey.forEach(key => {
        whereMap[key] = ['like', `%${keyword}%`];
      });
      res = await model.where(whereMap).page(currentPage, pageSize).countSelect();
    }

    res && res.data && res.data.forEach(item => {
      delete item.deleted;
      return item;
    })
    
    const pagination = {...res};
    delete pagination.data;
    return {pagination, list: res.data};
  }
};
