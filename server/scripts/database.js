const mysql = require('mysql');
const isDev = process.env && process.env.NODE_ENV != 'production'
const dbConfig = isDev ? require('../src/config/db.js') : require('../src/config/db.production.js');

console.log('isDev = ', isDev, process.env.NODE_ENV);
delete dbConfig.handle;
delete dbConfig.database;

const handler = (() => {
  let connection;
  function handleError(err) {
    if (err) {
      // 如果是连接断开，自动重新连接
      if (err.code === 'PROTOCOL_CONNECTION_LOST') {
        connection.connect();
      } else {
        console.error(err.stack || err);
      }
    }
  }
  const open = () => {
    console.log('open database');
    connection = mysql.createConnection(dbConfig);
    connection.connect(handleError);
    connection.on('error', handleError);
  }
  const close = () => {
    if (connection) {
      console.log('database closed');
      connection.end();
      connection = null;
    }
  }
  const excuteSql = async sql => {
    return new Promise((resolve, reject) => {
      connection.query(sql, function (error, results) {
        if (error) {
          handleError(error);
          reject(error);
        } else {
          resolve(results);
        }
      });
    })
    .catch(error => {
      console.log('error = ', error);
    });
  }
  open();
  return {
    open,
    close,
    excuteSql
  }
})();

module.exports = handler;