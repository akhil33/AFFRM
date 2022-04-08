public inherited sharing class DataStateGenerator {

	/**
	 * A List of classes that implement IStateGenerator. This will allow us to dynamically map
	 * State generators to keys.
	 */
	@TestVisible
	private static final List<String> stateGenerationClasses = new List<String>{


			//ContactState classes
			'ContactState_Account'

	};

	@TestVisible
	private static Map<String, IStateGenerator> stateGeneratorCache;

	/**
	 * Accepts a DataStateKey and runs the appropriate method to generate the related data in State .
	 *
	 * @author Akhil
	 * @param DataStateKey A String used as the Key for the data stored in State
	 */
	public static void generateState(String DataStateKey){
		if(!generateDynamicState(DataStateKey)) {

		}
	}

	/**
	 * Accepts a DataStateKey and checks the generator cache for a class that is able to generate the requested state.
	 *
	 * @author Akhil
	 * @param DataStateKey A String used as the Key for the data stored in State
	 * @return Boolean representing if State has been generated using the dynamic generator
	 */
	private static Boolean generateDynamicState(String DataStateKey){
		IStateGenerator generator = getStateGeneratorClass(DataStateKey);
		if(generator != null){
			generator.generateState();
			return true;
		}
		return false;
	}

	/**
	 * Generates the State Generator Cache on first request, then returns the appropriate state generator.
	 *
	 * @author Akhil
	 * @param DataStateKey A String used as the Key for the data stored in State
	 * @return IStateGenerator that contains the logic for generating the requested State
	 */
	public static IStateGenerator getStateGeneratorClass(String DataStateKey){
		if(stateGeneratorCache == null){
			generateCache();
		}
		if(stateGeneratorCache.containsKey(DataStateKey)){
			return stateGeneratorCache.get(DataStateKey);
		}
		return null;
	}

	/**
	 * Iterates all the generator classes and adds them to the Cache.
	 *
	 * @author Akhil
	 */
	@TestVisible
	private static void generateCache(){
		stateGeneratorCache = new Map<String, IStateGenerator>();
		for(String className : stateGenerationClasses){
			try {
				addToStateCache(className);
			}
			catch (Exception ex) {
				NullPointerException e = new NullPointerException();
				e.setMessage('CLASS NOT FOUND TO ADD TO STATE: ' + className);
				throw e;
			}
		}
	}

	/**
	 * Creates instances of IStateGenerator classes, maps their DataStateKeys back to the instance.
	 *
	 * @author Akhil
	 * @param className Name of the IStateGenerator class we will add to the cache.
	 */
	private static void addToStateCache(String className){
		IStateGenerator discreteClass = (IStateGenerator) Type.forName(className).newInstance();
		for (String DataKey : discreteClass.dataStateSearchKeys()) {
			stateGeneratorCache.put(DataKey, discreteClass);
		}
	}
}