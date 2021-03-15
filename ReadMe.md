# Renaldos Kitchen

An interactive 3D space using the Godot game engine. 
Walk using W = forward S = back A = slide left D = right. 

Models were built in Blender with principled BSDF (PBR) shaders and exported to GLTF. 
Images are mostly 512 and 1024 px compressed jpg. 

The source blend files and images are in the folder kitchenModels/

The Godot project is in the folder kitchen/ 
scenes/ contains the prefabs to use in a project. It has several subfolders. 
RenaldosKitchen.tscn is the main scene. 

Demo: [[title](https://www.example.com)](http://dev.krissnik.com/games/kitchen/)


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

ToDo still ...


![](_screenshots/workspace.png)

![](_screenshots/triggerAnimation.png)

