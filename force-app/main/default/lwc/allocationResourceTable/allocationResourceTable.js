/* eslint-disable guard-for-in */
import { LightningElement, api, track, wire } from 'lwc'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import allRoleResource from '@salesforce/apex/roleResource.allRoleResource'
import allProjectRoles from '@salesforce/apex/projectRoles.allProjectRoles'
import { createRecord } from 'lightning/uiRecordApi'
import RESOURCE_PROJECT_OBJECT from '@salesforce/schema/Resource_Project__c'
import PROJECT_FIELD from '@salesforce/schema/Resource_Project__c.Project__c'
import RESOURCE_FIELD from '@salesforce/schema/Resource_Project__c.Resource__c'
import REQUIRED_HOURS_FIELD from '@salesforce/schema/Resource_Project__c.Required_Hours__c'
import ESTIMATED_AMOUNT from '@salesforce/schema/Resource_Project__c.Estimated_Amount__c'
import START_DATE from '@salesforce/schema/Resource_Project__c.Start_Date__c'
import END_DATE from '@salesforce/schema/Resource_Project__c.End_Date__c'
import { refreshApex } from '@salesforce/apex'

export default class FormFill extends LightningElement {
  @track availableRes = []
  @track recursosDisponibles = []
  @api recordId
  @track refreshAvailableResources = []
  nuevoRegistro = []
  checkIds = []
 

  @wire(allRoleResource, { strRecordId: '$recordId' })
  availableResources (result) {
    this.refreshAvailableResources = result
    if (result.data) {
      for (let key in result.data) {
        this.availableRes.push({ value: result.data[key], key: key })
      }
      let mapaDeDatos = JSON.parse(JSON.stringify(this.availableRes))
      console.log('RESOURCE PROJECT - Recursos Disponibles')
      console.log(mapaDeDatos)
      allProjectRoles({ strRecordId: this.recordId })
        .then(data => {
          if (data) {
            for (let rol in data) {
              if (this.availableRes[rol].value.length !== 0) {
                this.recursosDisponibles.push({
                  Recursos: this.availableRes[rol].value,
                  Horas: data[rol].Sold_Role_Hours__c + ' hs requeridas',
                  Rol: data[rol].Role__c
                })
              } else {
                this.recursosDisponibles.push({
                  Recursos: '',
                  Horas:
                    data[rol].Sold_Role_Hours__c +
                    ' hs' +
                    '      -      (No hay recursos disponibles)  :(',
                  Rol: data[rol].Role__c
                })
              }
            }
            let mapaDeDatos2 = JSON.parse(
              JSON.stringify(this.recursosDisponibles)
            )
            console.log('recursosDisponibles')
            console.log(mapaDeDatos2)
          }
        })
        .catch(error => {
          console.log('error: ', error)
        })
    } else if (result.error) {
      this.error = result.error
    }
  }

  handleCheckBoxChange (event) {
    if (event.target.checked) {
      this.checkIds.push(event.target.value)
      this.template
        .querySelectorAll(
          'lightning-input[data-id="' + event.target.value + '"]'
        )
        .forEach(field => {
          field.disabled = false
          console.log(field.value)
          field.required = true
        })
    } else {
      this.checkIds = this.checkIds.filter(value => {
        return value !== event.target.value
      })
      this.template
        .querySelectorAll(
          'lightning-input[data-id="' + event.target.value + '"]'
        )
        .forEach(field => {
          field.disabled = true
          field.required = false
        })
    }
    console.log(this.checkIds)

    let today = new Date()
    let date =
      today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate()
    this.template.querySelectorAll(
      'lightning-input[data-id="' + event.target.value + '"]'
    )[0].min = date
  }
  handleDateDesdeChange (event) {
    console.log(event.target.value)
    console.log(event.target.dataset.id)
    this.template.querySelectorAll(
      'lightning-input[data-id="' + event.target.dataset.id + '"]'
    )[1].min = event.target.value
  }

