using Godot;
using System;
using System.Linq;
using System.Text;
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
            dialogueContainer.DialogueText.Text = CreateAppropriateLineBreaks(line.Value);
            dialogueContainer.Character = line.Key;
            var patchMarginProperties = (from property in typeof(NinePatchRect).GetProperties()
                                        where property.Name.StartsWith("PatchMargin")
                                        orderby property.Name ascending
                                        select property).ToArray();
            int y = (int)(32 * (caller.GetChildren().Count() - 1) + (previous is null ? 0f : previous.Size.Y / 4f));
            dialogueContainer.Position = new(79, y);
            if (dialogueContainer.Character == Characters.Player)
            {
                dialogueContainer.DialogueBubble.Texture = GD.Load<Texture2D>("res://Textures/self_message.png");
                dialogueContainer.LayoutDirection = Control.LayoutDirectionEnum.Rtl;
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
                foreach (var property in patchMarginProperties)
                {
                    var i = Array.IndexOf(patchMarginProperties, property);
                    property.SetValue(dialogueContainer.DialogueBubble, DialogueContainer.PatchMarginNpc[i]);
                }
            }
            dialogueContainer.Visible = true;
            previous = dialogueContainer;
        }
    }
    private string CreateAppropriateLineBreaks(string text)
    {
        const int maxLineLength = 16;
        var words = text.Split(' ');
        var lines = new List<string>();
        var currentLine = new StringBuilder();
        foreach (var word in words)
        {
            if (currentLine.Length + word.Length + 1 > maxLineLength)
            {
                lines.Add(currentLine.ToString().Trim());
                currentLine.Clear();
            }

            currentLine.Append(word);
            currentLine.Append(' ');
        }
        if (currentLine.Length > 0)
        {
            lines.Add(currentLine.ToString().Trim());
        }
        return string.Join("\n", lines);
    }
    public enum Characters
    {
        Player,
        Npc
    }
}