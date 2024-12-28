import { LightningElement } from 'lwc';

export default class AssignTrainingResource extends LightningElement {
    roleSpecificValues = [];
    generalValues = [];

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
