@IsTest
public with sharing class CreateTechComplaintForCaseBatch_Test {
    
    /*@IsTest
    static void getExternalCasesByDateModifiedTest() {
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalCaseSelector mockSelector = (ExternalCaseSelector)mocks.mock(ExternalCaseSelector.class);
        
        // Given
        mocks.startStubbing();

        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase1();
        system.debug('externalCase:::'+externalCase);
        List<Case__x> externalCases = new List<Case__x> { externalCase };
        DateTime asOf = DateTime.now();

        mocks.when(mockSelector.sObjectType()).thenReturn(Case__x.SObjectType);
        mocks.when(mockSelector.selectByDateModified(asOf)).thenReturn(externalCases);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmComplaintIntegrationServiceImpl service = (CrmComplaintIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmComplaintIntegrationService.class);
        List<Case__x> returnVal = service.getExternalCasesByDateModified(asOf);

        // Then
        ((ExternalCaseSelector)mocks.verify(mockSelector, 1)).selectByDateModified(fflib_Match.anyDatetime());

        System.assertEquals(1, returnVal.size());
        test.starttest();
            CreateTechComplaintForCaseBatch b = new CreateTechComplaintForCaseBatch();
            database.executebatch(b);
        test.stoptest();
    }*/

    @IsTest
    static void getExternalCasesByExternalIdTest() {
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalCaseSelector mockSelector = (ExternalCaseSelector)mocks.mock(ExternalCaseSelector.class);
        
        // Given
        mocks.startStubbing();

        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase();
        List<Case__x> externalCases = new List<Case__x> { externalCase };
        Set<Id> externalIds = new Set<Id> { externalCase.ExternalId };

        mocks.when(mockSelector.sObjectType()).thenReturn(Case__x.SObjectType);
        mocks.when(mockSelector.selectByExternalId(externalIds)).thenReturn(externalCases);
        mocks.stopStubbing();
		CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(false);
        complaint.BMX_Case_External__c = externalCase.ExternalId;
        insert complaint;
        test.starttest();
            CreateTechComplaintForCaseBatch b = new CreateTechComplaintForCaseBatch();
            database.executebatch(b);
            b.performBatchActions(externalCases);

        test.stoptest();
    }
}