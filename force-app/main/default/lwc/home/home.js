import { LightningElement, wire } from 'lwc';
import fetchList from '@salesforce/apex/HomepageController.fetchList';

export default class Home extends LightningElement {
    @wire(fetchList)
    wiredFetchList({error, data}){
        if (data) {
            console.log(data);
        } else if (error) {
            console.error(error);
        }
    }
}