public with sharing class VeriphoneIntegration {	
    @future(callout = true)
    public static void PhoneVerification(Set<Id> contactId, String phoneNumber){
        
        List<Contact> updatedContactList = new List<Contact>();

        string key = 'E4918B5493D14778BC532FFEBDAB7AD7';
        string endPoint = 'https://api.veriphone.io/v2/verify?phone=' + phoneNumber + '&key='+ key;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request); 
        
        //Parsing the response                 
        VeriphoneResponse vr = (VeriphoneResponse)JSON.deserialize(response.getBody(), VeriphoneResponse.class);
        
        //Getting the list of newly created contacts
        List<Contact> conList = [SELECT Id, Name, Phone 
                                   FROM Contact 
                                   WHERE Id 
                                   IN :contactId];

        for(Contact conObj : conList){
            if(conObj.Phone != Null){
                conObj.Is_Valid__c = vr.phone_valid;
                updatedContactList.add(conObj);
            }    
        } 
        if(!updatedContactList.isEmpty()){
            update updatedContactList;
        }
    }
    public class VeriphoneResponse{
        public string status;
        public string phone;
        public boolean phone_valid;
        public string phone_type;
        public string phone_region;
        public string country;
        public string country_code;
        public string country_prefix;
        public string international_number;
        public string local_number;
        public string e164;
        public string carrier;
    }
}