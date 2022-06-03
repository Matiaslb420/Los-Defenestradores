import { createElement } from "lwc";
import actions from 'c/actions'


describe('connectedCallback()',()=>{
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while(document.body.firstChild) {
          document.body.removeChild(document.body.firstChild);
        }
      });
    it('should show "Register Hours" button when the task is In Progress',()=>{
        let inputs = createElement('c-actions',{
            is:actions
        });
        inputs.task = {State__c:'In Progress'}
        document.body.appendChild(inputs);
        let button = inputs.shadowRoot.querySelector('button');
        return Promise.resolve().then(()=>{
            expect(button.textContent).toBe('Register Hours');
        })
    })

    it('should show "Start Task" button when the task is Uninitialized',()=>{
        let inputs = createElement('c-actions',{
            is:actions
        });
        inputs.task = {State__c:'Uninitialized'}
        document.body.appendChild(inputs);
        let button = inputs.shadowRoot.querySelector('button');
        return Promise.resolve().then(()=>{
            expect(button.textContent).toBe('Start Task');
        })
    })
})