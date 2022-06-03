import { createElement } from 'lwc';
import tablaCargaHoras from 'c/tablaCargaHoras';
import { CurrentPageReference } from 'lightning/navigation';
  
// Mock realistic data
const mockUserTaks = require('./data/userTasks.json');

describe('posiciona los datos en la pagina',()=>{
    afterEach(()=>{
        while(document.body.firstChild){
            document.body.removeChild(document.body.firstChild)
        }
    })
})