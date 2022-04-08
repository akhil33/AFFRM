/**

* @description: The purpose of this class is to ensure that methods which would run recursively do not
* cause an infinite loop. At the beginning of a method you can call filterProcessedRecords to filter
* out any records which have been marked as processed with markIdsAsProcessed. markIdsAsProcessed
* should be called at the end of the method with the ids of any records which the method shouldn't process
* in the next execution.
*
* The benefit of using a static set of ids rather than a boolean variable is that multiple executions that
* should happen due to the trigger acting on only 200 records at a time work as expected.
*/
public with sharing class RecursiveTriggerUtility {
	private static Map<String, Set<Id>> processedIdsByMethodMap = new Map<String, Set<Id>>();
	public static List<SObject> filterProcessedRecords(String methodName, List<SObject> records) {
		Set<Id> processedIds = processedIdsByMethodMap.get(methodName);
		if(processedIds == null) {
			return records;
		}
		else {
			List<SObject> recordsToProcess = new List<SObject>();
			for(SObject record : records) {
				if(!processedIds.contains(record.Id)) {
					recordsToProcess.add(record);
				}
			}
			return recordsToProcess;
		}
	}
	public static void markIdsAsProcessed(String methodName, Set<Id> recordIds) {
		Set<Id> processedIds = processedIdsByMethodMap.get(methodName);
		if(processedIds == null) {
			processedIds = new Set<Id>();
		}
		processedIds.addAll(recordIds);
		processedIdsByMethodMap.put(methodName, processedIds);
	}
}