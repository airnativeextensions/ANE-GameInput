/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * https://distriqt.com
 *
 * @author 		Michael Archbold (https://github.com/marchbold)
 * @created		20/08/2024
 * @copyright	https://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.gameinput
{
	import com.distriqt.extension.gameinput.GameInput;
	import com.distriqt.extension.gameinput.InputAction;
	import com.distriqt.extension.gameinput.InputControls;
	import com.distriqt.extension.gameinput.InputGroup;
	import com.distriqt.extension.gameinput.InputIdentifier;
	import com.distriqt.extension.gameinput.InputMap;
	import com.distriqt.extension.gameinput.MouseSettings;
	import com.distriqt.extension.gameinput.RemappingOption;
	import com.distriqt.extension.gameinput.events.GameInputEvent;

	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**	
	 */
	public class GameInputTests extends Sprite
	{
		public static const TAG : String = "";
		
		private var _l : ILogger;
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function GameInputTests( logger:ILogger )
		{
			_l = logger;
			try
			{
				log( "GameInput Supported: " + GameInput.isSupported );
				if (GameInput.isSupported)
				{
					log( "GameInput Version:   " + GameInput.service.version );

					GameInput.service.addEventListener( GameInputEvent.INPUT_MAP_CHANGED, inputMapChangedHandler );

				}
				
			}
			catch (e:Error)
			{
				trace( e );
			}
		}
		
		
		////////////////////////////////////////////////////////
		//  
		//
		private var IDS:Object = {
			DRIVE: 1,
			MOVE: 2,
			TURBO: 3,
			ADD_WAYPOINT: 4,

			GROUP_GAME: 10,

			MAP: 100
		}
		
		public function setInputMap():void
		{
			var driveInputAction:InputAction = InputAction.create(
					"Drive",
					InputIdentifier.fromId( IDS.DRIVE ),
					InputControls.create( [ Keyboard.SPACE ], [] ),
					RemappingOption.REMAP_OPTION_ENABLED
			);

			var mouseInputAction:InputAction = InputAction.create(
					"Move",
					InputIdentifier.fromId( IDS.MOVE ),
					InputControls.create( [], [ InputControls.MOUSE_LEFT_CLICK ] ),
					RemappingOption.REMAP_OPTION_DISABLED
			);

			var turboInputAction:InputAction = InputAction.create(
					"Turbo",
					InputIdentifier.fromId( IDS.TURBO ),
					InputControls.create( [ Keyboard.SHIFT, Keyboard.SPACE ], [] ),
					RemappingOption.REMAP_OPTION_ENABLED
			);

			var addWaypointAction:InputAction = InputAction.create(
					"Add waypoint",
					InputIdentifier.fromId( IDS.ADD_WAYPOINT ),
					InputControls.create( [ Keyboard.TAB ], [ InputControls.MOUSE_RIGHT_CLICK ] ),
					RemappingOption.REMAP_OPTION_DISABLED
			);

			var gameInputGroup:InputGroup = InputGroup.create(
					"Game controls",
					[
						driveInputAction,
						mouseInputAction,
						turboInputAction,
						addWaypointAction
					],
					InputIdentifier.fromId( IDS.GROUP_GAME ),
					RemappingOption.REMAP_OPTION_ENABLED
			);


			var inputMap:InputMap = InputMap.create(
					[
						gameInputGroup
					],
					new MouseSettings()
							.setInvertMouseMovement( true ),
					InputIdentifier.fromId( IDS.MAP ),
					RemappingOption.REMAP_OPTION_ENABLED,
					[
						InputControls.create( [ Keyboard.ESCAPE ], [] )
					]
			);

			GameInput.instance.setInputMap( inputMap );
			
		}


		private function inputMapChangedHandler( event:GameInputEvent ):void
		{

			log( "inputMapChangedHandler" );

			var group:InputGroup = event.inputMap.inputGroups[0];
			var drive:InputAction = group.inputActions[0];

			log( drive.inputControls.keycodes[0] +"->" + drive.remappedInputControls.keycodes[0]);
		}

	}
}
