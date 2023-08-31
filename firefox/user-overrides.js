/*** MY OVERRIDES ***/

/*** [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ***/
user_pref("browser.urlbar.suggest.searches", true);

/*** [SECTION 1000]: DISK AVOIDANCE ***/
user_pref("browser.cache.disk.enable", true);
user_pref("browser.sessionstore.privacy_level", 1);

/*** [SECTION 1700]: CONTAINERS ***/
user_pref("privacy.userContext.enabled", false);
user_pref("privacy.userContext.ui.enabled", false);

/*** [SECTION 2800]: SHUTDOWN & SANITIZING ***/
user_pref("privacy.clearOnShutdown.history", false); 
user_pref("privacy.clearOnShutdown.sessions", false);

/*** [SECTION 4500]: RFP (RESIST FINGERPRINTING) ***/
user_pref("privacy.resistFingerprinting.letterboxing", false);
user_pref("webgl.disabled", false); 

/*** [SECTION 5000]: OPTIONAL OPSEC ***/
user_pref("browser.sessionstore.max_tabs_undo", 3);
user_pref("browser.download.forbid_open_with", true);

