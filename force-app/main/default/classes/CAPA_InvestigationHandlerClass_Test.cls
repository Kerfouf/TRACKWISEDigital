/**
#############################################################################
#  File Name     : CAPAInvestigationHandler
#  Author        : Sparta Systems
#  Description   : Test class for CAPAInvestigationHandlerClass.

#############################################################################
*/

@isTest

private class CAPA_InvestigationHandlerClass_Test
{
    public static testmethod void myTest()
  {
        test.startTest();
            Set<Id> idsSet = new Set<Id>();
            CAPA_InvestigationHandlerClass.deleteInvestigationValidation( idsSet );
        test.stopTest();
    }
}