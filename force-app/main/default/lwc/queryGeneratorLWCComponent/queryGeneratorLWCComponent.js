import { LightningElement ,track} from 'lwc';
import getObjectOptions from '@salesforce/apex/QueryGeneratorLWCApex.getObjectOptions';
import getObjectFields from '@salesforce/apex/QueryGeneratorLWCApex.getObjectFields';
import getQueryRecords from '@salesforce/apex/QueryGeneratorLWCApex.getQueryRecords';


export default class InstituteDropDownLWCComponent extends LightningElement {
   @track value = '';
    selectedvalues = '';
    accoption = [];
    recoption = [];
    selected = [];
    soqlQuery = '';
    DataTablecolumns = [];
    a = false;
    b = false;
    c = false;


   
   


// Combobox Started 

    get options(){
        return this.accoption;
    }

    connectedCallback(){
        getObjectOptions()
        .then( result=> { 
            let acc = [];
            for(var i=0; i<result.length;i++){
                acc.push({ label : result[i] , value : result[i] });
            }
            this.accoption = acc;
        })
    }

handleChange(event){
    this.a = true;
    this.b = false;
    this.selectedvalues = null;
this.value = event.detail.value;                   // handler of combobox
getObjectFields({objectName : this.value })     // fetching  fields for  dual list box 
.then( result=> { 
   this.recoption = result;
})
}
    

// set data in dual list bix 
get recordsdata(){
    return this.recoption;
}


// dual list box event and value of selected fields 
handleSelect(event){
this.selectedvalues = event.detail.value; 
}

//create query taking object name and selected fields 
CreateQuery(event){
 this.b = true;   
 this.c= false;   

this.soqlQuery = 'SELECT '+this.selectedvalues.join(', ')+' '+'FROM '+this.value;
}

GetTableRecords(event){
    this.c = true;
    
    getQueryRecords({objectName : this.value, fields : this.selectedvalues })     // fetching  fields for  dual list box 
   .then( result=> { 

                 var tableRecords = [];
 
                this.selectedvalues.forEach(function(field) {
                  //field = field.charAt(0).toUpperCase()+field.substring(1);
                tableRecords.push({ label: field, fieldName: field, type: "string" });
                      });
                      
                      this.DataTablecolumns = tableRecords;
                      
                      this.fieldsoption = result;
       
  
     })
}

get DataTebledata(){
    return this.fieldsoption;
}

// refresh button 
RefreshSelectedFields(event){
    this.b = false;
    this.selectedvalues = null;

}

}