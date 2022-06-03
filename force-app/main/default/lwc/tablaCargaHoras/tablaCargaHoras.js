/* eslint-disable guard-for-in */
import { api, LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getResourceTasks from '@salesforce/apex/getTasksInProgress.getResourceTasks';
import { refreshApex } from '@salesforce/apex';


export default class BasicDatatable extends LightningElement {
    @track tasksByProjectName = [];
    @track wiredTaskList = [];//para el apex refresh
    @api userId = Id;
    @wire(getResourceTasks, { ResourceIdStr: '$userId'})
    tasks(result){
        this.wiredTaskList = result;
        if (result.data) {
            console.log(JSON.stringify(result.data));
            for (let project in result.data){
                this.tasksByProjectName.push({key:project,value:result.data[project]});
            }
        } else if (result.error) {
            console.log('error',result.error);
        }
    }

    handleRefresh(){
        this.tasksByProjectName = [];
        refreshApex(this.wiredTaskList);
    }
}