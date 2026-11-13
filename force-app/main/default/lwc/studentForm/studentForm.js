
import { LightningElement, wire } from 'lwc';

import createStudent from
    '@salesforce/apex/StudentController.createStudent';

import { ShowToastEvent } from
    'lightning/platformShowToastEvent';

import {
    MessageContext,
    publish
} from 'lightning/messageService';

import STUDENT_DATA_REFRESH from
    '@salesforce/messageChannel/StudentDataRefresh__c';


export default class StudentForm extends LightningElement {

    departmentOptions = [
    { label: 'Computer Science', value: 'Computer Science' },
    { label: 'Information Technology', value: 'Information Technology' },
    { label: 'Electronics', value: 'Electronics' },
    { label: 'Mechanical', value: 'Mechanical' },
    { label: 'Civil', value: 'Civil' }
    ];

    
    academicYearOptions = [
    { label: 'First Year', value: 'First Year' },
    { label: 'Second Year', value: 'Second Year' },
    { label: 'Third Year', value: 'Third Year' },
    { label: 'Fourth Year', value: 'Fourth Year' }
    ];

    prnNumber = '';
    department = '';
    academicYear = '';
    email = '';
    phone = '';

    isLoading = false;

    @wire(MessageContext)
    messageContext;

    handleChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
    }

    async handleRegister() {

        const allValid = [
            ...this.template.querySelectorAll(
                'lightning-input, lightning-combobox'
            )
        ].reduce((valid, field) => {
            field.reportValidity();
            return valid && field.checkValidity();
        }, true);

        if (!allValid) {
            return;
        }

        const studentRecord = {
            PRN_Number__c: this.prnNumber,
            Department__c: this.department,
            Academic_Year__c: this.academicYear,
            Email__c: this.email,
            Phone__c: this.phone
        };

        this.isLoading = true;

        try {

            await createStudent({
                studentRecord: studentRecord
            });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Student registered successfully!',
                    variant: 'success'
                })
            );

            publish(
                this.messageContext,
                STUDENT_DATA_REFRESH,
                { recordType: 'student' }
            );

            this.resetForm();

        } catch (error) {

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Registration Failed',
                    message: error.body?.message ||
                        'Unable to register student.',
                    variant: 'error'
                })
            );

        } finally {
            this.isLoading = false;
        }
    }

    resetForm() {
        this.prnNumber = '';
        this.department = '';
        this.academicYear = '';
        this.email = '';
        this.phone = '';
    }
}
