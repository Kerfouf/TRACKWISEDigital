import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getRunFileInformation from '@salesforce/apex/RunFileInformationController.GetRunFileInformation';
import POUCH_LOT from '@salesforce/label/c.POUCH_LOT';
import INSTRUMENT_SERIAL_NUMBER from '@salesforce/label/c.INSTRUMENT_SERIAL_NUMBER';
import LOADING from '@salesforce/label/c.LOADING';
import SAVE from '@salesforce/label/c.SAVE';
import CMPL123_WF_Status__c from '@salesforce/schema/CMPL123CME__Investigation__c.CMPL123_WF_Status__c';
import NOT_POSSIBLE_CREATE_IMP_LOT from '@salesforce/label/c.Not';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const SERIAL_NUMBER = 'Serial Number';

export default class ModalPopupLWC extends LightningElement {
  @api recordId;
  isModalOpen = false;
  runFileAnalysis = [];
  columns = [
    { label: SERIAL_NUMBER, fieldName: 'TestSerialNumber', type: 'text' },
    { label: POUCH_LOT, fieldName: 'EmptyPouchLot', type: 'text' },
    { label: INSTRUMENT_SERIAL_NUMBER, fieldName: 'InstrumentSerialNumber', type: 'text' }
  ];
  labels = {
    SAVE: SAVE,
    LOADING: LOADING,
    NOT_POSSIBLE_CREATE_IMP_LOT,
  };
  displaySaveSpinner = false;
  displayNotPossibleToAddSAPProducts = false;
  displayGrid = true;
  displayLoadingPanel = false;
  saveButtonEnabled = false;
  saveButtonDisable = false;
  materialNumber = '';
  successMessageVisible = false;
  successMessageTimeout;

  /**Get the Investigation/evaluation Workflow status*/
  @wire(getRecord, { recordId: '$recordId', fields: CMPL123_WF_Status__c })
  wiredRecord({ error, data }) {
    if (data) {
      let status = data.fields.CMPL123_WF_Status__c.value;
      let canAddProduct = status == 'Opened';
      canAddProduct = canAddProduct || status == 'Pending Approval' || status == 'Pending Expert Investigation' || status == 'Pending Investigator Reviewal';
      this.displayNotPossibleToAddSAPProducts = !canAddProduct;
    } else if (error) {
      console.log('Error occurred:' + JSON.stringify(error));
      this.displayNotPossibleToAddSAPProducts = true;
    }
  }

  get displaySearchAndAddPanel() {
    return !this.displaySaveSpinner && !this.displayNotPossibleToAddSAPProducts;
  }

  openModal() {
    this.isModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;
    this.successMessageVisible = false;
    clearTimeout(this.successMessageTimeout);
  }

  submitDetails() {
    this.serialNumber = this.template.querySelector(".serialNumberInput").value || 0;
  
    getRunFileInformation({ serialNumber: this.serialNumber })
      .then(result => {
        if (result != null) {
          //  convert it into an object
          const parsedResult = JSON.parse(result);
          if (parsedResult) {
            this.runFileAnalysis = [{
              'TestSerialNumber': parsedResult.serialNumber,
              'EmptyPouchLot': parsedResult.PouchLotNumber,
              'InstrumentSerialNumber': parsedResult.InstrumentID
            }];
            this.displayGrid = true;
            setTimeout(() => {
              this.isModalOpen = true;
            }, 0);
          } else {
            const toastEvent = new ShowToastEvent({
              title: 'Error',
              message: 'Serial number not found.',
              variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.runFileAnalysis = [];
            this.displayGrid = false;
          }
        } else {
          console.log('Serial number not found.');
          const toastEvent = new ShowToastEvent({
            title: 'Error',
            message: 'Serial number not found.',
            variant: 'error'
          });
          this.dispatchEvent(toastEvent);
          this.runFileAnalysis = [];
          this.displayGrid = false;
        }
      })
      .catch(error => {
        console.error('An error occurred');
        console.error(JSON.stringify(error));
        this.disableSaveButton();
        this.runFileAnalysis = [];
        this.displayGrid = false;
      });
  }
  
  handleSave(event) {
    let valuesToSave = this.getSelectedValues();
    let runFileFields = {
      // Required field specified
      Test_Serial_Number__c: this.runFileAnalysis && this.runFileAnalysis[0] && this.runFileAnalysis[0].TestSerialNumber || '',
      Instrument_Serial_Number__c: this.runFileAnalysis && this.runFileAnalysis[0] && this.runFileAnalysis[0].InstrumentSerialNumber || '',
      Empty_Pouch_Lot__c: this.runFileAnalysis && this.runFileAnalysis[0] && this.runFileAnalysis[0].EmptyPouchLot || ''
    };
  
    const recordInput = {
      apiName: 'Run_File_Analysis__c',
      fields: {
        Related_Invsestigation__c: this.recordId,
        ...runFileFields
      }
    };
  
    createRecord(recordInput)
      .then(result => {
        // Check if the record creation is successful
        if (result != null && result.id) {
          // Display a success message
          const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Run File Analysis created successfully.',
            variant: 'success'
          });
          this.dispatchEvent(toastEvent);
          // Display the success message
          this.successMessageVisible = true;
          setTimeout(() => {
            this.successMessageVisible = false;
          }, 2000);
  
          // Close the modal
          this.closeModal();
          this.isModalOpen = false;
          // Reset attributes
          clearTimeout(this.successMessageTimeout);
        }
      })
      .catch(error => {
        console.error(error);
        this.enableSaveButton();
      });
  }
  handleMaterialNumberChange(event) {
    this.materialNumber = event.detail.value;
  }

  getSelectedValues() {
    let dataGrid = this.template.querySelector('lightning-datatable');
    return dataGrid.getSelectedRows();
  }

  onRowSelect(event) {
    let selectedRows = event ? event.detail.selectedRows : [];
    if (selectedRows.length > 0) {
      this.enableSaveButton();
    } else {
      this.disableSaveButton();
    }
  }

  connectedCallback() {
    this.onRowSelect();
  }

  handleSaveAndClose(event) {
    this.saveButtonDisable = true;
    this.handleSave(event);
    ;
  }

  enableSaveButton() {
    this.saveButtonEnabled = true;
  }

  disableSaveButton() {
    this.saveButtonEnabled = false;
  }
}