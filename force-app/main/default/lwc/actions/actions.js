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
  
    changeTaskState(){
        let newStateUwU = this.isInitialized ? STATE_COMPLETED:STATE_IN_PROGRESS;
        changeTaskStateApex({taskIdStr:this.task.Id, newState:newStateUwU})
        .then(task =>{
            if(task){
                this.dispatchEvent(new CustomEvent('refresh'));
            }
            
        })
        .catch(console.error)
    }

    setNumber(e){
        console.log('number', e.target.value);
        this.number = e.target.value;
    }

    registerHours(e){ //si haces doble click aumenta el doble de horas D:
        this.number = parseInt(this.number, 10);
        if(this.number){
            e.target.disabled = true;
            registerHoursApex({taskIdStr:this.task.Id, hours:this.number})
            .then(task => {
                if(task){
                    this.dispatchEvent(new CustomEvent('refresh'));
                }
            })
        }
    }
}