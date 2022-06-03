import { createElement } from "lwc";
import actions from 'c/actions'


describe('connectedCallback()',()=>{
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while(document.body.firstChild) {
          document.body.removeChild(document.body.firstChild);
        }
      });
    it('should set isInitialized as a boolean',()=>{
        let inputs = createElement('c-actions',{
            is:actions
        });
        inputs.task = {State__c:'In Progress'}
        document.body.appendChild(inputs);
        return Promise.resolve().then(()=>{
            expect(inputs.isInitialized).toBe('boolean');
        })
    })
})