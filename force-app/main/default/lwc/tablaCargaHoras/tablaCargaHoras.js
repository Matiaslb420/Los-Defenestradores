import { api, LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getResourceTasks from '@salesforce/apex/getTasksInProgress.getResourceTasks';

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
}