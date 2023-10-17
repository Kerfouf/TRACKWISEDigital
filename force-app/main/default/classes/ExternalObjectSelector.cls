/*
 * Created on Thur Dec 02 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 * Extension of the fflib SObject selector
 * Allows for explicit setting of query clause segments
 * This class should be used for any selectors that source external objects 
 *  and query fields via a relationship (i.e. Select Id, relationship__r.field_name__c From ...) 
 * The current implementation of fflib does not support building queries via relationships if the 
 *  sobject is an external object
 */

 public abstract class ExternalObjectSelector extends fflib_SObjectSelector{

    private final String TECHNICAL_COMPLAINT = 'TechnicalComplaint';
    private List<String> selectFieldsList;
    private List<String> selectReferenceFields;
    private String whereClause;

    public ExternalObjectSelector() {
        this.selectFieldsList = populateSelectFieldList();
        this.selectReferenceFields = new List<String>();
        this.whereClause = '';
    }

    protected void setWhereClause(String whereClause) {
        this.whereClause = whereClause;
    }

    /**
    * Allows for setting the fields on related objects to include in the 'select' clause
    * @param  referenceFields - List of relationships 
    */
    protected void setReferenceFields(List<String> referenceFields) {
        this.selectReferenceFields = referenceFields;
    }

    /**
    * Allows for the addition of fields from a related object to be added to the 'select' clause
    * @param  relationshipFieldName - relationship name
    * @param  selector - related object selector
    */
    protected void registerExternalRelationshipFields(String relationshipFieldName, fflib_SObjectSelector selector) {
        for (String externalRelationshipField : selector.getFieldListString().split(',')) {
            selectReferenceFields.add(relationshipFieldName + '.' + externalRelationshipField.trim());
        }
    }

    protected String getQuery() {
        return buildSelectClause() + ' ' + buildFromClause() + ' ' + buildWhereClause();
    }

    @TestVisible
    protected List<SObject> filterCases(List<SObject> records) {
        return filterCases(records, null);
    }

    protected List<SObject> filterCases(List<SObject> records, String relationshipName) {
        
        List<SObject> returnVal = new List<SObject>();

        for (SObject record : records) {
            SObject tempObject = record;
            if (!String.isBlank(relationshipName)) {
                for (String relationship : relationshipName.split('\\.')) {
                    System.debug(tempObject.getSobject(relationship));
                    tempObject = (SObject)tempObject.getSobject(relationship);
                }
            }
            if (tempObject instanceof Case__x && caseWasCreatedInCrm((Case__x)tempObject) && isTechnicalComplaint((Case__x)tempObject)) {
                returnVal.add(record);
            }
        }
        return returnVal;
    }

    private Boolean caseWasCreatedInCrm(Case__x record) {
        return 
        (
            record.CaseNumber_c__c == record.CaseNumber__c
        &&  record.ExternalId != null
        &&  (
            record.TWComplaintNumber_c__c == null || 
            record.TWComplaintNumber_c__c.contains('CN')
            )
        );
    }

    private Boolean isTechnicalComplaint(Case__x record) {
        return record.Type__c == TECHNICAL_COMPLAINT;
    }

    private List<String> populateSelectFieldList() {
        List<String> selectFields = new List<String>();
        for (Schema.SObjectField field : getSObjectFieldList()) {
            selectFields.add(field.getDescribe().getName());
        }
        return selectFields;
    }

    private String buildSelectClause() {
        List<String> selectFields = new List<String>();

        selectFields.addAll(selectFieldsList);
        selectFields.addAll(selectReferenceFields);

        if (selectFields.size() == 0) {
            return 'Select Id';
        }

        return 'Select ' + String.join(selectFields, ',');
    }

    private String buildFromClause() {
        return 'From ' + getSObjectType().getDescribe().getName();
    }

    private String buildWhereClause() {

        if (String.isBlank(this.whereClause)) {
            return '';
        }
        else if (this.whereClause.trim().toLowerCase().startsWith('where')) {
            return this.whereClause;
        }
        else {
            return 'Where ' + this.whereClause;
        }
    }

    abstract Schema.SObjectType getSObjectType();

    abstract List<Schema.SObjectField> getSObjectFieldList();
}