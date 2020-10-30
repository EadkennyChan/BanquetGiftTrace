module.exports = class extends think.Model {
  async getList(currentPage = 1, pageSize = 20, keyword, whereMapKey) {
    let res;
    if (think.isEmpty(keyword)) {
      res = await this.page(currentPage, pageSize).countSelect();
    } else {
      const whereMap = {};
      whereMapKey.forEach && whereMapKey.forEach(key => {
        whereMap[key] = ['like', `%${keyword}%`];
      });
      res = await this.where(whereMap).page(currentPage, pageSize).countSelect();
    }
    const pagination = {...res};
    delete pagination.data;
    return {pagination, list: res.data};
  }
};
