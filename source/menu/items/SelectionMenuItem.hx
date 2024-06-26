package menu.items;

import menu.MenuItem;

class SelectionMenuItem extends LabelMenuItem
{
	/** The options that can be selected from. **/
	public var options(default, null):Array<String>;

	/** The index of the currently-selected option. **/
	public var selectedOption(default, null):Int;

	public var leftmostArrow(default, null):AssetSprite;
	public var selectionLabel(default, null):SpriteText;
	public var rightmostArrow(default, null):AssetSprite;

	public function new(labelText:String, options:Array<String>, defaultSelected:Int = 0, functions:MenuItemFunctions = null, iconID:String = null)
	{
		super(labelText, functions, iconID, true);
		this.options = options;
		selectedOption = defaultSelected;
		selectable = true;

		leftmostArrow = new AssetSprite(x, y, "menus/_shared/arrow");
		leftmostArrow.flipX = true;
		leftmostArrow.visible = false;
		add(leftmostArrow);

		selectionLabel = new SpriteText(x, y, options[selectedOption]);
		add(selectionLabel);

		rightmostArrow = new AssetSprite(x, y, "menus/_shared/arrow");
		rightmostArrow.visible = false;
		add(rightmostArrow);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var isSelected:Bool = getIsSelected();
		var isInteractTarget:Bool = getIsInteractTarget();

		var left:Bool = Controls.uiLeft.check();
		var right:Bool = Controls.uiRight.check();
		if (interactDelay <= 0.0 && isSelected && menu.interactable && (left || right))
		{
			if (!interactable)
				menu.playErrorSound(); // Play the error sound if the item itself is not interactable
			else
			{
				moveSelection(left ? -1 : 1);
				onInteracted(selectedOption);
			}
		}

		// Make the arrows visible and update their colors if selected
		leftmostArrow.visible = isSelected && isInteractTarget;
		leftmostArrow.color = label.color;
		rightmostArrow.visible = isSelected && isInteractTarget;
		rightmostArrow.color = label.color;
	}

	/** Moves the selected option in the given direction. **/
	public function moveSelection(dir:Int)
	{
		var index:Int = selectedOption + dir;
		if (index < 0)
			index = options.length - 1;
		if (index >= options.length)
			index = 0;
		selectOption(index);
	}

	inline function selectOption(index:Int)
	{
		selectedOption = index;
		selectionLabel.setText(options[selectedOption]);
		updateRightmostArrowPosition(); // Move the arrow over to fit the selection label
	}

	override function addToMenu(menu:Menu, index:Int)
	{
		super.addToMenu(menu, index);

		leftmostArrow.x = x - label.members[0].offset.x + label.width + 16.0;
		leftmostArrow.scale.set(menu.fontSize, menu.fontSize);
		leftmostArrow.updateHitbox();
		leftmostArrow.offset.set(0.0, 0.0);

		selectionLabel.x = leftmostArrow.x + leftmostArrow.width + 16.0;
		selectionLabel.setFont(selectionLabel.font, menu.fontSize);
		selectionLabel.color = menu.normalItemColor;

		updateRightmostArrowPosition();
		rightmostArrow.scale.set(menu.fontSize, menu.fontSize);
		rightmostArrow.updateHitbox();
		rightmostArrow.offset.set(0.0, 0.0);
	}

	inline function updateRightmostArrowPosition()
	{
		rightmostArrow.x = selectionLabel.x + selectionLabel.width + 16.0;
	}

	override function onInteracted(value:Dynamic)
	{
		menu.playToggleSound();
		super.onInteracted(value);
	}
}
