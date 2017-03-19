<template>
  <iframe ref="iframe" :style="style"/>
</template>

<script>
  export default {
    props: {
      rpcId: {
        type: String,
        required: true
      },
      template: {
        type: String,
        required: true
      },
      lines: {
        type: Number,
        default() {
          console.log("template", this.template)
          if(this.template)
            return this.template.split("\n").length
          else
            return 1
        }
      },
      lineHeight: {
        type: Number,
        default: 25
      },
      style: {
        type: Object,
        default()  {
          return {
            width: "100%",
            height: (this.lineHeight * this.lines) + "px",
            border: 0,
            margin: 0
          }
        }
      },
      clipboardButton: {
        type: String,
        default: "left"
      }
    },
    mounted() {
      window.parent.postMessage({renderTemplate: {
        rpcId: this.rpcId,
        clipboardButton: this.clipboardButton,
        template: this.template
      }}, "*")
      window.addEventListener("message", (event) => {
        if(event.data.rpcId == this.rpcId) {
          if(event.data.error)
            return this.$emit("error", error)
          this.$refs.iframe.setAttribute("src", event.data.uri)
        }
      })
    }
  }
</script>
