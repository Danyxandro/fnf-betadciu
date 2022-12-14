package;

import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;

import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import ui.FlxUIDropDownMenuCustom;
import flixel.addons.ui.FlxUIInputText;
import ui.FlxCustomStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;

using StringTools;

class HealthValueMenu extends FlxSubState
{
    private var UI_box:FlxUITabMenu;
    private var blackBox:FlxSprite;
    private var stepperMap:Map<String,Map<String,FlxCustomStepper>>;
	override function create()
	{	
        var tabs = [
			{name: "Easy", label: 'Easy'},
			{name: "Normal", label: 'Normal'},
			{name: "Hard", label: 'Hard'}
		];
        stepperMap = [
            "Easy" => new Map<String,FlxCustomStepper>(),
            "Normal" => new Map<String,FlxCustomStepper>(),
            "Hard" => new Map<String,FlxCustomStepper>()
        ];

        FlxG.mouse.visible = true;

        blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);

        UI_box = new FlxUITabMenu(null, tabs, true);
        UI_box.resize(1000, 900);
		UI_box.x = 140;
		UI_box.y = 20;

        var datos = cast Json.parse( Assets.getText( Paths.json('offsets') ).trim() );
        var posiciones = datos.menuPos;

        for (i in 0...3){
            var texto:String = "Normal";
            switch(i){
                case 0: texto = "Easy";
                case 1: texto = "Hard";
            }
            var tab_group = new FlxUI(null, UI_box);
            tab_group.name = texto;

            var normalNoteLabel:FlxText = new FlxText(210,15,-1,'Normal notes',16);
            var label0:FlxText = new FlxText(370,40,-1, "Shit      Bad    Good    Sick    Miss Miss(LN)",16);
            var normalNote:FlxSprite = new FlxSprite();
            normalNote.frames = Paths.getSparrowAtlas('NOTE_assets',"shared");
            normalNote.animation.addByPrefix('greenScroll', 'green0');
            normalNote.animation.play("greenScroll");
            normalNote.setGraphicSize(Std.int(normalNote.width * 0.4));
            normalNote.updateHitbox();
            normalNote.x = 240;
            normalNote.y = 45;
            for(j in 0...6){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                }
                var stepper:FlxCustomStepper = new FlxCustomStepper(365 + j * 67,65, 0.01, FlxG.save.data.healthValues.get("0").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "0", stepper);
                tab_group.add(stepper);
            }
            
