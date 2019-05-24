package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.javih.add2calendar.Add2CalendarPlugin;
import io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin;
import net.goderbauer.flutter.contactpicker.ContactPickerPlugin;
import io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin;
import io.flutter.plugins.firebaseauth.FirebaseAuthPlugin;
import io.flutter.plugins.firebase.core.FirebaseCorePlugin;
import io.flutter.plugins.firebasedynamiclinks.FirebaseDynamicLinksPlugin;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import io.flutter.plugins.firebase.storage.FirebaseStoragePlugin;
import com.roughike.facebooklogin.facebooklogin.FacebookLoginPlugin;
import com.example.flutterimagecompress.FlutterImageCompressPlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import com.appleeducate.fluttersms.FlutterSmsPlugin;
import com.roughike.fluttertwitterlogin.fluttertwitterlogin.TwitterLoginPlugin;
import com.aloisdeniel.geocoder.GeocoderPlugin;
import com.noeatsleepdev.geoflutterfire.GeoflutterfirePlugin;
import vn.hunghd.flutter.plugins.imagecropper.ImageCropperPlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import com.lyokone.location.LocationPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.flutter.plugins.share.SharePlugin;
import com.tekartik.sqflite.SqflitePlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    Add2CalendarPlugin.registerWith(registry.registrarFor("com.javih.add2calendar.Add2CalendarPlugin"));
    CloudFirestorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin"));
    ContactPickerPlugin.registerWith(registry.registrarFor("net.goderbauer.flutter.contactpicker.ContactPickerPlugin"));
    FirebaseAdMobPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin"));
    FirebaseAuthPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebaseauth.FirebaseAuthPlugin"));
    FirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FirebaseCorePlugin"));
    FirebaseDynamicLinksPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasedynamiclinks.FirebaseDynamicLinksPlugin"));
    FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    FirebaseStoragePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.storage.FirebaseStoragePlugin"));
    FacebookLoginPlugin.registerWith(registry.registrarFor("com.roughike.facebooklogin.facebooklogin.FacebookLoginPlugin"));
    FlutterImageCompressPlugin.registerWith(registry.registrarFor("com.example.flutterimagecompress.FlutterImageCompressPlugin"));
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    FlutterSmsPlugin.registerWith(registry.registrarFor("com.appleeducate.fluttersms.FlutterSmsPlugin"));
    TwitterLoginPlugin.registerWith(registry.registrarFor("com.roughike.fluttertwitterlogin.fluttertwitterlogin.TwitterLoginPlugin"));
    GeocoderPlugin.registerWith(registry.registrarFor("com.aloisdeniel.geocoder.GeocoderPlugin"));
    GeoflutterfirePlugin.registerWith(registry.registrarFor("com.noeatsleepdev.geoflutterfire.GeoflutterfirePlugin"));
    ImageCropperPlugin.registerWith(registry.registrarFor("vn.hunghd.flutter.plugins.imagecropper.ImageCropperPlugin"));
    ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"));
    LocationPlugin.registerWith(registry.registrarFor("com.lyokone.location.LocationPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    SharePlugin.registerWith(registry.registrarFor("io.flutter.plugins.share.SharePlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
