/***************************************************************************************************
 ApexReticle
 
 Copyright 2024 roundRekt v1.3
 GitHub：https://github.com/roundRekt
 bilibili：https://space.bilibili.com/2122119709
 
 关于：
 这是一个易于使用、可自定义、支持中文、基于ReShade、为Apex Legends开发的准星插件
 
 项目：
 https://github.com/roundRekt/ApexReticle
 
 教程：
 https://www.bilibili.com/video/BV1CeepemE82
 
 历史：
 版本 1.3
 * 添加了次要准星的显示策略
 * 添加了独立的次要准星自定义准星图片兼容（需要将准星图片重命名为KovaaK-Crosshair-Hipfire.png）
 * 添加了视频教程链接
 * 调整了设置选项布局
 * 现在可以双击输入图片宽度和图片高度
 版本 1.2
 * 添加了腰射专用准星
 * 添加了三种准星样式
 * 添加了切换开镜兼容
 版本 1.1
 * 现在当高抛雷分划的显示策略设置为“捏雷时显示”时如果右键被按住则不会显示
 版本 1.0
 * 添加了自定义准星功能
 * 添加了高抛雷分划功能
 * 添加了自定义准星的显示策略选项
 * 添加了高抛雷分划的显示策略选项
 * 添加了高抛雷分划的FOV选择功能
 * 添加了高抛雷分划的不透明度选项
***************************************************************************************************/

#include "ReShade.fxh"

uniform bool Crosshair_Toggle
<
	ui_label = "单击切换开镜";
	ui_tooltip = "设置是否使用单击切换开镜（建议改用按住开镜以获得最佳体验）";
> = 0;

uniform int Crosshair_Display
<
	ui_category = "主要准星";
    ui_type = "combo";
    ui_items = "开镜时显示\0开火时显示\0开镜或开火时显示\0始终显示\0关闭\0";
    ui_label = "显示策略";
    ui_tooltip = "设置主要准星的显示策略（默认开火为鼠标左键，开镜为按住鼠标右键）";
> = 0;

uniform int Crosshair_Type
<
	ui_category = "主要准星";
    ui_type = "combo";
    ui_items = "点状 ・\0十字 +\0叉形 ×\0自定义准星图片（KovaaK-Crosshair.png）\0";
    ui_label = "准星样式";
    ui_tooltip = "设置主要准星的样式（“自定义准星图片”需要手动添加准星图片，并设置宽度和高度）";
> = 0;

uniform int Crosshair_Width
<
	ui_category = "主要准星";
	ui_type = "drag";
	ui_min = 1;
	ui_max = 500;
	ui_step = 1;
	ui_label = "图片宽度";
	ui_tooltip = "（双击输入）设置主要准星的宽度（当准星样式为“自定义准星图片”时生效，建议与图片宽度保持一致）";
> = 250;

uniform int Crosshair_Height
<
	ui_category = "主要准星";
	ui_type = "drag";
	ui_min = 1;
	ui_max = 500;
	ui_step = 1;
	ui_label = "图片高度";
	ui_tooltip = "（双击输入）设置主要准星的高度（当准星样式为“自定义准星图片”时生效，建议与图片高度保持一致）";
> = 250;

uniform int Crosshair_Hipfire_Display
<
	ui_category = "次要准星";
    ui_type = "combo";
    ui_items = "腰射时显示\0开火时显示\0不开镜时显示\0始终显示\0关闭\0";
    ui_label = "显示策略";
    ui_tooltip = "设置次要准星的显示策略（默认开火为鼠标左键，开镜为按住鼠标右键）";
> = 0;

uniform int Crosshair_Hipfire_Type
<
	ui_category = "次要准星";
    ui_type = "combo";
    ui_items = "点状 ・\0十字 +\0叉形 ×\0自定义准星图片（KovaaK-Crosshair-Hipfire.png）\0";
    ui_label = "准星样式";
    ui_tooltip = "设置次要准星的样式（“自定义准星图片”需要手动添加准星图片，并设置宽度和高度）";
