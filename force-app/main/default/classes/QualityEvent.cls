//Generated by wsdl2apex

public class QualityEvent {
    public class SubmitQualityEvent_element {
        public QualityEvent.SubmitQualityEventRequest request;
        private String[] request_type_info = new String[]{'request','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class QualityEventResponse {
        public String QualityEventId;
        public String ResponseCode;
        public String ResponseMessage;
        private String[] QualityEventId_type_info = new String[]{'QualityEventId','http://tempuri.org/',null,'0','1','false'};
        private String[] ResponseCode_type_info = new String[]{'ResponseCode','http://tempuri.org/',null,'0','1','false'};
        private String[] ResponseMessage_type_info = new String[]{'ResponseMessage','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'QualityEventId','ResponseCode','ResponseMessage'};
    }
    public class SubmitImpactedItem {
        public String PartNumber;
        public String LotNumber;
        public String Disposition;
        private String[] PartNumber_type_info = new String[]{'PartNumber','http://tempuri.org/',null,'0','1','false'};
        private String[] LotNumber_type_info = new String[]{'LotNumber','http://tempuri.org/',null,'0','1','false'};
        private String[] Disposition_type_info = new String[]{'Disposition','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'PartNumber','LotNumber','Disposition'};
    }
    public class SubmitQualityEventResponse_element {
        public QualityEvent.QualityEventResponse SubmitQualityEventResult;
        private String[] SubmitQualityEventResult_type_info = new String[]{'SubmitQualityEventResult','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'SubmitQualityEventResult'};
    }
    public class ArrayOfSubmitImpactedItem {
        public QualityEvent.SubmitImpactedItem[] SubmitImpactedItem;
        private String[] SubmitImpactedItem_type_info = new String[]{'SubmitImpactedItem','http://tempuri.org/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'SubmitImpactedItem'};
    }
    public class SubmitQualityEventRequest {
        public String QualityEventId;
        public String Status;
        public QualityEvent.ArrayOfSubmitImpactedItem ImpactedItems;
        private String[] QualityEventId_type_info = new String[]{'QualityEventId','http://tempuri.org/',null,'0','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://tempuri.org/',null,'0','1','false'};
        private String[] ImpactedItems_type_info = new String[]{'ImpactedItems','http://tempuri.org/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'QualityEventId','Status','ImpactedItems'};
    }
    public class QualityEventSoap_soap {
        Webservice_Authentification__mdt authentification_details = Webservice_Authentification__mdt.getInstance('CreateQualityEvent');
        public String endpoint_x = authentification_details.Webservice_enpoint__c;
        //public String endpoint_x = 'http://dev.crmgw.biofiredx.net/QualityEvent.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/', 'QualityEvent'};
        public QualityEvent.QualityEventResponse SubmitQualityEvent(QualityEvent.SubmitQualityEventRequest request) {
            QualityEvent.SubmitQualityEvent_element request_x = new QualityEvent.SubmitQualityEvent_element();
            request_x.request = request;
            QualityEvent.SubmitQualityEventResponse_element response_x;
            Map<String, QualityEvent.SubmitQualityEventResponse_element> response_map_x = new Map<String, QualityEvent.SubmitQualityEventResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/ISubmitQualityEventService/SubmitQualityEvent',
              'http://tempuri.org/',
              'SubmitQualityEvent',
              'http://tempuri.org/',
              'SubmitQualityEventResponse',
              'QualityEvent.SubmitQualityEventResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.SubmitQualityEventResult;
        }
    }
}