import { createElement } from 'lwc';
import tablaCargaHoras from 'c/tablaCargaHoras';
import { CurrentPageReference } from 'lightning/navigation';
  
// Mock realistic data
const mockCurrentPageReference  = require('./data/CurrentPageReference.json');

describe('posiciona los datos en la pagina',()=>{
    afterEach(()=>{
        while(document.body.firstChild){
            document.body.removeChild(document.body.firstChild)
        }
        it('Should contain all the tasks',()=>{
            const tabla = createElement('c-tabla-carga-horas',{
                is:tablaCargaHoras
            })
            document.body.appendChild(tabla);
            CurrentPageReference.mock(mockCurrentPageReference );
            expect(1).toBe(1);
            
            return Promise.resolve().then(()=>{
                const allTasks = document.shadowRoot.querySelectorAll('tr');
                expect(allTasks.length).toBe(5);
            })
        })
    })
})