const Base = require('./base.js');

module.exports = class extends Base {
  __before() {
  }
  async loginAction() {
    const name = this.post('name');
    const password = this.post('password');

    const userModel = this.model('user');
    let res = userModel.where({name, password});
    let userInfo = await res.getField('name, realname, email, mobile, disabled', true);
    const userActionModel = this.model('user_action');
    userActionModel.userName = name;
    userActionModel.deviceInfo = this.header('device_info');
    userActionModel.type = 'login';
    if (think.isEmpty(userInfo) || think.isEmpty(userInfo.name)) {
      res = userModel.where({name});
      userInfo = await res.getField('id, name', true);
      if (think.isEmpty(userInfo) || think.isEmpty(userInfo.name)) {
        userActionModel.userAccountIsNotExist();
      } else {
        userActionModel.userPasswordFail();
      }
      return this.failCorrectAccountOrPassword();
    }
    if (userInfo.disabled) {
      userActionModel.userDisabled();
      return this.failAccountDisabled();
    } else {
      userActionModel.actionSuccess('登录成功');
      const modelUserToken = this.model('user_token');
      const token = await modelUserToken.generateToken2Save(name);
      return this.success({...userInfo, token});
    }
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
