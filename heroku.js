var express = require('express')
var app = express()
var path = require('path')
const port = process.env.PORT

app.get("/", (req, res) => {
  console.log("Getting index.html");
  var pathToIndexHtml = path.resolve(__dirname, "dist", "index.html");
  console.log(`route for index.html: ` + pathToIndexHtml)
  res.sendFile(pathToIndexHtml)
})

app.get("*", (req, res) => {
  console.log("Getting file...")
  var relativePathToFile = "/dist" + req.path
  var absolutePathToFile = __dirname + relativePathToFile // FIXME: Få det riktig med path.resolve

  res.sendFile(absolutePathToFile)
})

app.listen(port, (req, res) => {
  console.log(`listening on port ${port}`)
})
