/**
 * Deals with the chat input.
 */
module Input {

    var CHAT_INPUT: HTMLInputElement;


    export function init() {
        CHAT_INPUT = <HTMLInputElement>document.getElementById( "ChatInput" );

        CHAT_INPUT.onkeyup = function ( event ) {

            // add a new message when the 'enter' key is pressed
            if ( event.keyCode === 13 ) {
                newMessage();
            }
        };

        let send = document.getElementById( "Send" ) !;
        send.onclick = newMessage;
    }


    /**
     * A new message was sent by the user. Add to the chat list and send it to the server as well.
     */
    function newMessage() {
        var message = CHAT_INPUT.value;
        var length = message.length;

        // don't send messages outside the accepted range
        if ( length === 0 || length > 200 ) {
            return;
        }

        CHAT_INPUT.value = '';
        Chat.sendTextMessage( message );
    }
}