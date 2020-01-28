public with sharing class COT_BusinessPlanDatahandler {

    public static string RETAILPROGRAM = 'Starter Company Retail Accel Program';

    @AuraEnabled(cacheable=true)
    public static List<QuestionAndAnswerSection> GetQuestionAndAnswers(string incentiveId){

        system.debug('incentiveId:' + incentiveId);

        List<QuestionAndAnswerSection> rtn = new List<QuestionAndAnswerSection>();
        Financial_Incentive__c  fi = [SELECT id,Market_Research_and_Value_Proposition__c,Financial_Management__c,
            Inventory_Management_and_Supply_Chain__c,Customer_Retention_and_Experience__c,Managing_Staff__c,
            Store_Design_and_Merchandising__c,Program_Specific_Question_And_Answers__c,Application_Stream__c from Financial_Incentive__c where Id = :incentiveId];

        String type='Financial_Incentive__c';

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();


        QuestionAndAnswerSection sectionData = new QuestionAndAnswerSection();
        sectionData.Name = 'Business Plan';

        List<QuestionAndAnswer> questionAndAnswers =  new List<QuestionAndAnswer>();

        QuestionAndAnswer newQA = new QuestionAndAnswer();

        
        newQA = new QuestionAndAnswer();
        newQA.Question = fieldMap.get('Market_Research_and_Value_Proposition__c').getDescribe().getLabel();
        newQA.Answer = fi.Market_Research_and_Value_Proposition__c;
        questionAndAnswers.add(newQA);

        newQA = new QuestionAndAnswer();
        newQA.Question = fieldMap.get('Financial_Management__c').getDescribe().getLabel();
        newQA.Answer = fi.Financial_Management__c;
        questionAndAnswers.add(newQA);

        if (fi.Application_Stream__c == RETAILPROGRAM)
         {   

            newQA = new QuestionAndAnswer();
            newQA.Question = fieldMap.get('Customer_Retention_and_Experience__c').getDescribe().getLabel();
            newQA.Answer = fi.Customer_Retention_and_Experience__c;
            questionAndAnswers.add(newQA);

            newQA = new QuestionAndAnswer();
            newQA.Question = fieldMap.get('Managing_Staff__c').getDescribe().getLabel();
            newQA.Answer = fi.Managing_Staff__c;
            questionAndAnswers.add(newQA);

            newQA = new QuestionAndAnswer();
            newQA.Question = fieldMap.get('Inventory_Management_and_Supply_Chain__c').getDescribe().getLabel();
            newQA.Answer = fi.Inventory_Management_and_Supply_Chain__c;
            questionAndAnswers.add(newQA);
        
            newQA = new QuestionAndAnswer();
            newQA.Question = fieldMap.get('Store_Design_and_Merchandising__c').getDescribe().getLabel();
            newQA.Answer = fi.Store_Design_and_Merchandising__c;
            questionAndAnswers.add(newQA);
        }


        if (string.isNotEmpty(fi.Program_Specific_Question_And_Answers__c))
        {

            try {
                
                List<Map<string,List<Map<string,string>>>> finallist = (List<Map<string,List<Map<string,string>>>>)JSON.deserialize(fi.Program_Specific_Question_And_Answers__c, List<Map<string,List<Map<string,string>>>>.class);

                for (Map<string,List<Map<string,string>>> sectionMap : finallist)
                {

                    for (string sectionName : sectionMap.keySet())
                    {
                        
                        List<Map<string,string>> sectionList = sectionMap.get(sectionName);

                        for (Map<string,string> mp : sectionList)
                        {
                            for (string key : mp.keySet())
                            {
                                newQA = new QuestionAndAnswer();
                                newQA.Question = key;
                                newQA.Answer = EncodingUtil.urlDecode(mp.get(key), 'UTF-8');
                                questionAndAnswers.add(newQA);
                            }
                        }
                        
                    }

                }

            } catch (System.Exception ex) {
                
            }
        }

        sectionData.QuestionAndAnswers = questionAndAnswers;

        rtn.add(sectionData);

        system.debug('rtn:' + rtn);
        return rtn;
    }

    public class QuestionAndAnswerSection
    {
        @AuraEnabled
        public string Name;

        @AuraEnabled
        public List<QuestionAndAnswer> QuestionAndAnswers;
    }

    public class QuestionAndAnswer
    {
        @AuraEnabled
        public string Question;

        @AuraEnabled
        public string Answer;

        @AuraEnabled
        public string Type;
    }
}