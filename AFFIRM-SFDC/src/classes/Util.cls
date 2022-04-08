/***
 * Utils
 * Author: Akhil
 *
 * Util Class will hold general methods that aren't object specific.
 */
public inherited sharing class Util {
	public static List<SObject> getChangedObjects(List<SObject> records, Map<Id, SObject> oldRecords, List<String> fieldsToCheck){
		List<SObject> changedObjects = new List<SObject>();
		SObject tempOldRecord = null;
		for(SObject record : records){
			if(oldRecords.keySet().contains(record.Id)){
				tempOldRecord = oldRecords.get(record.Id);
				for(String field : fieldsToCheck){
					if(record.get(field) != tempOldRecord.get(field)){
						changedObjects.add(record);
						break;
					}
				}
			}
		}
		return changedObjects;
	}

	static Integer s_num = 1;
	public static String generateRandomId(SObjectType objType) {
		String result = String.valueOf(s_num++);
		return objType.getDescribe().getKeyPrefix() +
				'0'.repeat(12-result.length()) + result;
	}


	public static String randomStringGenerator(Integer size){
		List<Integer> allChars = new List<Integer>();
		while(size > 0){
			Integer num = 97 + (Math.floor(Math.random() * 25)).intValue();
			allChars.add(num);
			size--;
		}
		return (String.fromCharArray(allChars));

	}
}