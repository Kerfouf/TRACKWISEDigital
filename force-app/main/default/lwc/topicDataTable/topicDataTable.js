// In DataTableLWC.js
import { LightningElement, api, wire } from 'lwc';
import getChaptersBySource from '@salesforce/apex/ChapterController.fetchChaptersBySource';

const columns = [
    { label: 'Topic Name', fieldName: 'TopicName', type: 'text' }, // Add Topic Name column
    { label: 'Topic (Lookup)', fieldName: 'TopicLookup', type: 'text' }, // Add Topic (Lookup) column
    { label: 'Source', fieldName: 'Source', type: 'text' },
    { label: 'Chapter', fieldName: 'Chapter', type: 'text' },
    { label: 'Comments', fieldName: 'Comments', type: 'text' }
];

export default class DataTableLWC extends LightningElement {
    @api chapterList;
    @api selectedSourceId; 
    auditData = []; 
    columns = columns; // Assign the columns to the property

    @wire(getChaptersBySource, { selectedSourceId: '$selectedSourceId' })
    wiredAuditData({ error, data }) {
        if (data) {
            console.log('Data received from Apex:' + JSON.stringify(data) );

            // Map the data to match the columns in the table
            this.auditData = data.map(item => ({
                Id: item.Id,
                TopicName: 'test', // Empty string for Topic Name
                TopicLookup: '', // Empty string for Topic (Lookup)
                Source: item.Source__c,
                Chapter: item.Name,
                Comments: ''
            }));
            console.log('Audit Data:' + this.auditData);
        } else if (error) {
            console.error('Error:', error);
        }
    }
}
