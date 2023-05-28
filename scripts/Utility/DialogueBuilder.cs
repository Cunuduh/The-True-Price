using Godot;
using System;
using System.Collections.Generic;
namespace WasItWorthIt.Utility;
public class DialogueBuilder
{
    private Dialogue _dialogue;
    public Dictionary<string, bool> Responses => _dialogue.Responses;
    public DialogueBuilder(string description)
    {
        _dialogue = new Dialogue(description);
    }
    public DialogueBuilder WithText(Dictionary<Dialogue.Characters, string> text)
    {
        _dialogue.Text = text;
        return this;
    }
    public DialogueBuilder WithResponses(Dictionary<String, bool> responses)
    {
        _dialogue.Responses = responses;
        return this;
    }
    public DialogueBuilder WithResult(Action resultant)
    {
        _dialogue.Resultant = resultant;
        return this;
    }
    public DialogueBuilder SelectResponses(params string[] response)
    {
        foreach (var r in response)
        {
            _dialogue.Responses[r] = true;
        }
        return this;
    }
    public Dialogue Build()
    {
        return _dialogue;
    }
}
public class ExampleUsage
{
    public void Example()
    {
        var dialogueBuilder = new DialogueBuilder("Brazil Event")
            .WithText(new Dictionary<Dialogue.Characters, string>
            {
                { Dialogue.Characters.NPC, "Come to Brazil with me!" }
            })
            .WithResponses(new Dictionary<string, bool>
            {
                { "OK, I will come", false },
                { "No", false }
            });
        if (true) // Clicked on "OK, I will come" button?
        {
            dialogueBuilder.SelectResponses("OK, I will come");
        }
        var dialogue = dialogueBuilder
            .WithResult(() =>
            {
                if (dialogueBuilder.Responses["OK, I will come"])
                {
                    GD.Print("You went to Brazil!");
                }
                else
                {
                    GD.Print("You didn't go to Brazil!");
                }
            })
            .Build();
    }
}