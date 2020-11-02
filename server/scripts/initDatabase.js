const fs = require('fs');
const dbHandler = require('./database');

const sqlFile = './config/handsel.sql';

const sqlText = fs.readFileSync(sqlFile, 'utf-8');
const arrSqls = [];

let tmpSql = '';
sqlText.split('\n').forEach(sql => {
  if (sql && sql.length > 0) {
    if (sql.indexOf('-- ') == -1) {
      tmpSql += sql;
      if (sql.indexOf(';') != -1) {
        arrSqls.push(tmpSql);
        tmpSql = '';
      }
    }
  }
});

(async () => {
  console.log('begin init database');
  let sqlTmp;
  for (let i in arrSqls) {
    sqlTmp = arrSqls[i];
    await dbHandler.excuteSql(sqlTmp);
  }
  // arrSqls.forEach(sql => {
  //   sql && dbHandler.excuteSql(sql + ';');
  // });
  console.log('end init complete');  
  dbHandler.close();  
})();
