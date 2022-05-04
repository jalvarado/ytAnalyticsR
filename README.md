# ytAnalyticsR

API wrapper library for the YouTube Analytics and Reporting APIs.

## R Client for the YouTube Analytics and Reporting APIs

Query the YouTube Analytics API to retrieve targeted, real-time queries and
power custom reports in response to user interactions. Or retrieve and store
bulk reports using the YouTube Reporting API for further processing using
the big data tools you are most familiar with.

## Install the development version of the package from GitLab Repo

```
# Install devtools from CRAN
install.packages("devtools")
install.packages("git2r")

# If the repository is set to private or internal access only, you will need
# to setup a SSH key in order to authenticate with GitLab.
# If the repository is set to allow public access, then this step can be skipped.
creds <- git2r::cred_ssh_key(publickey="<path_to_public_key.pub>",
                         privatekey="<path_to_private_key>")

devtools::install_git(
  url="git@git.cdc.gov:wok1/ytanalyticsr.git",
  quiet=FALSE,
  credentials=creds
)
```

## Package configuration process

In order to allow the ytAnalyticsR package to authenticate users using OAuth
there are five setup steps required:

1. Create a new [Google Console](https://console.cloud.google.com/) project or select an existing one.
2. Enable the YouTube Analytics and Reporting APIs
3. Create and configure a new [OAuth application](https://support.google.com/googleapi/answer/6158849?hl=en) for the project.
4. Add the OAuth application client_id and client_secret to the package options.
5. Authenticate a user using the `yt_auth()` function.

### 1. Create a Google developer console project
In order to enable access to the YouTube Analytics and Reporting APIs you must first create
a project in the Google developer console. The Google developer console is used to manage access to all Google APIs as well as provide information as to how that API access is being used.

Google console documentation: [Creating a new project](https://developers.google.com/workspace/guides/create-project)

1. Navigate to the [Google Cloud Console](https://console.cloud.google.com/)
2. At the top-left, click Menu -> IAM & Admin -> Create a Project
3. Enter a project name, select an organization and location, and click Create

### 2. Enable the YouTube Analytics and Reporting APIs
Enabling an API associates it with the current project, adds monitoring, and enables billing for that API if billing is enabled and required.

Google documentation: [Enable and Disable APIs](https://support.google.com/googleapi/answer/6158841?hl=en&ref_topic=7013279)

1. Navigate to the [Google Cloud Console](https://console.cloud.google.com/)
2. Select a project or create a new one
3. Open the APIs & Services page then select Library
4. Select the YouTube Analytics API and click Enable.  Repeat for the YouTube Reporting API

### 3. Create and configure an OAuth Application
1. Navigate to the [Google Cloud Console](https://console.cloud.google.com/)
2. Select a project or create a new one
3. Open the APIs & Services page then select Credentials
4. Click the "+ Create Credentials" link at the top of the page and select "OAuth Client ID"

### 4. Configure the R package
To connect to the OAuth application created in the Google Console you must set
the googleAuthR options for the client ID and client secret.  You must also
specify the required authorization scopes which the application will use to
access the YouTube APIs.

```
library(ytAnalyticsR)

options(googleAuthR.client_id = "<CLIENT_ID>")
options(googleAuthR.client_secret = "<CLIENT_SECRET>")

scopes <- c("https://www.googleapis.com/auth/youtube",
             "https://www.googleapis.com/auth/youtube.readonly",
             "https://www.googleapis.com/auth/yt-analytics-monetary.readonly",
             "https://www.googleapis.com/auth/yt-analytics.readonly")
options(googleAuthR.scopes.selected = scopes)
```

### 5. Authenticate with the API using OAuth 2.0
The OAuth authentication process requires an interactive environment and the authentication token will expire after 24 hours.

1. In the R console enter `ytAnalyticsR::yt_auth()` and press enter
2. A browser window shoudl appear and promtp you to log in with your Google Account
3. Log in
4. You will then be asked to allow the OAuth application to access your YouTube data.  Accept this prompt.
5. You will then be redirected to a success page and notified that you can close this window.
6. Return to the R console and you should see a confirmation message that the authentication was successful

### 6. Confirm the setup worked and make a test call
Test that everything is working correctly by fetching the metrics for a given
video id.

```
df <- video.query("YouTube_Video_ID",
                 startDate = '2022-04-01',
                 endDate = '2022-04-30',
                 metrics = 'views,likes,dislikes',
                 dimensions = 'day',
                 sort = 'day',
                 ids = "channel)
```