
@IsTest
private class EnquiryControllerTest {

    // Create common Student test data
    @TestSetup
    static void setupData() {

        Student__c student = new Student__c(
            PRN_Number__c = 'ENQTEST1001'
        );

        insert student;
    }

    // Helper method to create an Enquiry
    private static Enquiry__c createTestEnquiry() {

        Student__c student = [
            SELECT Id
            FROM Student__c
            WHERE PRN_Number__c = 'ENQTEST1001'
            LIMIT 1
        ];

        Enquiry__c enquiry = new Enquiry__c(
            Subject__c = 'Admission Enquiry',
            Category__c = 'Admission',
            Status__c = 'Pending',
            Description__c = 'Test admission enquiry',
            Student__c = student.Id
        );

        insert enquiry;
        return enquiry;
    }

    // Test 1: Create Enquiry
    @IsTest
    static void testCreateEnquiry() {

        Student__c student = [
            SELECT Id FROM Student__c
            WHERE PRN_Number__c = 'ENQTEST1001'
            LIMIT 1
        ];

        Enquiry__c enquiry = new Enquiry__c(
            Subject__c = 'Scholarship Enquiry',
            Category__c = 'Scholarship',
            Status__c = 'Pending',
            Student__c = student.Id
        );

        Test.startTest();
        Enquiry__c result =
            EnquiryController.createEnquiry(enquiry);
        Test.stopTest();

        System.assertNotEquals(null, result.Id);
        System.assertEquals('Scholarship', result.Category__c);
    }

    // Test 2: Get All Enquiries
    @IsTest
    static void testGetEnquiries() {

        createTestEnquiry();

        Test.startTest();
        List<Enquiry__c> result =
            EnquiryController.getEnquiries();
        Test.stopTest();

        System.assertEquals(1, result.size());
    }

    // Test 3: Get Enquiries of a Student
    @IsTest
    static void testGetStudentEnquiries() {

        createTestEnquiry();

        Student__c student = [
            SELECT Id FROM Student__c
            WHERE PRN_Number__c = 'ENQTEST1001'
            LIMIT 1
        ];

        Test.startTest();
        List<Enquiry__c> result =
            EnquiryController.getStudentEnquiries(student.Id);
        Test.stopTest();

        System.assertEquals(1, result.size());
        System.assertEquals(
            student.Id,
            result[0].Student__c
        );
    }

    // Test 4: Update Enquiry
    @IsTest
    static void testUpdateEnquiry() {

        Enquiry__c enquiry = createTestEnquiry();

        enquiry.Status__c = 'In Progress';
        enquiry.Response__c = 'Your enquiry is being reviewed.';

        Test.startTest();
        EnquiryController.updateEnquiry(enquiry);
        Test.stopTest();

        Enquiry__c updatedRecord = [
            SELECT Status__c, Response__c
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals(
            'In Progress',
            updatedRecord.Status__c
        );

        System.assertEquals(
            'Your enquiry is being reviewed.',
            updatedRecord.Response__c
        );
    }

    // Test 5: Delete Enquiry
    @IsTest
    static void testDeleteEnquiry() {

        Enquiry__c enquiry = createTestEnquiry();

        Test.startTest();
        EnquiryController.deleteEnquiry(enquiry.Id);
        Test.stopTest();

        List<Enquiry__c> result = [
            SELECT Id
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals(0, result.size());
    }
}
