<template>
  <div>
    <p>Your public site is available at <a :href="url" target="_blank">{{ url }}</a>.</p>
    <div v-if="!isDemo">
      <p>To set up your domain to point at your public site, add the following DNS records to your domain. Replace <code>blog.example.com</code> with your site's hostname.</p>
      <table>
        <thead>
          <th>Name</th>
          <th>Type</th>
          <th>Value</th>
        </thead>
        <tbody>
          <tr>
            <td>blog.example.com</td>
            <td>CNAME</td>
            <td>{{ domain }}</td>
          </tr>
          <tr>
            <td>sandstorm-www.blog.example.com</td>
            <td>TXT</td>
            <td>{{ publicId }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <h2>Editing Your Site</h2>
    <p>To check out the Git repository containing your site, first add an authorization key to Git:</p>
    <render-template
      rpcId="gitAuthorize"
      :template="'echo url=' + this.gitHost + ' | git -c credential.helper=store credential approve'"/>
    <p>Then run the following to clone the site:</p>
    <render-template
      rpcId="gitClone"
      :template="'git clone -c credential.helper=store ' + this.gitUrl + ' site'"/>
    <p>Here are a few pointers to help you get started:</p>
    <ul>
      <li>Choose a theme to make your site look nice. Hugo's <a href="https://themes.gohugo.io">theme showcase</a> is a good place to start.</li>
      <li>Add the theme to your Git repository as a subtree at <code>themes/themename</code>.</li>
      <li>Add <code>theme = "themename"</code> to <code>Config.toml</code>.</li>
      <li>Push the repository, and your new site will be immediately published.</li>
    </ul>
    <h2>Pushing Existing Site</h2>
    <p>If you have an existing Hugo site, run the following to publish in this grain:</p>
    <render-template
      rpcId="gitPush"
      :template="'git remote add origin ' + this.gitUrl + '\ngit push -fu origin master'"/>
    <h2>Admin Interface</h2>
    <p>Simple site changes can be made directly in the included <a href="/admin/">administrative interface</a>.</p>
  </div>
</template>

<script>
  import "isomorphic-fetch"
  import RenderTemplate from "~components/render-template"

  export default {
    data: () => ({
      isDemo: true,
      url: "",
      domain: "",
      publicId: ""
    }),
    computed: {
      gitHost: () => {
        if(process.BROWSER_BUILD)
          return window.location.protocol+"//git@$API_HOST"
        else
          return ""
      },
      gitUrl: () => {
        if(process.BROWSER_BUILD)
          return `${window.location.protocol}//git@$API_HOST/git`
        else
          return ""
      }
    },
    mounted() {
      fetch("/publicId", {
        credentials: "same-origin"
      }).then((r) => r.json())
      .then((r) => {
        this.isDemo = r.isDemo
        this.url = r.url
        this.publicId = r.publicId
        this.domain = r.domain
      })
      .catch(console.error)
    },
    head: {
      title: "Home"
    },
    components: {RenderTemplate}
  }

</script>
