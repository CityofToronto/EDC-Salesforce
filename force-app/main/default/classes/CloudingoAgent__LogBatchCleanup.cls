/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LogBatchCleanup implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global Integer daysToKeep;
    global LogBatchCleanup(Integer daysToKeep) {

    }
    global void execute(Database.BatchableContext bc, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext bc) {

    }
    global String getNamespace() {
        return null;
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }
}
