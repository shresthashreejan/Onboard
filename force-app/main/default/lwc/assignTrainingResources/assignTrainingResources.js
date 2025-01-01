import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import fetchResources from '@salesforce/apex/Resource.fetchResources';
import assignResources from '@salesforce/apex/TrainingResource.assignResources';

const FIELDS = [
    'Employee__c.Department__c',
    'Employee__c.Role__c'
];

export default class AssignTrainingResource extends LightningElement {
    
    @api recordId;

    roleSpecificValues = [];
    generalValues = [];
    selectedValues = [];
    employeeData;
    dataLoaded;

    @wire(getRecord, {recordId : '$recordId', fields: FIELDS})
    wiredGetRecord ({error, data}){
        if (data) {
            this.employeeData = data;
            this.fetchRelatedResources(data.fields?.Department__c?.value, data.fields?.Role__c?.value);
        } else if (error) {
            console.error(error);
        }
    }

    fetchRelatedResources(department, role) {
        fetchResources({
            department: department,
            role: role
        }).then((data) => {
            if (data) {
                this.dataLoaded = true;
                this.roleSpecificValues = [];
                this.generalValues = [];
                data.roleSpecified.forEach(rsc => {
                    this.roleSpecificValues.push({id: rsc.Id, label: rsc.Name});
                });
                data.general.forEach(rsc => {
                    this.generalValues.push({id: rsc.Id, label: rsc.Name});
                })
            }
            
        }).catch((error) => console.error(error));
    }

    get roleSpecificLabel() {
        return 'Resources for ' + this.employeeData.fields?.Role__c?.value;
    }

    get generalResourcesLabel() {
        return 'General Resources';
    }

    get roleSpecificOptions() {
        return this.roleSpecificValues.map(rsc => ({
            label: rsc.label,
            value: rsc.id
        }));
    }

    get generalOptions() {
        return this.generalValues.map(rsc => ({
            label: rsc.label,
            value: rsc.id
        }));
    }

    get selectedValues() {
        return this.selectedValues.join(', ');
    }

    handleSelection(event) {
        this.selectedValues = event.detail.value;
    }

    handleAssign() {
        if(this.selectedValues) {
            assignResources({
                employeeId: this.recordId,
                resourceIds: this.selectedValues
            }).then(() => {
                this.showToast('Success', 'Selected resources assigned successfully.', 'success');
                this.closeModal();
            }).catch((error) => {
                this.showToast('Error', error.body.message || 'An error occurred while assigning resources.', 'error');
            });
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}
