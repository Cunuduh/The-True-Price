using System;
using System.Collections.Generic;
namespace WasItWorthIt.Utility;
public class Dialogue
{
    public string Description { get; }
    public Dictionary<Characters, string> Text { get; set; }
    public Dictionary<string, bool> Responses { get; set; }
    public Action Resultant { get; set; }
    public Dialogue(string description)
    {
        Description = description;
        Text = new();
        Responses = new Dictionary<string, bool>{};
        Resultant = new Action(() => { });
    }
    public enum Characters
    {
        Player,
        NPC
    }
}