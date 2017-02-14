var SOCKET: WebSocket;
var CHAT_LIST: HTMLUListElement;
var CHAT_INPUT: HTMLInputElement;


window.onload = function () {

    SOCKET = new WebSocket( "ws://" + window.location.host + "/chat", "chat" );
    SOCKET.onopen = function () {
        SOCKET.send( "Hello" );
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


function newMessage() {
    var message = CHAT_INPUT.value;
    CHAT_INPUT.value = '';

    SOCKET.send( message );

    var messageItem = document.createElement( "li" );
    messageItem.innerText = message;
    CHAT_LIST.appendChild( messageItem );
}