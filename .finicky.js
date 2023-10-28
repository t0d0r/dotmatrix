// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

module.exports = {
  defaultBrowser: "Safari",
  options: {
    logRequests: true,
  },
  handlers: [
    {
      // Open google.com and *.google.com urls in Google Chrome
      match: [
        '*catenate.bg/*',
        '*catenate.com/*',
        'app.getguru.com/*',
        'app.asana.com/*',
        'docs.google.com/*',
        'drive.google.com/*',
				'graylog.oddspedia:9000/*',
        // finicky.matchDomains(/.*\.catenate.bg/), // use helper function to match on domain only
      ],
      browser: "Google Chrome"
    },
    {
      match: [
        "fos-support.com/*",
        "mandrillapp.com/*",
      ],
      browser: "Firefox"
    }

//  {
//    match: [
//      // "google.com*", // match google.com urls
//      "github.com*",
//    ], browser: "Safari"
//  }
  ]
}
