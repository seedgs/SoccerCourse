shader_type canvas_item;

// 关键词 + 指定的类型 + 名称
uniform sampler2D team_palette;

// 设置索引，目的给着色器指定 “行”的位置
uniform int team_color;


//顶点着色器
void vertex() {
	// Called for every vertex the material is visible on.
}

//uv坐标的函数方法
//vec2 pos:像素坐标
//vec2 tex_size:纹理大小(也就是调色板大小)
vec2 px_to_uv(ivec2 pos, ivec2 tex_size){
    return vec2(
    
        //这里 + 0.5是为了对准中心，UV坐标正数可以选择4个图像，为了精准需要 +0.5
        //pos[0]为 u坐标，pos[1]为 v坐标
        (float(pos[0]) + 0.5) / float(tex_size[0]),
        (float(pos[1]) + 0.5) / float(tex_size[1])
    );
}

//vec4 color:原始颜色
//sampler2D palette:调色板
//int selection:“行”参数
vec4 get_palette_color(vec4 color, sampler2D palette, int selection){
    
    //告诉GPU以 “什么” 参照物去查找并替换成 “什么”
    // texture(a, b):
    //a参数是 以 “什么” 参照物去查找（也就是你的调色板）
    //b参数是查找的位置是什么，也就是坐标（这里的坐标是UV坐标，UV坐标是 x轴 或 y轴的长度都为 “单位为 1”，举例：你调色板x轴有100px，y轴50px，它们都是等于1）
    //举例：texture(a, vec2(3,4)) 转换为UV坐标为 texture(a, vec2(3/x,4/y))
    
    ivec2 tex_size = textureSize(palette, 0);
    
    //遍历调色板，搜索第一行
    for (int i=0; i<tex_size[0]; i++) {
    
        // px_to_uv(a, b)
        //a参数:我们需要遍历的是x轴坐标的位置，所以是(i,0)
        //b参数:大小为调色板(tex_size)
        vec2 uv_color_ref = px_to_uv(ivec2(i, 0),tex_size);
        
        //查找调色板的第一行，初始化至color_ref
        vec4 color_ref = texture(palette, uv_color_ref);
        
        //查找颜色后，并替换
        if (color == color_ref){
        
            //搜索第一行的颜色，然后对比你所选的team_color中的数（因为你的get_palette_color()的selection对应的是team_color，也就是你选的行数）
            //举例：team_color中你选了 5，texture就会先扫描第 1 行，把第 1 行的颜色替换成你选的team_color第 5 行的颜色
            //有了你选的行，然后代码根据你选的行对应的列的颜色就可以输出了颜色了
            vec2 uv_color_dest = px_to_uv(ivec2(i,selection), tex_size);
            return texture(palette, uv_color_dest);
        }
    }
    
    return color;
}

//片段着色器
void fragment() {
    
    COLOR = get_palette_color(COLOR, team_palette, team_color);
	
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
