var description = {
  summary: "Google Core",
  version: "1.0.0",
  name: "google-core"
};
Package.describe(description);

var path = Npm.require("path");
var fs = Npm.require("fs");
eval(fs.readFileSync("./packages/autopackage.js").toString());
Package.onUse(function(api) {
  addFiles(api, description.name, getDefaultProfiles());
  api.use(["core"]);
});

Npm.depends({
  "googleapis": "2.0.5"
});
