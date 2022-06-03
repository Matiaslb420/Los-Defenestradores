import { LightningElement, api, track, wire } from 'lwc'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import allRoleResource from '@salesforce/apex/roleResource.allRoleResource'
import allProjectRoles from '@salesforce/apex/projectRoles.allProjectRoles'

import { CloseActionScreenEvent } from 'lightning/actions'

export default class FormFill extends LightningElement {

  @api End_Date__c
  @api Name
  @api objectApiName
  @track mapData = []
  @track mapData2 = []
  emptyRoles = []
  _recordId
  recursoId

  @api set recordId(value) {
    this._recordId = value
    allRoleResource({ strRecordId: this._recordId })
      .then(data => {
        if (data) {
          for (var key in data) {
            this.mapData.push({ value: data[key], key: key })
          }
        }
        return this.mapData
      })
      .then(data => {
        allProjectRoles({ strRecordId: this._recordId }).then(dataRole => {
          if (dataRole) {
            for (var rol in dataRole) {

              if (this.mapData[rol].value.length !== 0) {
                this.mapData2.push({
                  Recursos: this.mapData[rol].value,
                  Horas: dataRole[rol].Sold_Role_Hours__c + ' hs',
                  Rol: dataRole[rol].Role__c
                })
            } else {
                this.mapData2.push({
                Recursos: '',
                Horas:
                    dataRole[rol].Sold_Role_Hours__c +
                    ' hs' +
                    '      -      (No hay recursos disponibles)  :(',
                Rol: dataRole[rol].Role__c
                })
            }
            }
        }
        })
      })
      .catch(error => {
        console.log('error: ', error)
      })
  }

  get recordId() {
    return this._recordId
  }

  checkIds = [];

handleCheckBoxChange(event) {

    if (event.target.checked) {
      this.checkIds.push(event.target.value)
      this.template.querySelectorAll('lightning-input[data-id="' + event.target.value + '"]').forEach((field) => {field.disabled=false})
      
    } else {
      this.checkIds = this.checkIds.filter((value) => { return value !== event.target.value })
      this.template.querySelectorAll('lightning-input[data-id="' + event.target.value + '"]').forEach((field) => {field.disabled=true})
    }
    console.log(this.checkIds);
  }


  nuevoRegistro=[];
  obj={};
  handleClick(e) {

    console.log("click");
    console.log("this.nuevoRegistro",this.nuevoRegistro)

    for (var i in this.checkIds) {
      this.nuevoRegistro.push({});
      this.nuevoRegistro[i].usuarioId = this.checkIds[i];
      this.template.querySelectorAll('lightning-input[data-id="' + this.checkIds[i] + '"]').forEach((field) => {
        this.nuevoRegistro[i][field.label] = field.value;
       })
       this.template.querySelectorAll('div[data-id="' + this.checkIds[i] + '"]').forEach((field) => {
        this.nuevoRegistro[i]["Rate"] = Number(field.innerText);
       })
    }

    console.log("this.nuevoRegistro",this.nuevoRegistro);

    this.dispatchEvent(new CloseActionScreenEvent())
    this.dispatchEvent(
      new ShowToastEvent({
        title: 'Success',
        message: 'Recursos Asignados!',
        variant: 'success'
      })
    )
  }
}