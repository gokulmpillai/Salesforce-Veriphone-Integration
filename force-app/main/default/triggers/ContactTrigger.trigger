trigger ContactTrigger on Contact (after insert, after update) {
    switch on Trigger.Operationtype {
        when AFTER_INSERT{
            Set<id> conIdSet=new Set<id>();
            for(Contact conObj : Trigger.new){
                if(conObj.phone != Null){
                    conIdSet.add(conObj.id);
                    String phone = (String)conObj.Phone;
                    VeriphoneIntegration.PhoneVerification(conIdSet, phone);
                }
            }
        }
        when AFTER_UPDATE{
            
        }
    }
}