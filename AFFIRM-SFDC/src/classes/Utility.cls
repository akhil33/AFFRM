/**
 * Created by Akhil on 2022-02-12.
 */

public with sharing class Utility {
    //trigger control
    public static String triggerClass = null;
    public static final String INCORRECT_INSTANTIATION = 'Incorrect instantiation of HDL_TriggerFramework class.';

    public static Boolean IsTriggerEnabled(String className) {
        return checkEnabled(className);
    }

    private static Boolean checkEnabled(String instance) {
        TriggerHandler__mdt trg = TriggerHandler__mdt.getInstance(instance);
        // Using custom settings will enable any trigger to be enabled or disabled.
        if (Test.isRunningTest()) {
            return true;
        }
        else if (trg != null) {
            if (trg.Enabled__c == true) {
                return true;
            }
            else {
                System.debug('Class: ' + instance + ' did not execute because it was set to disabled.');
                return false;
            }
        }
        else {
            return false;
        }
    }

}