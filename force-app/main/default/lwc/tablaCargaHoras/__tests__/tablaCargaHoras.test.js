import { createElement } from 'lwc';
import tablaCargaHoras from 'c/tablaCargaHoras';
import getResourceTasks from '@salesforce/apex/getTasksInProgress.getResourceTasks';
  
// Mock realistic data
const mockUserTasks = require('./data/userTasks.json');

describe('posiciona los datos en la pagina',()=>{
    afterEach(()=>{
        while(document.body.firstChild){
            document.body.removeChild(document.body.firstChild)
        }
        jest.clearAllMocks();
    })
        it('Should contain all the tasks', () => {
            const tabla = createElement('c-tabla-carga-horas',{
                is:tablaCargaHoras
            })
            document.body.appendChild(tabla);

            getResourceTasks.emit(mockUserTasks);
            
            return Promise.resolve().then(()=>{
                const allTasks = tabla.shadowRoot.querySelectorAll('tr');
                expect(allTasks.length).toBe(5);
            })
        })
    
})