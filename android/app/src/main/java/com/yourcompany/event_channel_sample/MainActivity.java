package com.yourcompany.event_channel_sample;

import android.util.Log;

import androidx.annotation.NonNull;

import java.util.concurrent.TimeUnit;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;

public class MainActivity extends FlutterActivity {
    public static final String TAG = "eventchannelsample";
    public static final String STREAM = "com.yourcompany.eventchannelsample/stream";

    private Disposable timerSubscription;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, EventChannel.EventSink events) {
                        Log.w(TAG, "adding listener");
                        timerSubscription = Observable
                                .interval(0, 1, TimeUnit.SECONDS)
                                .observeOn(AndroidSchedulers.mainThread())
                                .subscribe(
                                        (Long timer) -> {
                                            Log.w(TAG, "emitting timer event " + timer);
                                            events.success(timer);
                                        },
                                        (Throwable error) -> {
                                            Log.e(TAG, "error in emitting timer", error);
                                            events.error("STREAM", "Error in processing observable", error.getMessage());
                                        },
                                        () -> Log.w(TAG, "closing the timer observable")
                                );
                    }

                    @Override
                    public void onCancel(Object args) {
                        Log.w(TAG, "cancelling listener");
                        if (timerSubscription != null) {
                            timerSubscription.dispose();
                            timerSubscription = null;
                        }
                    }
                }
        );
    }
}
