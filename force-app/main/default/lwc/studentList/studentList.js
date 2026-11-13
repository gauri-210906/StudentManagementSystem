import { LightningElement, wire } from 'lwc';

import getStudents from
    '@salesforce/apex/StudentController.getStudents';

import {
    MessageContext,
    subscribe,
    unsubscribe
} from 'lightning/messageService';

import STUDENT_DATA_REFRESH from
    '@salesforce/messageChannel/StudentDataRefresh__c';

import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    { label: 'Student Name', fieldName: 'Name' },
    { label: 'PRN Number', fieldName: 'PRN_Number__c' },
    { label: 'Department', fieldName: 'Department__c' },
    { label: 'Academic Year', fieldName: 'Academic_Year__c' },
    { label: 'Email', fieldName: 'Email__c', type: 'email' },
    { label: 'Phone', fieldName: 'Phone__c', type: 'phone' }
];

export default class StudentList extends LightningElement {

    columns = COLUMNS;
    subscription = null;

    @wire(MessageContext)
    messageContext;

    @wire(getStudents)
    students;

    connectedCallback() {
        this.subscribeToRefresh();
    }

    subscribeToRefresh() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                STUDENT_DATA_REFRESH,
                (message) => {
                    if (message.recordType === 'student') {
                        refreshApex(this.students);
                    }
                }
            );
        }
    }

    disconnectedCallback() {
        if (this.subscription) {
            unsubscribe(this.subscription);
            this.subscription = null;
        }
    }
}
