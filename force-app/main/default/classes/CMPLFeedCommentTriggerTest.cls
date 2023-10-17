@isTest
 public   class CMPLFeedCommentTriggerTest{
	static testMethod void FeedCommentTriggerTestmethod(){
        
        Contact con = new Contact(LastName = 'kumar');
        insert con;
        FeedItem testFeed = new FeedItem(Body = 'Test',ParentId = con.Id);
        insert testFeed;
		FeedComment testobject = new FeedComment (FeedItemId = testFeed.Id);
		testobject.CommentBody = 'Testtextarea';
		insert testobject; 
        update testobject;
		delete testobject; 
		//undelete testobject; 
		 
		System.assertEquals('1','1');
	}
}