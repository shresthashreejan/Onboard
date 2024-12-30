import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import fetchResources from '@salesforce/apex/ResourceController.fetchResources';

const FIELDS = [
    'Employee__c.Department__c',
    'Employee__c.Role__c'
];

export default class AssignTrainingResource extends LightningElement {
    
    @api recordId;

    roleSpecificValues = [];
    generalValues = [];

    employeeData;

    @wire(getRecord, {recordId : '$recordId', fields: FIELDS})
    wiredGetRecord ({error, data}){
        if (data) {
            console.log(data);
        } else if (error) {
            console.error(error);
        }
    }

    fetchRelatedResources(department, role) {
        fetchResources({
            department: department,
            role: role
        }).then((result) => {
            console.log(result);
        }).catch((error) => console.error(error));
    }

    get roleSpecificLabel() {
        return 'Resources for Interns';
    }

    get generalResourcesLabel() {
        return 'General Resources';
    }

    get roleSpecificOptions() {
        return [
            { label: 'Resource001', value: 'Resource001' },
            { label: 'Resource002', value: 'Resource002' },
            { label: 'Resource003', value: 'Resource003' }
        ];
    }

    get generalOptions() {
        return [
            { label: 'Resource004', value: 'Resource004' },
            { label: 'Resource005', value: 'Resource005' },
            { label: 'Resource006', value: 'Resource006' }
        ];
    }

    get selectedValues() {
        return [...this.roleSpecificValues, ...this.generalValues].join(', ');
    }

    handleRoleSpecificChange(event) {
        this.roleSpecificValues = event.detail.value;
    }

    handleGeneralChange(event) {
        this.generalValues = event.detail.value;
    }
}
