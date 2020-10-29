module.exports = class extends think.Controller {
  __before() {

  }
  __call() {
    return this.fail(404, "该接口不存在");
  }
};
