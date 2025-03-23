extends ItemList

var blockList = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# for all of the tilesets that we will be using, put them into the item list
	var tilemap:TileMapLayer = get_node("/root/LevelEditor/TileMapLayer")

	var tile_set = tilemap.tile_set
	
	for index in range(tile_set.get_source_count()):
		var source_id = tile_set.get_source_id(index)
		
		print(source_id)
		
		if (source_id == 0 or source_id == 3):
			continue
		
		var source = tile_set.get_source(source_id) as TileSetAtlasSource
		
		var count = source.get_tiles_count()
		
		if source_id == 7:
			count = 1
		
		for tileIndex in range(count):
			print(tileIndex)
			
			var coords = source.get_tile_id(tileIndex)
			var atlasImage:Image = source.texture.get_image()
			
			var tileImage = atlasImage.get_region(source.get_tile_texture_region(coords))
			
			tileImage.resize(100,100)
			
			var texture = ImageTexture.create_from_image(tileImage)

			# create a new button inside of the item list with this texture
			self.add_icon_item(texture)
			
			blockList.append([coords.x, coords.y, source_id])
	
	var wireTM:TileMapLayer = get_node("/root/LevelEditor/WireTileMapLayer")
	
	var wireTS = wireTM.tile_set
	
	var wireSource = wireTS.get_source(2)	
	
	for index in range(10):
		var atlasImage:Image = wireSource.texture.get_image()
			
		var tileImage = atlasImage.get_region(wireSource.get_tile_texture_region(Vector2i(index,0)))
		
		tileImage.resize(100,100)
		
		var texture = ImageTexture.create_from_image(tileImage)
		
		self.add_icon_item(texture)
		
		blockList.append([index, 0, "Wires"])

func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (mouse_button_index == 1):
		var block = blockList[index]
		
		get_node("/root/LevelEditor/TileMapLayer").setSelectedBlock(block[0], block[1], block[2])
