/**
 * Created by reddy on 2022-04-08.
 */

import { LightningElement, track, wire, api } from 'lwc';
import retrieveAccountRecords from '@salesforce/apex/AccountsListPOCController.retrieveAccountRecords';
import getAccountRec from '@salesforce/apex/AccountsListPOCController.retrieveAccountRecord';



const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Website', fieldName: 'Phone', type: 'phone' },
    { label: 'Phone', fieldName: 'Industry'},
    {type: "button", typeAttributes: {
        label: 'Next',
        name: 'View',
        title: 'View',
        disabled: false,
        value: 'view',
        iconPosition: 'left'
    }}
];

export default class AccountsListLwc extends LightningElement {
    data = [];
    columns = columns;
    accountId;
    @track showModal = false;
    @track spinner = false;
    @api selectedAccountRec;

    @wire (retrieveAccountRecords)
        wireRecords({data}){
        if(data){
            this.data = data;
            console.log('*******'+JSON.stringify(this.data));
        }
    }

    callRowAction( event ) {
        this.accountId =  event.detail.row.Id;
        const actionName = event.detail.action.name;
        console.log('actionName==> '+actionName);
        if ( actionName === 'View' ) {
            console.log('**row***'+this.accountId);
            this.openModal();
            this.spinner = true;
            this.retrieveAccountRec(this.accountId);

        }
    }

    openModal() {
        // Setting boolean variable to true, this will show the Modal
        this.showModal = true;
    }

    closeModal() {
        // Setting boolean variable to false, this will hide the Modal
        this.showModal = false;
    }

    retrieveAccountRec(accountId){
            getAccountRec({accountId: accountId})
            .then(result => {
                this.isLoading = false;
                this.selectedAccountRec = result;
                this.spinner = false;
            })
            .catch(error => {
                if(error) {
                    this.error = error;
                    this.spinner = false;
                }
            });

    }

    checkValid(inputValue){
        if(inputValue) return true;
        return false;
    }

    get name() {
        return this.checkValid(this.selectedAccountRec) && this.checkValid(this.selectedAccountRec.Name) ? this.selectedAccountRec.Name : '-NA-';
    }

    get industry() {
        return this.checkValid(this.selectedAccountRec) && this.checkValid(this.selectedAccountRec.Industry) ? this.selectedAccountRec.Industry : '-NA-';
    }

    get type() {
        return this.checkValid(this.selectedAccountRec) && this.checkValid(this.selectedAccountRec.Type) ? this.selectedAccountRec.Type : "";
    }

    get ownername() {
        return this.checkValid(this.selectedAccountRec) && this.checkValid(this.selectedAccountRec.Owner.Name) ? this.selectedAccountRec.Owner.Name : '';
    }

    get ownerphoto() {
        return this.checkValid(this.selectedAccountRec) && this.checkValid(this.selectedAccountRec.Owner.SmallPhotoUrl) ? this.selectedAccountRec.Owner.SmallPhotoUrl : '';
    }

}