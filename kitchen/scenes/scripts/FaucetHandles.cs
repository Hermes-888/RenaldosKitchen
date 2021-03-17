using Godot;
using System;

public class FaucetHandles : Area
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    /*
        Faucet Handles have Handle_Hot & Handle_Cold colliders
        add gui elements to see Hot Cold above the handles
        mouse? clicking one or the other changes the color of the water red/blue
        
        HMM, each collider, Handle_Hot & Handle_Cold, needs it's own Area and script
    */
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        GD.Print("FaucetHandles ready");
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
