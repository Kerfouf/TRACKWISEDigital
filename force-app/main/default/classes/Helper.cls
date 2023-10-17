public with sharing class Helper {
    private Helper() {

    }

    public static Boolean isEmpty(List<SObject> listToTest){
        return listToTest == null || listToTest.isEmpty();
    }

    public static Boolean isEmpty(Set<Id> listToTest){
        return listToTest == null || listToTest.isEmpty();
    }


    /**Returns the count of non null fields with the list given in parameter.*/
    public static Integer nonEmptyFieldsCount(SObject objectToTest , List<String> listOfFieldsName){
        Integer nonEmptyFieldsCount = 0;
        for(String fieldName : listOfFieldsName){
            String fieldValue = (String) objectToTest.get(fieldName);
            if(String.isNotBlank(fieldValue)){
                nonEmptyFieldsCount++;
            }
        }
        return nonEmptyFieldsCount;
    }

    public static void checkOnlyOneParent(List<SObject> listOfSObjectsToTest , List<String> listOfFieldsName, String labelToApply){
        if(Helper.isEmpty(listOfSObjectsToTest)){
            return;
        }
        for(SObject loopSObject : listOfSObjectsToTest){
            Integer parentCount = Helper.nonEmptyFieldsCount(loopSObject, listOfFieldsName);
            if(parentCount != 1){
                loopSObject.addError(labelToApply);
            }
        }
    }

    public static Set<Id> extractListOfIdsOfAField(List<SObject> objectList , String fieldName){       
        return extractListOfIdsOfAField(objectList , new List<String> {fieldName});
    }

    public static Set<Id> extractListOfIdsOfAField(List<SObject> objectList , List<String> fieldNames){
        Set<Id> listOfIdsToReturn = new Set<Id>();
        for(SObject loopObject : objectList){
            for(String fieldName : fieldNames){
                Id idValue = (Id) loopObject.get(fieldName);
                if(String.isNotBlank(idValue)){
                    listOfIdsToReturn.add(idValue);
                }
            }
        }
        return listOfIdsToReturn;
    }
}