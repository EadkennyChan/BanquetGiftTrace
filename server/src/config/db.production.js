const mysql = require('think-model-mysql');

module.exports = {
  handle: mysql,
  database: 'handsel_record',
  prefix: '',
  encoding: 'utf8',
  host: '106.14.14.130',
  port: '3306',
  user: 'root',
  password: '123456',
  dateStrings: true
};