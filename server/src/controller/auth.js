const Base = require('./base.js');

module.exports = class extends Base {
  __before() {
  }
  async loginAction() {
    const name = this.post('name');
    const password = this.post('password');

    const userModel = this.model('user');

    const userActionModel = this.model('user_action');
    userActionModel.userName = name;
    userActionModel.deviceInfo = this.header('device_info');
    userActionModel.type = 'login';

    // 用户是否存在
    let res = await userModel.where({name}).getField('id, realname, email, mobile, disabled, password', true);
    if (think.isEmpty(res) || think.isEmpty(res.id)) {
      userActionModel.userAccountIsNotExist();
      return this.failCorrectAccountOrPassword();
      // return this.fail('用户不存在')
    } else if (res.disabled != '0') {
      userActionModel.userDisabled();
      return this.failAccountDisabled();
    } else if (res.password != password) {
      userActionModel.userPasswordFail();
      return this.failCorrectAccountOrPassword();
    }
    userActionModel.actionSuccess('登录成功');

    const modelUserToken = this.model('user_token');
    const token = await modelUserToken.generateToken2Save(name);
    delete res.password;
    delete res.disabled;
    return this.success({...res, token});
  }
  async getUserInfoAction() {
    const token = this.header('token');
    const modelUserToken = this.model('user_token');
    let res = modelUserToken.where({token, deleted:0});
    const userName = await res.getField('user_name', true);
    const userActionModel = this.model('user_action');
    userActionModel.deviceInfo = this.header('device_info');
    userActionModel.type = 'getUserInfo';
    if (think.isEmpty(userName)) {
      userActionModel.userName = token;
      userActionModel.actionFail('无效token');
      return this.failNeedLogin();
    }
    
    userActionModel.userName = userName;
    const isTokenValide = await modelUserToken.isTokenValide(token, userName);
    if (isTokenValide) {
      res = this.model('user').where({name: userName});
      const userInfo = await res.getField('name, realname, mobile, email, disabled', true);
      if (think.isEmpty(userInfo) || think.isEmpty(userInfo.name)) {
        userActionModel.actionFail('用户不存在');
        return this.fail(500, "该用户不存在");
      }
      userActionModel.actionSuccess('获取用户信息成功');
      return this.success({...userInfo, token});
    } else {
      userActionModel.actionFail('token失效');
      return this.failNeedLogin();
    }
  }
  async logoutAction() {
    const token = this.header('token');
    await this.model('user_token').deleteToken(token);
    return this.success();
  }

  async modifyPasswordAction() {
    if (await this.isTokenValide()) {

    }
    const token = this.header('token');
    const modelUserToken = this.model('user_token');
    let res = modelUserToken.where({token, deleted:0});
    const userName = await res.getField('user_name', true);
    if (think.isEmpty(user) || think.isEmpty(user.user_account)) {
      return this.failNeedLogin();
    }
    const isTokenValide = await modelUserToken.isTokenValide(token, user.user_account);
    if (isTokenValide) {
      res = this.model('user').where({account: user.user_account});
      const userInfo = await res.getField('name, account, figure_url, profile, enabled', true);
      if (think.isEmpty(userInfo) || think.isEmpty(userInfo.account)) {
        return this.fail(500, "该用户不存在");
      }
      return this.success({...userInfo, token});
    } else {
      return this.failNeedLogin();
    }
  }
};
