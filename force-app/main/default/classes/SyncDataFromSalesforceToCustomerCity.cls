global class SyncDataFromSalesforceToCustomerCity {
    // This function is for sending data from salesforce to Customer city
    public static String sendDataToCustomerCity(){
        try{
            wrapperValidateUser wvu= getToken('cctest@gmail.com','Password123.');
            System.debug('==wvu=>'+wvu);
            String token;
            if(!wvu.isNull()){
               token = wvu.data.accessToken;
            }
            else{
                return 'Not Able To Get Access Token';
            }
            Migration md = getDataMigrationCode();
            HTTP objectOfHttp = new HTTP(); 
            HTTPRequest req = new HTTPRequest();
            req.setEndpoint('https://api.customercitydev.com/dataMigration/3e48c623-6293-475e-8601-a6ffc009ccb2/recordUpdate');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer '+token);
            req.setMethod('POST');  
            String JSONBody = constructReqBody('abs');
            System.debug('===>'+JSONBody);
            req.setBody(JSONBody);
            integer StatusCode = 0; 
            String responseBody='';
            HTTPResponse res =new HTTPResponse();
            if(!Test.isRunningTest()){    
                res = objectOfHttp.send(req); 
                StatusCode=res.getStatusCode(); 
            }else{
                StatusCode = 200;
                responseBody = '';
            }
            system.debug('StatusCode'+ StatusCode);
            responseBody = res.getBody();
            system.debug('responseBody'+ responseBody);
            return responseBody;
        }
        catch(Exception e){
            return e.getMessage();
        }     
    }
    // This function is for creating request body as per req of api request body
    @AuraEnabled
    public static String constructReqBody(String jsonString){
        UpdateWrapper wrap = new UpdateWrapper();
        UpdateWrapper.UpdateInfo ui = new UpdateWrapper.UpdateInfo();
        UpdateWrapper.UpdateData ud  = new UpdateWrapper.UpdateData();
        Map<String, Object> payloadMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        Map<String, Object> dataMap = (Map<String, Object>) payloadMap.get('data');
        Map<String, Object> payload = (Map<String, Object>) dataMap.get('payload');
        Map<String, Object> changeEventHeader = (Map<String, Object>) payload.get('ChangeEventHeader');
        //String rating = (String) payload.get('Rating');
        System.debug('ChangedFields: ' + changeEventHeader.get('changedFields'));
        List<String> Fields =(List<String>)changeEventHeader.get('changedFields');
        String dataFields ='{';
          for(Integer i=0;i<Fields.size();i++){
              dataFields +=Fields[i]+':'+payload.get(Fields[i]);
        }
        dataFields+='}';
       String requestBody = '{"updates": [{"table": "Table-1","data": [{'+dataFields+'}]}]}';
        String entityName = (String) changeEventHeader.get('entityName');
        System.debug('Entity Name: ' + entityName);


     //   Map<String,Object>DataMap = parsedData.get('data');
       // String jsonString='';
     //   System.debug('=>'+wrap);
        System.debug('==>'+jsonString);
       
        return jsonString;
        
    }
    public static UpdateWrapper deserilizeResponse(String jsonString){
    UpdateWrapper wrapper = (UpdateWrapper) JSON.deserialize(jsonString, UpdateWrapper.class);
        for (UpdateWrapper.UpdateInfo info : wrapper.updates) {
            System.debug('Table name: ' + info.table);
            for (UpdateWrapper.UpdateData data : info.data) {
                System.debug('Id: ' + data.Id);
                System.debug('Name: ' + data.name);
                System.debug('Email: ' + data.email);
            }
        }   
        return wrapper;
    } 
    // For Getting Access Token
    public static wrapperValidateUser getToken(string email, string password){
        wrapperValidateUser wrap = new wrapperValidateUser();
        try{
            HTTP objectOfHttp = new HTTP(); 
            HTTPRequest req = new HTTPRequest();
            req.setEndpoint('https://api.customercitydev.com/auth/login');
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');  
            String JSONBody ='{"email":"'+email.trim() +'","password":"'+password.trim()+'"}';
            System.debug('===>'+JSONBody);
            req.setBody(JSONBody);
            integer StatusCode = 0; 
            String responseBody='';
            HTTPResponse res =new HTTPResponse();
            if(!Test.isRunningTest()){    
                res = objectOfHttp.send(req); 
                StatusCode=res.getStatusCode(); 
            }else{
                StatusCode = 200;
                responseBody = '';
            }
            system.debug('StatusCode'+ StatusCode);
            if(StatusCode == 201) {   
                responseBody = res.getBody();
                system.debug('responseBody'+ responseBody);
                wrap = (wrapperValidateUser)JSON.deserialize(responseBody, wrapperValidateUser.class);
                return wrap;
            }
            else{
                return wrap;   
            }
        }
        catch(Exception e){
            System.debug('==>'+e.getMessage());
            return wrap;
        }
    }
    // For Data Migration Code API
    public static Migration getDataMigrationCode(){
        HTTP objectOfHttp = new HTTP(); 
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://api.customercitydev.com/dataMigration/dataSource/Salesforce');
       // req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer eyJraWQiOiJtSFZUekVSUTZMc3RZektzZm5LZGtZSWJJMVRvM24yaERuSk1jUmFEYmFFPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiIwNGUxOTNkNi1kY2I4LTQyM2QtYmRlMy03MTg4ZDhmMDc5ZjciLCJjb2duaXRvOmdyb3VwcyI6WyJvd25lciJdLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9FbEpHWklKUFoiLCJjb2duaXRvOnVzZXJuYW1lIjoiMDRlMTkzZDYtZGNiOC00MjNkLWJkZTMtNzE4OGQ4ZjA3OWY3Iiwib3JpZ2luX2p0aSI6ImU4MjNhY2M2LTcyNzMtNGMyNS05YjE4LTBiNTk0YTk2Njc1NCIsImF1ZCI6IjcyZ2l1bTZlYnV2NThsYWVncGhtOWEyOG8xIiwiZXZlbnRfaWQiOiI5MDhjNjQ3My1mNGVlLTQ5YTctYmI4MC0zNGY3YmM5OGY4ZDIiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTY4Mjc2ODA0NCwiZXhwIjoxNjgyNzcxNjQ0LCJpYXQiOjE2ODI3NjgwNDQsImp0aSI6ImVlODljM2YzLTNjYTUtNDIwZC1hYjhkLTBlYmE2NDE0ZDlmNCIsImVtYWlsIjoiY2N0ZXN0QGdtYWlsLmNvbSJ9.dXpAltqXOSvghq-2_cc_T8Zq-VZ30WUrGNAl3tfGu6dbBeeF4fWjFgml_xRa2u-4hwWA8sOkGePuRIU82Y-bj1YmYyV--WFgsAAmjaqiwy1dVvA0m4zkd1MYpK-qGZbVpg1bOiV06CMFAEjsSyj7T2zbXuHqh0T5bpwn4spaBeqhaRyx8GvDiLp0MzjamcYxca2efA1D1DvIKcsUtg1uDcY4r82T6JZVghSHAEaNeDs4ZDVlfZchK73yo3lX5cQm4f2ZHn7S-TJkHFLdkJdbHW5d1IbO78XDQwi3zTk1mhlQOqx1TqV7IDQWtfP55BPbTlnXbi-obDlYXvEPYtY3pQ');
        req.setMethod('GET');  
        
        integer StatusCode = 0; 
        String responseBody='';
        HTTPResponse res =new HTTPResponse();
        if(!Test.isRunningTest()){    
            res = objectOfHttp.send(req); 
            StatusCode=res.getStatusCode(); 
        }else{
            StatusCode = 200;
            responseBody = '';
        }
        system.debug('StatusCode'+ StatusCode);
        responseBody = res.getBody();
        system.debug('responseBody'+ responseBody);
        Migration md = (Migration) JSON.deserialize(responseBody,Migration.class);
        return md; 
    }
    public class wrapperValidateUser{
        private Object obj {get;set;}
        public Boolean success {get;set;}
        public string message {get;set;}
        public getAccessToken data {get;set;}    
        public Boolean isNull() {
        return obj == null;
    }
    }
    public class getAccessToken{
        public string accessToken{get;set;}
    }
    public class Migration{
        public Object obj{get;set;}
        public Boolean Success{get;set;}
        public String Message{get;set;}
        public Data dmObj{get;set;}
        public Boolean isNull(){
          return obj == null;
        }
    }
    public class Data{
        public String dataMigrationId{get;set;}
        public String dataSourceId{get;set;}
        public String status{get;set;}
        public Integer tenantId{get;set;}
        public String userId{get;set;}
        public DateTime statusDate{get;set;}
        public Date syncedAt{get;set;}
    }
}