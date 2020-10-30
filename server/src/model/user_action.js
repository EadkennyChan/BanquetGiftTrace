const moment  = require('moment');

module.exports = class extends think.Model {
  constructor(modelName = '', config = {}) {
    super(modelName, config);
    this.data = {};
    this.data.date = moment().format('YYYY-MM-DD HH:mm:ss');
  }
  set deviceInfo(value) {
    if (think.isEmpty(value)) {
      this.data.device_info = '';
    } else {
      this.data.device_info = JSON.stringify(value);
    }
  }
  set userName(value) {
    this.data.user_name = value;
  }
  set type(value) {
    this.data.type = value;
  }
  // userName
  // deviceInfo
  async userAccountIsNotExist() {
    this.data.msg = '账户不存在';
    this.data.result = 0;
    await this.add(this.data);
  }
  async userPasswordFail() {
    this.data.msg = '密码错误';
    this.data.result = 0;
    await this.add(this.data);
  }
  async userDisabled() {
    this.data.msg = '用户被禁用';
    this.data.result = 0;
    await this.add(this.data);
  }
  async actionFail(msg) {
    msg && (this.data.msg = msg);
    this.data.result = 0;
    await this.add(this.data);
  }
  async actionSuccess(msg) {
    msg && (this.data.msg = msg);
    this.data.result = 1;
    await this.add(this.data);
  }
};
