const gulp = require('gulp');
const {series} = gulp;
const shell = require('gulp-shell');
const path = require('path');

const dirNameTmp = path.resolve('.').split('/');
const PROJECT_NAME = dirNameTmp[dirNameTmp.length - 1];

// const PROJECT_NAME = 'FiiAppServer';

const showError = function (err) {
  console.error(err);
  this.emit('end');
};

gulp.task('default', cb => {
  return gulp.src('./')
  .pipe(shell(['npm run start'], {cwd: '<%= file.path %>'}))
  .on('error', showError);
})

// 设置项目根目录的pm2.json文件
function initPm2Json(done) {
  const fs = require('fs');
  const pm2Data = {
    "apps": [{
      "name": PROJECT_NAME,
      "script": "production.js",
      "cwd": __dirname,
      "exec_mode": "fork",
      "max_memory_restart": "1G",
      "autorestart": true,
      "node_args": [],
      "args": [],
      "env": {}
    }]
  };
  fs.writeFileSync('./pm2.json', JSON.stringify(pm2Data, null, 2));
  done();
};
function pm2Start() {
  return gulp.src('./').pipe(shell(
    ['pm2 reload pm2.json'],
    {cwd: '<%= file.path %>'}
  )).on('error', showError);
}
function pm2Stop() {
  return gulp.src('./').pipe(shell(
    [`pm2 delete ${PROJECT_NAME}`],
    {cwd: '<%= file.path %>'}
  )).on('error', showError)
}

exports.start = series(initPm2Json, pm2Start);
exports.stop = pm2Stop;

/*
* 数据库任务
*/
function initDatabase() {
  return gulp.src('./scripts/')
  .pipe(shell(['node ./initDatabase.js'], {cwd: '<%= file.path %>'}))
  .on('error', showError);
}
exports.initDB = initDatabase;
exports.drop = () => {
  return gulp.src('./scripts/')
  .pipe(shell(['node ./dropAllTable.js'], {cwd: '<%= file.path %>'}))
  .on('error', showError);
};