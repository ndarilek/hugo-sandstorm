import Nuxt from "nuxt"
import logger from "morgan"
const exec = require("child_process").exec
import Express from "express"
import gitBackend from "git-http-backend"
import httpProxy from "http-proxy"
const spawn = require("child_process").spawn

const app = new Express()

app.use(logger("dev"))
const server = require("http").createServer(app)
const host = process.env.HOST || "127.0.0.1"
const port = process.env.PORT || "8000"

app.set("port", port)

app.get("/publicId", (req, res) => {
  const sessionId = req.headers["x-sandstorm-session-id"]
  exec(`getPublicId ${sessionId}`, (err, rv) => {
    if(err)
      return res.end(err)
    const lines = rv.split("\n")
    const publicId = lines[0]
    const hostname = lines[1]
    const domain = publicId+"."+hostname
    const url = lines[2]
    const isDemo = lines[3] == "true"
    res.json({publicId, hostname, domain, url, isDemo})
  })
})

app.use("/git", (req, res) => {
  req.pipe(gitBackend(req.url, (err, service) => {
    if(err)
      return res.end(err+"\n")
    res.setHeader("content-type", service.type)
    console.log("cmd", service.cmd)
    const ps = spawn(service.cmd, service.args.concat("/var/git"))
    ps.stdout.pipe(service.createStream()).pipe(ps.stdin)
  })).pipe(res)
})

const proxy = httpProxy.createProxyServer({
  target: "http://127.0.0.1:8001/admin/",
  changeOrigin: true
})

app.use("/admin/", (req, res) => proxy.web(req, res))

// Import and Set Nuxt.js options
let config = require("./nuxt.config.js")
config.dev = !(process.env.NODE_ENV === "production")

// Init Nuxt.js
const nuxt = new Nuxt(config)
app.use(nuxt.render)

// Build only in dev mode
if (config.dev) {
  nuxt.build()
  .catch((error) => {
    console.error(error) // eslint-disable-line no-console
    process.exit(1)
  })
}

server.listen(port, host, () => console.log(`Server listening on ${host}:${port}`))
