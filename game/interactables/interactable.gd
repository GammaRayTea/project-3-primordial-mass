@abstract class_name Interactable extends Node3D

@export var tile_spawn_margin:int = 1


@abstract func hover_start() -> void
@abstract func hover_end() -> void
@abstract func activate(_source:Node3D) -> void
@abstract func deactivate(_source:Node3D) -> void
