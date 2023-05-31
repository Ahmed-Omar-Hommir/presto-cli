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

# Magic Commands 🪄

Magic Commands is a CLI tool designed to streamline Flutter development by automatically running common commands like `flutter pub get`, `flutter clean`, and more, in the appropriate project directories.

**Note:** Magic Commands should be run in the root project directory.

## Project Structure

Magic Commands is designed to work with the following project structure:

```
├── lib
├── test
├── pubspect.lock
├── pubspect.yaml
└── packages
    ├── package_one
    ├── package_two
    └── package_three
```

## How It Works

Using a Magic Command simplifies your workflow. It scans your project, identifying the packages that need the command. Whether it's L10N or build_runner, Magic Commands knows which packages require what. There's no need to manually specify the package path or to know which packages require a specific command. Best of all, Magic Commands runs these tasks in parallel across all applicable packages, speeding up your development process.

## Available Commands

Here are the currently available subcommands:

- `build_runner`: build_runner: Executes code generation utilities, useful with packages like freezed or json_serializable.
- `clean`: Deletes build/ directory and clears previous build artifacts for a fresh build.
- `get`: Fetches dependencies in pubspec.yaml, making them available in your Dart files.
- `l10n`: Generates localization files based on the arb files in the l10n directory.
- `upgrade`: Updates your dependencies to their latest versions as per pubspec.yaml, and refreshes pubspec.lock.

## Usage

I think you like magic, let's turn this frog into something beautiful 🪄 + 🐸 = 🐣

To use Magic Commands, navigate to your root project directory and run the desired command:

```bash
presto magic <command>
```

Replace `<command>` with one of the available subcommands listed above.

---

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
