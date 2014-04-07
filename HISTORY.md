# Jacinthe Management, a.k.a. JacMan
## [v1.9.2]
* detect invalid users in notifications

## [v1.9.1]
* changed set_ and get_ names (rubocop 1.6.0)
* fixed 'active' bug in command table

## [v1.9.0]
* CRON_DIRECTORY moved to SMF_SERVEUR/Data
* new structure for jacman-core gem extraction

## [v1.8.3]
* module Info

## [v1.8.2]
* batch_manager becomes cli
* config becomes defaults
* no more cron_manager : methods moved to command
* folder restructuration : core

## [v1.8.1]
* added gr command to batman

## [v1.8.0]
* watching return of client files

## [v1.7.ASP.4]
* disable commands when nothing to do
* fixed aspaway importing for new directory structure

## [v1.7.ASP.3]
* migration of catalog manager

## [v1.7.ASP.2]
* checking for success of transmission to aspaway
* method for resending pending client files

## [v1.7.ASP.1]
* adding blocking message box during importation

## [v1.7.ASP.0]
* ported to Aspaway
* sage_file -> win_file
* transmission methods
* sage_importer -> aspaway_importer

## [v1.6.3]
* spec_helper tests if on tty
* new WinFile class for Aspaway conversion
* new logic for win_file_spec, working on Windows/Unix

## [v1.6.2]
* Restructured directories

## [v1.6.1]
* Watcher is a class
* Mail is a class
* CronManager is a class

## [v1.6.0]
* sql_fragments in files

## [v1.5.8]
* good fix for server problem
* manager idle when minimized

## [v1.5.7]
* correcting 'pipe' bad working on OSX (wrong !)
* new timing for window updates

## [v1.5.6]
* protecting 'update' when running
* special sizes for server

## [v1.5.5]
* Importers in Catalog manager

## [v1.5.4]
* SageImporter & SalesImporter

## [v1.5.3]
* Notify class Methods become Notification module

## [v1.5.2]
* sage.rb cut in two : sales.rb and clients.rb

## [v1.5.1]
* specific help in manager rows
* module ManagerHelp

## [v1.5.0]
* two distinct managers
* common class CentralWidget

## [v1.4.4]
* adding help to gescom table for 'ventes' and 'catalogue'

## [v1.4.3]
* reporting ce in gescom watcher
* reporting jtd in night watcher

## [v1.4.2]
* automatic importing of gescom files
* help for gescom export

## [v1.4.1]
* watching client file

## [v1.4.0]
* gescom import watcher

## [v1.3.0]
* timer with refreshing

## [v1.2.0]
* pendant watcher
* cleaned panel

## [v1.1.0] branch watcher
* catalog watcher
* watcher for cronman
* methods for counting new clients and notifications

## [v1.0.2]
* module CronManager extracted

## [v1.0.1]
* cronman for crontab jobs, reporting in files
* DRUPAL field in notification

## [v1.0.0]
* error management for wrong email addresses
* restricted batch manager and developer manager
* tests work on server and on PC

## [v0.4.2]
* config dialog with confirmation
* full comments

## [v0.4.1]
* long titles for batman and tooltips for manager
* bash files

## [v0.4.0]
* batch_manager renamed batman !

## [v0.3.4]
* encodings fixed ?
* better reporting
* reporting for ssh and scp

## [v0.3.3]
* batch manager
* registering tiers without mail
* solved flush bug on server (to be checked)

## [v0.3.2]
* tests for conversion and extraction
* dangerous commands added in red

## [v0.3.1]
* extra_config merged in config
* fixed and to be checked
** fixed import_tariff (works from csv file, and not sylk file)
** fixed push_to_drupal (added ssh after scp)
** fixed import_stock (regexp works OK on Win/1.9.3, what happens on OSX ???)
* still to be checked
** invalid ranges

## [v0.3.0]
* new directory structure
* moved mode constants to extra_config, to be merged later in my_config

## [v0.2.7]
* build and mail executive report (connecting to J2R)
* logger

## [v0.2.6]
* show invalid ranges command, manager completed

## [v0.2.5]
* fixed an encoding problem in manager output
* notify work as a demo (no mail sent)

## [v0.2.4]
* two electronic commands added (upload to smf4 to be checked)
* better error signaling
* mail utility

## [v0.2.3]
* catching Exceptions and signaling errors
* transmission : fetch/pull from Mathrice
* hopefully, MacRoman problems solved.
* manager : more commands

## [v0.2.2]
* manager :report widget for shell puts
* manager : four commands : import/export, sage/drupal

## [v0.2.1]
* Command class

## [v0.2.0]
* prototype of QT manager

## [v0.1.11]
* Electronic module with KL's export_ip methods, refactored
* New files : subscription.rb (was eabo.rb), subscription_spec.rb (was eabo_spec.tb)
* Exporting valid ranges work.
* To be checked : cases with invalid ranges

## [v0.1.10]
* conversion methods integrated in catalogue methods
* SageFile class for Mac line terminator

## [v0.1.9]
* added sylk/csv conversion method

## [v0.1.8]
* import_catalogue OK
* new extract_lines yielding the match_data
* encodings problems should be almost solved
* LINE ENDINGS NOT FIXED

## [v0.1.7]
* Clarified file and directory names : catalog/data/drupal/electronic/reset_db/sage

## [v0.1.6]
* Renamed to **JacintheManagement**

## [v0.1.5]
* Catalogue methods OK, except part of import_stock
* Catalogue DB need a 'catalogue_interne' table

## [v0.1.4]
* Import sellings :
- 'sellings' should be 'sales'
- conversion sylk/csv and sage/utf8 to be done
- injection in base raises a mysql error.

## [v0.1.3]
* Local import drupal works
* Export client sage works

## [v0.1.2]
* Export data and settings work.

## [v0.1.1]
* Local export Drupal works
* Still scp part to be written

## [v0.1.0]
* No more mysql bindings
* ResetDb works (ImportDrupal still to be written)

## [v0.0.1]
* First experiment, with slop
