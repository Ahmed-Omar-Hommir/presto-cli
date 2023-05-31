![Presto CLI Logo](assets/presto_cli_logo.png)

---

A Presto Command-Line Interface for Dart.

Developed with 🧡 by Presto Team 🐥

## Quick Start 🚀

### Installing 🧑‍💻

```bash
dart pub global activate --source git https://github.com/Ahmed-Omar-Hommir/presto-cli
```

### Commands ✨

# Magic Commands 🪄 [Soon...]

# FCM-Test Command <img src="assets/firebase-icon.svg" alt="Alternative Text" width="28" height="28" />

The `fcm-test` command is a powerful utility for testing Firebase Cloud Messaging (FCM) push notifications. It's designed to be simple to use.

## Requirements

- The command requires a JSON file named `fcm_test.json` in the current directory. This file should contain the server key and request data for the FCM notification you wish to send.

## Usage

To execute the command, navigate to the directory containing your `fcm_test.json` file, and run:

```bash
presto fcm-test
```

## JSON File Structure

Your `fcm_test.json` file should have the following structure:

```json
{
  "serverKey": "<Your FCM server key here>",
  "request": {
    "to": "<The recipient's FCM token here>",
    "notification": {
      "title": "<Notification title here>",
      "body": "<Notification body here>"
    },
    "data": {
      "title": "<Data title here>",
      "body": "<Data body here>"
    }
  }
}
```

The `request` object should contain the necessary FCM request data. You can find more information on this structure in the [Firebase documentation](https://firebase.google.com/docs/cloud-messaging).
