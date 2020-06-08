window.onerror = (msg, url, line, column, error) => {
    window.github._sendMessage('error', {
    message: msg,
    url: url,
    line: line,
    column: column,
    error: JSON.stringify(error)
    })
}

/**
 * @typedef {object} Rect
 * @property {number} X - The X coordinate
 * @property {number} Y - The Y coordinate
 * @property {number} Width - The width
 * @property {number} Height - The height
 */

/**
 * Object for configuring and controlling the page content
 */
class GitHub {
    /**
     * Initialize
     *
     * @param {string} id Identifier of the web view
     */
    constructor (id) {
        this.id = id
        
        // Notify Swift that we are ready to receive events
        this._sendMessage('ready', { isReady: 1 })
    }
    
    /**
     * Send a message to the native app.
     *
     * @param {string} name Name of the message
     * @param {object} message Message content
     */
    _sendMessage (name, message) {
        var payload = message
        payload.messageName = name
        payload.id = this.id
        
        if (window.webkit) {
            window.webkit.messageHandlers.message.postMessage(payload)
        } else {
            console.log(payload)
        }
    }
    
    /**
     * Send a height to the app
     */
    _updateHeight () {
        const height = document.body.scrollHeight
        if (height === this._lastHeight) {
            return
        }
        
        this._lastHeight = height
        this._sendMessage('height', { height: height })
    }
    
    /**
     * Listen for events and send a height event when they fire
     *
     * @param {string} querySelector Query selector for elements
     * @param {string} eventName Event name to listen to
     */
    _addHeightListener (querySelector, eventName) {
        const elements = document.querySelectorAll(querySelector)
        for (const element of elements) {
            element.addEventListener(eventName, () => {
                this._updateHeight()
            })
        }
    }
    
    /**
     * Unescape `?raw=true` at the end of image URLs
     */
    _unescapeImageURLs () {
        const images = document.querySelectorAll('img')
        for (const image of images) {
            const url = image.src
            if (!url || !url.endsWith('%3Fraw%3Dtrue')) {
                continue
            }
            
            image.src = url.replace(/%3Fraw%3Dtrue$/, '?raw=true')
        }
    }
    
    /**
     * Post-process and setup listeners after changing the main content
     */
    _didLoad () {
        // Clear the height cache
        this._lastHeight = 0
        
        // Post-process content
        this._unescapeImageURLs()
        
        // Setup event listeners
        this._addHeightListener('details', 'toggle')
        this._addHeightListener('img, svg', 'load')
    }
    
    /**
     * Load content into the web view
     *
     * @param {string} html Content to load
     * @returns {number} Height of the document
     */
    load (html) {
        const content = document.getElementById('content')
        
        if (content.innerHTML === html) {
            return this.getHeight()
        }
        
        // Set the content
        content.innerHTML = html
        
        this._didLoad()
        
        return this.getHeight()
    }
    
    /**
     * Get the position of an element by ID
     *
     * @param {string} elementID Name of the anchor tapped
     * @returns {Rect} Bounds of the target element
     */
    positionOf (elementID) {
        const rect = document.getElementById('user-content-' + elementID).getBoundingClientRect()
        
        // Use keys to match what `CGRect(dictionaryRepresentation:)` expects.
        return {
        X: rect.x,
        Y: rect.y,
        Width: rect.width,
        Height: rect.height
        }
    }
    
    /**
     * Get the current height
     *
     * @returns {number} Height of the document
     */
    getHeight () {
        const height = document.body.scrollHeight
        this._lastHeight = height
        return height
    }
}

if (typeof exports !== 'undefined') {
    exports.GitHub = GitHub
}
