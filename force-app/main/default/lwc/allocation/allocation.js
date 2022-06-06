import { LightningElement,api,track, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import allRoleResource  from "@salesforce/apex/roleResource.allRoleResource";
//import projectList from "@salesforce/apex/projectList.preKickoffProjects"
import { CloseActionScreenEvent } from 'lightning/actions';

export default class FormFill extends LightningElement {
@api End_Date__c;
@api Name;
@api objectApiName;
@track mapData =[];
   //@track projectList; 
_recordId;

    @api set recordId(value) {
        this._recordId = value;
        console.log('setter ', this._recordId)
        allRoleResource({ strRecordId :this._recordId})
        .then(data =>{
            if (data) {
                var conts=data;
                for(var key in conts){
                    this.mapData.push({value:conts[key],key:key});
            }
            console.log('DATAA');
            } 
        })
        .catch(error => {console.log('error: ',error)})

    }

    get recordId() {
        return this._recordId;
    }

    
/* @wire(allRoleResource,{Id:'$recordId'})
rolesWithResoursesResult({data,error}){
    if (data) {
    var conts=data;
        for(var key in conts){
            this.mapData.push({value:conts[key],key:key});
        }
        console.log('DATAA');
    } 
    if (error) {
        console.error(error)
        console.log(this.recordId)
    }
   }; */

/* @wire(projectList)
projectListResult({data,error}){
    if(data){
        this.projectList=data;
        console.log(data);
    }
    if(error){
        console.log(error);

    } 
   } */
//------------------------------------------------

handleSuccess(e) {
        // Close the modal window and display a success toast
        this.dispatchEvent(new CloseActionScreenEvent());
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Recursos Asignados!',
                variant: 'success'
            })
        );
}
}