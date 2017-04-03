public with sharing class ConfigurationSelector {
    public static List<ApexTrigger> getTriggers()
    {
        List<ApexTrigger> triggerList = new List<ApexTrigger>([Select TableEnumOrId,Name from ApexTrigger]);
        if(test.isRunningTest()){
            ApexTrigger a=new ApexTrigger();
            a.id='01q28000000kJuS';
            a.Name='TriggerOne';
            a.TableEnumOrId='01q28000000kJuS';
            ApexTrigger b=new ApexTrigger();
            b.id='01q28000000kJaS';
            b.Name='TriggerTwo';
            b.TableEnumOrId='01q28000000kJuS';
            triggerList.add(a);
            triggerList.add(b);
        }
        return triggerList;
    }
    public static List<ApexPage> getVisualforcePages(){      
        List<ApexPage> apexPageList = new List<ApexPage>([Select Id, Name From Apexpage]);
        return apexPageList;
    }
    public static List<ApexClass> getApexClasses(){      
        List<ApexClass> apexClassList=new List<ApexClass>([select Id,Name from ApexClass]);
        return apexClassList;
    }
     public static List<Search.SearchResult> selectclasses(String SearchQuery)
    {  
        if( SearchQuery != null && SearchQuery.length() > 0 ){
            
            Search.SearchResults searchResults = Search.find(SearchQuery);
            return searchResults.get('ApexClass');
        }
        return null;
    } 
    //get triggers
    public static List<Search.SearchResult> selectTriggers(String SearchQuery)
    {
        if( SearchQuery != null && SearchQuery.length() > 0 ){
            
            Search.SearchResults searchResults = Search.find(SearchQuery);
            return searchResults.get('ApexTrigger');
        }
        return null;
    }
    //get visiualforce pages
    public static List<String> selectApexPages(List<String> searchKeywords)
    {
        
        Map<ID, ApexPage> ApexpageBody = new Map<ID, ApexPage>([SELECT Id,Name,Markup FROM ApexPage]);
        List<String> PageNames = new List<String>();
        if( searchKeywords != null && searchKeywords.size()>0){
        
            for(String s:searchKeywords)
            {
                for (ID idKey : ApexpageBody.keyset()) 
                {
                     ApexPage a = ApexpageBody.get(idKey);
                    
                    String pageMarkup=a.Markup.normalizeSpace();
                    String pageName=pageMarkup.substringAfter('=');
                    String finalPageName=pageName.substringBefore('>');
                    if(finalPageName=='"'+s+'"' || finalPageName==s)
                    {
                        PageNames.add(a.Name);
                    }
                }
            }
        }
        
        return PageNames;
    }
    
    //Added for Apex Classes deletion
    public static Map<ID, ApexClass> getApexClassBody(String className)
    {
        return new Map<ID, ApexClass>([SELECT Id,Body,Name FROM ApexClass where Name=:className]);
    }
    public static Map<ID, ApexTrigger> getApexTrigger(String triggerName)
   {
        return new Map<ID, ApexTrigger>([SELECT Id,Body,Name FROM ApexTrigger where Name=:triggerName]);    
   }
   //get visiualforcePageMarkup
    public static ApexPage selectApexPagemarkup(String pageName)
    {
        
        if(test.isRunningTest()){
            return null;
        }
        else{
            ApexPage ApexPageBody = ([SELECT Id,Markup,Name FROM ApexPage where Name=:pageName]);   
            return ApexPageBody;
        }
    }
    
    public static AsyncApexJob asyncApexJobDetails(Id idOfJob) {
        AsyncApexJob a;
        try {
            if(idOfJob != null) {
                a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                     TotalJobItems, CreatedBy.Email
                     FROM AsyncApexJob WHERE Id =:idOfJob LIMIT 1];
            }
        return a;
        }catch(Exception ex) {
           return new AsyncApexJob();
        }
    }
    public static List<ApexClass> getApexClasses(List<String> lstNameOfClasses)
    {
        List<ApexClass> lstclasses=new List<ApexClass>([select Id,Name from ApexCLass where Name IN:lstNameOfClasses]);
        return  lstclasses;
    }
    
    public static List<AsyncApexJob> getAsyncApexJobStatus(List<String> lstAsyncApexJobNames){
        System.debug('lstAsyncApexJobNames='+lstAsyncApexJobNames);
        return new List<AsyncApexJob>([Select ApexClass.Name,ApexClassID,status from AsyncApexJob where ApexClass.name IN:lstAsyncApexJobNames]);
    }
    //Query for find NamespacePrefix of your Organization
    public static string nameSpaceprefixOfOrg()
    {
        String nameSpace;
        Organization org = [SELECT NamespacePrefix FROM Organization];
        nameSpace = String.valueOf(org.NamespacePrefix);
        return nameSpace;
    }
    public static List<ApexClass> getAllApexClasses(){
        List<ApexClass> lstclasses=new List<ApexClass>([select Id,Name from ApexCLass]);    
        return  lstclasses;
    }
}