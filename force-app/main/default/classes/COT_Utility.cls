public with sharing class COT_Utility {
    @AuraEnabled
    public static List<CRecordType> getRecordTypes(string apiName,string recordTypeName)
    {
        List<CRecordType> rtn = new List<CRecordType>();
        Map<Id,RecordType> lst = new Map<Id,RecordType>();

                system.debug('apiName:' + apiName);
                system.debug('recordTypeName:' + recordTypeName);


        Schema.sObjectType obj = Schema.getGlobalDescribe().get(apiName);        

        List<Schema.RecordTypeInfo> recTypeInfo = obj.getDescribe().getRecordTypeInfos();

        if (string.isEmpty(recordTypeName))
        {
            lst = new Map<Id,RecordType>([SELECT Id, Name,Description  FROM recordtype where sObjectType = :apiName]);

            for (Schema.RecordTypeInfo rti : recTypeInfo)
            {
                if (rti.Active && rti.Available && !rti.Master)
                {
                    CRecordType rt = new CRecordType();
                    rt.Id = rti.RecordTypeId;
                    rt.Name = rti.Name;
                    rt.Description = lst.get(rti.RecordTypeId).Description;
                    rt.checked = rti.DefaultRecordTypeMapping;
                    rtn.add(rt);
                }
            }
        }
        else 
        {
            for (Schema.RecordTypeInfo rti : recTypeInfo)
            {
                system.debug('rti:' + rti);
                if (rti.Name == recordTypeName)
                {
                    CRecordType rt = new CRecordType();
                    rt.Id = rti.RecordTypeId;
                    rt.Name = rti.Name;
                    //rt.Description = r.Description;
                    rt.checked = rti.DefaultRecordTypeMapping;
                    rtn.add(rt);
                }
            }

        }

        system.debug('rtn:' + rtn);
        return rtn;
    }


    @AuraEnabled
    public static string getDefaultRecordType(string apiName)
    {
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(apiName);
        Schema.DescribeSObjectResult dsr = objectType.getDescribe();
        Schema.RecordTypeInfo defaultRecordType;
        for(Schema.RecordTypeInfo rti : dsr.getRecordTypeInfos()) {
            if(rti.isDefaultRecordTypeMapping()) {
                defaultRecordType = rti;
            }
        }

        return defaultRecordType.RecordTypeId;
    }

    public class CRecordType
    {
        @AuraEnabled
        public String Id;

        @AuraEnabled
        public String Name;

        @AuraEnabled
        public String Description;

        @AuraEnabled
        public Boolean checked;

    }
}