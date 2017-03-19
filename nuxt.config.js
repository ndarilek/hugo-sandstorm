module.exports = {
  /*
  ** Headers of the page
  */
  head: {
    titleTemplate: "%s - Hugo",
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' }
    ]
  },
  /*
  ** Add env variables
  */
  env: {
    baseURL: process.env.BASE_URL || "http://127.0.0.1:8000"
  },
  plugins: [
    "~plugins/sandstorm"
  ]
}
