const dbHandler = require('./database');

// const sql = 'SHOW TABLES';
// const getTables = async () => {
//   const tables = await dbHandler.excuteSql(sql);
//   tables.forEach(async table => {
//     const keys = Object.keys(table);
//     const name = table[keys[0]];
//     const sqlStr = `DROP TABLE IF EXISTS ${name};`;
//     await dbHandler.excuteSql(sqlStr);
//   });
//   dbHandler.close();
// }
// getTables();

const sql = 'DROP DATABASE handsel_record';
const getTables = async () => {
  await dbHandler.excuteSql(sql);
  dbHandler.close();
}
getTables();
