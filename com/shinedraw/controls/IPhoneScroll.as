/****************************************************************************

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

-- A iPhone Scroll in AS3
-- Copyright 2009 Terence Tsang
-- admin@shinedraw.com
-- http://www.shinedraw.com
-- Your Flash vs Silverlight Repository

----------------------------------------------------------------------

-- Naftali: http://naftali.com.br --

This class was modified by Naftali to attend his needs in a 
project.

All the movement and core algorithms were not modified.
Below is a list of modifications I did.

08-25-2010:
	* Changed the extends from MovieClip to none
	* Removed myCanvas and added the listeners directly to the content
	* Created the release method to remove the listeners and the pointer to the movieclip
	* Added the stage property, which come as a parameter in the constructor
	* Changed _myScrollElement to be a DisplayObjectContainer, instead of a MovieClip
	* _canvasHeight receives the Height from the movieclip
	* Added the "canvasHeight" property for when that needs to be changed
	* Changed BOUNCING_SPRINGNESS from 0.08 to 0.2
	* Added percPosition property to make it easy to create a ScrollBar outside of this class
	* Added the "stop" property so that this item can be controlled outside without interfering with this process
	* created a property for "myScrollItem"

****************************************************************************/


package com.shinedraw.controls {
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.display.MovieClip;

	public class IPhoneScroll {

        // Constant variables
        private static var DECAY:Number = 0.4;
        private static var MOUSE_DOWN_DECAY:Number = 0.5;
        private static var SPEED_SPRINGNESS:Number = 0.4;
        private static var BOUNCING_SPRINGESS:Number = 0.2;

		// variables
        private var _mouseDown:Boolean = false;
        private var _velocity:Number = 0;
        private var _mouseDownY:Number = 0;
        private var _mouseDownPoint:Point = new Point();
        private var _lastMouseDownPoint:Point = new Point();
        		
        // elements
        private var _canvasHeight:Number = 0;
		private var _myScrollElement:DisplayObjectContainer;
		private var _stage:Stage;
		private var _started:Boolean;
		
		
		public var tHeight:Number;
		
		public function IPhoneScroll( pContent:DisplayObjectContainer, pStage:Stage, th:Number) {
			tHeight = th;
			_stage = pStage;
			_myScrollElement = pContent;
			
			_canvasHeight = _myScrollElement.height;
			
			start();
			
			// add handlers
			_myScrollElement.addEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down);
			_myScrollElement.addEventListener(Event.ENTER_FRAME, on_enter_frame);
			//_myScrollElement.y = 500;
		}
		
		private function on_enter_frame(e:Event):void {
			if ( started )
			{
				// decay the velocity
				if(_mouseDown) _velocity *= MOUSE_DOWN_DECAY;
				else _velocity *= DECAY;
				
				
				// if not mouse down, then move the element with the velocity
				if (!_mouseDown)
				{
					var textHeight:Number = tHeight;
					
					var y:Number = _myScrollElement.y;
					var bouncing:Number = 0;
					
					// calculate a bouncing when the text moves over the canvas size
					if (y > 0 || textHeight <= _canvasHeight) // textHeight <= _canvasHeight => when the item is smaller than the stage.height, align to the top
					{
						bouncing = -y * BOUNCING_SPRINGESS;
					}else if( y + textHeight < _canvasHeight){
						bouncing = (_canvasHeight - textHeight - y) * BOUNCING_SPRINGESS;
					}
					
					_myScrollElement.y = y + _velocity + bouncing;
				}
			}
		}
		
		// when mouse button up
        private function on_mouse_down(e:MouseEvent):void
        {
            if (!_mouseDown)
            {
                // get some initial properties
                _mouseDownPoint = new Point(e.stageX, e.stageY);
                _lastMouseDownPoint = new Point(e.stageX, e.stageY);
                _mouseDown = true;
                _mouseDownY = _myScrollElement.y;

				// add some more mouse handlers
                _stage.addEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
                _stage.addEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
            }
        }

        // when mouse is moving
        private function  on_mouse_move(e:MouseEvent):void
        {
            if (_mouseDown)
            {
                // update the element position
                var point:Point = new Point(e.stageX, e.stageY);
                _myScrollElement.y = _mouseDownY + (point.y - _mouseDownPoint.y);

                // update the velocity
                _velocity += ((point.y - _lastMouseDownPoint.y) * SPEED_SPRINGNESS);
                _lastMouseDownPoint = point;
            }
        }

        // clear everythign when mouse up
        private function  on_mouse_up(e:MouseEvent):void
        {
            if (_mouseDown)
            {
                _mouseDown = false;
                _stage.removeEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
                _stage.removeEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
            }
        }
		
		public function release():void
		{
			_myScrollElement.removeEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down);
			_myScrollElement.removeEventListener(Event.ENTER_FRAME, on_enter_frame);
			
			_myScrollElement = null;
		}
		
		public function start():void
		{
			_started = true;
		}
		
		public function stop():void
		{
			_started 	= false;
			_velocity 	= 0;
		}
		
		public function set canvasHeight( pVal:Number ):void
		{
			_canvasHeight = pVal;
		}
		
		public function get canvasHeight():Number
		{
			return _canvasHeight;
		}
		
		public function get percPosition():Number
		{
			var finalPos:Number 	= _canvasHeight - _myScrollElement.height;
			var currentPos:Number 	= _myScrollElement.y;
			
			return currentPos / finalPos;
		}
		
		public function get started():Boolean { return _started; }
		
		public function set started(value:Boolean):void 
		{
			if ( value ) 	start();
			else			stop();
		}
		
		public function get myScrollElement():DisplayObjectContainer { return _myScrollElement; }
	}
}