> = 2;

uniform int Crosshair_Hipfire_Width
<
	ui_category = "次要准星";
	ui_type = "drag";
	ui_min = 1;
	ui_max = 500;
	ui_step = 1;
	ui_label = "图片宽度";
	ui_tooltip = "（双击输入）设置次要准星的宽度（当准星样式为“自定义准星图片”时生效，建议与图片宽度保持一致）";
> = 250;

uniform int Crosshair_Hipfire_Height
<
	ui_category = "次要准星";
	ui_type = "drag";
	ui_min = 1;
	ui_max = 500;
	ui_step = 1;
	ui_label = "图片高度";
	ui_tooltip = "（双击输入）设置次要准星的高度（当准星样式为“自定义准星图片”时生效，建议与图片高度保持一致）";
> = 250;

uniform int Grenade_Display
<
	ui_category = "高抛雷分划";
    ui_type = "combo";
    ui_items = "捏雷时显示\0始终显示\0关闭\0";
    ui_label = "显示策略";
    ui_tooltip = "设置高抛雷分划的显示策略（默认捏雷为长按鼠标左键且松开鼠标右键）";
> = 0;

uniform int Grenade_FOV
<
	ui_category = "高抛雷分划";
    ui_type = "combo";
    ui_items = "90\0""100\0""104\0""106\0""110\0""120\0";
    ui_label = "视野(FOV)";
    ui_tooltip = "设置高抛雷分划的视野（游戏菜单-设置-视频-视野(FOV)右侧显示的数值）";
> = 4;

uniform float Grenade_Opacity
<
	ui_category = "高抛雷分划";
	ui_type = "slider";
	ui_min = 0;
	ui_max = 1;
	ui_step = 0.01;
	ui_label = "不透明度";
	ui_tooltip = "设置高抛雷分划的不透明度（0为完全透明，1为完全不透明）";
> = 1;

uniform int GitHub
<
	ui_category = "Copyright 2024 roundRekt v1.3";
	ui_type = "radio";
	ui_items = "https://github.com/roundRekt\0";
	ui_label = "GitHub";
	ui_tooltip = "主页里有项目详情喵~";
>;

uniform int Bilibili
<
	ui_category = "Copyright 2024 roundRekt v1.3";
	ui_type = "radio";
	ui_items = "https://space.bilibili.com/2122119709\0";
	ui_label = "bilibili";
	ui_tooltip = "空间里有视频教程喵~";
>;

uniform int Repository
<
	ui_category = "Copyright 2024 roundRekt v1.3";
	ui_type = "radio";
	ui_items = "https://github.com/roundRekt/ApexReticle\0";
	ui_label = "项目地址";
	ui_tooltip = "项目里有文字教程喵~";
>;

uniform int Tutorial
<
	ui_category = "Copyright 2024 roundRekt v1.3";
	ui_type = "radio";
	ui_items = "https://www.bilibili.com/video/BV1CeepemE82\0";
	ui_label = "视频教程";
	ui_tooltip = "链接里有视频教程喵~";
>;

uniform bool Mouse_Left
<
  	source = "mousebutton";
 	keycode = 0;
 	toggle = false;
>;

uniform bool Mouse_Right
<
 	source = "mousebutton";
 	keycode = 1;
  	toggle = false;
>;

uniform bool Mouse_Right_Toggle
<
 	source = "mousebutton";
 	keycode = 1;
  	toggle = true;
>;

