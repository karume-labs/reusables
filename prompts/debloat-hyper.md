# Android Apps Report

## 1. Bloatware Apps Detected

Based on the apps installed on your device (identified as a Xiaomi/Redmi/POCO device), the following are commonly considered "bloatware" (pre-installed system apps, analytics trackers, and non-essential OEM applications):

* `com.miui.analytics` (Xiaomi Analytics)
* `com.xiaomi.mipicks` (Xiaomi GetApps / App Store)
* `com.miui.cleaner` (Xiaomi Cleaner)
* `com.mi.globalbrowser` (Mi Browser)
* `com.miui.player` (Mi Music)
* `com.xiaomi.discover` (Xiaomi Discover)
* `com.miui.videoplayer` (Mi Video)
* `com.xiaomi.payment` (Xiaomi Payment)

## 2. Command to Uninstall Bloatware

You can uninstall these apps for the current user (without needing root access) using the following ADB command.

> [!CAUTION]
> Uninstalling system apps can sometimes cause minor system glitches depending on your MIUI version. A factory reset will restore any uninstalled system apps.

Run this command in your terminal:

```bash
for pkg in com.miui.analytics com.xiaomi.mipicks com.miui.cleaner com.mi.globalbrowser com.miui.player com.xiaomi.discover com.miui.videoplayer com.xiaomi.payment; do adb shell pm uninstall -k --user 0 $pkg; done
```

## 3. All Installed Apps

Here is the complete list of all packages installed on your phone:

- android
- android.aosp.overlay
- android.aosp.overlay.telephony
- com.activision.callofduty.shooter
- com.android.apps.tag
- com.android.avatarpicker
- com.android.bluetooth
- com.android.bluetooth.overlay
- com.android.calllogbackup
- com.android.cameraextensions
- com.android.carrierconfig
- com.android.carrierconfig.overlay.miui
- com.android.certinstaller
- com.android.chrome
- com.android.compos.payload
- com.android.cts.ctsshim
- com.android.deskclock
- com.android.dreams.basic
- com.android.dynsystem
- com.android.hotwordenrollment.okgoogle
- com.android.hotwordenrollment.xgoogle
- com.android.htmlviewer
- com.android.inputdevices
- com.android.intentresolver
- com.android.internal.display.cutout.emulation.double
- com.android.internal.display.cutout.emulation.hole
- com.android.internal.display.cutout.emulation.tall
- com.android.internal.systemui.navbar.transparent
- com.android.localtransport
- com.android.managedprovisioning
- com.android.managedprovisioning.overlay
- com.android.mms.service
- com.android.musicfx
- com.android.networkstack.overlay.miui
- com.android.nfc
- com.android.overlay.gmssettingprovider
- com.android.overlay.gmstelecomm
- com.android.pacprocessor
- com.android.phone
- com.android.phone.overlay.miui
- com.android.providers.contactkeys
- com.android.providers.partnerbookmarks
- com.android.providers.settings
- com.android.providers.settings.overlay
- com.android.providers.telephony
- com.android.providers.telephony.overlay.miui
- com.android.providers.userdictionary
- com.android.provision
- com.android.role.notes.enabled
- com.android.settings
- com.android.settings.overlay.miui
- com.android.stk.overlay.miui
- com.android.storagemanager
- com.android.systemui
- com.android.systemui.navigation.bar.overlay
- com.android.vending
- com.android.virtualmachine.res
- com.android.vpndialogs
- com.android.wallpaperbackup
- com.android.wifi.dialog
- com.android.wifi.mainline.resources.overlay
- com.android.wifi.resources.overlay
- com.android.wifi.resources.xiaomi
- com.bsp.catchlog
- com.chess
- com.debug.loggerui
- com.facebook.katana
- com.facebook.services
- com.figma.mirror
- com.fingerprints.optical
- com.github.android
- com.google.ambient.streaming
- com.google.android.adservices.api
- com.google.android.aicore
- com.google.android.apps.adm
- com.google.android.apps.authenticator2
- com.google.android.apps.bard
- com.google.android.apps.chromecast.app
- com.google.android.apps.docs
- com.google.android.apps.maps
- com.google.android.apps.restore
- com.google.android.apps.safetyhub
- com.google.android.apps.subscriptions.red
- com.google.android.apps.translate
- com.google.android.apps.wellbeing
- com.google.android.appsearch.apk
- com.google.android.ar.core
- com.google.android.as
- com.google.android.as.oss
- com.google.android.calendar
- com.google.android.cellbroadcastreceiver
- com.google.android.cellbroadcastreceiver.overlay.miui
- com.google.android.connectivity.resources
- com.google.android.contacts
- com.google.android.devicelockcontroller
- com.google.android.dialer
- com.google.android.ext.shared
- com.google.android.gsf
- com.google.android.health.connect.backuprestore
- com.google.android.keep
- com.google.android.marvin.talkback
- com.google.android.networkstack.tethering
- com.google.android.onetimeinitializer
- com.google.android.overlay.devicelockcontroller
- com.google.android.overlay.gmsconfig.common
- com.google.android.overlay.gmsconfig.comms
- com.google.android.overlay.gmsconfig.gsa
- com.google.android.overlay.gmsconfig.photos
- com.google.android.overlay.gmsconfig.searchselector
- com.google.android.overlay.modules.captiveportallogin.forframework
- com.google.android.overlay.modules.documentsui
- com.google.android.permissioncontroller
- com.google.android.photopicker
- com.google.android.rkpdapp
- com.google.android.safetycenter.resources
- com.google.android.syncadapters.calendar
- com.google.android.tts
- com.google.android.videos
- com.google.android.wifi.resources
- com.google.android.wifi.resources.xiaomi
- com.google.android.youtube
- com.google.mainline.adservices
- com.king.candycrushsaga
- com.linkedin.android
- com.luma.mobile
- com.mediatek
- com.mediatek.FrameworkResOverlayExt
- com.mediatek.SettingsProviderResOverlay
- com.mediatek.atmwifimeta
- com.mediatek.callrecorder
- com.mediatek.capctrl.service
- com.mediatek.cellbroadcastuiresoverlay
- com.mediatek.datachannel.service
- com.mediatek.engineermode
- com.mediatek.frameworkresoverlay
- com.mediatek.gbaservice
- com.mediatek.ims
- com.mediatek.location.mtkgeofence
- com.mediatek.mdmlsample
- com.mediatek.miravision.ui
- com.mediatek.mt6899.gamedriver
- com.mediatek.networkstack.gooverlay
- com.mediatek.networkstack.overlay
- com.mediatek.smartratswitch.service
- com.mediatek.voiceunlock
- com.mediatek.ygps
- com.mi.android.globallauncher
- com.mi.globalbrowser
- com.mi.globalminusscreen
- com.miHoYo.GenshinImpact
- com.microsoft.appmanager
- com.microsoft.deviceintegrationservice
- com.microsoftsdk.crossdeviceservicebroker
- com.mihoyo.hoyolab
- com.miui.accessibility
- com.miui.analytics
- com.miui.android.fashiongallery
- com.miui.backup
- com.miui.cit
- com.miui.cleaner
- com.miui.cloudservice
- com.miui.core
- com.miui.extraphoto
- com.miui.mediaviewer
- com.miui.mishare.connectivity
- com.miui.misightservice
- com.miui.miwallpaper
- com.miui.miwallpaper.overlay
- com.miui.permissioncontroller.overlay
- com.miui.phrase
- com.miui.player
- com.miui.screenshot
- com.miui.securitycore
- com.miui.settings.rro.device.config.overlay
- com.miui.settings.rro.device.hide.statusbar.overlay
- com.miui.settings.rro.device.systemui.overlay
- com.miui.settings.rro.device.type.overlay
- com.miui.system.overlay
- com.miui.systemui.carriers.overlay
- com.miui.thirdappassistant
- com.miui.videoplayer
- com.miui.vsimcore
- com.miui.wallpaper.overlay
- com.miui.weather2
- com.miui.phone.carriers.overlay.h3g
- com.miuix.editor
- com.pinterest
- com.safaricom.mpesa.lifestyle
- com.supercell.clashofclans
- com.supercell.clashroyale
- com.udemy.android
- com.whatsapp
- com.worldcoin
- com.xiaomi.account
- com.xiaomi.aicr
- com.xiaomi.aon
- com.xiaomi.barrage
- com.xiaomi.bluetooth.rro.device.config.overlay
- com.xiaomi.continuity.sdkapp
- com.xiaomi.discover
- com.xiaomi.mi_connect_service
- com.xiaomi.micloud.sdk
- com.xiaomi.mipicks
- com.xiaomi.mirror
- com.xiaomi.misettings
- com.xiaomi.payment
- com.xiaomi.phone
- com.xiaomi.simactivate.service
- com.xiaomi.trustservice
- com.xiaomi.xmsfkeeper
- com.zhiliaoapp.musically
- com.zombodroid.MemeGenerator
- ke.co.equitygroup.equitymobile
- org.mozilla.firefox

