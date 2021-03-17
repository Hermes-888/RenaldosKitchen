using Godot;
using System;

public class Handsink_Handle_Hot : Area
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";
    public double temperature;

    /*
        Handle_Hot 
        show gui element 'Hot' (word) above the handle
        and temperature. temp starts low when first started
        Goal: player must raise the temp to be hotter

        clicking handle changes the emitter color of the water to red
        temperature changes to correct degree for handwashing
        
        HMM, each collider, Handle_Hot & Handle_Cold, needs it's own Area and script
        how do they communicate? 
        the main AreaTrigger enter, exited should inform handles to show/hide gui

        should there be a master script on the root node to control interactions
        video plays each step, player interacts with sink 
        Use the model with the soap and paper towels
    */

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        temperature = 98.4;
        GD.Print("Hot handle ready");
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
