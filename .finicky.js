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
				'*.microsoft.com/*',
				'*.miro.com/*',
				'*.safelinks.protection.outlook.com/*',
				'gitlab.oddspedia.com/*',
				'jenkins.oddspedia.com/*',
				'mg.mail.notion.so/*',
				'miro.com/*',
				'zabbix.oddspedia/*',
        '*catenate.bg/*',
        '*catenate.com/*',
        'app.hibob.com/*',
        'catenate1-my.*',
        'catenate1.sharepoint.com/*',
        'graylog.oddspedia:9000/*',
        'netman.okta.com/*',
        'netmanagement.atlassian.net/*',
      ],
      browser: "Microsoft Edge"
    },
    {
      match: [
        "fos-support.com/*",
        "mandrillapp.com/*",
        "books.1dxr.com/*",
        "docs.1dxr.com/*",
        "*1dxr.com/*",
      ],
      browser: "Firefox Proxy"
    },
		{
			match: [
        'confidential-mail.google.com/*',
        'docs.google.com/*',
        'drive.google.com/*',
        'meet.google.com/*',
			],
			browser: "Google Chrome"
		},
//  {
//    match: [
//      // "google.com*", // match google.com urls
//      "github.com*",
//    ], browser: "Safari"
//  }
  ]
}
