global class ScheduledTechnicalToNonTechnicalApexJob implements Schedulable {

   global void execute(SchedulableContext SC) {
      CreateTechComplaintForCaseBatch TechToNon = new CreateTechComplaintForCaseBatch(); 
      Database.Executebatch(TechToNon);
   }
}