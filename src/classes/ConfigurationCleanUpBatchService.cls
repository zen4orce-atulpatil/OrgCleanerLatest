global class ConfigurationCleanUpBatchService implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{    
    global Map<String,List<String>> receivedlist = new Map<String,List<String>>();
    global List<String> batchlist = new List<String>(); 
    global string configName;
    public String sessionId; 
    
    global ConfigurationCleanUpBatchService(Map<String,List<String>> listofsobject){
       
        sessionId = UserInfo.getSessionId();
        for(String sObj : listofsobject.keySet()){
            batchlist = listofsobject.get(sObj);
            configName = sObj;
            listofsobject.remove(sObj);
            receivedlist = listofsobject.clone();
           
            break;
        }
    }
    global List<String> start(Database.BatchableContext BC){
       
        return batchlist;
        //return new IterableConfigurationHandler();
    }
    global void execute(Database.BatchableContext BC, List<String> scope){
       
        List<String> ss = new  List<String>();
        try{
            system.debug('*****************try*********************');
            ToolingAPIService t = new ToolingAPIService();
            MetadataAPI mapi = new MetadataAPI();
            for (String s : scope) 
            {   
                system.debug('*****************configName*********************'+configName);
                if(configName == 'ApexTrigger'){
                   
                    t.TriggerDelete(s, sessionId);
                }
                if(configName == 'ApexPage'){
                  
                    t.PageDelete(s, sessionId);
                } 
                ss.add(string.valueOf(s));
            }
            if(configName == 'Workflow'){
                system.debug('*****************if configName*********************'+configName);
                mapi.deleteWorkflow(ss,sessionId);
            }
            if(configName == 'ValidationRule'){
              
                mapi.deleteValidationRule(ss,sessionId);
            }
        }
        catch(Exception e){
            System.debug('*************************Exception*************************'+ e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
      
       if(receivedlist.size() > 0){
           
            configName = ''; 
            Id batchInstanceId = Database.executeBatch(new ConfigurationCleanUpBatchService(receivedlist));
        }
    }     
}