public class handleImpacted_Lot_SN {
    public static void handleAfterInsert(Map<Id,Impacted_Lot_SN__c> oldMap,Map<Id,Impacted_Lot_SN__c> newMap) {
        sendQualityEventlLots(newMap.keyset());
    }
    @future(callout=true)
    public static void sendQualityEventlLots(Set<Id> idset) {
        Id impactedLotRecordTypeId = Schema.SObjectType.Impacted_Lot_SN__c.getRecordTypeInfosByDeveloperName().get('PW_Impacted_Lot').getRecordTypeId();
        Map<Id,List<Impacted_Lot_SN__c>> qualityEventLotListMap = new Map<Id,List<Impacted_Lot_SN__c>>();
        List<Impacted_Lot_SN__c> ImpactedLotSNList = [select Id,Lot_Serial_Number__c,recordtypeId,Dispositions__c,Related_Quality_Event__r.Name,Related_Quality_Event__r.CMPL123_WF_Status__c,Item_Number__c from Impacted_Lot_SN__c WHERE Id IN:idset];
        for(Impacted_Lot_SN__c sn : ImpactedLotSNList){
            if(sn.recordtypeId == impactedLotRecordTypeId){
                if(qualityEventLotListMap.containskey(sn.Related_Quality_Event__c)){
                    List<Impacted_Lot_SN__c> existingList = qualityEventLotListMap.get(sn.Related_Quality_Event__c);
                    existingList.add(sn);
                    qualityEventLotListMap.put(sn.Related_Quality_Event__c,existingList);
                }else{
                    List<Impacted_Lot_SN__c> newList = new List<Impacted_Lot_SN__c>();
                    newList.add(sn);
                    qualityEventLotListMap.put(sn.Related_Quality_Event__c,newList);
                }
            }
        }
        for(Id ids : qualityEventLotListMap.keyset()){
            system.debug('send quality event in insert');
            QualityEventController.createQualityEvent(qualityEventLotListMap.get(ids));
        }
    }
}