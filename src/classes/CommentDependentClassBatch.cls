global with sharing class CommentDependentClassBatch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{
	
	public String typeName='';
	public List<String> lstPagesToComment;  
	public List<String> lstClassesToDelete=new List<String>();
	public String sessionId='';
    public List<String> lstFailedClasses=new List<String>();
    public map<String,List<String>> failedComponentsToComment=new map<String,List<String>>();

	global CommentDependentClassBatch(List<String> typeWiseMap,string sess)
	{
		sessionId = sess;
		System.debug('In Cons sessionId CommentDependentClassBatch'+sessionId);
		lstPagesToComment=new List<String>();
		lstPagesToComment=typeWiseMap;
	}
	
	global List<String> start(Database.BatchableContext BC){
		System.debug('In Start method sessionId CommentDependentClassBatch'+sessionId);
        return lstPagesToComment;	
    }
    global void execute(Database.BatchableContext BC, List<String> scope){	
        try{
        	System.debug('one ');
        		System.debug('sessionId CommentDependentClassBatch execute method='+sessionId);
        		for(String s:CommentDependents.CommentMultipleClasses(scope, sessionId))
        		{
        			lstFailedClasses.add(s);	
        		}
        		failedComponentsToComment.put('ApexClass',lstFailedClasses);
        		System.debug('lstFailedClasses='+lstFailedClasses);
        	System.debug('one end');
        }
        catch(Exception e){
        	System.debug('Error in Batch'+e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
    	
	    String body;
	    if(lstFailedClasses.size()>0){
	    	body='Class='+lstFailedClasses+' are not commented and will give errors while you compile. Please Comment these mannually';
	    }
	    else{
	    	body='All Classes are commented Successfully';
	    }
	    Id idOfCurrentBetch = BC.getJobId();
	    List<ApexClass> lstclasses=new List<ApexClass>();
	    AsyncApexJob lstAsyncApexJob = Configurationselector.asyncApexJobDetails(idOfCurrentBetch);
	    AsyncApexJob a=lstAsyncApexJob;
	    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	    String[] toAddresses;
	    if(test.isRunningTest()){
	    	toAddresses = new String[]{'abc@gmail.com'};
	    }else{
			toAddresses = new String[] {a.CreatedBy.Email};	    
	    }
	    mail.setToAddresses(toAddresses);
	    mail.setSubject('Details of Classes Comment');
		mail.setPlainTextBody(body);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }		
}