@isTest
public class RequireReportsToWhenMinorTest {

    static Date today;
    static Contact contact;
    static final String MSG_RULE_EXPECTED_TO_TRIGGER;
    static final String MSG_RULE_NOT_EXPECTED_TO_TRIGGER;

    static {
        today = System.today();
        contact = new Contact(
            LastName = 'Stormtrooper'
        );
        MSG_RULE_EXPECTED_TO_TRIGGER = 'The rule should have been triggered.';
        MSG_RULE_NOT_EXPECTED_TO_TRIGGER = 'The rule should not have been triggered.';
    }

    @TestSetup
    static void makeData(){
        insert new Contact(
            LastName = 'Vader'
        );
    }
    
    @isTest
    static void testOverAge(){
        contact.Birthdate = today.addYears(-18);
        Boolean result = saveContact(contact);
        Assert.isTrue(result, MSG_RULE_NOT_EXPECTED_TO_TRIGGER);
    }

    @isTest
    static void testUnderAgeReportsToMissing(){
        contact.Birthdate = today.addYears(-17);
        Boolean result = saveContact(contact);
        Assert.isFalse(result, MSG_RULE_EXPECTED_TO_TRIGGER);
    }

    @isTest
    static void testUnderAgeReportsToFilled(){
        Contact reportsToContact = [SELECT Id FROM Contact LIMIT 1];
        contact.ReportsToId = reportsToContact.Id;
        contact.Birthdate = today.addYears(-17);
        Boolean result = saveContact(contact);
        Assert.isTrue(result, MSG_RULE_NOT_EXPECTED_TO_TRIGGER);
    }

    @isTest
    static void testNoBirthdate(){
        Boolean result = saveContact(contact);
        Assert.isTrue(result, MSG_RULE_NOT_EXPECTED_TO_TRIGGER);
    }

    static Boolean saveContact(Contact contact){
        return Database.insert(contact, false).isSuccess();
    }

}