@isTest
public with sharing class ConfigurationSelectorTest {
	@isTest
	public static void testselectApexPages(){
		List<String> classesToSearch = new List<String>();
		classesToSearch.add('ClassOne');
		classesToSearch.add('ClassTwo');
		classesToSearch.add('ClassThree');
		List<String> lstPages = new List<String>();
		lstPages = Configurationselector.selectApexPages(classesToSearch);
	}
    @isTest
    public static void testselectclasses(){
		 String SearchQuery = 'FIND {ClassOne,ClassTwo}RETURNING ApexClass(Name)';
		Configurationselector.selectclasses(SearchQuery);      
    }
    @isTest
    public static void testselectTriggers(){
    	String SearchQuery = 'FIND {ClassOne,ClassTwo}RETURNING ApexTrigger(Name)';
		Configurationselector.selectTriggers(SearchQuery);    
    }
    
    @isTest
    public static void testselectApexPagemarkup(){
        String errmsg;
        String pageName ='SamplePage';
        ApexPage a = Configurationselector.selectApexPagemarkup('pageName'); 
        /*try{
        	   
        }catch(Exception e){
            errmsg=e.getMessage();
        }
        //System.assertEquals(true,errmsg.contains('List has no rows for assignment to SObject'));*/
    }
    
    @isTest
    public static void testselectAllTriggers(){
    	List<ApexTrigger> lstTriggers = new List<ApexTrigger>();
		lstTriggers = Configurationselector.getTriggers();    
    }
    @isTest
    public static void testselectVisualforcePages(){
        List<ApexPage> lstApexPages = new List<ApexPage>();
		lstApexPages = Configurationselector.getVisualforcePages();
    }
    @isTest
    public static void testgetApexClasses(){
    	List<ApexClass> lstClassesToDelete = new List<ApexClass>();
		lstClassesToDelete=Configurationselector.getApexClasses();
    }
    @isTest
    public static void testSelectdgetApexClasses(){
        List<String> lstclassesToSearch = new List<String>();
        lstclassesToSearch.add('ClassOne');
    	List<ApexClass> lstClassesToDelete = new List<ApexClass>();
		lstClassesToDelete=Configurationselector.getApexClasses(lstclassesToSearch);
    }
    @isTest
    public static void testgetApexClassBody(){
        
        Map<ID, ApexClass> mapApexClass = new Map<ID, ApexClass>();
        String ClassName='SampleClass';
        mapApexClass = Configurationselector.getApexClassBody(ClassName);
    }
    @isTest
    public static void testgetApexTrigger(){
        Map<ID, ApexTrigger> mapApexTrigger = new Map<ID, ApexTrigger>();
        String triggerName = 'SampleTrigger';
        mapApexTrigger = Configurationselector.getApexTrigger(triggerName);
    }
    @isTest
    public static void testasyncApexJobDetails(){
        
        Id jobId='7072800002nQFRDAA4';
        AsyncApexJob ap = Configurationselector.asyncApexJobDetails(jobId); 
        /*try{
            
        	AsyncApexJob ap = Configurationcleanupselector.asyncApexJobDetails(jobId);    
        }catch(Exception e){
            String err=e.getMessage();
            System.assertEquals(true,err.contains('List has no rows for assignment to SObject'));
        }*/
    	
    }
    @isTest
    public static void testgetAllApexClasses(){
        List<ApexClass> lstApexClasses = new List<ApexClass>(); 
        lstApexClasses = Configurationselector.getAllApexClasses();
    }
    @isTest
    public static void testgetAsyncApexJobStatus(){
        List<AsyncApexJob> lstAsyncApexJob = new List<AsyncApexJob>();
        List<String> lstApexAsyncJobNames = new List<String>();
		lstApexAsyncJobNames.add('CommentDependentClass');
		lstApexAsyncJobNames.add('CommentDependentPages');
		lstApexAsyncJobNames.add('CommentDependentTriggers');
        try{
			lstAsyncApexJob =  Configurationselector.getAsyncApexJobStatus(lstApexAsyncJobNames);            
        }catch(Exception e){
            String errmsg=e.getMessage();
            System.assertEquals(true,errmsg.contains('List has no rows for assignment to SObject'));
        }
    }
}