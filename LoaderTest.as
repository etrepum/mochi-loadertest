/* Copyright 2011 Mochi Media, Inc. */

package {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import flash.system.*;

    public class LoaderTest extends Sprite {
        private var url:String = loaderInfo.parameters["url"];
        private var method:String = loaderInfo.parameters["method"];

        private var loader:Loader = new Loader();
        private var bytesLoader:URLLoader = new URLLoader();

        public function LoaderTest() {
            trace("[LoaderTest] started");

            Security.allowInsecureDomain("*");

            bytesLoader.dataFormat = URLLoaderDataFormat.BINARY;
            if (method == "load")
                doLoad();
            else if (method == "loadBytes")
                doLoadBytes();
            else {
                trace("[LoaderTest] unknown method '" + method + "'; "
                      + "defaulting to 'load'");
                doLoad();
            }
            addChild(loader);
        }

        private function doLoad():void {
            trace("[LoaderTest] doLoad called");
            loader.contentLoaderInfo.addEventListener(Event.INIT, onInit);
            loader.load(new URLRequest(url));
        }

        private function doLoadBytes():void {
            trace("[LoaderTest] doLoadBytes called");
            setupProgressBar();
            bytesLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
            bytesLoader.addEventListener(Event.COMPLETE, onComplete);
            bytesLoader.load(new URLRequest(url));
        }

        private function onProgress(ev:ProgressEvent):void {
            trace("[LoaderTest] onProgress called");
            innerBar.scaleX = ev.bytesLoaded / ev.bytesTotal;
        }

        private function onComplete(ev:Event):void {
            trace("[LoaderTest] onComplete called");
            progressBar.visible = false;
            loader.contentLoaderInfo.addEventListener(Event.INIT, onInit);
            loader.loadBytes(bytesLoader.data);
        }

        private function onInit(ev:Event):void {
            trace("[LoaderTest] onInit called");
            try {
                var rect:Shape = new Shape();
                var g:Graphics = rect.graphics;
                g.beginFill(0xFFFFFF);
                g.drawRect(0, 0, loader.contentLoaderInfo.width, loader.contentLoaderInfo.height);
                g.endFill();
                loader.mask = rect;
            } catch (error:Error) {
                trace("[LoaderTest] couldn't set SWF mask");
            }

            try {
                stage.frameRate = loader.contentLoaderInfo.frameRate;
            } catch (error:Error) {
                trace("[LoaderTest] couldn't adjust stage frame rate");
            }
        }

        private var progressBar:Sprite;
        private var innerBar:Shape;

        private function setupProgressBar():void {
            var outerBar:Shape;
            var hilight:Shape;
            var g:Graphics;

            var w:uint = 800;
            var h:uint = 600;
            var padX:uint = 50;
            var barHeight:uint = 10;

            outerBar = new Shape();
            g = outerBar.graphics;
            g.beginFill(0xE6B873);
            g.drawRect(0, 0, w - 2 * padX, barHeight);
            g.endFill();

            innerBar = new Shape();
            g = innerBar.graphics;
            g.beginFill(0x806640);
            g.drawRect(0, 0, w - 2 * padX, barHeight);
            g.endFill();

            hilight = new Shape();
            g = hilight.graphics;
            g.lineStyle(0, 0xBF8630);
            g.drawRect(0, 0, w - 2 * padX, barHeight);

            progressBar = new Sprite();
            progressBar.addChild(outerBar);
            progressBar.addChild(innerBar);
            progressBar.addChild(hilight);

            innerBar.scaleX = 0;

            progressBar.x = padX;
            progressBar.y = (h - barHeight) / 2;
            addChild(progressBar);
        }
    }
}
