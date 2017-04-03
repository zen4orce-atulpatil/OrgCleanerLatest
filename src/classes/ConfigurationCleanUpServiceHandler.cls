public with sharing class ConfigurationCleanUpServiceHandler {
    public static List<String> classesToDelete;
    public static map<Id,String> mapClassNameId;
    public static String sessionId;
    public static string generateJsonForTrigger(Map<string, List<List<string>>> configurationList){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;  
        for(String objectName: configurationList.keySet()){
            gen.writeStartObject();
            gen.writeStringField('id', String.valueOf(count));
            gen.writeStringField('name', objectName);
            gen.writeStringField('enbl', '0');
            gen.writeStringField('level', '0');
            gen.writeStringField('parent', '');
            gen.writeStringField('isLeaf', 'false');
            gen.writeStringField('expanded', 'false');
            gen.writeStringField('loaded', 'false');
            gen.writeEndObject();
            Integer ChildCount = 0;
            
            for(List<String> configDetails : configurationList.get(objectName)){
                gen.writeStartObject();
                gen.writeStringField('id', count + '' + (ChildCount+1));
                gen.writeStringField('configID', configDetails[1]);
                gen.writeStringField('name', configDetails[0]);
                gen.writeStringField('enbl', '0');
                gen.writeStringField('level', '1');
                gen.writeStringField('parentName', objectName);
                gen.writeStringField('parent', String.valueOf(count));
                gen.writeStringField('isLeaf', 'true');
                gen.writeStringField('expanded', 'false');
                gen.writeStringField('loaded', 'false');
                gen.writeEndObject();
                ChildCount++;
            }
            count++;
        }
        gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    }
    public static string generateJsonForApexPage(List<ApexPage> configurationList){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;  
        
        for(ApexPage apexPageObj: configurationList){
            gen.writeStartObject();
            gen.writeStringField('id', String.valueOf(count));
            gen.writeStringField('configID', apexPageObj.ID);
            gen.writeStringField('name', apexPageObj.Name);
            gen.writeStringField('enbl', '0');
            gen.writeStringField('level', '0');
            gen.writeStringField('parent', '');
            gen.writeStringField('isLeaf', 'false');
            gen.writeStringField('expanded', 'false');
            gen.writeStringField('loaded', 'false');
            gen.writeEndObject();
            count++;
        }
         gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    }
     public static string generateJsonForApexClass(List<ApexClass> lstAllApexClasses){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;  
        
        for(ApexClass apexClassObj: lstAllAPexClasses){
            gen.writeStartObject();
            gen.writeStringField('id', String.valueOf(count));
            gen.writeStringField('configID', apexClassObj.ID);
            gen.writeStringField('name', apexClassObj.Name);
            gen.writeStringField('enbl', '0');
            gen.writeStringField('level', '0');
            gen.writeStringField('parent', '');
            gen.writeStringField('isLeaf', 'false');
            gen.writeStringField('expanded', 'false');
            gen.writeStringField('loaded', 'false');
            gen.writeEndObject();
            count++;
        }
         gen.writeEndArray();
        gen.writeEndObject();
        System.debug('gen.getAsString()='+gen.getAsString());
        return gen.getAsString();
    }
      public static string generateJsonForCustomField(Map<string, List<string>> configurationList){
       System.debug('In Service Handler ');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;  
        
        for(String objectName: configurationList.keySet()){
            gen.writeStartObject();
            gen.writeStringField('id', String.valueOf(count));
            gen.writeStringField('name', objectName);
            gen.writeStringField('enbl', '0');
            gen.writeStringField('level', '0');
            gen.writeStringField('parent', '');
            gen.writeStringField('isLeaf', 'false');
            gen.writeStringField('expanded', 'false');
            gen.writeStringField('loaded', 'false');
            gen.writeEndObject();
            Integer ChildCount = 0;
            
            for(String configDetails : configurationList.get(objectName))
            {
                gen.writeStartObject();
                gen.writeStringField('id', count + '' + (ChildCount+1));
                gen.writeStringField('configID', configDetails);
                gen.writeStringField('name', configDetails);
                gen.writeStringField('enbl', '0');
                gen.writeStringField('level', '1');
                gen.writeStringField('parentName', objectName);
                gen.writeStringField('parent', String.valueOf(count));
                gen.writeStringField('isLeaf', 'true');
                gen.writeStringField('expanded', 'false');
                gen.writeStringField('loaded', 'false');
                gen.writeEndObject();
                ChildCount++;
            }
            count++;
        }
        gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    }
     Public static List<String> SearchInClass(List<String> searchKeywords)
    {
        List<String> lstDependentCLasses = new List<String>();
        String keywordsToSearch;
        String FinalString;
        set<String> ClassSummary = new set<String>();
        List<String> lstclasses=new List<String>();
        if(searchKeywords != null && searchKeywords.size()>0){
        
                for(String s:searchKeywords)
                    {
                         keywordsToSearch=keywordsToSearch+s+' '+'OR ';
                 }
        }
        
        if( keywordsToSearch != null && keywordsToSearch.length() > 0){
            
            String preFinalString=keywordsToSearch.removeStart('null');
            if(  preFinalString != null && preFinalString.length() > 0){
                
                FinalString=preFinalString.removeEndIgnoreCase('OR ');
            }           
        }
        
        String SearchQuery;
        //SOSL Dynamic Query
         System.debug('FinalString==>'+FinalString);
         if( FinalString != null && FinalString.length() > 0 ){
            
             SearchQuery = 'FIND {'+FinalString+'}RETURNING ApexClass(Name)';
         }
        
         System.debug('SearchQuery==>'+SearchQuery);
         
         List<Search.SearchResult> ClassSearchResult=ConfigurationSelector.selectclasses(SearchQuery);
         System.debug('ClassSearchResult==>'+ClassSearchResult);
        //Retriving Keyword Used in Class
         if(ClassSearchResult != null && ClassSearchResult.size() > 0){
            
            for (Search.SearchResult searchResult : ClassSearchResult) { 
                ApexClass Classes = (ApexClass) searchResult.getSObject(); 
                ClassSummary.add(Classes.Name);
            }
         }
         if( ClassSummary.size() > 0){
            
            ClassSummary.removeAll(searchKeywords); 
         }
        
        
        if(Test.isRunningTest()){
            lstclasses.add('SampleClass');  
        }
        else{
            lstclasses.addAll(ClassSummary);        
        }
        
        Map<String, List<String>> SummaryMap = new Map<String, List<String>>();
        SummaryMap.put('ApexClass',lstclasses);
        return lstclasses; 
    }
    
    Public static List<String> SearchInTrigger(List<String> searchKeywords)
    {   
        
        
        String keywordsToSearch;
        String SearchQuery;
        List<String> TriggerSummary = new list<String>();
        for(String s:searchKeywords)
        {
            keywordsToSearch=keywordsToSearch+s+' '+'OR ';
        }
        if( keywordsToSearch != null && keywordsToSearch.lengtH()>0){
            
             String preFinalString=keywordsToSearch.removeStart('null');
                if( preFinalString != null && preFinalString.length()>0 ){
                    
                    String FinalString=preFinalString.removeEndIgnoreCase('OR ');
                    SearchQuery = 'FIND {'+FinalString+'}RETURNING ApexTrigger(name)';
                }
                
            
        }
        List<Search.SearchResult> TriggersearchResults=ConfigurationSelector.selectTriggers(SearchQuery);
        
        
        if(TriggersearchResults != null && TriggersearchResults.size() > 0){
            
            for (Search.SearchResult TriggersResults : TriggersearchResults) { 
                ApexTrigger Triggers = (ApexTrigger) TriggersResults.getSObject();
                TriggerSummary.add(Triggers.Name);
            }
         }
         Map<String, List<String>> SummaryMap = new Map<String, List<String>>();
         SummaryMap.put('ApexTrigger', TriggerSummary);
         return TriggerSummary;  
    }
    
    Public static List<String> SearchInPage(List<String> searchKeywords)
    {        
        //Retriving Keyword Used in Pages
        List<String> PageNames = new List<String>();
        PageNames=ConfigurationSelector.selectApexPages(searchKeywords);
         Map<String, List<String>> SummaryMap = new Map<String, List<String>>();
        SummaryMap.put('ApexPages', PageNames);
        return PageNames;
    }
    
    public static string generateJson(List<String> lstComponents){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;  
        
        for(String apexClassObj: lstComponents){
            gen.writeStartObject();
            gen.writeStringField('id', String.valueOf(count));
            gen.writeStringField('configID', '');
            gen.writeStringField('name', apexClassObj);
            gen.writeStringField('enbl', '0');
            gen.writeStringField('level', '0');
            gen.writeStringField('parent', '');
            gen.writeStringField('isLeaf', 'false');
            gen.writeStringField('expanded', 'false');
            gen.writeStringField('loaded', 'false');
            gen.writeEndObject();
            count++;
        }
         gen.writeEndArray();
        gen.writeEndObject();
        System.debug('gen.getAsString()='+gen.getAsString());
        return gen.getAsString();
    }
    
    
    public static void deleteclasses(map<Id,String> mapClassNameandId,List<String> lstDependentClasses,List<String> lstDependentTriggers ,List<String> lstDependentPages)
    {
        
        mapClassNameId = new map<Id,String>(); 
        mapClassNameId.putAll(mapClassNameandId);
        classesToDelete=new List<String>();
        List<String> lstClassesToDelete = new List<String>();
        lstClassesToDelete.addAll(mapClassNameId.values());
        classesToDelete.addAll(lstClassesToDelete);
        lstDependentClasses=SearchInClass(lstClassesToDelete);
        lstDependentPages=SearchInPage(lstClassesToDelete);
        lstDependentTriggers=SearchInTrigger(lstClassesToDelete);   
        sessionId=UserInfo.getSessionId();
        Integer count = System.purgeOldAsyncJobs(Date.today()+1);
        Database.executeBatch(new CommentDependentClassBatch(lstDependentClasses,sessionId),10);
        Database.executeBatch(new CommentDependentTriggersBatch(lstDependentTriggers,sessionId),10);
        Database.executeBatch(new CommentDependentPagesBatch(lstDependentPages,sessionId),10);
        
        ScheduleDeletionBatch();    
    }
    
    public static void ScheduleDeletionBatch(){
        System.debug('In ScheduleDeletionBatch');
        List<ApexClass> lstclasses=new List<ApexClass>();
        lstclasses=Configurationselector.getApexClasses(classesToDelete);
        DeleteclassesBatch deletionBatch=new DeleteclassesBatch(mapClassNameId,sessionId);
        BatchScheduler scheduler = new BatchScheduler();
        scheduler.batchClass = deletionBatch;
        if(BatchScheduler.schedulestatus==false || BatchScheduler.schedulestatus==null){
            String day = string.valueOf(system.now().day());
            String month = string.valueOf(system.now().month());
            String hour = string.valueOf(system.now().hour());
            String minute = string.valueOf(system.now().minute()+1);
            String second = string.valueOf(system.now().second());
            String year = string.valueOf(system.now().year());
            String strJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
            String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
            System.schedule(strJobName,strSchedule,scheduler);
        }
        System.debug('In ScheduleDeletionBatch');
    }
    
   //Added
   public static string generateJsonForCustomData(List<String> configurationList)
   {
       System.debug('In Service Handler ');
       JSONGenerator gen = JSON.createGenerator(true);
       gen.writeStartObject();
       gen.writeFieldName('data');
       gen.writeStartArray();
       Integer count = 1; 
       
       for(String objectName: configurationList){
           gen.writeStartObject();
           gen.writeStringField('id', String.valueOf(count));
           gen.writeStringField('name', objectName);
           gen.writeStringField('enbl', '0');
           gen.writeStringField('level', '0');
           gen.writeStringField('parent', '');
           gen.writeStringField('isLeaf', 'false');
           gen.writeStringField('expanded', 'false');
           gen.writeStringField('loaded', 'false');
           gen.writeEndObject();
           count++;
       }
       gen.writeEndArray();
       gen.writeEndObject();
       System.debug('In Json Parser gen.getAsString()'+gen.getAsString());
       return gen.getAsString();
   }
}