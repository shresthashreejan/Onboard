import { LightningElement, api, wire } from 'lwc';
import fetchContentId from '@salesforce/apex/Resource.fetchContentId';

export default class ViewResource extends LightningElement {
    @api 
    recordId;

    redirectToContent(){
        fetchContentId({recordId: this.recordId}).then((result) => {
            if(result) {
                const url = window.location.origin + '/' + result;
                window.open(url, '_blank');
            }
        })
    }
}