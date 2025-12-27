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
        'app.asana.com/*',
				'graylog.oddspedia:9000/*',
				'login.microsoftonline.com/*',
        // finicky.matchDomains(/.*\.catenate.bg/), // use helper function to match on domain only
      ],
      browser: "Microsoft Edge"
    },
    {
      match: [
        "fos-support.com/*",
        "mandrillapp.com/*",
        "books.1dxr.com/*",
      ],
      browser: "Firefox Proxy"
    },
		{
			match: [
        'docs.google.com/*',
        'drive.google.com/*',
			],
			browser: "Google Chrome"
		}

//  {
//    match: [
//      // "google.com*", // match google.com urls
//      "github.com*",
//    ], browser: "Safari"
//  }
  ]
}
