import { LightningElement, api } from 'lwc';

export default class ResourceUploadFile extends LightningElement {
    @api 
    recordId;

    get validFormats() {
        return ['.pdf', '.doc', '.docx', '.jpg', '.jpeg', '.png', '.webp'];
    }

    handleUpload(event) {
        console.log(event.detail.files);
    }
}