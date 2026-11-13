public with sharing class EnquiryController {

    // 1. Create a new Enquiry
    @AuraEnabled
    public static Enquiry__c createEnquiry(Enquiry__c enquiryRecord) {
        try {
            if (enquiryRecord == null) {
                throw new AuraHandledException('Enquiry details are required.');
            }

            insert enquiryRecord;
            return enquiryRecord;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // 2. Get all Enquiries
    @AuraEnabled(cacheable=true)
    public static List<Enquiry__c> getEnquiries() {
        return [
            SELECT Id, Name, Subject__c, Category__c,
                   Description__c, Status__c, Response__c,
                   Student__c, Student__r.Name
            FROM Enquiry__c
            ORDER BY CreatedDate DESC
        ];
    }

    // 3. Get Enquiries for a particular Student
    @AuraEnabled(cacheable=true)
    public static List<Enquiry__c> getStudentEnquiries(Id studentId) {

        if (studentId == null) {
            return new List<Enquiry__c>();
        }

        return [
            SELECT Id, Name, Subject__c, Category__c,
                   Description__c, Status__c, Response__c,
                   Student__c, Student__r.Name
            FROM Enquiry__c
            WHERE Student__c = :studentId
            ORDER BY CreatedDate DESC
        ];
    }

    // 4. Update Enquiry
    @AuraEnabled
    public static Enquiry__c updateEnquiry(Enquiry__c enquiryRecord) {
        try {
            if (enquiryRecord == null || enquiryRecord.Id == null) {
                throw new AuraHandledException('Valid enquiry record is required.');
            }

            update enquiryRecord;
            return enquiryRecord;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // 5. Delete Enquiry
    @AuraEnabled
    public static void deleteEnquiry(Id enquiryId) {
        try {
            if (enquiryId == null) {
                throw new AuraHandledException('Enquiry ID is required.');
            }

            delete [
                SELECT Id
                FROM Enquiry__c
                WHERE Id = :enquiryId
            ];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
