SlackAppInstaller = require '../src/app-installer'

cfg =
  port: process.env.PORT

app = new SlackAppInstaller(cfg)

app.boot()