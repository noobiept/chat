/**
 * Deals with the chat input.
 */
namespace Input {

    var CHAT_INPUT: HTMLInputElement;
    var ERROR_TOOLTIP: HTMLElement;
    var TOOLTIP_TIMEOUT: number;


    export function init() {
        CHAT_INPUT = <HTMLInputElement>document.getElementById( "ChatInput" );
        CHAT_INPUT.onkeyup = function ( event ) {

            // add a new message when the 'enter' key is pressed
            if ( event.keyCode === 13 ) {
                newMessage();
            }
        };

        let send = document.getElementById( "Send" )!;
        send.onclick = newMessage;

        ERROR_TOOLTIP = document.getElementById( 'ErrorTooltip' )!;

        let optionsButton = document.getElementById( 'ChatOptionsButton' )!;
        let options = document.getElementById( 'ChatOptions' )!;

        // toggle the options menu on the button click
        optionsButton.onclick = function () {
            options.classList.toggle( 'hidden' );
        };

        let showOnlyUserMessages = <HTMLInputElement>document.getElementById( 'ShowOnlyUserMessages' );
        showOnlyUserMessages.onchange = function () {
            Chat.showOnlyUserMessages( showOnlyUserMessages.checked );
        };
    }


    /**
     * A new message was sent by the user. Add to the chat list and send it to the server as well.
     */
    function newMessage() {
        var message = CHAT_INPUT.value;
        var length = message.length;

        // don't send messages outside the accepted range
        if ( length === 0 || length > 200 ) {
            inputError( `Can only send a message between 0 and 200 characters (has ${ length }).` );
            return;
        }

        hideErrorMessage();
        CHAT_INPUT.value = '';
        Chat.sendTextMessage( message );
    }


    /**
     * Show an input error message.
     **/
    function inputError( message: string ) {
        ERROR_TOOLTIP.innerText = message;
        ERROR_TOOLTIP.classList.remove( 'hidden' );

        // clear any previous timeout that was set
        window.clearTimeout( TOOLTIP_TIMEOUT );

        // hide the tooltip after a short moment
        TOOLTIP_TIMEOUT = window.setTimeout( function () {
            ERROR_TOOLTIP.classList.add( 'hidden' );

        }, 3000 );
    }


    /**
     * Hide the error message.
     **/
    function hideErrorMessage() {
        window.clearTimeout( TOOLTIP_TIMEOUT );
        ERROR_TOOLTIP.classList.add( 'hidden' );
    }
}