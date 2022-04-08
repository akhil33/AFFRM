/**
*
* @description: This class is used to add data to test method logs. An instance of this class is automatically created
* in any class that extends. Data can be added at any point during the test (setup, test, assertions)
* and is added to the object that is logged for each test during builds.
*
* ApexLimitDescribe is basically a wrapper around a Map<String, String> with the intention of providing convenience methods
* to set the value for any key we are interested in tracking, as well as assert some control over how data is added.
*/
public class ApexLimitDescribe {
    public virtual class BaseException extends Exception {}
    public class KeyNotImplementedException extends BaseException {}

    private Map<String, Object> LIMIT_DESCRIBE_MAP = new Map<String, Object>();

    /** Here we keep track of the keys we are interested in tracking in DESCRIBE_KEYS. This allows us to reject any keys used
    * in setDescribe that have not first been implemented as a constant and registered in DESCRIBE_KEYS, to help keep usage
    * consistent, and remind us to use the constants.
    */
    public final static String LIMIT_ID_KEY = 'limit_identifier';
    public final static String LIMIT_CLASS_ID_KEY = 'limit_class_identifier';
    public final static String USING_DML_KEY = 'using_dml';
    public final static String BATCH_SIZE_KEY = 'batch_size';
    public final static String CONTEXT_KEY = 'limit_context';

    public final static List<String> DESCRIBE_KEYS = new List<String>{
            LIMIT_ID_KEY, USING_DML_KEY, BATCH_SIZE_KEY, CONTEXT_KEY
    };

    /**
    * @description: Allows us to set values for multiple keys in TEST_DESCRIBE_MAP in one call. Checks to make sure
    * any keys used have been added to DESCRIBE_KEYS, throwing an exception if not.
    */
    public void setDescribe(Map<String, Object> mTestDescribe) {
        for(String testDescribeKey : mTestDescribe.keySet()) {
            if(!DESCRIBE_KEYS.contains(testDescribeKey)) {
                throw new KeyNotImplementedException('Key named ' + testDescribeKey + ' is not implemented in ApexLimitDescribe. Implement any new keys or use key constants.');
            }
            else {
                // merge mTestDescribe with TEST_DESCRIBE_MAP, keeping the value registered first, so we can call it multiple times
                if(!LIMIT_DESCRIBE_MAP.containsKey(testDescribeKey)) {
                    LIMIT_DESCRIBE_MAP.put(testDescribeKey, (String) mTestDescribe.get(testDescribeKey));
                }
            }
        }
    }

    /**
    * @description: Provides direct access to the test description map
    */
    public Map<String, Object> getDescribe() {
        return LIMIT_DESCRIBE_MAP;
    }

    /**
    * @description: Setter method for LIMIT_ID_KEY
    */
    public void setUniqueId(String uniqueId) {
        LIMIT_DESCRIBE_MAP.put(LIMIT_ID_KEY, uniqueId);
    }

    /**
    * @description: Setter method for LIMIT_CLASS_ID_KEY
    */
    public void setClassName(String className) {
        LIMIT_DESCRIBE_MAP.put(LIMIT_CLASS_ID_KEY, className);
    }

    /**
    * @description: Setter method for USING_DML_KEY
    */
    public void setUsingDml(Boolean usingDml) {
        LIMIT_DESCRIBE_MAP.put(USING_DML_KEY, usingDml);
    }

    /**
    * @description: Setter method for BATCH_SIZE_KEY
    */
    public void setBatchSize(Integer batchSize) {
        LIMIT_DESCRIBE_MAP.put(BATCH_SIZE_KEY, batchSize);
    }

    /**
    * @description: Allows for setting any custom test descriptors
    */
    public void setContext(String context) {
        LIMIT_DESCRIBE_MAP.put(CONTEXT_KEY, context);
    }

    /**
    * @description: Allows for setting any custom test descriptors
    */
    public void setCustomDescription(String key, Object value) {
        LIMIT_DESCRIBE_MAP.put(key, value);
    }
}