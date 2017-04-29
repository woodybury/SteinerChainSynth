package geometry
{
	import geometry.atoms.Circle;

	/**
	 * Constructs a Steiner Chain
	 * 
	 * References
	 * http://mathworld.wolfram.com/SteinerChain.html
	 * http://en.wikipedia.org/wiki/Steiner_chain
	 * 
	 * Recursive Steiner Chains
	 * http://www.flickr.com/photos/quasimondo/2469992061/
	 * 
	 * @author Andre Michelle
	 */
	public final class SteinerChain
	{
		private const ERROR_EDIT_MODE: Error = new Error( 'SteinerChain is currently in editMode and cannot be processed.' );
		
		private var _numCircles: int;
		private var _radius: Number;
		private var _xOffset: Number;
		private var _yOffset: Number;
		private var _angle: Number;
		
		private var _editMode: Boolean;
		
		private var _a: Number;
		private var _b: Number;
		private var _c: Number;
		private var _d: Number;

		/**
		 * @param n The number of circles inside the steiner chain (MIN:3)
		 * @param radius The radius of the outer circle
		 * @param xRatio The x-offset of the inner circle refering to the center of the outer circle
		 * @param yRatio The y-offset of the inner circle refering to the center of the outer circle
		 * @param angle The angle of the steiner chain
		 */
		public function SteinerChain( numCircles: int, radius: Number, xRatio: Number = 0.0, yRatio: Number = 0.0, angle: Number = 0.0 )
		{
			if( 3 > numCircles )
				numCircles = 3;
			
			_numCircles = numCircles;
			_radius = radius;
			_xOffset = xRatio;
			_yOffset = yRatio;
			_angle = angle;

			updateABC();
		}
		
		/**
		 * Sets the circle properties to match the outer circle
		 * 
		 * @param circle The Circle object to override its properties
		 */
		public function setCircleOuter( circle: Circle ): void
		{
			if( _editMode )
				throw ERROR_EDIT_MODE;
			
			circle.x =
			circle.y = 0.0;
			circle.r = _radius;
		}

		/**
		 * Sets the circle properties to match the inner circle
		 * 
		 * @param circle The Circle object to override its properties
		 */
		public function setCircleInner( circle: Circle ): void
		{
			if( _editMode )
				throw ERROR_EDIT_MODE;

			circle.x = _xOffset;
			circle.y = _yOffset;
			circle.r = _a + _c * 2.0;

			inverseCircle( circle );
		}

		/**
		 * Sets the circle properties to match one of the steiner chain circles
		 * 
		 * @param circle The Circle object to override its properties
		 * @param index The index of the steiner chain circle
		 */
		public function setCircleByIndex( circle: Circle, index: int ): void
		{
			if( _editMode )
				throw ERROR_EDIT_MODE;

			const phase: Number = index * _b * 2.0 + _angle;
			
			circle.x = _xOffset + _d * Math.cos( phase );
			circle.y = _yOffset + _d * Math.sin( phase );
			circle.r = _c;
			
			inverseCircle( circle );
		}

		/**
		 * @return The number of circles in the steiner chain
		 */
		public function get numCircles(): int
		{
			return _numCircles;
		}

		/**
		 * @param value Sets the number of circles in the steiner chain
		 */
		public function set numCircles( value: int ): void
		{
			if( 3 > value )
				value = 3;
				
			if( _numCircles != value )
			{
				_numCircles = value;
				
				if( !_editMode )
					updateABC();
			}
		}

		/**
		 * @return The radius of the outer circle
		 */
		public function get radius(): Number
		{
			return _radius;
		}

		/**
		 * @param value Sets the radius of the outer circle
		 */
		public function set radius( value: Number ): void
		{
			if( _radius != value )
			{
				_radius = value;
			}
		}

		/**
		 * @returns The x-offset of the inner circle refering to the center of the outer circle
		 */
		public function get xOffset(): Number
		{
			return _xOffset;
		}

		/**
		 * @param value Sets the x-offset of the inner circle refering to the center of the outer circle
		 */
		public function set xOffset( value: Number ): void
		{
			if( _xOffset != value )
			{
				_xOffset = value;
				
				if( !_editMode )
					updateABC();
			}
		}

		/**
		 * @returns The y-offset of the inner circle refering to the center of the outer circle
		 */
		public function get yOffset(): Number
		{
			return _yOffset;
		}

		/**
		 * @param value Sets the y-offset of the inner circle refering to the center of the outer circle
		 */
		public function set yOffset( value: Number ): void
		{
			if( _yOffset != value )
			{
				_yOffset = value;
				
				if( !_editMode )
					updateABC();
			}
		}

		/**
		 * @return The angle of the steiner chain
		 */
		public function get angle(): Number
		{
			return _angle;
		}

		/**
		 * @param value Sets the angle of the steiner chain
		 */
		public function set angle( value: Number ): void
		{
			if( _angle != value )
			{
				_angle = value;
			}
		}

		/**
		 * @return True, if SteinerChain is in editMode
		 */
		public function get editMode(): Boolean
		{
			return _editMode;
		}

		/**
		 * @param value When editMode is true, no updates will be processed while setting values
		 */
		public function set editMode( value: Boolean ): void
		{
			if( _editMode != value )
			{
				_editMode = value;
				
				if( !_editMode )
					updateABC();
			}
		}
		
		private function updateABC(): void
		{
			_a = ( Math.sqrt( ( 4.0 * _yOffset * _yOffset + 4.0 * _xOffset * _xOffset + 1.0 ) ) + 1.0 ) * 0.5;
			_b = Math.PI / _numCircles;

			const sin_b: Number = Math.sin( _b );

			_c = _a * sin_b / ( 1.0 - sin_b );
			_d = _a + _c;
		}
		
		private function inverseCircle( circle: Circle ): void
		{
			var cx: Number = circle.x;
			var cy: Number = circle.y;
			var cr: Number = circle.r;
			
			var ci: Number = 1.0 / ( cx * cx + cy * cy - cr * cr );
			
			circle.x = ( cx * ci + _xOffset / _a ) * _radius;
			circle.y = ( cy * ci + _yOffset / _a ) * _radius;
			circle.r = cr * ci * _radius;
		}
	}
}
