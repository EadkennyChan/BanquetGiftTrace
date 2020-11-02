const Base = require('./base.js');

module.exports = class extends Base {
  async listAction() {
    const datas = await this.getList('gift', ['name']);
    const actionModel = this.actionModel();
    actionModel.type = 'getGiftList'
    await actionModel.actionSuccess('获取回礼列表成功');
    return this.success(datas);
  }
  async addAction() {

  }
};
