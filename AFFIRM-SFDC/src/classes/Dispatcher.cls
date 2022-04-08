public inherited sharing class Dispatcher {
	public static List<String> processed = new List<String>();
	public static Boolean allowLoops = true;
	private static List<SObjectType> Overrides = new List<SObjectType>();

	private static Boolean AllowLoopsOverride(SObjectType type){


        if (Overrides.contains(type)) {
            return true;
        } else {
            return false;
        }

	}


	public static void process(SObjectType type, TriggerHandler handler){
		//no loops allowed, if we detect there has already been a trigger of this type called already
		String triggerContext;


		if(Trigger.isBefore) {
			triggerContext = 'before:';
		}
		else if(Trigger.isAfter) {
			triggerContext = 'after:';
		}

		triggerContext += String.valueOf(type);

		if(!processed.contains(triggerContext)){
			processed.add(triggerContext);
			doProcessing(handler);
		}
		//bypass to allow us to loop, for testing, remove when all dependant loops are eliminated
		else if(allowLoops && !(AllowLoopsOverride(type))){
			doProcessing(handler);
		}
	}




	private static void doProcessing(TriggerHandler handler){
		if (Trigger.isBefore) {
			if(Trigger.isInsert){
				handler.beforeInsert(Trigger.new);
			}
			else if(Trigger.isUpdate){
				handler.beforeUpdate(Trigger.new, Trigger.oldMap);
			}
			else{ //Trigger.isDelete{
				handler.beforeDelete(Trigger.old, Trigger.oldMap);
			}

		} else if (Trigger.isAfter) {
			if(Trigger.isInsert){
				handler.afterInsert(Trigger.new);
			}
			else if(Trigger.isUpdate){
				handler.afterUpdate(Trigger.new, Trigger.oldMap);
			}
			else if(Trigger.isDelete){
				handler.afterDelete(Trigger.old, Trigger.oldMap);
			}
			else{ //Trigger.isUndelete{
				handler.afterUndelete(Trigger.new);
			}
		}
		/*if(Trigger.isDelete){
			handler.runTriggerSwitchHandler(Trigger.old, Trigger.oldMap);
		}else{
			handler.runTriggerSwitchHandler(Trigger.new, Trigger.oldMap);
		}*/
	}
}