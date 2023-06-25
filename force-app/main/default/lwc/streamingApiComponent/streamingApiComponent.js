import { LightningElement,api,track } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import syncDataSf from '@salesforce/apex/SyncDataFromSalesforceToCustomerCity.constructReqBody'

export default class streamingApiComponent extends LightningElement {
    subscription = {};
  
    @api objectname;
    connectedCallback() {
      //  alert(this.objectname);
        const channel = '/data/'+this.objectname+'ChangeEvent';
   
        subscribe(channel, -1, this.messageCallback)
            .then(response => {
                console.log('Subscribed to channel:', JSON.stringify(response.channel));
                this.subscription = response;
            }); 
        onError(error => {
            console.error('Received error ', error);
        });
    }
    messageCallback = function(response) {
       let  payload = {
            "updates": [ // Inside this array you can send many updates object if you need to send records that got update in multiple tables
                { 
                    "table":"", // In Salesforce escenario would be the sObject name
                    "data": [ // This data is an array of whatever you like should have the enough information so we can update the data in our side, typically mean to be the records that got updated
                        
                    ]
                }
            ]
        }

         console.log('Received event: ', JSON.stringify(response));
         /*
        console.log('==>'+response.data.payload.ChangeEventHeader.changedFields)
        console.log('==>'+response.data.payload.ChangeEventHeader.changedFields.length)
        console.log('==>'+response.data.payload.ChangeEventHeader.entityName);
        console.log('==>'+response.data.payload.ChangeEventHeader.recordIds[0]);
        console.log('==>'+response.data.payload.LastModifiedDate);
        console.log('==>'+response.data.payload.Rating);
        payload.updates[0].table = response.data.payload.ChangeEventHeader.entityName;
        fields={} */
       // console.log(response.data.payload.ChangeEventHeader);
      
    /*     for(let i=0;i<2;i++){
            console.log('===>'+i)
           /*  console.log(response.data.payload.ChangeEventHeader.changedFields[i])
            fields[response.data.payload.ChangeEventHeader.changedFields[i]] = response.data.payload[response.data.payload.ChangeEventHeader.changedFields[i]]; */
        //}
     //   console.log(fields); 
      /*   fldList.forEach(elm=>{
            console.log(elm);
           
        }); */
      //  payload.updates[0].data[0] =fields;


        //this.payload.updates[0].table = response.data.payload.ChangeEventHeader.entityName;
     /*    let updates = [{
            table: response.data.payload.ChangeEventHeader.entityName,
            data: [{
              id: response.data.payload.ChangeEventHeader.recordIds[0],
              LastModifiedDate: response.data.payload.LastModifiedDate,
              Rating: response.data.payload.Rating
            }]
          }]; */
        //console.log(JSON.stringify(payload));

         syncDataSf({jsonString:JSON.stringify(response)})
        .then(resp =>{
        alert('in');
        })
        .catch(err=>{
            alert('e',e);
        }) 
        
      
       // //this.sendPayloadCC(response);
       // alert('bjb'+response)
    };

    disconnectedCallback() {
        unsubscribe(this.subscription, response => {
            console.log('Unsubscribed from channel:', JSON.stringify(response.channel));
        });
    }
    sendPayloadCC(payload){
        alert(payload)
    //jsonObj = JSON.parse(payload);
    payload.forEach(elm => {
      console.log('==>',elm);  
    });
    }
}