texture Crosshair_Texture_Dot				<source="Dot.png";>							{Width = 8;	   Height = 8;    Format = RGBA8;};
texture Crosshair_Texture_Cross				<source="Cross.png";>						{Width = 100;  Height = 100;  Format = RGBA8;};
texture Crosshair_Texture_X					<source="X.png";>							{Width = 62;   Height = 62;   Format = RGBA8;};
texture Crosshair_Texture_KovaaK			<source="KovaaK-Crosshair.png";>			{Width = 500;  Height = 500;  Format = RGBA8;};
texture Crosshair_Texture_KovaaK_Hipfire	<source="KovaaK-Crosshair-Hipfire.png";>	{Width = 500;  Height = 500;  Format = RGBA8;};
texture Grenade_Texture_FOV90	 			<source="FOV90.png";>						{Width = 1920; Height = 1080; Format = RGBA8;};
texture Grenade_Texture_FOV100				<source="FOV100.png";>						{Width = 1920; Height = 1080; Format = RGBA8;};
texture Grenade_Texture_FOV104				<source="FOV104.png";>						{Width = 1920; Height = 1080; Format = RGBA8;};
texture Grenade_Texture_FOV106				<source="FOV106.png";>						{Width = 1920; Height = 1080; Format = RGBA8;};
texture Grenade_Texture_FOV110				<source="FOV110.png";>						{Width = 1920; Height = 1080; Format = RGBA8;};
texture Grenade_Texture_FOV120				<source="FOV120.png";>						{Width = 1920; Height = 1080; Format = RGBA8;};
sampler	Crosshair_Sampler_Dot 	 			{Texture = Crosshair_Texture_Dot;};
sampler	Crosshair_Sampler_Cross  			{Texture = Crosshair_Texture_Cross;};
sampler	Crosshair_Sampler_X  				{Texture = Crosshair_Texture_X;};
sampler	Crosshair_Sampler_KovaaK  			{Texture = Crosshair_Texture_KovaaK;};
sampler	Crosshair_Sampler_KovaaK_Hipfire  	{Texture = Crosshair_Texture_KovaaK_Hipfire;};
sampler	Grenade_Sampler_FOV90  				{Texture = Grenade_Texture_FOV90;};
sampler	Grenade_Sampler_FOV100 				{Texture = Grenade_Texture_FOV100;};
sampler	Grenade_Sampler_FOV104 				{Texture = Grenade_Texture_FOV104;};
sampler	Grenade_Sampler_FOV106 				{Texture = Grenade_Texture_FOV106;};
sampler	Grenade_Sampler_FOV110 				{Texture = Grenade_Texture_FOV110;};
sampler	Grenade_Sampler_FOV120 				{Texture = Grenade_Texture_FOV120;};

float4 VS_Crosshair(uint vid : SV_VertexID, out float2 texcoord : TexCoord) : SV_POSITION
{
  	texcoord.y = vid % 2, texcoord.x = vid / 2;
	int Width,Height;
	switch(Crosshair_Type)
	{
		case 0:Width=Height=8*BUFFER_HEIGHT/1080; break;
		case 1:Width=Height=100*BUFFER_HEIGHT/1080; break;
		case 2:Width=Height=62*BUFFER_HEIGHT/1080; break;
		default:Width=Crosshair_Width; Height=Crosshair_Height; break;
	}
  	return float4((texcoord.x*2-1)*Width/BUFFER_WIDTH,(1-texcoord.y*2)*Height/BUFFER_HEIGHT,0,1);
}

float4 VS_Crosshair_Hipfire(uint vid : SV_VertexID, out float2 texcoord : TexCoord) : SV_POSITION
{
  	texcoord.y = vid % 2, texcoord.x = vid / 2;
	int Width,Height;
	switch(Crosshair_Hipfire_Type)
	{
		case 0:Width=Height=8*BUFFER_HEIGHT/1080; break;
		case 1:Width=Height=100*BUFFER_HEIGHT/1080; break;
		case 2:Width=Height=62*BUFFER_HEIGHT/1080; break;
		default:Width=Crosshair_Hipfire_Width; Height=Crosshair_Hipfire_Height; break;
	}
  	return float4((texcoord.x*2-1)*Width/BUFFER_WIDTH,(1-texcoord.y*2)*Height/BUFFER_HEIGHT,0,1);
}

