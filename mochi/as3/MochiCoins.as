/**
* MochiServices
* Class that provides API access to Mochi Coins Service
* @author Mochi Media
*/
package mochi.as3 {

    import flash.display.Sprite;

    public class MochiCoins {
        public static const LOGGED_IN:String = "LoggedIn";
        public static const LOGGED_OUT:String = "LoggedOut";
        public static const LOGIN_SHOW:String = "LoginShow";
        public static const LOGIN_HIDE:String = "LoginHide";
        public static const STORE_SHOW:String = "StoreShow";
        public static const STORE_HIDE:String = "StoreHide";
        public static const PROFILE_SHOW:String = "ProfileShow";
        public static const PROFILE_HIDE:String = "ProfileHide";
        public static const PROPERTIES_SAVED:String = "PropertySaved";
        public static const WIDGET_LOADED:String = "WidgetLoaded";
        
        
        // event passes {id: item id, count: number owned}
        public static const ITEM_OWNED:String = "ItemOwned";
        
        // event passes {id: item id, count: number of new items}
        public static const ITEM_NEW:String = "ItemNew";
        
        // initiated with getStoreItems() call.
        // event passes array of item metas [ { id: "ab473e7f87129ecb", name: "Super Cannon", desc: "A Super Cannon", 
        //    imgURL: "http://..", cost: 150, maxNum: 1, tags: [ level-1, powerup] ], properties: { power: 20 } } ]
        public static const STORE_ITEMS:String = "StoreItems";
        
        // initiated with getUserInfo() call.
        // event pass object with user info. 
        // {name: "name", uid: unique_identifier, profileImgURL: url_of_player_image, hasCoins: True}
        public static const USER_INFO:String = "UserInfo";
        
        public static const ERROR:String = "Error";
        // error types
        public static const IO_ERROR:String = "IOError";
        public static const NO_USER:String = "NoUser";
        public static const PROPERTIES_SIZE:String = "PropertiesSize"
        
        private static var _dispatcher:MochiEventDispatcher = new MochiEventDispatcher();
        
        public static function getVersion():String 
        {
            return MochiServices.getVersion();
        }
        
        /**
         * Method: showStore
         * Displays the MochiGames Store.
         * @param   options object containing variables representing the changeable parameters <see: GUI Options>
         */
        public static function showStore(options:Object = null):void
        {
            MochiServices.bringToTop();
            MochiServices.send("coins_showStore", { options: options }, null, null );
        }
        
        /**
         * Method: showItem
         * Displays the MochiGames with one item.
         * @param   options object containing variables representing the changeable parameters <see: GUI Options>
         */
        public static function showItem(options:Object = null):void
        {
            if ((! options) || (typeof(options.item) != "string")) {
                trace("ERROR: showItem call must pass an Object with an item key");
                return;
            }
            
            MochiServices.bringToTop();
            MochiServices.send("coins_showItem", { options: options }, null, null );
        }
        
        /**
         * Method: showVideo
         * Displays the demonstration video for an item
         * @param   options object containing variables representing the changeable parameters <see: GUI Options>
         */
        public static function showVideo(options:Object = null):void
        {
            if ((! options) || (typeof(options.item) != "string")) {
                trace("ERROR: showVideo call must pass an Object with an item key");
                return;
            }
            
            MochiServices.bringToTop();
            MochiServices.send("coins_showVideo", { options: options }, null, null );
        }
        
        /**
         * Method: showLoginWidget
         * Displays the MochiGames Login widget.
         * @param   options object containing variables representing the changeable parameters <see: GUI Options>
         * {x: 150, y: 10}
         */
        public static function showLoginWidget(options:Object = null):void
        {
            MochiServices.setContainer();
            MochiServices.bringToTop();
            MochiServices.send("coins_showLoginWidget", { options: options });
        }
        
        public static function hideLoginWidget():void
        {
            MochiServices.send("coins_hideLoginWidget");
        }
        
        /**
         * Method: getStoreItems
         * Calls STORE_ITEMS event, passing an object with all store items, keyed by itemID
         * { ab473e7f87129ecb: { name: "Super Cannon", desc: "A Super Cannon", imgURL: "http://..", cost: 150, maxNum: 1, tags:{ levels: "level-1" } } }
         */
        public static function getStoreItems():void
        {
            MochiServices.send("coins_getStoreItems");
        }
        
        /**
         * Method: getUserInfo
         * Calls USER_INFO event.  If a user is logged in, it repeats the same info triggered by the LOGGED_IN event. Otherwise it returns
         * an empty Object.
         * {name: "name", uid: unique_identifier, profileImgURL: url_of_player_image, hasCoins: True}
         */
        public static function getUserInfo():void
        {
            MochiServices.send("coins_getUserInfo");
        }
        
        public static function saveUserProperties(properties:Object):void
        {
            MochiServices.send("coins_saveUserProperties", properties);
        }
        
        // --- Callback system ----------
        public static function addEventListener( eventType:String, delegate:Function ):void
        {
            _dispatcher.addEventListener( eventType, delegate );
        }

        public static function triggerEvent( eventType:String, args:Object ):void
        {
            _dispatcher.triggerEvent( eventType, args );
        }
        
        public static function removeEventListener( eventType:String, delegate:Function ):void
        {
            _dispatcher.removeEventListener( eventType, delegate );
        }
    }
}