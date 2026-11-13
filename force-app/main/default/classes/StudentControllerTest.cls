
@IsTest
private class StudentControllerTest {

    // Test 1: Create Student
    @IsTest
    static void testCreateStudent() {

        Student__c student = new Student__c(
            PRN_Number__c = 'TEST1001'
        );

        Test.startTest();
        Student__c result =
            StudentController.createStudent(student);
        Test.stopTest();

        System.assertNotEquals(null, result.Id);
        System.assertEquals('TEST1001', result.PRN_Number__c);
    }

    // Test 2: Get Students
    @IsTest
    static void testGetStudents() {

        Student__c student = new Student__c(
            PRN_Number__c = 'TEST1002'
        );
        insert student;

        Test.startTest();
        List<Student__c> result =
            StudentController.getStudents();
        Test.stopTest();

        System.assert(result.size() > 0);
    }

    // Test 3: Check Duplicate PRN
    @IsTest
    static void testCheckDuplicatePRN() {

        Student__c student = new Student__c(
            PRN_Number__c = 'TEST1003'
        );
        insert student;

        Test.startTest();
        Boolean result =
            StudentController.checkDuplicatePRN('TEST1003');
        Test.stopTest();

        System.assertEquals(true, result);
    }

    // Test 4: Update Student
    @IsTest
    static void testUpdateStudent() {

        Student__c student = new Student__c(
            PRN_Number__c = 'TEST1004'
        );
        insert student;

        student.Email__c = 'student@test.com';

        Test.startTest();
        StudentController.updateStudent(student);
        Test.stopTest();

        Student__c updatedStudent = [
            SELECT Email__c
            FROM Student__c
            WHERE Id = :student.Id
        ];

        System.assertEquals(
            'student@test.com',
            updatedStudent.Email__c
        );
    }

    // Test 5: Delete Student
    @IsTest
    static void testDeleteStudent() {

        Student__c student = new Student__c(
            PRN_Number__c = 'TEST1005'
        );
        insert student;

        Test.startTest();
        StudentController.deleteStudent(student.Id);
        Test.stopTest();

        List<Student__c> result = [
            SELECT Id
            FROM Student__c
            WHERE Id = :student.Id
        ];

        System.assertEquals(0, result.size());
    }
}
