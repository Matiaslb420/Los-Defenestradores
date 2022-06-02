import { LightningElement, api } from 'lwc';
import changeTaskStateApex from '@salesforce/apex/taskTableButtons.changeTaskState';
import registerHoursApex from '@salesforce/apex/taskTableButtons.registerHours';

const STATE_IN_PROGRESS = 'In Progress';
const STATE_COMPLETED = 'Completed';

export default class Actions extends LightningElement {
    @api task;
    number;
    isInitialized;
    connectedCallback(){
        this.isInitialized = this.task.State__c === STATE_IN_PROGRESS;
    }
  
    changeTaskState(e){
        let newStateUwU = this.isInitialized ? STATE_COMPLETED:STATE_IN_PROGRESS;
        changeTaskStateApex({taskIdStr:this.task.Id, newState:newStateUwU})
        .then(task =>{
            this.dispatchEvent(new CustomEvent('refresh'));
            
        })
        .catch(console.error)
    }

    setNumber(e){
        console.log('number', e.target.value);
        this.number = e.target.value;
    }

    registerHours(){ //si haces doble click aumenta el doble de horas D:
        this.number = parseInt(this.number);
        if(this.number){
            registerHoursApex({taskIdStr:this.task.Id, hours:this.number})
            .then(task => {
                this.dispatchEvent(new CustomEvent('refresh'));
            })
        }
    }

    
}