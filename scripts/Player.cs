using Godot;
using System.Collections.Generic;

public partial class Player : Node
{
	[Signal] public delegate void InteractionScoreChangeEventHandler(Godot.Collections.Dictionary<string, int> interactionScore);
	private Dictionary<string, int> _interactionScore = new();
	public Dictionary<string, int> InteractionScore
	{
		get => _interactionScore;
		set
		{
			_interactionScore = value;
			EmitSignal(nameof(InteractionScoreChange), new Godot.Collections.Dictionary<string, int>(_interactionScore));
		}
	}
	private int _vapeHits = 0;
	private DopamineController _dopamineController;
	public override void _Ready()
	{
		_dopamineController = GetNode<Node>("../DopamineController") as DopamineController;
		InteractionScoreChange += OnInteractionScoreChange;
	}
    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event is InputEventKey eventKey)
		{
			switch (eventKey.Keycode)
			{
				case Key.Escape:
					GetTree().Quit();
					break;
				case Key.Space:
					_vapeHits++;
					_dopamineController.Dopamine += Mathf.RoundToInt(50 * 1/_vapeHits);
					GD.Print($"Dopamine added: {Mathf.RoundToInt(50 * 1/_vapeHits)}");
					break;
			}
		}
    }
	private void OnInteractionScoreChange(Godot.Collections.Dictionary<string, int> interactionScore)
	{
		foreach (var interaction in interactionScore)
		{
			GD.Print($"{interaction.Key}: {interaction.Value}");
		}
	}
}
