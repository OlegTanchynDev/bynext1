package com.bynext.bynextcourier

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterMain
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
import io.flutter.plugins.packageinfo.PackageInfoPlugin
import rekab.app.background_locator.LocatorService

class ByNextApp : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        LocatorService.setPluginRegistrant(this)
        FlutterMain.startInitialization(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        if (!registry!!.hasPlugin("io.flutter.plugins.sharedpreferences")) {
            SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences"))
        }
        if (!registry.hasPlugin("io.flutter.plugins.packageinfo")) {
            PackageInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.packageinfo"))
        }
    }
}