## 4. Uninstalled Apps

The following apps were successfully uninstalled during this session:

**Xiaomi Apps:**
- `com.miui.analytics` (Analytics)
- `com.xiaomi.mipicks` (GetApps)
- `com.miui.cleaner` (Cleaner)
- `com.mi.globalbrowser` (Mi Browser)
- `com.miui.player` (Music)
- `com.xiaomi.discover` (Xiaomi Discover)
- `com.miui.videoplayer` (Mi Video)
- `com.xiaomi.payment` (Xiaomi Payment)
- `com.miui.miservice` (Services & feedback)
- `com.miui.bugreport` (Feedback)
- `com.miui.msa.global` (msa)
- `com.mi.appfinder` (App finder)
- `com.mi.globalminusscreen` (App vault)
- `com.miui.daemon` (System Daemon)
- `com.miui.yellowpage` (Yellow pages)
- `com.miui.gallery` (Xiaomi Gallery)
- `com.miui.android.fashiongallery` (Fashion Gallery / Wallpaper Carousel)
- `com.xiaomi.glgm` (Game Center)
- `com.duokan.phone.remotecontroller` (Mi Remote)

**Google / Android Apps:**
- `com.google.android.adservices.api` (Ad privacy)
- `com.google.mainline.adservices` (Ad privacy)
- `com.android.inputsettings.overlay.miui` (Input Settings overlay)
- `android.autoinstalls.config.Xiaomi.model` (PlayAutoInstalls)
- `com.google.android.videos` (Google TV)
- `com.google.android.apps.tachyon` (Google Meet)
- `com.google.android.apps.subscriptions.red` (Google One)
- `com.google.android.apps.messaging` (Google Messages / SMS)
- `com.google.android.youtube` (YouTube)
- `com.google.android.apps.youtube.music` (YouTube Music)
- `com.google.android.apps.safetyhub` (Personal Safety)

**Other Services:**
- `com.tencent.soter.soterserver` (SoterService)
