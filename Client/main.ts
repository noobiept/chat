window.onload = function () {
    Chat.init();
};


namespace Chat {

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

    var CONNECTED: HTMLSpanElement;
    var CONNECTED_COUNT = 0;
    var USERNAME = '';
    var USERS_COLORS: { [ username: string ]: string } = {};
    var SHOW_ONLY_USER_MESSAGES = false;


    /**
     * Initialize the chat.
     */
    export function init() {
        SOCKET = new WebSocket( "wss://" + window.location.host + "/chat", "chat" );
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

        CONNECTED = document.getElementById( "ConnectedCount" )!;
        CHAT_LIST = <HTMLUListElement>document.getElementById( "ChatList" );

        // put the focus on the chat input when a key is pressed
        document.body.onkeypress = function () {
            Input.gainFocus();
        };

        Input.init();
        addSystemMessage( textElement( 'Welcome to the chat!' ) );
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
     * A non-user message.
     **/
    function addSystemMessage( ...elements: HTMLElement[] ) {
        if ( SHOW_ONLY_USER_MESSAGES ) {
            return;
        }

        let item = document.createElement( "li" );
        item.className = 'systemMessage';

        item.appendChild( textElement( '--- ' ) );

        for ( var a = 0; a < elements.length; a++ ) {
            item.appendChild( elements[ a ] );
        }

        CHAT_LIST.appendChild( item );
        checkListClear();
        checkIfNeedToScroll();

        return item;
    }


    /**
     * Add a message to the chat list.
     */
    export function addUserMessage( message: Message ) {

        let timePart = timeElement( message.time );
        let usernamePart = usernameElement( message.username );

        let messagePart = document.createElement( "span" );
        messagePart.className = 'message';
        messagePart.innerText = message.message;

        let item = document.createElement( "li" );
        item.appendChild( timePart );
        item.appendChild( usernamePart );
        item.appendChild( messagePart );

        CHAT_LIST.appendChild( item );
        checkListClear();
        checkIfNeedToScroll();

        return item;
    }


    /**
     * Create a username element (with the correct color).
     **/
    function usernameElement( username: string ) {
        let usernamePart = document.createElement( "span" );

        usernamePart.className = 'username';
        usernamePart.innerText = username;
        usernamePart.style.color = getUserColor( username );

        return usernamePart;
    }


    /**
     * Show a message of a certain time (in the hour/minutes format).
     **/
    function timeElement( time: number ) {

        let date = new Date( time );
        let hours = Utilities.leftPad( date.getHours().toString(), '0', 2 )
        let minutes = Utilities.leftPad( date.getMinutes().toString(), '0', 2 );

        let timePart = document.createElement( "span" );
        timePart.className = 'time';
        timePart.innerText = `${ hours }:${ minutes }`;
        timePart.title = date.toLocaleString();

        return timePart;
    }


    /**
     * Create a text element.
     **/
    function textElement( text: string ) {
        let element = document.createElement( 'span' );
        element.innerText = text;

        return element;
    }


    /**
     * Show a message saying the given user has joined the chat.
     */
    function userJoined( username: string ) {
        let li = addSystemMessage(
            timeElement( Utilities.getCurrentTime() ),
            usernameElement( username ),
            textElement( 'joined.' )
        );

        if ( li ) {
            li.classList.add( "userJoined" );
        }

        addToUsersCount( 1 );
    }


    /**
     * Show a message saying the given user has left the chat.
     */
    function userLeft( username: string ) {
        let li = addSystemMessage(
            timeElement( Utilities.getCurrentTime() ),
            usernameElement( username ),
            textElement( 'left.' )
        );

        if ( li ) {
            li.classList.add( "userLeft" );
        }

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

        addSystemMessage(
            textElement( 'Your username is:' ),
            usernameElement( username )
        );
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


    /**
     * Need to reduce the message list once it gets past a certain limit.
     **/
    function checkListClear() {
        if ( CHAT_LIST.childElementCount > 100 ) {

            // remove 50 in a row
            while ( CHAT_LIST.childElementCount > 50 ) {
                CHAT_LIST.firstElementChild!.remove();
            }
        }
    }


    /**
     * Scroll the chat list to the bottom (so we can see the last message that was sent).
     **/
    function scrollChatList() {
        CHAT_LIST.scrollTop = CHAT_LIST.scrollHeight;
    }


    /**
     * Only scroll to the bottom if we're close to the bottom (don't scroll down if someone is reading something above).
     **/
    function checkIfNeedToScroll() {
        let margin = 30;

        if ( CHAT_LIST.scrollTop + CHAT_LIST.clientHeight + margin > CHAT_LIST.scrollHeight ) {
            scrollChatList();
        }
    }


    /**
     * Get the associated username.
     **/
    export function getUsername() {
        return USERNAME;
    }


    /**
     * Send a text message to the server.
     **/
    export function sendTextMessage( message: string ) {
        SOCKET.send( "M|" + message );

        let li = Chat.addUserMessage( {
            time: Utilities.getCurrentTime(), message: message, username: Chat.getUsername()
        } );

        // style our own messages differently
        li.classList.add( "ownMessage" );

        // scroll to the bottom when its the user that sent a new message
        scrollChatList();
    }


    export function showOnlyUserMessages( value: boolean ) {
        SHOW_ONLY_USER_MESSAGES = value;
    }
}
