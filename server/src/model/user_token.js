const jwt  = require('jsonwebtoken');
const moment  = require('moment');

module.exports = class extends think.Model {
  /* 创建token数据库表
  createTokenTable() {
    const sqlString = "CREATE TABLE IF NOT EXISTS `user_token`  ( \
      `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, \
      `token` varchar(255) NULL,  \
      `user_id` int NULL, \
      `user_account` varchar(64) NULL,  \
      `expire` datetime NULL, \
      `begin_date` datetime NULL, \
      `end_date` datetime NULL, \
      `deleted` char 0, \
      PRIMARY KEY (`id`)  \
    );"
    return this.execute(sqlString);
  }
  */
  // 生成token并保存到表中
  async generateToken2Save(account) {
    if (account && account.length > 0) {
      const token = jwt.sign({account}, account, {expiresIn:60*60*24*30});
      const datetime = moment().format('YYYY-MM-DD HH:mm:ss');

      await this.add({token, user_name: account, begin_date: datetime, deleted: 0});
      return token;
    }
  }
  async isTokenValide(token, account) {
    if (think.isEmpty(token)) {
      return false;
    }
    if (think.isEmpty(account)) {
      account = await this.where({token, deleted: 0}).getField('user_name', true);
    } else {
      account = await this.where({token, deleted: 0, user_name: account}).getField('user_name', true);
    }
    if (think.isEmpty(account)) {
      return false;
    }
    return new Promise(resolve => {
      jwt.verify(token, account, null, async (error, results) => {
        if (error) {
          resolve(false);
        } else {
          resolve(true);
        }
      });
    });
  }
  async deleteToken(token) {
    if (token) {
      const datetime = moment().format('YYYY-MM-DD HH:mm:ss');
      const res = await this.where({token}).update({deleted:1, end_date: datetime})
    }
  }

};
