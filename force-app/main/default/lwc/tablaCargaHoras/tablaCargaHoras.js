import { api, LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getResourceTasks from '@salesforce/apex/getTasksInProgress.getResourceTasks';
import { refreshApex } from '@salesforce/apex';


export default class BasicDatatable extends LightningElement {
    @track tasksByProjectName = [];
    @track wiredTaskList = [];
    @api userId = Id;
    @wire(getResourceTasks, { ResourceIdStr: '$userId'})
    tasks(result){
        this.wiredTaskList = result;
        if (result.data) {
            for (let project in result.data){
                this.tasksByProjectName.push({key:project,value:result.data[project]});
            }
        } else if (result.error) {
            console.log('error',result.error);
        }
    };

    handleRefresh(){
        console.log('ENTRO', this.wiredTaskList)
        this.tasksByProjectName = [];
        refreshApex(this.wiredTaskList);
    }
}