public class handleQualityEvent {
    public static void handleAfterUpdate(Map<Id,Quality_Event__c> oldMap,Map<Id,Quality_Event__c> newMap) {
        sendQualityEventlLots(newMap.keyset());
    }
    @future(callout=true)
    public static void sendQualityEventlLots(Set<Id> idset) {
        Map<Id,List<Impacted_Lot_SN__c>> qualityEventLotListMap = new Map<Id,List<Impacted_Lot_SN__c>>();
        Id impactedLotRecordTypeId = Schema.SObjectType.Impacted_Lot_SN__c.getRecordTypeInfosByDeveloperName().get('PW_Impacted_Lot').getRecordTypeId();
        List<Impacted_Lot_SN__c> ImpactedLotSNList = [select Id,recordtypeId,Lot_Serial_Number__c,Dispositions__c,Related_Quality_Event__r.Id,Related_Quality_Event__r.Name,Related_Quality_Event__r.CMPL123_WF_Status__c,Item_Number__c from Impacted_Lot_SN__c WHERE Related_Quality_Event__r.Id IN:idset];
        for(Impacted_Lot_SN__c imp1 : ImpactedLotSNList){
            if(imp1.recordtypeId == impactedLotRecordTypeId){
                if(qualityEventLotListMap.containskey(imp1.Related_Quality_Event__c)){
                    List<Impacted_Lot_SN__c> existingList = qualityEventLotListMap.get(imp1.Related_Quality_Event__c);
                    existingList.add(imp1);
                    qualityEventLotListMap.put(imp1.Related_Quality_Event__c,existingList);
                }else{
                    List<Impacted_Lot_SN__c> newList = new List<Impacted_Lot_SN__c>();
                    newList.add(imp1);
                    qualityEventLotListMap.put(imp1.Related_Quality_Event__c,newList);
                }
            }
        }
        for(Id ids : qualityEventLotListMap.keyset()){
            system.debug('send quality event in update');
            QualityEventController.createQualityEvent(qualityEventLotListMap.get(ids));
        }
    }
}