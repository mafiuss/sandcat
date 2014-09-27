express = require('express')
router = express.Router()

index = require('../controllers/index');
hairball = require('../controllers/hairball');

router.get '/', (req, res) ->
  index.render req, res

router.get '/home', (req, res) ->
  index.render req, res

router.get '/hairball', (req, res) ->
  hairball.render req, res


module.exports = router
