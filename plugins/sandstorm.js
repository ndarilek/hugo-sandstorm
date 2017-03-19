import router from "~router"

if(process.BROWSER_BUILD)
  router.afterEach(() => {
    window.parent.postMessage({"setTitle": document.title}, "*")
    window.parent.postMessage({"setPath": location.pathname + location.hash}, "*")
  })
