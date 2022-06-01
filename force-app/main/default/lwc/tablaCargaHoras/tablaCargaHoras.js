import { api, LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getResourceTasks from '@salesforce/apex/getTasksInProgress.getResourceTasks';
import initializeTaskApex from '@salesforce/apex/taskTableButtons.initializeTask';

export default class BasicDatatable extends LightningElement {
    @track tasksByProjectName = [];
    @api userId = Id;
    @wire(getResourceTasks, { ResourceIdStr: '$userId'})
    tasks({error, data}){
        if (data) {
            console.log('data',data);
            console.log('id',this.userId);
            for (let project in data){
                this.tasksByProjectName.push({key:project,value:data[project]});
            }
        } else if (error) {
            console.log('error',error);
        }
    };

    initializeTask(e){
        initializeTaskApex({taskIdStr:e.target.dataset.id})
        .then(task =>{
            console.log('click');
            console.log('task', task);
            let index = 0;
            let found = false;
            while(index < this.tasksByProjectName.length && !found){
                if(e.target.dataset.projectname === this.tasksByProjectName[index].key){
                    found = true;
                    let taskIndex = 0;
                    for(let task in this.tasksByProjectName[index].value){
                        if(e.target.dataset.id === task.Id){
                            this.tasksByProjectName[index].value[taskIndex].State__c = 'In Progress';
                            break;
                            taskIndex++;
                        }
                    }
                }
                index++;
            }
            
        })
        .catch(console.error)
        
    }
}