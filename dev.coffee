
require("calabash").do "use new interface",
  "coffee -o lib/ -wbc coffee/"
  "node-dev test/test.coffee"