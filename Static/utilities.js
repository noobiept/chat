"use strict";
var Utilities;
(function (Utilities) {
    /**
     * Generate a somewhat dark color.
     **/
    function generateRandomColor() {
        let red = getRandomInt(0, 150);
        let green = getRandomInt(0, 150);
        let blue = getRandomInt(0, 150);
        return `rgb(${red},${green},${blue})`;
    }
    Utilities.generateRandomColor = generateRandomColor;
    /**
     * Return a random integer between the given range (inclusive).
     **/
    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
    Utilities.getRandomInt = getRandomInt;
    /**
     * Return the time (in milliseconds) since 1 january 1970 (unix time).
     */
    function getCurrentTime() {
        return new Date().getTime();
    }
    Utilities.getCurrentTime = getCurrentTime;
    /**
     * Fill the string with the given character until it reaches the desired length.
     **/
    function leftPad(str, character, length) {
        let diff = length - str.length;
        // see if we need to do anything
        if (diff > 0) {
            return character.repeat(diff) + str;
        }
        return str;
    }
    Utilities.leftPad = leftPad;
})(Utilities || (Utilities = {}));
