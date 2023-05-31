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
    public DialogueBuilder WithText(List<KeyValuePair<Dialogue.Characters, string>> text)
    {
        _dialogue.Text = text;
        return this;
    }
    public DialogueBuilder WithResponses(Dictionary<string, bool> responses)
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