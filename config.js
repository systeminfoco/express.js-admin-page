/**
 * Do not edit this file directly! See README.
 */

let userConfig
try {
  userConfig = require("./config.user")
} catch(error) {
  console.log("To customize the configuration, create a config.user.js file.")
  userConfig = require("./config.sample")
}

module.exports = {
  mongodb: {
    host: userConfig.mongodb.host || "localhost",
    port: userConfig.mongodb.port || 27017,
    db: userConfig.mongodb.db || "rvk_gnd_ubregensburg",
    collection: userConfig.mongodb.collection || "mappings"
  },
  port: userConfig.port || 3000
}
