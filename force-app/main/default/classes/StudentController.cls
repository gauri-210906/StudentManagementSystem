public with sharing class StudentController {

    // 1. Create a new Student
    @AuraEnabled
    
    @AuraEnabled
    public static Student__c createStudent(Student__c studentRecord) {
        try {
        if (studentRecord == null) {
            throw new AuraHandledException('Student details are required.');
        }

        if (String.isBlank(studentRecord.Name)) {
            throw new AuraHandledException('Student Name is required.');
        }

        if (String.isBlank(studentRecord.PRN_Number__c)) {
            throw new AuraHandledException('PRN Number is required.');
        }

        insert studentRecord;

        return studentRecord;

        } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
        }
    }

    // 2. Get all Students
    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudents() {
        return [
            SELECT Id, Name, PRN_Number__c,
                   Department__c, Academic_Year__c,
                   Email__c, Phone__c
            FROM Student__c
            ORDER BY CreatedDate DESC
        ];
    }

    // 3. Check duplicate PRN
    @AuraEnabled
    public static Boolean checkDuplicatePRN(String prn) {

        if (String.isBlank(prn)) {
            return false;
        }

        List<Student__c> students = [
            SELECT Id
            FROM Student__c
            WHERE PRN_Number__c = :prn
            LIMIT 1
        ];

        return !students.isEmpty();
    }

    // 4. Update Student
    @AuraEnabled
    public static Student__c updateStudent(Student__c studentRecord) {
        try {
            if (studentRecord == null || studentRecord.Id == null) {
                throw new AuraHandledException('Valid student record is required.');
            }

            update studentRecord;
            return studentRecord;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // 5. Delete Student
    @AuraEnabled
    public static void deleteStudent(Id studentId) {
        try {
            if (studentId == null) {
                throw new AuraHandledException('Student ID is required.');
            }

            delete [SELECT Id FROM Student__c WHERE Id = :studentId];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
