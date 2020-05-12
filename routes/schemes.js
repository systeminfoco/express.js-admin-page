const express = require("express")
const router = express.Router()
const Container = require("typedi").Container
const schemeService = Container.get(require("../services/schemes"))
const conceptService = Container.get(require("../services/concepts"))
const config = require("../config")
const utils = require("../utils")
const auth = require("../utils/auth")

router.get(
  "/",
  config.schemes.read.auth ? auth.default : auth.optional,
  utils.supportDownloadFormats([]),
  utils.wrappers.async(async (req) => {
    return await schemeService.getSchemes(req.query)
  }),
  utils.addPaginationHeaders,
  utils.adjust,
  utils.returnJSON,
)

router.get(
  "/top",
  config.concepts.read.auth ? auth.default : auth.optional,
  utils.supportDownloadFormats([]),
  utils.wrappers.async(async (req) => {
    return await conceptService.getTop(req.query)
  }),
  utils.addPaginationHeaders,
  utils.adjust,
  utils.returnJSON,
)

router.get(
  "/concepts",
  config.concepts.read.auth ? auth.default : auth.optional,
  utils.supportDownloadFormats([]),
  utils.wrappers.async(async (req) => {
    return await conceptService.getConcepts(req.query)
  }),
  utils.addPaginationHeaders,
  utils.adjust,
  utils.returnJSON,
)

module.exports = router
