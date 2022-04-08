import { LightningElement,api,track } from 'lwc';
import getAccountList from '@salesforce/apex/LWCDemo.retrieveAccountList';
import getAccountRec from '@salesforce/apex/LWCDemo.retrieveAccountRecord';
//import ACCOUNT_OWNER_NAME_FIELD from '@salesforce/schema/Account.Owner.Name';
// import ACCOUNT_OWNER_DP_FIELD from '@salesforce/schema/Account.Owner.Name';

export default class DemoLWC extends LightningElement {
    @api selectedRecordId;
    @api selectedAccountRec;
    @api listOfAccounts;
    @track isLoading;
    @api showList;
    retrievedAccountList;
    error;
    @api objectApiName = 'Account';
    fieldsFormatted = ['Id','Name','Industry','Type'];
     @track acc_name;
     @track acc_own_name;
    // @track industry;
    // @track ownername;
    // @track type;
    // @track ownerphoto;

    handleClick(event){
        console.log(event.currentTarget.dataset.recid);
        this.selectedRecordId = event.currentTarget.dataset.recid;
    }
    handleOnLoad(){
        
    }

    handleNext(){
        this.showList=false;
        this.retrieveAccountRec();
    }
    handleBack(){
        this.showList = true;
        this.selectedRecordId = '';
    }

    connectedCallback(){
        this.showList = true;
        getAccountList()
                .then(result => {
                    this.isLoading = false; 
                    this.retrievedAccountList = result;
                                  
                })
                .catch(error => {              
                    if(error) {
                        this.error = error;
                    }                         
                });
        
    }

    retrieveAccountRec(){
        getAccountRec({accountId: this.selectedRecordId})
        .then(result => {
            this.isLoading = false;
            this.selectedAccountRec = result;
            this.acc_name = result.Name;
            this.acc_own_name = result.Owner.Name;  
        })
        .catch(error => {              
            if(error) {
                this.error = error;
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