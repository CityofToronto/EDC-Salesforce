import { LightningElement, wire, api } from 'lwc';
import GetQuestionAndAnswers from '@salesforce/apex/COT_BusinessPlanDatahandler.GetQuestionAndAnswers';

export default class FormAssemblyQuestionAndAnswers extends LightningElement {
    @api recordId;
    @api flexipageRegionWidth;

    @wire (GetQuestionAndAnswers,{incentiveId : '$recordId'}) questionAndAnswers;

}