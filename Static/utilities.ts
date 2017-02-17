module Utilities {
    /**
     * Generate a somewhat dark color.
     **/
    export function generateRandomColor() {
        let red = getRandomInt( 0, 150 );
        let green = getRandomInt( 0, 150 );
        let blue = getRandomInt( 0, 150 );

        return `rgb(${ red },${ green },${ blue })`;
    }


    /**
     * Return a random integer between the given range (inclusive).
     **/
    export function getRandomInt( min: number, max: number ) {
        return Math.floor( Math.random() * ( max - min + 1 ) ) + min;
    }


    /**
     * Return the time (in milliseconds) since 1 january 1970 (unix time).
     */
    export function getCurrentTime() {
        return new Date().getTime();
    }
}