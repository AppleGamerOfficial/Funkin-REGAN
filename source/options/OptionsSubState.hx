package options;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class OptionsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String>;
	var grpOptions:FlxTypedGroup<Alphabet>;

	var curSelected:Int = 0;

	#if mobile
	final DIST_BEETWEN_ITEMS = 0.8;
	#end

	public var parent:OptionsState;

	public function new(parent:OptionsState, items:Array<String>)
	{
		super();

		this.parent=parent;
		this.textMenuItems=items;

		createItems();
		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var accept:Bool=controls.ACCEPT;

		#if mobile
		for (item in grpOptions.members)
			for(touch in FlxG.touches.list){
				if(touch.overlaps(item)&&touch.justPressed){
					curSelected=item.ID;
					changeSelection();
					accept=true;
				}
			}
		#end

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (accept)
		{
			onSelect(textMenuItems[curSelected],curSelected);
		}
	}
	
	function changeSelection(change:Int = 0)
	{
	
		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	
		curSelected += change;
	
		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
		if (curSelected >= textMenuItems.length)
			curSelected = 0;
	
		// selector.y = (70 * curSelected) + 30;
	
		var bullShit:Int = 0;

		#if !mobile
		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));
	
			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		#end
	}
	function toggleOption(num:Int=0,text:String="",oldVal:Bool=false,on:String='on',off:String='off'):Bool{
		var oldAlphabet=grpOptions.members[num];

		var newVal=!oldVal;
		
		textMenuItems[num]=text + (newVal ? on : off);
			
		var alphabet:Alphabet = new Alphabet(0, 0, textMenuItems[num], true, false);
		alphabet.ID = num;
		alphabet.isMenuItem = true;

		alphabet.x=oldAlphabet.x;
		alphabet.y=oldAlphabet.y;
		alphabet.targetY=oldAlphabet.targetY;

		grpOptions.replace(oldAlphabet,alphabet);

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		return newVal;
	}
	function onSelect(value:String="",number:Int=0) {}
	override function onBack() {
		parent.onBack();
		close();
	}
	function createItems() {
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, (105 * i)+30, textMenuItems[i], true, false);
			optionText.ID = i;
			optionText.isMenuItem = true;
			#if mobile
			optionText.targetY=(i-(textMenuItems.length/2))*DIST_BEETWEN_ITEMS;
			#end

			grpOptions.add(optionText);
		}
	}
}
