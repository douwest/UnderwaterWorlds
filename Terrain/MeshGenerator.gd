extends Node

export(SpatialMaterial) var material = SpatialMaterial.new()
export(float) var isolevel setget generate

onready var height: float = Density.height
onready var width: float = Density.width

signal generation_finished(mesh)
		
func vertexInterp(a, b, iso):
	if abs(iso - a[3]) < 0.00001:
		return Vector3(a[0], a[1], a[2])
	if abs(iso - b[3]) < 0.00001:
		return Vector3(b[0], b[1], b[2])
	if abs(a[3]-b[3]) < 0.00001:
		return Vector3(a[0], a[1], a[2])
	var mu = (iso - a[3]) / (b[3] - a[3])
	return Vector3(
		a[0] + mu * (b[0] - a[0]),
		a[1] + mu * (b[1] - a[1]),
		a[2] + mu * (b[2] - a[2])
	)
	

"""
how to make it faster? :c
offload this to gpu somehow..
"""
func addVerts(x, y, z, surfTool, isolevel, color):
	var value = 0
	var grid = [
		[x, y, z],
		[x + 1, y, z],
		[x + 1, y + 1, z],
		[x, y + 1, z],
		[x, y, z + 1],
		[x + 1, y, z + 1],
		[x + 1, y + 1, z + 1],
		[x, y + 1, z + 1]
	]
	var check = 1
	for i in range(8):
		grid[i].append(Density.get_density(grid[i][0], grid[i][1], grid[i][2]))
		if grid[i][3] < isolevel:
			value |= check
		check *= 2
	
	if MeshConstants.edgeTable[value] == 0:
		return
	
	var vertlist = [null, null, null, null, null, null, null, null, null, null, null, null]
	if MeshConstants.edgeTable[value] & 1:
		vertlist[0] = vertexInterp(grid[0], grid[1], isolevel)
	if MeshConstants.edgeTable[value] & 2:
		vertlist[1] = vertexInterp(grid[1], grid[2], isolevel)
	if MeshConstants.edgeTable[value] & 4:
		vertlist[2] = vertexInterp(grid[2], grid[3], isolevel)
	if MeshConstants.edgeTable[value] & 8:
		vertlist[3] = vertexInterp(grid[3], grid[0], isolevel)
	if MeshConstants.edgeTable[value] & 16:
		vertlist[4] = vertexInterp(grid[4], grid[5], isolevel)
	if MeshConstants.edgeTable[value] & 32:
		vertlist[5] = vertexInterp(grid[5], grid[6], isolevel)
	if MeshConstants.edgeTable[value] & 64:
		vertlist[6] = vertexInterp(grid[6], grid[7], isolevel)
	if MeshConstants.edgeTable[value] & 128:
		vertlist[7] = vertexInterp(grid[7], grid[4], isolevel)
	if MeshConstants.edgeTable[value] & 256:
		vertlist[8] = vertexInterp(grid[0], grid[4], isolevel)
	if MeshConstants.edgeTable[value] & 512:
		vertlist[9] = vertexInterp(grid[1], grid[5], isolevel)
	if MeshConstants.edgeTable[value] & 1024:
		vertlist[10] = vertexInterp(grid[2], grid[6], isolevel)
	if MeshConstants.edgeTable[value] & 2048:
		vertlist[11] = vertexInterp(grid[3], grid[7], isolevel)
	
	for i in range(0, 12, 3):
		if MeshConstants.triTable[value][i] == -1:
			continue
		for x in range(0, 3):
			var a = vertlist[MeshConstants.triTable[value][i + x]]
			surfTool.add_uv(Vector2(a.x, a.z))
			surfTool.add_color(color)
			surfTool.add_vertex(a)

func generate(offset: Vector3) -> ArrayMesh:
	print('generate!')
	isolevel = 0.0
	
	var surfTool = SurfaceTool.new()
	var mesh = Mesh.new()
	surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for x in range(-width/2, width/2):
		for y in range(-height / 2, height / 2):
			for z in range(-width/2, width/2):
				"""
				maybe precalculate noise and only add vertices at voxels where necessary?
				"""
				addVerts(x + offset.x, y + offset.y, z + offset.z, surfTool, isolevel, get_color(y, offset))
	
	surfTool.generate_normals()
	surfTool.index()
	material.set_flag(SpatialMaterial.FLAG_ALBEDO_FROM_VERTEX_COLOR, true)
	surfTool.set_material(material)
	mesh = surfTool.commit(mesh)
	return mesh
	
func get_color(y: float, offset: Vector3) -> Color:
	var color_mult: float = (offset.y + y) / (height * 2) #value ranging from 0 to 1
	return Color(
		0.2 + (0.6 * color_mult), 
		0.2 + (0.6 * color_mult), 
		0.1 + (0.9 * color_mult)
		)
