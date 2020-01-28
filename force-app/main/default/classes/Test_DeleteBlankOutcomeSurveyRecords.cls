@isTest
public class Test_DeleteBlankOutcomeSurveyRecords{
     private static testmethod void test1(){
      Test.startTest();
        Client_FollowUp__c cf=new Client_FollowUp__c();
        cf.Survey_Start_Date__c =System.Date.Today()-1;
        insert cf;

       // This test runs a scheduled job at midnight Sept. 3rd. 2022
        String CRON_EXP = '0 0 0 3 9 ? 2022';
       // Schedule the test job
       String jobId = System.schedule('Test_DeleteBlankOutcomeSurveyRecords', CRON_EXP, new DeleteBlankOutcomeSurveyRecords());
      // Get the information from the CronTrigger API object 
         CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
       // Verify the expressions are the same System.assertEquals(CRON_EXP, ct.CronExpression); 
      // Verify the job has not run 
      System.assertEquals(0, ct.TimesTriggered); 
      // Verify the next time the job will run 
      System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));   
      Test.stopTest();        
    }
}