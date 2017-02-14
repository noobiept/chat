var SOCKET: WebSocket;
var CHAT_LIST: HTMLUListElement;
var CHAT_INPUT: HTMLInputElement;


window.onload = function () {

    SOCKET = new WebSocket( "ws://" + window.location.host + "/chat", "chat" );
    SOCKET.onopen = function () {
        SOCKET.send( "Hello" );
    };
    SOCKET.onmessage = function ( event: MessageEvent ) {
        addToList( event.data );
    };

    init();
};


function init() {
    CHAT_LIST = <HTMLUListElement>document.getElementById( "ChatList" );
    CHAT_INPUT = <HTMLInputElement>document.getElementById( "ChatInput" );

    CHAT_INPUT.onkeyup = function ( event ) {

        // add a new message when the 'enter' key is pressed
        if ( event.keyCode === 13 ) {
            newMessage();
        }
    };
}


/**
 * A new message was sent by the user. Add to the chat list and send it to the server as well.
 */
function newMessage() {
    var message = CHAT_INPUT.value;
    CHAT_INPUT.value = '';

    SOCKET.send( message );
    addToList( message );
}


/**
 * Add a message to the chat list.
 */
function addToList( message: string ) {
    var messageItem = document.createElement( "li" );
    messageItem.innerText = message;
    CHAT_LIST.appendChild( messageItem );
}