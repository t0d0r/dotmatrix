// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

module.exports = {
  defaultBrowser: "Safari Technology Preview",
  options: {
    logRequests: true,
  },
  handlers: [
    {
      // oddspedia
      match: [
        'app.asana.com/*',
        'app.hibob.com/*',
        'docs.google.com/*',
        'drive.google.com/*',
        'graylog.oddspedia:9000/*',
        'netman.okta.com/*',
				'miro.com/*',
				'mg.mail.notion.so/*',
        'netmanagement.atlassian.net/*',
				'gitlab.oddspedia.com/*',
				'jenkins.oddspedia.com/*',
				'zabbix.oddspedia/*',
				'*.safelinks.protection.outlook.com/*',
				'*.microsoft.com/*',
				'*.miro.com/*',
        // finicky.matchDomains(/.*\.catenate.bg/), // use helper function to match on domain only
      ],
      browser: "Microsoft Edge"
    },
    {
      match: [
        '*catenate.bg/*',
        '*catenate.com/*',
        'app.getguru.com/*',
        'catenate1.sharepoint.com/*',
        'catenate1-my.*',
      ],
      browser: "Microsoft Edge"
    },
    {
      match: [
        "fos-support.com/*",
        "mandrillapp.com/*",
        "docs.1dxr.com/*",
        "*1dxr.com/*",
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
