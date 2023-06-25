trigger testTrigger on Contact (after insert,after update){
	 DemoCallAPI.ValidateUserCred();
}