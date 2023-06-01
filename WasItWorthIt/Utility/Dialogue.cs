using Godot;
using System;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;
namespace WasItWorthIt.Utility;
public class Dialogue
{
    public string Description { get; }
    public List<KeyValuePair<Characters, string>> Text { get; set; }
    public Dictionary<string, bool> Responses { get; set; }
    public Action Resultant { get; set; }
    public Dialogue(string description)
    {
        Description = description;
        Text = new();
        Responses = new Dictionary<string, bool>{};
        Resultant = new Action(() => {});
    }
    public void Display(Node caller, List<KeyValuePair<Characters, string>> lines)
    {
        DialogueContainer previous = null;
        foreach (var line in lines)
        {
            caller.AddChild(GD.Load<PackedScene>("res://dialogue_container.tscn").Instantiate() as DialogueContainer);
            var dialogueContainer = caller.GetChildren().OfType<DialogueContainer>().Last();
            dialogueContainer.DialogueText.Text = WordWrap(line.Value);
            dialogueContainer.Character = line.Key;
            var patchMarginProperties = (from property in typeof(NinePatchRect).GetProperties()
                                        where property.Name.StartsWith("PatchMargin")
                                        orderby property.Name
                                        select property).ToArray();
            if (dialogueContainer.Character == Characters.Player)
            {
                dialogueContainer.DialogueBubble.Texture = GD.Load<Texture2D>("res://Textures/self_message.png");
                dialogueContainer.LayoutDirection = Control.LayoutDirectionEnum.Ltr;
                dialogueContainer.DialogueText.HorizontalAlignment = HorizontalAlignment.Right;
                dialogueContainer.SizeFlagsHorizontal = Control.SizeFlags.ShrinkEnd;
                foreach (var property in patchMarginProperties)
                {
                    var i = Array.IndexOf(patchMarginProperties, property);
                    property.SetValue(dialogueContainer.DialogueBubble, DialogueContainer.PatchMarginPlayer[i]);
                }
            }
            else
            {
                dialogueContainer.DialogueBubble.Texture = GD.Load<Texture2D>("res://Textures/npc_message.png");
                dialogueContainer.LayoutDirection = Control.LayoutDirectionEnum.Ltr;
                dialogueContainer.DialogueText.HorizontalAlignment = HorizontalAlignment.Left;
                dialogueContainer.SizeFlagsHorizontal = Control.SizeFlags.ShrinkBegin;
                foreach (var property in patchMarginProperties)
                {
                    var i = Array.IndexOf(patchMarginProperties, property);
                    property.SetValue(dialogueContainer.DialogueBubble, DialogueContainer.PatchMarginNpc[i]);
                }
            }
            dialogueContainer.Visible = true;
            previous = dialogueContainer;
        }
        DialogueContainer[] dialogueContainers = caller.GetChildren().OfType<DialogueContainer>().ToArray();
        previous = null;
        for (int i = 0; i < dialogueContainers.Length; i++)
        {
            dialogueContainers[i].Position = dialogueContainers[i].Position with { Y = (previous is not null ? CalculateYSize(WordWrap(previous.DialogueText.Text)) + previous.Position.Y : 0) };
            previous = dialogueContainers[i];
        }
    }
    private int CalculateYSize(string text)
    {
        var lines = text.Split('\n');
        return 4 + (lines.Length * 9);
    }
    private string WordWrap(string text)
    {
        const int maxLineLength = 15;
        var words = text.Split(' ');
        var lines = new List<string>();
        var currentLine = new StringBuilder();
        foreach (var word in words)
        {
            if (currentLine.Length + word.Length > maxLineLength)
            {
                lines.Add(currentLine.ToString());
                currentLine.Clear();
            }
            currentLine.Append(word + " ");
        }
        if (currentLine.Length > 0)
        {
            lines.Add(currentLine.ToString());
        }
        var ret = new List<string>();
        foreach (var line in lines)
        {
            var substrings = from Match match in Regex.Matches(line.Trim(), ".{1,15}")
                             select match.Value;
            ret.AddRange(substrings);
        }
        return string.Join("\n", ret).Trim();
    }
    public enum Characters
    {
        Player,
        Npc
    }
}