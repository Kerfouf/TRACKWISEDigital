import { LightningElement, wire, track } from 'lwc';
import searchTopics from '@salesforce/apex/TopicSearchController.searchTopics';
import fetchSources from '@salesforce/apex/SourceController.fetchSources';
import getChaptersBySource from '@salesforce/apex/ChapterController.fetchChaptersBySource';

export default class AddTopicLWC extends LightningElement {
    @track modalBackdropClass = 'slds-backdrop';
    @track searchTerm = '';
    @track searchResults = [];
    @track selectedTopic = '';
    @track sources = [];
    @track selectedSources = [];
    @track showTopics = false; 
    @track showSources = false; 
    @track showDataTable = false; // Add a new variable to track if the data table should be shown
    @track screenTitle = 'Add a Topic';
    @track errorMessage = '';
    @track auditData = [];
    @track chapterList = [];
    @track topicSelected = false; // Add a new variable to track if a topic is selected

    get isNextButtonDisabled() {
        return !this.selectedTopic;
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
    }

    searchTopics() {
        this.errorMessage = '';
        searchTopics({ searchTerm: this.searchTerm })
            .then(result => {
                this.searchResults = result;
                if (result.length === 0) {
                    this.errorMessage = 'No topics found. Please refine your search.';
                } else {
                    this.showTopics = true;
                }
            })
            .catch(error => {
                console.error('Error:'+error);
                this.errorMessage = 'An error occurred while searching for topics.';
            });
    }

    handleTopicChange(event) {
        this.selectedTopic = event.target.value;
    }

    navigateToSources() {
        if (this.selectedTopic) {
            this.showTopics = false;
            this.showSources = true;
            this.screenTitle = 'Select Sources';
            this.topicSelected = true; // Set topicSelected to true when a topic is selected
            fetchSources()
                .then(result => {
                    this.sources = result;
                })
                .catch(error => {
                    console.error('Error:'+ error);
                    this.errorMessage = 'An error occurred while fetching sources.';
                });
        } else {
            this.errorMessage = 'Please select a topic.';
        }
    }

    handleSourceChange(event) {
        const selectedSourceId = event.currentTarget.name;
        const isChecked = event.target.checked;
        console.log('selectedSourceId'+selectedSourceId);
        console.log('isChecked'+isChecked);
        if (isChecked) {
            this.selectedSources.push(selectedSourceId);
        } else {
            const index = this.selectedSources.indexOf(selectedSourceId);
            if (index !== -1) {
                this.selectedSources.splice(index, 1);
            }
        }
        console.log('selectedSources'+this.selectedSources);
    }

    @wire(getChaptersBySource, { selectedSourceId: '$selectedSources' })
    wiredAuditData({ error, data }) {
        if (data) {
            console.log('Data received from Apex:' + data);
            
            this.auditData = data.map(item => ({
                Id: item.Id,
                Source: item.Source__c, 
                Chapter: item.Name,
                Comments: ''
            }));
        } else if (error) {
            console.error('Error:'+ error);
        }
    }

    navigateToNext() {
        if (this.selectedSources.length > 0) {
            this.showSources = false;
            getChaptersBySource({ selectedSourceId: this.selectedSources })
                .then(result => {
                    console.log('Fetched data:'+ JSON.stringify(result));
                    this.chapterList = result.map(item => ({
                        'Id': item.Id,
                        'Source': item.Source__c,
                        'Chapter': item.Name,
                        'Comments': '',
                    }));
                    console.log('chapterList:'+ JSON.stringify(this.chapterList));
                    
                    // Show the data table when data is fetched
                    this.showDataTable = true;
                })
                .catch(error => {
                    console.error('Error:'+ error);
                    this.errorMessage = 'An error occurred while fetching data.';
                });
        } else {
            this.errorMessage = 'Please select at least one source.';
        }
    }
    

    cancelAction() {
        const cancelEvent = new CustomEvent('cancel');
        this.dispatchEvent(cancelEvent);
    }
    closeModal() {
        
        this.modalBackdropClass = 'slds-backdrop slds-backdrop_open';
    }

}
