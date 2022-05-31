import { LightningElement,api,track, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import allRoleResource  from "@salesforce/apex/roleResource.allRoleResource";
import allProjectRoles from "@salesforce/apex/projectRoles.allProjectRoles";

import { CloseActionScreenEvent } from 'lightning/actions';

export default class FormFill extends LightningElement {
@api End_Date__c;
@api Name;
@api objectApiName;
@track mapData=[];
@track mapData2=[];
emptyRoles=[];
   //@track projectList; 
_recordId;

    @api set recordId(value) {
        this._recordId = value;
        console.log('setter ', this._recordId)
        //allProjectRoles({ strRecordId :this._recordId})
        allRoleResource({ strRecordId :this._recordId})
        .then(data =>{
            console.log("map");
            console.log(data);
            if (data) {
                for(var key in data){
                    this.mapData.push({value:data[key],key:key});
                } 
            let mapaDeDatos = JSON.parse(JSON.stringify(this.mapData)); 
            console.log("RESOURCE PROJECT");                              
            console.log(mapaDeDatos); 
            }
            return this.mapData; 
        })
        .then(data =>{
            allProjectRoles({ strRecordId :this._recordId})
            .then(dataRole =>{
                console.log("PLI");
                console.log(dataRole);
                if (dataRole) {
                
                    for(var index in this.mapData ){
                        
                        for(var rol in dataRole){
                            
                            if(this.mapData[index].key == dataRole[rol].Role__c){
                                
                                this.mapData2.push(dataRole[rol]);
                                this.mapData2.push(this.mapData[index]);    
                            }
                            // else{
                            //     //this.mapData2.push("No requerido");
                            //     this.mapData2.push(this.mapData[index]);
                            // }
                            
                        }
                    }

                }    
                // let mapaDeDatos2 = JSON.parse(JSON.stringify(this.mapData2));
                // console.log("mapData2");                              
                // console.log(mapaDeDatos2);    
            })
        
        
        })    
        .catch(error => {console.log('error: ',error)})

    }


    get recordId() {
        return this._recordId;
    }




        // .then(data =>{
        //     allProjectRoles({ strRecordId :this._recordId})
        //     .then(dataRole =>{
        //         for(var rol in dataRole){
        //             var hasResources=false;                   
        //             for(var res in data){
        //                 if(rol.Role__c = res.userrole.name){
        //                     res.roleHours = rol.Sold_Role_Hours__c;
        //                     hasResources = true;
        //                 }                       
        //             }
        //             if(!hasResources){
        //                 this.emptyRoles.push(rol);
        //             }
                    
        //         }
                
        //         console.log(this.emptyRoles);
        //         console.log("--->" + rol);
        //     })
        // })

        

    
/*@wire(allRoleResource,{Id:'$recordId'})
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
};*/

/*@wire(projectList)
projectListResult({data,error}){
    if(data){
        this.projectList=data;
        console.log(data);
    }
        if(error){
        console.log(error);

    } 
}*/
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