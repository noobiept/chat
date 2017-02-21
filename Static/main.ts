window.onload = function () {
    Chat.init();
};


module Chat {

    interface Message {
        time: number;   // time in milliseconds since 1 january 1970 (unix time).
        message: string;
        username: string;
    }

    // read the readme for more information
    const MessageType = {
        getUsername: "U",
        currentUsersCount: "C",
        textMessage: "M",
        userJoined: "J",
        userLeft: "L"
    }


    var SOCKET: WebSocket;
    var CHAT_LIST: HTMLUListElement;
    var CHAT_INPUT: HTMLInputElement;
    var CONNECTED: HTMLSpanElement;
    var CONNECTED_COUNT = 0;
    var USERNAME = '';
    var USERS_COLORS: { [ username: string ]: string } = {};


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

                case MessageType.currentUsersCount:
                    let connectedCount = parseUsersCount( event.data );
                    addToUsersCount( connectedCount );
                    break;

                case MessageType.textMessage:
                    var message = parseTextMessage( event.data );
                    addUserMessage( message );
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

        CONNECTED = document.getElementById( "ConnectedCount" ) !;
        CHAT_LIST = <HTMLUListElement>document.getElementById( "ChatList" );
        CHAT_INPUT = <HTMLInputElement>document.getElementById( "ChatInput" );

        CHAT_INPUT.onkeyup = function ( event ) {

            // add a new message when the 'enter' key is pressed
            if ( event.keyCode === 13 ) {
                newMessage();
            }
        };

        let send = document.getElementById( "Send" ) !;
        send.onclick = newMessage;

        addSystemMessage( "Welcome to the chat!" );
    }


    /**
     * Format: "U|(username)"
     */
    function parseUsernameMessage( data: string ) {
        return data.slice( 2 );
    }


    /**
     * Format: "C|(connectedCount)"
     **/
    function parseUsersCount( data: string ) {
        return parseInt( data.slice( 2 ) );
    }


    /**
     * The server sends a message in the following format: "M|username|message".
     */
    function parseTextMessage( data: string ): Message {
        var timeSeparator = data.indexOf( "|", 2 );
        var time = data.slice( 2, timeSeparator );

        var usernameSeparator = data.indexOf( "|", timeSeparator + 1 );
        var username = data.slice( timeSeparator + 1, usernameSeparator );

        var message = data.slice( usernameSeparator + 1 );

        return { time: parseFloat( time ), username: username, message: message };
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
        let li = addUserMessage( {
            time: Utilities.getCurrentTime(), message: message, username: USERNAME
        });

        // style our own messages differently
        li.classList.add( "ownMessage" );
    }


    /**
     * A non-user message.
     **/
    function addSystemMessage( text: string ) {
        let item = document.createElement( "li" );
        item.className = 'systemMessage';
        item.innerText = text;

        CHAT_LIST.appendChild( item );
    }


    /**
     * Add a message to the chat list.
     */
    function addUserMessage( message: Message ) {
        let item = document.createElement( "li" );
        let timePart = document.createElement( "span" );
        let usernamePart = document.createElement( "span" );
        let messagePart = document.createElement( "span" );

        let date = new Date( message.time );
        let hours = Utilities.leftPad( date.getHours().toString(), '0', 2 )
        let minutes = Utilities.leftPad( date.getMinutes().toString(), '0', 2 );

        timePart.className = 'time';
        timePart.innerText = `${ hours }:${ minutes }`;

        usernamePart.className = 'username';
        usernamePart.innerText = message.username;
        usernamePart.style.color = getUserColor( message.username );

        messagePart.className = 'message';
        messagePart.innerText = message.message;

        item.appendChild( timePart );
        item.appendChild( usernamePart );
        item.appendChild( messagePart );

        CHAT_LIST.appendChild( item );

        return item;
    }


    /**
     * Show a message saying the given user has joined the chat.
     */
    function userJoined( username: string ) {
        addUserMessage( { time: Utilities.getCurrentTime(), username: username, message: "Joined." });
        addToUsersCount( 1 );
    }


    /**
     * Show a message saying the given user has left the chat.
     */
    function userLeft( username: string ) {
        addUserMessage( { time: Utilities.getCurrentTime(), username: username, message: "Left." });
        addToUsersCount( -1 );
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

        addSystemMessage( `Your username is: ${ username }` );
    }


    /**
     * Get the color associated with the given user (the color is client side, so its going to be different in every client).
     **/
    function getUserColor( username: string ) {
        var color = USERS_COLORS[ username ];

        if ( !color ) {
            color = Utilities.generateRandomColor();
            USERS_COLORS[ username ] = color;
        }

        return color;
    }


    /**
     * Update the number of currently connected users element (adds to the current value).
     **/
    function addToUsersCount( addedValue: number ) {
        CONNECTED_COUNT += addedValue;
        CONNECTED.innerText = CONNECTED_COUNT.toString();
    }
}
