module.exports = class extends think.Logic {
  addAction() {
    this.allowMethods = 'post';
  }
  modifyAction() {
    this.allowMethods = 'post';
  }
}