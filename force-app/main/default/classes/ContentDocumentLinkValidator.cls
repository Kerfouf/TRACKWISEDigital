/**
 * @File Name          : ContentDocumentLinkValidator.cls
 * @Description        : 
 * @Author             : Jon Astemborski
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 3/30/2020, 10:16:14 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/30/2020   Jon Astemborski     Initial Version
**/
public class ContentDocumentLinkValidator extends fflib_SObjectDomain {
    public ContentDocumentLinkValidator(List<ContentDocumentLink> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new ContentDocumentLinkValidator(sObjectList);
        }
    }

    public override void onValidate() {
        // Validate Opportunities
        for(ContentDocumentLink cdl : (List<ContentDocumentLink>) Records) {
            if (!cdl.LinkedEntityId.getSObjectType().getDescribe().isUpdateable()) {
                cdl.addError('You must have edit permissions in order to add files.');
            }
        }
    }

}