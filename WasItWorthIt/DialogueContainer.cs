using Godot;
using WasItWorthIt.Utility;
namespace WasItWorthIt;
public partial class DialogueContainer : MarginContainer
{
	public Label DialogueText { get; set; }
	public NinePatchRect DialogueBubble { get; set; }
	public VBoxContainer VBoxContainer { get; set; }
	public Dialogue.Characters Character { get; set; } = Dialogue.Characters.Player;
	// { bottom, left, right, top } order
	public static int[] PatchMarginPlayer { get; } = { 8, 3, 5, 4 };
	public static int[] PatchMarginNpc { get; } = { 8, 5, 3, 4 };
	public override void _Ready()
	{
		DialogueText = GetNode<Label>("MarginContainer/VBoxContainer/DialogueText");
		DialogueBubble = GetNode<NinePatchRect>("DialogueBubble");
		VBoxContainer = GetNode<VBoxContainer>("MarginContainer/VBoxContainer");
		Visible = false;
	}
}
