package com.example.xengine;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import com.momo.xeengine.XE3DEngine;
import com.momo.xeengine.game.XEGameView;
import com.momo.xeengine.game.XEGameViewCallback;
import com.momo.xeengine.script.ScriptBridge;

public class GameActivity extends AppCompatActivity implements XEGameViewCallback {

    private static final int REQUEST_EXTERNAL_STORAGE = 1;
    private static String[] PERMISSIONS_STORAGE = {
            "android.permission.READ_EXTERNAL_STORAGE",
            "android.permission.WRITE_EXTERNAL_STORAGE"};


    public static void verifyStoragePermissions(Activity activity) {

        try {
            //检测是否有写的权限
            int permission = ActivityCompat.checkSelfPermission(activity,
                    "android.permission.WRITE_EXTERNAL_STORAGE");
            if (permission != PackageManager.PERMISSION_GRANTED) {
                // 没有写的权限，去申请写的权限，会弹出对话框
                ActivityCompat.requestPermissions(activity, PERMISSIONS_STORAGE, REQUEST_EXTERNAL_STORAGE);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private XEGameView gameView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_game);
        verifyStoragePermissions(this);
        XE3DEngine.setApplicationContext(this);
        gameView = findViewById(R.id.gameView);
        gameView.setCallback(this);
        gameView.startGame();
    }

    //渲染视图创建回调
    @Override
    public void onRenderViewCreate(View view) {
        GLSurfaceView renderView = (GLSurfaceView) view;
        //do something if needed
    }

    //引擎启动回调
    @Override
    public void onStart(XE3DEngine engine) {
        engine.getLogger().setLogEnable(true);
        engine.addLibraryPath("/sdcard/demo");
        engine.getScriptBridge().regist(this, "GameHandler");
        engine.getScriptEngine().startGameScriptFile("app");
    }

    //引擎启动失败回调
    //可能导致引擎启动失败的原因：
    //1. 引擎启动前没有设置全局的上下文对象
    //2. 如果有so打包时排出，改为运行时下载的场景。可能为so下载失败。或so版本与客户端不匹配
    @Override
    public void onStartFailed(String errorMsg) {
        Toast.makeText(this, "引擎启动失败 " + errorMsg, Toast.LENGTH_LONG).show();
        finish();

    }

    //渲染尺寸改变回调
    @Override
    public void onRenderSizeChaged(int width, int height) {

    }

    //引擎so下载进度，仅针对陌陌客户端
    @Override
    public void onEngineDynamicLinkLibraryDownloadProcess(int percent, double speed) {

    }

    //同步Bridge方法
    public String onGameOver(String arg) {
        runOnUiThread(() -> {

            AlertDialog alert = new AlertDialog.Builder(GameActivity.this).create();
            alert.setTitle("游戏结束");
            alert.setMessage(arg);

            //添加"确定"按钮
            alert.setButton(DialogInterface.BUTTON_POSITIVE, "是的", (arg0, arg1) -> finish());
            alert.show();
        });
        return null;
    }

    //异步Bridge方法
    public void func2(String arg, ScriptBridge.Callback callback) {
        callback.call("Java异步回调");
    }
}