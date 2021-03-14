# Renaldos Kitchen

An interactive 3D game using the Godot game engine. 
Models were built in Blender with principled BSDF (PBR) shaders and exported to GLTF. 

The blend files are in the folder kitchenModels/

In Godot, import the gltf file, open it and save as .tscn, the native Godot scene format. Scenes are prefabs!


### Interactive items
Meshes that will have interaction should be separate gltf files to add scripts, particles, triggers and colliders.


Add StaticBody.CollisionShape.box for presence

Add Area.CollisionShape.box for trigger. Add script to Area, connect the entered & exited signal nodes.

Add AnimationPlayer and animation 

Appliances:

sink_Handwash trigger Water particle emitter

Microwave trigger Door open

Oven trigger Door and Rack open

Fridge trigger Door open


### Physics items
Fry_Pan
