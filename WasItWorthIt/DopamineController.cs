using Godot;
using System;
namespace WasItWorthIt;
public partial class DopamineController : Node
{
	[Signal] public delegate void DopamineChangeEventHandler(int dopamine);
	private int _dopamine = 0;
	public int Dopamine
	{
		get => _dopamine;
		set
		{
			_dopamine = value;
			EmitSignal(nameof(DopamineChange), _dopamine);
		}
	}
	private TextureProgressBar _dopamineBar;
	private Timer _dopamineTimer;
	public override void _Ready()
	{
		_dopamineBar = GetNode<TextureProgressBar>("../Control/DopamineProgress");
		_dopamineTimer = GetNode<Timer>("../DopamineTimer");
		DopamineChange += OnDopamineChange;
		_dopamineTimer.Timeout += CheckDopamine;
		Dopamine = 75;
	}
	public override void _Process(double delta)
	{
	}
	private void OnDopamineChange(int dopamine)
	{
		_dopamineBar.Value = dopamine;
		if (dopamine <= 0)
		{
			_dopamineTimer.Start(10.0);
		}
		else
		{
			_dopamineTimer.Stop();
		}
	}
	private void CheckDopamine()
	{
		if (Dopamine <= 0)
		{
			// uh oh! dopamine is too low for too long!
			_dopamineTimer.Stop();
		}
	}
}
