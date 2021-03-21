# Interactive Handwashing
Learn the proper way to wash your hands.

### ToDo:
Add sounds for paper towel dispenser, door knob, water, points

Theme for UI, choose a font

Draw custom sprites and animated hands scrubbing

Cursor starts as graphic of a hand, 2 hands, png sequence of hands washing, hand w/ towel, 
Cursor changes to paper towel to open door

![](_screenshots/handwashing.png)


# Renaldos Kitchen

An interactive 3D space using the Godot game engine. 
Walk using W = forward S = back A = slide left D = right. 

Models were built in Blender with principled BSDF (PBR) shaders and exported to GLTF. 
Images are mostly 512 and 1024 px compressed jpg. 

The source blend files and images are in the folder kitchenModels/

The Godot project is in the folder kitchen/ 
scenes/ contains the prefabs to use in a project. It has several subfolders. 
RenaldosKitchen.tscn is the main scene. 

Demo: [http://dev.krissnik.com/games/kitchen/](http://dev.krissnik.com/games/kitchen/)

### ToDo: 
Export separate gltf files for interactive and physics items

Develop a static scene with an interactive appliance to play with.


### Interactive items
Import the gltf files into Godot, open it and save as .tscn, the native Godot scene format. 
Scene files (.tscn) with meshes that will be interactive should be separate gltf files to add scripts, particles, triggers and colliders.
Scenes are prefabs!

- Add a StaticBody.CollisionShape.box for presence. 
- Add a Area.CollisionShape.box for trigger. Add script to Area, connect the entered & exited signal nodes.
- Add an AnimationPlayer and animation to play when triggered. 

#### Appliances:
sink_Handwash trigger Water particle emitter

Microwave trigger opens door

Oven trigger opens Door and Rack

Fridge trigger opens door

Hotholder trigger opens door


#### Doors:
Front Door trigger


### Physics items
Fry_Pan


![](_screenshots/workspace.png)

![](_screenshots/triggerAnimation.png)
