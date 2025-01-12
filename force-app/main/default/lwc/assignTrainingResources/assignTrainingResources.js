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

export default class AssignTrainingResources extends LightningElement {
    
    @api recordId;

    employeeData;
    showPopup = false;

    roleSpecificValues;
    generalValues;
    filteredRoleSpecificValues;
    filteredGeneralValues;
    roleSpecificSelections = [];
    generalSelections = [];

    @wire(getRecord, {recordId : '$recordId', fields: FIELDS})
    wiredGetRecord ({error, data}){
        if (data) {
            this.employeeData = data;
            this.role = data.fields?.Role__c?.value;
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
                this.showPopup = true;
                this.roleSpecificValues = [];
                this.generalValues = [];
                data.roleSpecified.forEach(rsc => {
                    this.roleSpecificValues.push({id: rsc.Id, label: rsc.Name});
                });
                data.general.forEach(rsc => {
                    this.generalValues.push({id: rsc.Id, label: rsc.Name});
                });
                this.filteredRoleSpecificValues = this.roleSpecificValues;
                this.filteredGeneralValues = this.generalValues;
            }
            
        }).catch((error) => console.error(error));
    }

    get roleSpecificOptions() {
        return this.filteredRoleSpecificValues?.map(rsc => ({
            label: rsc.label,
            value: rsc.id
        }));
    }

    get generalOptions() {
        return this.filteredGeneralValues?.map(rsc => ({
            label: rsc.label,
            value: rsc.id
        }));
    }

    get hasFilteredRoleValues() {
        if(this.filteredRoleSpecificValues && this.filteredRoleSpecificValues.length !== 0) {
            return true;
        } else {
            return false;
        }
    }

    get hasFilteredGeneralValues() {
        if(this.filteredGeneralValues && this.filteredGeneralValues.length !== 0) {
            return true;
        } else {
            return false;
        }
    }

    handleRoleSpecificSelection(event) {
        this.roleSpecificSelections = event.detail.value;
    }

    handleGeneralSelection(event) {
        this.generalSelections = event.detail.value;
    }

    handleAssign() {
        const selectedValues = [...this.roleSpecificSelections, ...this.generalSelections];
        if(selectedValues.length !== 0) {
            assignResources({
                employeeId: this.recordId,
                resourceIds: selectedValues
            }).then(() => {
                this.showToast('Success', 'Selected resources assigned successfully.', 'success');
                this.closeModal();
            }).catch((error) => {
                this.showToast('Error', error.body.message || 'An error occurred while assigning resources.', 'error');
            });
        }
    }

    filterResources(event) {
        let searchString = event.detail.value.toLowerCase();
        if(searchString == '') {
            this.filteredRoleSpecificValues = this.roleSpecificValues;
            this.filteredGeneralValues = this.generalValues;
        }  else {
            this.filteredRoleSpecificValues = this.roleSpecificValues.filter(resource => 
                resource.label.toLowerCase().includes(searchString)
            );
            this.filteredGeneralValues = this.generalValues.filter(resource => 
                resource.label.toLowerCase().includes(searchString)
            );
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
