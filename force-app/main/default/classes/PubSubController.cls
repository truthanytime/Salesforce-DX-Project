public class PubSubController {
   /* public static void subscribeToExampleEvent(List<String> params) {
        String channel = '/event/Example_Event__e';
        Integer replayId = -1;
        EMP_API.Subscription subscription = EMP_API.subscribe(channel, replayId, new ExampleEventCallback());
        System.debug('Subscribed to channel: ' + subscription.getChannel());
    }

    private class ExampleEventCallback implements EMP_API.EventCallback {
        public void onEvent(EMP_API.Event event) {
            Example_Event__e eventData = (Example_Event__e) event.getData();
            String message = eventData.Message__c;
            Integer priority = eventData.Priority__c;
            System.debug('Received event with message "' + message + '" and priority ' + priority);
        }
    }
*/
}