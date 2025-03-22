extends ItemList

var blockList = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# for all of the tilesets that we will be using, put them into the item list
	var tilemap:TileMapLayer = get_node("/root/LevelEditor/TileMapLayer")

	var tile_set = tilemap.tile_set
	
	for index in range(tile_set.get_source_count()):
		var source_id = tile_set.get_source_id(index)
		var source = tile_set.get_source(source_id) as TileSetAtlasSource
		
		for tileIndex in range(source.get_tiles_count()):
			var coords = source.get_tile_id(tileIndex)
			var atlasImage:Image = source.texture.get_image()
			
			var tileImage = atlasImage.get_region(source.get_tile_texture_region(coords))
			
			tileImage.resize(100,100)
			
			var texture = ImageTexture.create_from_image(tileImage)

			# create a new button inside of the item list with this texture
			self.add_icon_item(texture)
			
			blockList.append([coords.x, coords.y, source_id])


func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var block = blockList[index]
	
	get_node("/root/LevelEditor/TileMapLayer").setSelectedBlock(block[0], block[1], block[2])
