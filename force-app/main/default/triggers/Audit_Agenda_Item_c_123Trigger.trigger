/********************************************************************************************************************
	Copyright (c) 2017 Sparta Systems, Inc.

	THIS IS AN AUTO-GENERATED TRIGGER CREATED BY  TRACKWISE DIGITAL PLATFORM PACKAGE
	Note: Follow the guidelines on how to use/implement 123 Triggers
	Add your custom code before  X123TriggerHandler. X123TriggerHandler code should be on the last line.
*********************************************************************************************************************/

trigger Audit_Agenda_Item_c_123Trigger on Audit_Agenda_Item__c (before insert,after insert,before update,after update,before delete,after delete,after undelete){

	CMPL123.X123TriggerHandler X123handler = new CMPL123.X123TriggerHandler();

	/* Before Insert */
	if(Trigger.isInsert && Trigger.isBefore){
		// Place your custom code here 
		AuditAgendaHandler.Limit_Update(Trigger.New, Null );
		X123handler.handleBeforeInsert();
	}

	/* After Insert */
	else if(Trigger.isInsert && Trigger.isAfter){
		// Place your custom code here 
		X123handler.handleAfterInsert();
	}

	/* Before Update */
	else if(Trigger.isUpdate && Trigger.isBefore){
		// Place your custom code here 
	    AuditAgendaHandler.Limit_Update(Trigger.New, Trigger.OldMap);
		X123handler.handleBeforeUpdate();
	}

	/* After Update */
	else if(Trigger.isUpdate && Trigger.isAfter){
		// Place your custom code here 
		X123handler.handleAfterUpdate();
	}

	/* Before Delete */
	else if(Trigger.isDelete && Trigger.isBefore){
		// Place your custom code here 
		X123handler.handleBeforeDelete();
	}

	/* After Delete */
	else if(Trigger.isDelete && Trigger.isAfter){
		// Place your custom code here 
		X123handler.handleAfterDelete();
	}

	/* After UnDelete */
	else if(Trigger.isUnDelete && Trigger.isAfter){
		// Place your custom code here 
		X123handler.handleAfterUnDelete();
	}
}