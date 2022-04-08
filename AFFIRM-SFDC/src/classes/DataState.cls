/**
 * Created by Akhil on 2022-04-07.
 */

public with sharing class DataState {
	public static fflib_SObjectUnitOfWork uow;
	public static Map<String, Map<String, List<SObject>>> serviceState;

	static {
		serviceState = new Map<String, Map<String, List<SObject>>>();
	}

	/**
	 * Allows a state reset, may be useful in AFTER triggers.
	 */
	public static void resetState(){
		serviceState = new Map<String, Map<String, List<SObject>>>();
	}

	public static void resetState(List<String> DataStateKeysToRemove){
		for (String key : DataStateKeysToRemove) {
			if(serviceState.containsKey(key)) {
				serviceState.remove(key);
			}
		}
	}

	/**
	 * Registers a String as a key to the serviceState, we use String as it allows us to have multiple Maps of the
	 * same object
	 *
	 * EX:
	 * registerObjectType('Account');
	 * registerObjectType('PartnerAccounts');
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 */
	public static void registerObjectType(String DataStateKey){
		if(!serviceState.keySet().contains(DataStateKey)){
			serviceState.put(DataStateKey, new Map<String, List<SObject>>());
		}
	}

	/**
	 * Registers a List of records in the serviceState. With no keyField provided this will default to use "Id"
	 * Hence this should only be used with records that exist and have an Id.
	 *
	 * EX:
	 * registerObjects('Account', new List<Account>{a,a2,a3});
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 * @param records A List of Records to be stored by Id and DataStateKey
	 */
	public static void registerObjects(String DataStateKey, List<SObject> records){
		registerObjectType(DataStateKey);
		registerObjects(DataStateKey, records, 'Id');
	}

	/**
	 * Registers a record in the serviceState. With no keyField provided this will default to use "Id"
	 * Hence this should only be used with records that exist and have an Id.
	 *
	 * EX:
	 * registerObject('Account', new Account());
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 * @param record A Record to be stored by Id and DataStateKey
	 */
	public static void registerObject(String DataStateKey, SObject record){
		registerObjectType(DataStateKey);
		registerObjects(DataStateKey, new List<SObject>{record}, 'Id');
	}

	/**
	 * Registers a List of records in the serviceState. keyField allows for any unique field to be used to track state
	 * Useful for newly created records that aren't in the database yet (IE do not have an ID)
	 *
	 * EX:
	 * registerObjects('Account', new List<Account>{a,a2,a3}, "Domain__c");
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 * @param records A List of Records to be stored by DataStateKey
	 * @param keyField A String to identify individual records within a given Object State
	 */
	public static void registerObjects(String DataStateKey, List<SObject> records,  String keyField){
		registerObjectType(DataStateKey);
		Map<String, List<SObject>> state = serviceState.get(DataStateKey);
		for(SObject record : records){
			addValueToStateByKeyValue(record, (String)record.get(keyField), state);
		}
		serviceState.put(DataStateKey, state);
	}

	/**
	 * Registers a single record in the serviceState. keyField allows for any unique field to be used to track state
	 * Useful for newly created records that aren't in the database yet (IE do not have an ID)
	 *
	 * EX:
	 * registerObject('Account', new Account(), "Domain__c");
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 * @param records A Record to be stored by DataStateKey
	 * @param keyField A String to identify the record within a given Object State
	 */
	public static void registerObject(String DataStateKey, SObject record,  String key){
		registerObjectType(DataStateKey);
		registerObjects(DataStateKey, new List<SObject>{record}, key);
	}

	/**
	 * Registers a List of records in the serviceState. keyField allows for any unique field to be used to track state
	 * Useful for newly created records that aren't in the database yet (IE do not have an ID)
	 *
	 * EX:
	 * registerObjects('Account', new List<Account>{a,a2,a3}, "Domain__c");
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 * @param records A List of Records to be stored by DataStateKey
	 * @param key A String key to identify individual records within a given Object State
	 */
	public static void registerObjectByKey(String DataStateKey, SObject record,  String key){
		registerObjectType(DataStateKey);
		Map<String, List<SObject>> state = serviceState.get(DataStateKey);
		addValueToStateByKeyValue(record, key, state);

		serviceState.put(DataStateKey, state);
	}

	/**
	 * Registers a Map of records in the serviceState. key allows for any unique value to be used to track state
	 * Useful for newly created records that aren't in the database yet (IE do not have an ID),
	 * or for mapping fields from other objects (ie. Asset__r.Account.Domain__c)
	 *
	 * EX:
	 * registerObjectsByKey('Account', new Map<String, SObject>{'testify.com' => accountRecord});
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 * @param keyToRecord A Map consisting of List of A String to identify individual records within a given Object State mapped to a Record to be stored by DataStateKey
	 */
	public static void registerObjectsByKey(String DataStateKey, Map<String, SObject> keyToRecord){
		registerObjectType(DataStateKey);

		Map<String, List<SObject>> state = serviceState.get(DataStateKey);
		for(String key : keyToRecord.keySet()){
			addValueToStateByKeyValue(keyToRecord.get(key), key, state);
		}
		serviceState.put(DataStateKey, state);
	}

	public static void registerObjectListByKey(String DataStateKey, Map<String, List<SObject>> keyToRecordList){
		registerObjectType(DataStateKey);

		Map<String, List<SObject>> state = serviceState.get(DataStateKey);

		for(String keyValue : keyToRecordList.keySet()){
			if(!state.containsKey(keyValue)){
				state.put(keyValue, new List<SObject>());
			}
			state.get(keyValue).addAll(keyToRecordList.get(keyValue));
		}
	}

	private static void addValueToStateByKeyValue(SObject record, String keyValue, Map<String, List<SObject>> state){

		if(!state.containsKey(keyValue)){
			state.put(keyValue, new List<SObject>{ record });
		}
		else{
			List<SObject> currentValues = state.get(keyValue);
			currentValues.add(record);
			state.put(keyValue, currentValues);
		}
	}

	/**
	 * Retrieves a single (first) record from the DataStateKey State by the keyField
	 * Knowledge of what keyField was used is needed
	 *
	 * EX:
	 * getObject('Account', "someDomain.com");
	 * getObject('PartnerAccount', "001Id93kInfjd8HJne8");
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 * @param key The key used to identify the record
	 */
	public static SObject getObject(String DataStateKey, String key){
		generateState(DataStateKey);
		if(serviceState.containsKey(DataStateKey)){
			if(serviceState.get(DataStateKey).containsKey(key)){
				return serviceState.get(DataStateKey).get(key)[0];
			}
			return null;
		}
		return null;
	}

	/**
	 * Retrieves entire Map of objects based on the DataStateKey
	 *
	 * EX:
	 * getObjectMap('Account');
	 * getObjectMap('PartnerAccount');
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 */
	public static Map<String, SObject> getObjectMap(String DataStateKey){
		generateState(DataStateKey);
		Map<String, SObject> consolidatedState = null;
		if(serviceState.keySet().contains(DataStateKey)){
			consolidatedState = new Map<String, SObject>();
			for (String key : serviceState.get(DataStateKey).keySet()){
				consolidatedState.put(key, serviceState.get(DataStateKey).get(key)[0]);
			}
		}
		return consolidatedState;
	}

	/**
	 * Retrieves entire Map of objects based on the DataStateKey
	 *
	 * EX:
	 * getObjectMap('Account');
	 * getObjectMap('PartnerAccount');
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 */
	public static Map<String, List<SObject>> getObjectListMap(String DataStateKey){
		generateState(DataStateKey);
		Map<String, List<SObject>> consolidatedState = null;
		if(serviceState.keySet().contains(DataStateKey)){
			consolidatedState = new Map<String, List<SObject>>();
			for (String key : serviceState.get(DataStateKey).keySet()){
				consolidatedState.put(key, serviceState.get(DataStateKey).get(key));
			}
		}
		return consolidatedState;
	}

	/**
	 * Retrieves entire List of List of objects based on the DataStateKey
	 *
	 * EX:
	 * getObjectMap('Account');
	 * getObjectMap('PartnerAccount');
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 */
	public static List<SObject> getObjectList(String DataStateKey){
		generateState(DataStateKey);
		List<SObject> consolidatedState = null;
		if(serviceState.keySet().contains(DataStateKey)){
			consolidatedState = new List<SObject>();
			for(String key : serviceState.get(DataStateKey).keySet()){
				consolidatedState.addAll(serviceState.get(DataStateKey).get((key)));
			}
		}
		return consolidatedState;
	}

	/**
	 * Retrieves entire List of List of objects based on the DataStateKey
	 *
	 * EX:
	 * getObjectMap('Account', 'Plus');
	 * getObjectMap('PartnerAccount', 'SharedKey');
	 *
	 * @param DataStateKey A String used as the Key for the data in the State
	 * @param key The individual record(s) identifying key
	 */
	public static List<SObject> getObjectList(String DataStateKey, String key){
		generateState(DataStateKey);
		if(serviceState.keySet().contains(DataStateKey)){
			if(serviceState.get(DataStateKey).keySet().contains((key))) {
				return serviceState.get(DataStateKey).get(key);
			}
		}
		return null;
	}

	/**
	 * Checks if the requested key is already in State, if not call the DataStateGenerator to get the data.
	 *
	 * @author akhil
	 * @param DataStateKey A String used as the Key for the data in the State.
	 */
	private static void generateState(String DataStateKey){

		if(!serviceState.keySet().contains(DataStateKey)){
			//State has not been generated yet.
			DataStateGenerator.generateState(DataStateKey);
		}
	}
}