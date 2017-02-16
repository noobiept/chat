window.onload = function () {
    Chat.init();
};


module Chat {

    interface Message {
        message: string;
        username: string;
    }

    const MessageType = {
        getUsername : "U",  // U|(username)
        textMessage : "M",  // M|(username)|(message)
        userJoined  : "J",  // J|(username)
        userLeft    : "L"   // L|(username)
    }


    var SOCKET: WebSocket;
    var CHAT_LIST: HTMLUListElement;
    var CHAT_INPUT: HTMLInputElement;
    var USERNAME = '';


    /**
     * Initialize the chat.
     */
    export function init() {
        SOCKET = new WebSocket( "ws://" + window.location.host + "/chat", "chat" );
        SOCKET.onopen = socketReady;
        SOCKET.onmessage = function ( event: MessageEvent ) {
            var type = event.data[ 0 ];

            switch ( type ) {
                case MessageType.getUsername:
                    var username = parseUsernameMessage( event.data );
                    associateUsername( username );
                    break;

                case MessageType.textMessage:
                    var message = parseTextMessage( event.data );
                    addToList( message );
                    break;

                case MessageType.userJoined:
                    var username = parseUsernameMessage( event.data );
                    userJoined( username );
                    break;

                case MessageType.userLeft:
                    var username = parseUsernameMessage( event.data );
                    userLeft( username );
                    break;
            }
        };

        CHAT_LIST = <HTMLUListElement>document.getElementById( "ChatList" );
        CHAT_INPUT = <HTMLInputElement>document.getElementById( "ChatInput" );

        CHAT_INPUT.onkeyup = function ( event ) {

            // add a new message when the 'enter' key is pressed
            if ( event.keyCode === 13 ) {
                newMessage();
            }
        };

        let send = document.getElementById( "Send" )!;
        send.onclick = newMessage;
    }


    /**
     * Format: "U|(username)"
     */
    function parseUsernameMessage( data: string ) {
        return data.slice( 2 );
    }


    /**
     * The server sends a message in the following format: "M|username|message".
     */
    function parseTextMessage( data: string ): Message {
        var separator = data.indexOf( "|", 2 );
        var username = data.slice( 2, separator );
        var message = data.slice( separator + 1 );

        return { username: username, message: message };
    }


    /**
     * A new message was sent by the user. Add to the chat list and send it to the server as well.
     */
    function newMessage() {
        var message = CHAT_INPUT.value;

            // don't send empty messages
        if ( message.length === 0 ) {
            return;
        }

        CHAT_INPUT.value = '';

        SOCKET.send( "M|" + message );
        addToList( {
            message: message, username: USERNAME
        });
    }


    /**
     * Add a message to the chat list.
     */
    function addToList( message: Message ) {
        let item = document.createElement( "li" );
        let usernamePart = document.createElement( "span" );
        let messagePart = document.createElement( "span" );

        usernamePart.className = 'username';
        usernamePart.innerText = message.username;

        messagePart.className = 'message';
        messagePart.innerText = message.message;

        item.appendChild( usernamePart );
        item.appendChild( messagePart );

        CHAT_LIST.appendChild( item );
    }


    /**
     * Show a message saying the given user has joined the chat.
     */
    function userJoined( username: string ) {
        addToList({ username: username, message: "Joined." });
    }


    /**
     * Show a message saying the given user has left the chat.
     */
    function userLeft( username: string ) {
        addToList({ username: username, message: "Left." });
    }


    /**
     * The connection is opened, signal that to the server so it can send some initial information.
     */
    function socketReady() {
        SOCKET.send( "R" );
    }


    /**
     * Set this user name.
     */
    function associateUsername( username: string ) {
        USERNAME = username;
    }
}