            var trickyNoteLabel:FlxText = new FlxText(210,110,-1,'Tricky notes',16);
            var label1:FlxText = new FlxText(370, 140,-1, "Shit      Bad    Good    Sick    Miss Miss(LN)",16);
            var trickyNote:FlxSprite = new FlxSprite();
            trickyNote.frames = Paths.getSparrowAtlas('specialNotes/NOTE_fire',"shared");
            trickyNote.animation.addByPrefix('greenScroll', 'green fire0');
            trickyNote.animation.play("greenScroll");
            trickyNote.setGraphicSize(Std.int(trickyNote.width * 0.3));
            trickyNote.updateHitbox();
            trickyNote.x = 230;
            trickyNote.y = 120;
            for(j in 0...6){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                }
                var stepper:FlxCustomStepper = new FlxCustomStepper(365 + j * 67,165, 0.01, FlxG.save.data.healthValues.get("1").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "1", stepper);
                tab_group.add(stepper);
            }

            var blackNoteLabel:FlxText = new FlxText(200, 230,-1,'Damage notes',16);
            var label2:FlxText = new FlxText(370, 260,-1, "Shit      Bad    Good    Sick    Miss Miss(LN)",16);
            var blackNote:FlxSprite = new FlxSprite();
            blackNote.frames = Paths.getSparrowAtlas('specialNotes/NOTE_Black',"shared");
            blackNote.animation.addByPrefix('greenScroll', 'green0');
            blackNote.animation.play("greenScroll");
            blackNote.setGraphicSize(Std.int(blackNote.width * 0.4));
            blackNote.updateHitbox();
            blackNote.x = 240;
            blackNote.y = 260;
            for(j in 0...6){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                }
                var stepper:FlxCustomStepper = new FlxCustomStepper(365 + j * 67,285, 0.01, FlxG.save.data.healthValues.get("2").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "2", stepper);
                tab_group.add(stepper);
            }

            var hurtNoteLabel:FlxText = new FlxText(220, 330,-1,'Hurt notes',16);
            var label3:FlxText = new FlxText(370, 360,-1, "Shit      Bad    Good    Sick    Miss Miss(LN)",16);
            var hurtNote:FlxSprite = new FlxSprite();
            hurtNote.frames = Paths.getSparrowAtlas('specialNotes/HURTNOTE_assets',"shared");
            hurtNote.animation.addByPrefix('greenScroll', 'green0');
            hurtNote.animation.play("greenScroll");
            hurtNote.setGraphicSize(Std.int(hurtNote.width * 1.3));
            hurtNote.updateHitbox();
            hurtNote.x = 240;
            hurtNote.y = 360;
            for(j in 0...6){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                }
                var stepper:FlxCustomStepper = new FlxCustomStepper(365 + j *67,385, 0.01, FlxG.save.data.healthValues.get("3").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "3", stepper);
                tab_group.add(stepper);
            }

            var goldNoteLabel:FlxText = new FlxText(215, 430,-1,'Gold notes',16);
            var label4:FlxText = new FlxText(370, 460,-1, "Shit      Bad    Good    Sick    Miss Miss(LN)",16);
            var goldNote:FlxSprite = new FlxSprite();
            goldNote.frames = Paths.getSparrowAtlas('specialNotes/GoldNote',"shared");
            goldNote.animation.addByPrefix('greenScroll', 'GoldNote green');
            goldNote.animation.play("greenScroll");
            goldNote.setGraphicSize(Std.int(goldNote.width * 1.3));
            goldNote.updateHitbox();
            goldNote.x = 240;
            goldNote.y = 460;
            for(j in 0...6){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                }
                var stepper:FlxCustomStepper = new FlxCustomStepper(365 + j * 67,485, 0.01, FlxG.save.data.healthValues.get("4").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "4", stepper);
                tab_group.add(stepper);
            }

            var warningNoteLabel:FlxText = new FlxText(200, 530,-1,'Warning notes',16);
            var label5:FlxText = new FlxText(370, 560,-1, "Shit      Bad    Good    Sick    Miss Miss(LN)",16);
            var warningNote:FlxSprite = new FlxSprite();
            warningNote.frames = Paths.getSparrowAtlas('specialNotes/Warning',"shared");
            warningNote.animation.addByPrefix('greenScroll', 'Warning warning');
            warningNote.animation.play("greenScroll");
            warningNote.setGraphicSize(Std.int(warningNote.width * 0.45));
            warningNote.updateHitbox();
            warningNote.x = 242;
            warningNote.y = 560;
            for(j in 0...6){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                }
                var stepper:FlxCustomStepper = new FlxCustomStepper(365 + j * 67,585, 0.01, FlxG.save.data.healthValues.get("5").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "5", stepper);
                tab_group.add(stepper);
            }

            var whiteNoteLabel:FlxText = new FlxText(220, 630,-1,'White notes',16);
            var label6:FlxText = new FlxText(370, 660,-1, "Shit      Bad    Good    Sick    Miss Miss(LN)",16);
            var whiteNote:FlxSprite = new FlxSprite();
            whiteNote.frames = Paths.getSparrowAtlas('specialNotes/whiteoutlined',"shared");
            whiteNote.animation.addByPrefix('greenScroll', 'green0');
            whiteNote.animation.play("greenScroll");
            whiteNote.setGraphicSize(Std.int(whiteNote.width * 0.4));
            whiteNote.updateHitbox();
            whiteNote.x = 245;
            whiteNote.y = 660;
            for(j in 0...6){
                var texto2:String = "sick";
                switch(j){
                    case 0: texto2 = "shit";
                    case 1: texto2 = "bad";
                    case 2: texto2 = "good";
                    case 3: texto2 = "sick";
                    case 4: texto2 = "miss";
                    case 5: texto2 = "missLN";
                }
                var stepper:FlxCustomStepper = new FlxCustomStepper(365 + j * 67,685, 0.01, FlxG.save.data.healthValues.get("6").get(texto).get(texto2), -2, 2, 2, 30);
                stepperMap.get(texto).set(texto2 + "6", stepper);
                tab_group.add(stepper);
            }
            var hint:FlxText = new FlxText(-220,300,-1,'Scroll using keys or mouse wheel',28);
            hint.angle -= 90;
            tab_group.add(hint);
            var hint2:FlxText = new FlxText(30,300,-1,'Hold shift for more\nincrease/decrease',16);
            hint2.angle -= 90;
            tab_group.add(hint2);

            var misspressLabel = new FlxText(390, 755,-1,'Miss press',16);
            var stepperMiss:FlxCustomStepper = new FlxCustomStepper(515, 761, 0.005, FlxG.save.data.healthValues.get("missPressed").get(texto), -2, 0, 3, 35, 0.1);
            stepperMap.get(texto).set("missPress",stepperMiss);
            tab_group.add(misspressLabel);
            tab_group.add(stepperMiss);

            tab_group.add(label0);
            tab_group.add(normalNoteLabel);
            tab_group.add(normalNote);

            tab_group.add(label1);
            tab_group.add(trickyNoteLabel);
            tab_group.add(trickyNote);

            tab_group.add(label2);
            tab_group.add(blackNoteLabel);
            tab_group.add(blackNote);

            tab_group.add(label3);
            tab_group.add(hurtNoteLabel);
            tab_group.add(hurtNote);

            tab_group.add(label4);
            tab_group.add(goldNoteLabel);
            tab_group.add(goldNote);

            tab_group.add(label5);
            tab_group.add(warningNoteLabel);
            tab_group.add(warningNote);

            tab_group.add(label6);
            tab_group.add(whiteNoteLabel);
            tab_group.add(whiteNote);

            var reloadBtn:FlxButton = new FlxButton(300,810, "Reset Values", function()
		    {
			    reset();
		    });
            var saveBtn:FlxButton = new FlxButton(600,810, "Save", function()
		    {
			    save();
		    });
            tab_group.add(reloadBtn);
            tab_group.add(saveBtn);

            UI_box.addGroup(tab_group);
        }
        add(UI_box);

        super.create();
	}

	override function update(elapsed:Float)
	{
        if(FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE){
            quit();
        }
        super.update(elapsed);

        if (FlxG.mouse.wheel > 0){
            UI_box.y += 40;
        }
        if (FlxG.mouse.wheel < 0){
            UI_box.y -= 40;
        }
        if (FlxG.keys.pressed.UP)
			UI_box.y += 10;
		if (FlxG.keys.pressed.DOWN)
			UI_box.y -= 10;
        if(UI_box.y < -220)
            UI_box.y = -220;
        if(UI_box.y > 20)
            UI_box.y = 20;
	}

    function save(){
        var texto:String = UI_box.selected_tab_id;
        var map:Map<String,Dynamic>;
        for(key in stepperMap.keys()){
            map = stepperMap.get(texto);
            for(i in 0...7){
                FlxG.save.data.healthValues.get(""+i).get(texto).set("shit", map.get("shit"+i).value);
                FlxG.save.data.healthValues.get(""+i).get(texto).set("bad", map.get("bad"+i).value);
                FlxG.save.data.healthValues.get(""+i).get(texto).set("good", map.get("good"+i).value);
                FlxG.save.data.healthValues.get(""+i).get(texto).set("sick", map.get("sick"+i).value);
                FlxG.save.data.healthValues.get(""+i).get(texto).set("miss", map.get("miss"+i).value);
                FlxG.save.data.healthValues.get(""+i).get(texto).set("missLN", map.get("missLN"+i).value);
            }
            FlxG.save.data.healthValues.get("missPressed").set(texto, map.get("missPress").value);
        }
        FlxG.save.flush();
    }

    function reset(){
        var map:Map<String,Dynamic> = [
			"0" => new Map<String,Dynamic>(),
			"1" => new Map<String,Dynamic>(),
			"2" => new Map<String,Dynamic>(),
			"3" => new Map<String,Dynamic>(),
			"4" => new Map<String,Dynamic>(),
			"5" => new Map<String,Dynamic>(),
			"6" => new Map<String,Dynamic>(),
			"missPressed" => ["Hard" => -0.075, "Easy" => -0.025, "Normal" => -0.05]
		];

		map["0"].set("Hard",["shit"=>-0.1,"bad"=>-0.06,"good"=>0,"sick"=>0.04,"miss"=>-0.15,"missLN"=>-0.05]);
		map["0"].set("Normal",["shit"=>-0.1,"bad"=>-0.06,"good"=>0.03,"sick"=>0.07,"miss"=>-0.15,"missLN"=>-0.05]);
		map["0"].set("Easy",["shit"=>-0.07,"bad"=>-0.03,"good"=>0.03,"sick"=>0.07,"miss"=>-0.1,"missLN"=>-0.03]);
		map["0"].set("score",["shitScore"=>-100,"badScore"=>0,"goodScore"=>200,"sickScore"=>350,"missScore"=>-150,"missLNScore"=>-50]);
		map["0"].set("damage",false);

		map["1"].set("Hard",["shit"=>0,"bad"=>0,"good"=>-2,"sick"=>-2,"miss"=>0,"missLN"=>0]);
		map["1"].set("Normal",["shit"=>0,"bad"=>0,"good"=>-1,"sick"=>-1,"miss"=>0,"missLN"=>0]);
		map["1"].set("Easy",["shit"=>0,"bad"=>0,"good"=>-0.75,"sick"=>-0.75,"miss"=>0,"missLN"=>0]);
		map["1"].set("score",["shitScore"=>0,"badScore"=>0,"goodScore"=>-1000,"sickScore"=>-1000,"missScore"=>0,"missLNScore"=>0]);
		map["1"].set("damage",true);

		map["2"].set("Hard",["shit"=>0,"bad"=>0,"good"=>-0.1,"sick"=>-0.1,"miss"=>0,"missLN"=>0]);
		map["2"].set("Normal",["shit"=>0,"bad"=>0,"good"=>-0.075,"sick"=>-0.075,"miss"=>0,"missLN"=>0]);
		map["2"].set("Easy",["shit"=>0,"bad"=>0,"good"=>-0.05,"sick"=>-0.05,"miss"=>0,"missLN"=>0]);
		map["2"].set("score",["shitScore"=>0,"badScore"=>0,"goodScore"=>-300,"sickScore"=>-300,"missScore"=>0,"missLNScore"=>0]);
		map["2"].set("damage",true);

		map["3"].set("Hard",["shit"=>0,"bad"=>0,"good"=>-0.2,"sick"=>-0.2,"miss"=>0,"missLN"=>0]);
		map["3"].set("Normal",["shit"=>0,"bad"=>0,"good"=>-0.15,"sick"=>-0.15,"miss"=>0,"missLN"=>0]);
		map["3"].set("Easy",["shit"=>0,"bad"=>0,"good"=>-0.1,"sick"=>-0.1,"miss"=>0,"missLN"=>0]);
		map["3"].set("score",["shitScore"=>0,"badScore"=>0,"goodScore"=>-500,"sickScore"=>-500,"missScore"=>0,"missLNScore"=>0]);
		map["3"].set("damage",true);

		map["4"].set("Hard",["shit"=>0.14,"bad"=>0.14,"good"=>0.14,"sick"=>0.14,"miss"=>-0.3,"missLN"=>-0.1]);
		map["4"].set("Normal",["shit"=>0.1,"bad"=>0.1,"good"=>0.1,"sick"=>0.1,"miss"=>-0.2,"missLN"=>-0.075]);
		map["4"].set("Easy",["shit"=>0.1,"bad"=>0.1,"good"=>0.1,"sick"=>0.1,"miss"=>-0.1,"missLN"=>-0.05]);
		map["4"].set("score",["shitScore"=>420,"badScore"=>420,"goodScore"=>420,"sickScore"=>420,"missScore"=>-600,"missLNScore"=>-100]);
		map["4"].set("damage",false);

		map["5"].set("Hard",["shit"=>-0.1,"bad"=>-0.06,"good"=>0,"sick"=>0.04,"miss"=>-1,"missLN"=>-0.15]);
		map["5"].set("Normal",["shit"=>-0.1,"bad"=>-0.06,"good"=>0.03,"sick"=>0.07,"miss"=>-0.75,"missLN"=>-0.15]);
		map["5"].set("Easy",["shit"=>-0.07,"bad"=>-0.03,"good"=>0.03,"sick"=>0.07,"miss"=>-0.5,"missLN"=>-0.1]);
		map["5"].set("score",["shitScore"=>-100,"badScore"=>0,"goodScore"=>200,"sickScore"=>350,"missScore"=>-1000,"missLNScore"=>-150]);
		map["5"].set("damage",false);

		map["6"].set("Hard",["shit"=>-0.05,"bad"=>-0.03,"good"=>0.03,"sick"=>0.07,"miss"=>-0.3,"missLN"=>-0.1]);
		map["6"].set("Normal",["shit"=>-0.05,"bad"=>-0.03,"good"=>0.07,"sick"=>0.15,"miss"=>-0.3,"missLN"=>-0.07]);
		map["6"].set("Easy",["shit"=>-0.03,"bad"=>0,"good"=>0.07,"sick"=>0.15,"miss"=>-0.2,"missLN"=>-0.05]);
		map["6"].set("score",["shitScore"=>-50,"badScore"=>100,"goodScore"=>300,"sickScore"=>500,"missScore"=>-300,"missLNScore"=>-75]);
		map["6"].set("damage",false);

        var map2:Map<String,Dynamic>;
		var map3:Map<String,Dynamic>;
		for (key in map.keys()){
			if(key != "missPressed"){
				map2 = map.get(key);
				for(key2 in map2.keys()){
					map3 = map2.get(key2);
					if(key2 != "damage" && key2 != "score"){
						for(key3 in map3.keys())
                            stepperMap.get(key2).get(key3+key).value = map3.get(key3);
					}
				}
			}else{
                map2 = map.get(key);
                for(key2 in map2.keys()){
					stepperMap.get(key2).get("missPress").value = map2.get(key2);
				}
            }
			//healthValues.set(key,map.get(key).copy());
		}
        
        FlxG.save.data.healthValues = map;
        FlxG.save.flush();
    }

    function quit(){

        /*state = "exiting";

        save();*/

        FlxG.mouse.visible = false;
        OptionsMenu.instance.acceptInput = true;
        close();

        /*FlxTween.tween(UI_box, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0}, 1.1, {ease: FlxEase.expoInOut, onComplete: function(flx:FlxTween){close();}});
        FlxTween.tween(infoText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});*/
    }

}//Fin de la clase3310214059