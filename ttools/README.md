# ttools

THIS FOLDER IS NOT ACTIVELY MAINTAINED AND SOME THINGS DO/MIGHT NOT WORK!

## Usage

## Developement

### Structure

#### functions
Contains all scripts that will be available as functions of ttools

#### function_modules
Contains modules that will be available as functions of ttools
The difference to normal functions is that these modules can provide multiple functions in themselves
These modules do not have a run.sh, since they are never called on their own

#### modules
Contains all modules that will be available as alias in every new console

##### Structure

###### module.info
Contains information about what this module is supposed to do. 
No fancy design allowed here, because this will be used to display the module in lists etc.

###### functions
Every script places in this folder will be avaiable as a function of the module

###### run.sh
This script will be registered as alias in every new terminal