float4 PS_Crosshair(float4 pos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	switch(Crosshair_Display)
	{
		case 0:if (Crosshair_Toggle ? Mouse_Right_Toggle : Mouse_Right) 				{}else return 0; break;
		case 1:if (Mouse_Left)															{}else return 0; break;
		case 2:if (Mouse_Left || (Crosshair_Toggle ? Mouse_Right_Toggle : Mouse_Right)) {}else return 0; break;
		case 3:break;
		default:return 0;
	}
	switch(Crosshair_Type)
	{
		case 0:return tex2D(Crosshair_Sampler_Dot, texcoord);
		case 1:return tex2D(Crosshair_Sampler_Cross, texcoord);
		case 2:return tex2D(Crosshair_Sampler_X, texcoord);
		default:return tex2D(Crosshair_Sampler_KovaaK, texcoord);
	}
}

float4 PS_Crosshair_Hipfire(float4 pos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	switch(Crosshair_Hipfire_Display)
	{
		case 0:if (Mouse_Left && (Crosshair_Toggle ? !Mouse_Right_Toggle : !Mouse_Right)) 	{}else return 0; break;
		case 1:if (Mouse_Left)																{}else return 0; break;
		case 2:if (Crosshair_Toggle ? !Mouse_Right_Toggle : !Mouse_Right)					{}else return 0; break;
		case 3:break;
		default:return 0;
	}
	switch(Crosshair_Hipfire_Type)
	{
		case 0:return tex2D(Crosshair_Sampler_Dot, texcoord);
		case 1:return tex2D(Crosshair_Sampler_Cross, texcoord);
		case 2:return tex2D(Crosshair_Sampler_X, texcoord);
		default:return tex2D(Crosshair_Sampler_KovaaK, texcoord);
	}

}

float4 PS_Grenade(float4 pos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	switch (Grenade_Display)
	{
		case 0:if (Mouse_Left && !(Crosshair_Toggle ? Mouse_Right_Toggle : Mouse_Right)) {}else return lerp(tex2D(ReShade::BackBuffer, texcoord),0,0); break;
		case 1:break;
		default:return lerp(tex2D(ReShade::BackBuffer, texcoord),0,0);
	}
	switch (Grenade_FOV)
	{
		case 0:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV90, texcoord),tex2D(Grenade_Sampler_FOV90, texcoord).a*Grenade_Opacity);
		case 1:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV100, texcoord),tex2D(Grenade_Sampler_FOV100, texcoord).a*Grenade_Opacity);
		case 2:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV104, texcoord),tex2D(Grenade_Sampler_FOV104, texcoord).a*Grenade_Opacity);
		case 3:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV106, texcoord),tex2D(Grenade_Sampler_FOV106, texcoord).a*Grenade_Opacity);
		case 4:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV110, texcoord),tex2D(Grenade_Sampler_FOV110, texcoord).a*Grenade_Opacity);
		case 5:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV120, texcoord),tex2D(Grenade_Sampler_FOV120, texcoord).a*Grenade_Opacity);
		default:return lerp(tex2D(ReShade::BackBuffer, texcoord),0,0);
	}
}

technique ApexReticle
<
	ui_label = "APEX准星";
	ui_tooltip = "这是一个易于使用、可自定义、支持中文、基于ReShade、为Apex Legends开发的准星插件";
>
{
	pass CrosshairPass
	{
		VertexCount = 4;
		PrimitiveTopology = TRIANGLESTRIP;
		VertexShader = VS_Crosshair;
		PixelShader = PS_Crosshair;
		BlendEnable = true;
        SrcBlend = SRCALPHA;
        DestBlend = INVSRCALPHA;
	}
	pass CrosshairHipfirePass
	{
		VertexCount = 4;
		PrimitiveTopology = TRIANGLESTRIP;
		VertexShader = VS_Crosshair_Hipfire;
		PixelShader = PS_Crosshair_Hipfire;
		BlendEnable = true;
        SrcBlend = SRCALPHA;
        DestBlend = INVSRCALPHA;
	}
	pass GrenadePass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_Grenade;
	}
}