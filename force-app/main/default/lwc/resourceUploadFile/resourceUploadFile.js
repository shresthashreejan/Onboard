import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import commitUploadChanges from '@salesforce/apex/Resource.commitUploadChanges';

export default class ResourceUploadFile extends LightningElement {
    @api 
    recordId;

    get validFormats() {
        return ['.pdf', '.doc', '.docx', '.jpg', '.jpeg', '.png', '.webp'];
    }

    handleUpload(event) {
        commitUploadChanges({
            recordId: this.recordId, 
            contentId: event.detail.files[0].documentId
        })
        .then(() => {
            this.showToast('Success', 'File uploaded successfully.', 'success');
        })
        .catch((error) => {
            this.showToast('Error', error.body.message || 'An error occurred while uploading the file.', 'error');
        })
        .finally(() => {
            this.closeModal();
        });
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