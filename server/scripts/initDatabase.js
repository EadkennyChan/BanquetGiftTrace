const fs = require('fs');
const dbHandler = require('./database');

const sqlFile = './config/handsel.sql';

const sqlText = fs.readFileSync(sqlFile, 'utf-8');
const arrSqls = sqlText.split(';\n').map(sql => {
  sql = sql.replace(/\n/g, '');
  sql = sql.replace(/----------------------------/g, '----------------------------\n')
  return sql;
});

console.log('init database');
arrSqls.forEach(sql => {
  sql && dbHandler.excuteSql(sql + ';');
});
console.log('init complete');


dbHandler.close();