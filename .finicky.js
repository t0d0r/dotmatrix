// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

module.exports = {
  //defaultBrowser: "Safari Technology Preview",
  defaultBrowser: "Safari",
  options: {
    logRequests: true,
  },
  handlers: [
    {
      match: [
        'confidential-mail.google.com/*',
        'docs.google.com/*',
        'drive.google.com/*',
        'meet.google.com/*',
        // finicky.matchDomains(/.*\.catenate.bg/), // use helper function to match on domain only
      ],
      browser: "Google Chrome"
    },
    {
      match: [
				'*.microsoft.com/*',
				'*.miro.com/*',
				'miro.com/*',
				'*.safelinks.protection.outlook.com/*',
				'gitlab.oddspedia.com/*',
        'app.asana.com/*',
        'app.hibob.com/*',
				'jenkins.oddspedia.com/*',
				'mg.mail.notion.so/*',
				'zabbix.oddspedia/*',
        'graylog.oddspedia:9000/*',
        'netman.okta.com/*',
        'netmanagement.atlassian.net/*',
        // finicky.matchDomains(/.*\.catenate.bg/), // use helper function to match on domain only
      ],
      browser: "Microsoft Edge"
    },
    {
      match: [
        '*catenate.bg/*',
        '*catenate.com/*',
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