  handleDateHastaChange (event) {
    let startDate = new Date(
      this.template.querySelectorAll(
        'lightning-input[data-id="' + event.target.dataset.id + '"]'
      )[0].value
    )
    let endDate = new Date(event.target.value)
    let result = this.daysdiff(startDate, endDate) * 8
    this.template.querySelectorAll(
      'div[data-id="' + event.target.dataset.id + '"]'
    )[1].innerText = result + ' hs   '
    let rolname = this.template.querySelectorAll(
      'div[data-id="' + event.target.dataset.id + '"]'
    )[1].dataset.rol
    let suma = 0
    this.template
      .querySelectorAll('div[data-rol="' + rolname + '"]')
      .forEach(field => {
        if (isNaN(parseInt(field.innerText,10))) {
          suma = suma + 0
        } else {
          suma = suma + parseInt(field.innerText,10)
        }
      })

    console.log(suma)
    this.template.querySelector('th.' + rolname + '').textContent =
      '/ ' + suma + ' hs. Asignadas'
  }

  handleClick () {
    console.log('click')
    console.log('this.nuevoRegistro', this.nuevoRegistro)

    for (let i in this.checkIds) {
      this.nuevoRegistro.push({})
      this.nuevoRegistro[i].usuarioId = this.checkIds[i]
      this.template
        .querySelectorAll('lightning-input[data-id="' + this.checkIds[i] + '"]')
        .forEach(field => {
          this.nuevoRegistro[i][field.label] = field.value
        })

      let rate = this.template.querySelectorAll(
        'div[data-id="' + this.checkIds[i] + '"]'
      )[0].innerText
      console.log(rate)
      this.nuevoRegistro[i].Rate = parseInt(rate,10)

      let startDate = new Date(this.nuevoRegistro[i].Desde)
      let endDate = new Date(this.nuevoRegistro[i].Hasta)
      let result = this.daysdiff(startDate, endDate)

      console.log('Cantidad de dias sin fines de semana', result)
      this.nuevoRegistro[i].HorasAsignadas = result * 8
      this.nuevoRegistro[i].estimatedAmount =
        this.nuevoRegistro[i].HorasAsignadas * this.nuevoRegistro[i].Rate
      this.nuevoRegistro[i].ProjectId = this.recordId
    }

    console.log('this.nuevoRegistro', this.nuevoRegistro)


    Promise.all(
      this.nuevoRegistro.map(p => {
        const fields = {}
        fields[RESOURCE_FIELD.fieldApiName] = p.usuarioId
        fields[REQUIRED_HOURS_FIELD.fieldApiName] = p.HorasAsignadas
        fields[PROJECT_FIELD.fieldApiName] = p.ProjectId
        fields[ESTIMATED_AMOUNT.fieldApiName] = p.estimatedAmount
        fields[START_DATE.fieldApiName] = p.Desde
        fields[END_DATE.fieldApiName] = p.Hasta
        const recordInput = {
          apiName: RESOURCE_PROJECT_OBJECT.objectApiName,
          fields
        }
        return createRecord(recordInput)
      })
    )
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Success',
            message: 'Recursos Asignados!',
            variant: 'success'
          })
        )
        this.handleRefresh()
      })
      .catch(error => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Error while creating the record',
            message: error.body.message,
            variant: 'error'
          })
        )
      })
  }

  handleRefresh () {
    this.availableRes = []
    this.recursosDisponibles = []
    this.nuevoRegistro = []
    this.checkIds = []
    refreshApex(this.refreshAvailableResources)
  }

  daysdiff (startDate, endDate) {
    let result = 0
    while (startDate <= endDate) {
      let weekDay = new Date(startDate).getDay() + 1
      if (weekDay !== 6 && weekDay !== 7) result++
      startDate.setDate(startDate.getDate() + 1)
    }
    return result
  }
}