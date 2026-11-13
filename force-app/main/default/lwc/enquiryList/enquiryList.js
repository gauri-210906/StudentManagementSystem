import { LightningElement, wire } from 'lwc';

import getEnquiries from
    '@salesforce/apex/EnquiryController.getEnquiries';

import {
    MessageContext,
    subscribe,
    unsubscribe
} from 'lightning/messageService';

import STUDENT_DATA_REFRESH from
    '@salesforce/messageChannel/StudentDataRefresh__c';

import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    { label: 'Enquiry Name', fieldName: 'Name' },
    { label: 'Subject', fieldName: 'Subject__c' },
    { label: 'Category', fieldName: 'Category__c' },
    { label: 'Status', fieldName: 'Status__c' },
    { label: 'Description', fieldName: 'Description__c' },
    { label: 'Response', fieldName: 'Response__c' }
];

export default class EnquiryList extends LightningElement {

    columns = COLUMNS;
    subscription = null;

    @wire(MessageContext)
    messageContext;

    @wire(getEnquiries)
    enquiries;

    connectedCallback() {
        this.subscribeToRefresh();
    }

    subscribeToRefresh() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                STUDENT_DATA_REFRESH,
                (message) => {
                    if (message.recordType === 'enquiry') {
                        refreshApex(this.enquiries);
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
