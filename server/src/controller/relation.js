const Base = require('./base.js');

module.exports = class extends Base {
  async listAction() {
    const datas = await this.getList('relation', ['name']);
    const actionModel = this.actionModel();
    actionModel.type = 'getRelationList'
    await actionModel.actionSuccess('获取关系列表成功');
    return this.success(datas);
  }
  async addAction() {

  }
};
