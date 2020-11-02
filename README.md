# khangout

Kalamazoo + Hangout

## Purpose

KHangout is an application designed to enhance student interaction at Kalamazoo College. The platform
allows students to view/create hangout opportunites..

## Getting Started

View https://flutter.dev/docs/get-started/install to install Flutter, Android Studio, Xcode following the instructions
  - Flutter 1.22.0
  - Android Studio 4.0.1
  - Xcode 12.0.1

Install Aqueduct
  - ``` flutter pub global activate aqueduct ``` (aqueduct should be availble in your $PATH)

Set up database
  - Install postgres and start postgres server
    - ``` brew install postgresql```
    - ``` pg_ctl -D /usr/local/var/postgres start ```
    - ``` psql postgres``` (psql should be availble in your $PATH)
  - Configure a new postgres database and a user to manage it
    - ``` CREATE DATABASE hangouts; CREATE USER username WITH createdb; ALTER USER username WITH password 'password'; GRANT all ON database hangouts TO username;```
  - Configure database table
    - run migration.1-create_hangouts_table.sql file

- Set up credentials for Postgres connection
   - Copy config.src.yaml into a new file config.yaml and update following key-value pairs
      - username: your_username 
      - password: your_password 
      - databaseName: hangouts
## How to run

After succesfully install Android Studio and Xcode, set up Android and iOS emulator
  - Mac
    - Use command `open -a Simulator`
    - Make sure your simulator is using 64bit device (check Hardcare > Device)
    
  - Windows
    - Launch Android studio > AVD Manager > Create Virtual Device 
    - Choose a device definition > Next > Select system image (x86 or x86_64 is recommended) > Next > Finish
    - AVD Manager > Run
    
 After successfullt set up emulators, run the app using
   - run ```aqueduct serve``` (it runs the web server where RESTful api is built to perform CRUD operations with Postgres)
   - VS code
      - Select a device from the Device Selector area or launch a simulator if no device exists
      - Run > Start Debugging
   - Android Studio
      - Select a device in the target selector located in the main Android Studio toolbar
      - Run > Run or Clink the run icon in the toolbar

## Troubleshooting

- warning: Capabilities for Signing & Capabilities may not function correctly
because its entitlements use a placeholder team ID. To resolve this, select
a development team in the Runner editor. (in target 'Runner' from project
'Runner')
  - This issue was resolved on macOS Catalina version 10.15.6
  - Run these two commands:
    - xattr -lr [path_to_Runner.app]
    - xattr -cr [path_to_Runner.app]
  
