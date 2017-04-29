// as package for analogous circle synth //
package
{
	import geometry.SteinerChain;
	import geometry.atoms.Circle;
									/*SteinerChain geometry by Andre Michelle*/
	import flash.media.Sound;
	import flash.events.SampleDataEvent;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.events.IOErrorEvent;
																	//sound elements//
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;


	[SWF(backgroundColor="#121212", frameRate="50", width="600", height="600")]
																// my canvas properties //

	public final class synth extends Sprite
	{
		private const circle: Circle = new Circle();
		private const chain: SteinerChain = new SteinerChain( 7, 240.0 );
		private const canvas: Shape = new Shape();
		private var speed: Number = 0.0;
																//circle variables defined //

		public function synth()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			canvas.blendMode = BlendMode.ADD;
			addChild( canvas );

			stage.addEventListener( Event.ENTER_FRAME, enterFrame );
			stage.addEventListener( Event.RESIZE, resize );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
																			//stage events //
			enterFrame( null );
			resize( null );

			var position:int = 0;
			var sound:Sound = new Sound();
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
																					// sound events //

            var channel:SoundChannel;
																							// sound channel //
            var transform:SoundTransform = new SoundTransform((circle.y * .1), ((circle.x)-1) );
																			// sound transforms- volume and pan //

            channel = sound.play();
            channel.soundTransform = transform;
																// sound play and transform //

			function onSampleData(event:SampleDataEvent):void
			{
			for(var i:int = 0; i < 8192; i++)
			{
			var phase:Number = position  / 44100 * Math.PI * 2;
			position ++;
			var sample:Number = Math.sin(phase * circle.r * speed * 50);
																			// phase and sine wave generation //

			event.data.writeFloat(sample); // left //
			event.data.writeFloat(sample); // right //
			}
			}
		}


		private function enterFrame( event: Event ): void
		{
			chain.editMode = true;
			chain.xOffset = canvas.mouseX * 0.01;
			chain.yOffset = canvas.mouseY * 0.01;
			chain.angle += speed;
			chain.editMode = false;
															// make canvas and track mouse //
			const g: Graphics = canvas.graphics;

			g.clear();

			g.beginFill( 0xB400FF );
			chain.setCircleOuter( circle );
			g.drawCircle( circle.x, circle.y, circle.r );
			g.endFill();
																// circles background //

			g.beginFill( 0x3CFFFF );
			chain.setCircleInner( circle );
			g.drawCircle( circle.x, circle.y, circle.r );
			g.endFill();
																	// traking circle //

			var i: int = 0;
			var n: int = chain.numCircles;

			for( ; i < n ; ++i )
			{
				g.beginFill( 0x0000FF );
				chain.setCircleByIndex( circle, i );
				g.drawCircle( circle.x, circle.y, circle.r );
				g.endFill();
																	// added circles //
			}
		}

		private function keyDown( event: KeyboardEvent ): void
		{
			if( event.keyCode == Keyboard.UP )
				chain.numCircles++;
			else
			if( event.keyCode == Keyboard.DOWN )
				chain.numCircles--;
															// arrow controls- # of added circles & frequency //

			if( event.keyCode == Keyboard.LEFT )
				speed += 0.01;
			else
			if( event.keyCode == Keyboard.RIGHT )
				speed -= 0.01;
															// arrow controls- circle speed & sequencing //


			if( speed > 0.2 )
				speed = 0.2;
			else
			if( speed < -0.2 )
				speed = -0.2;
												// speed caps //
		}

		private function resize( event: Event ): void
		{
			const w: Number = stage.stageWidth;
			const h: Number = stage.stageHeight;

			canvas.x = w * 0.5;
			canvas.y = h * 0.5;

			chain.radius = Math.min( w, h ) * 0.4;
															// resize proportions //
		}
	}
}
