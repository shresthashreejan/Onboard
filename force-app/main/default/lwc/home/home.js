import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import fetchList from '@salesforce/apex/HomeController.fetchList';
import fetchTrainingResources from '@salesforce/apex/HomeController.fetchTrainingResources';

export default class Home extends NavigationMixin(LightningElement) {

    trainingResources;
    employees;
    employeeSpecificResources;
    employeeName;
    employeeId;
    showPopup;

    @wire(fetchList)
    wiredFetchList({error, data}){
        if (data) {
            if (data[0]?.Resource__c) {
                this.trainingResources = data.map(item => ({
                    Id: item.Id,
                    Name: item.Resource__r.Name
                }));
            } else if (data[0]?.Manager__c) {
                this.employees = data.map(item => ({
                    Id: item.Id,
                    Name: item.Name
                }));
            }
        } else if (error) {
            console.error(error);
        }
    }

    handleResourceNavigation(event) {
        this.handleNavigation(event, 'Training_Resource__c');
    }

    handleEmployeeNavigation(event) {
        this.handleNavigation(event, 'Employee__c');
    }

    handleNavigation(event, objectApiName) {
        const recordId = event.target.getAttribute('record-id');
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: objectApiName,
                actionName: "view"
            }
        });
    }

    renderEmployeeModal(event) {
        this.showPopup = true;
        this.fetchEmployeeResources(event);
    }

    closeModal() {
        this.showPopup = false;
    }

    fetchEmployeeResources(event) {
        this.employeeId = event.target.getAttribute('record-id');
        fetchTrainingResources({ 'employeeId' : this.employeeId }).then((data) => {
            if (data) {
                if (data[0].Resource__c) {
                    this.employeeName = data[0].Employee__r.Name;
                    this.employeeSpecificResources = data.map(item => ({
                        Id: item.Id,
                        Name: item.Resource__r.Name
                    }));
                }
            }
        }).catch((error) => {
            console.error(error);
        });
    }
}