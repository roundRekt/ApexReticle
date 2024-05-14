/***************************************************************************************************
 ApexReticle
 
 Copyright 2024 roundRekt v1.0
 GitHub：https://github.com/roundRekt
 bilibili：https://space.bilibili.com/2122119709
 
 关于：
 这是一个易于使用、可自定义、支持中文、基于ReShade、为Apex Legends开发的准星插件
 
 项目：
 https://github.com/roundRekt/ApexReticle
 
 历史：
 版本 1.0
 * 添加了自定义准星功能
 * 添加了高抛雷分划功能
 * 添加了自定义准星的显示策略选项
 * 添加了高抛雷分划的显示策略选项
 * 添加了高抛雷分划的FOV选择功能
 * 添加了高抛雷分划的不透明度选项
***************************************************************************************************/

#include "ReShade.fxh"

#define CROSSHAIR "自定义准星"
#define GRENADE "高抛雷分划"
#define AUTHOR "Copyright 2024 roundRekt v1.0"

uniform bool Crosshair_Flag
<
	ui_category = CROSSHAIR;
	ui_label = "启用";
	ui_tooltip = "设置是否启用自定义准星";
> = 1;

uniform int Crosshair_Width
<
	ui_category = CROSSHAIR;
	ui_type = "slider";
	ui_min = 1;
	ui_max = 500;
	ui_step = 1;
	ui_label = "宽度";
	ui_tooltip = "设置自定义准星的宽度（此项建议与图片宽度保持一致）";
> = 8;

uniform int Crosshair_Height
<
	ui_category = CROSSHAIR;
	ui_type = "slider";
	ui_min = 1;
	ui_max = 500;
	ui_step = 1;
	ui_label = "高度";
	ui_tooltip = "设置自定义准星的高度（此项建议与图片高度保持一致）";
> = 8;

uniform int Crosshair_Display
<
	ui_category = CROSSHAIR;
    ui_type = "combo";
    ui_items = "开镜时显示\0开火时显示\0开镜或开火时显示\0始终显示\0";
    ui_label = "显示策略";
    ui_tooltip = "设置自定义准星的显示策略（默认开火为鼠标左键，开镜为按住鼠标右键）";
> = 2;

uniform bool Grenade_Flag
<
	ui_category = GRENADE;
	ui_label = "启用";
	ui_tooltip = "设置是否启用高抛雷分划（不提倡在对局中启用）";
> = 1;

uniform float Grenade_Opacity
<
	ui_category = GRENADE;
	ui_type = "slider";
	ui_min = 0;
	ui_max = 1;
	ui_step = 0.01;
	ui_label = "不透明度";
	ui_tooltip = "设置高抛雷分划的不透明度（0为完全透明，1为完全不透明）";
> = 1;

uniform int Grenade_FOV
<
	ui_category = GRENADE;
    ui_type = "combo";
    ui_items = "90\0""100\0""104\0""106\0""110\0""120\0";
    ui_label = "视野(FOV)";
    ui_tooltip = "游戏菜单-设置-视频-视野(FOV)右侧显示的数值";
> = 4;

uniform int Grenade_Display
<
	ui_category = GRENADE;
    ui_type = "combo";
    ui_items = "捏雷时显示\0始终显示\0";
    ui_label = "显示策略";
    ui_tooltip = "设置高抛雷分划的显示策略（默认捏雷为长按鼠标左键）";
> = 0;

uniform int Repository
<
	ui_category = AUTHOR;
	ui_type = "list";
	ui_items = "https://github.com/roundRekt/ApexReticle\0";
	ui_label = "项目地址";
	ui_tooltip = "项目里有文字教程喵~";
> = 0;

uniform int GitHub
<
	ui_category = AUTHOR;
	ui_type = "list";
	ui_items = "https://github.com/roundRekt\0";
	ui_label = "GitHub";
	ui_tooltip = "主页里有项目详情喵~";
> = 0;

uniform int Bilibili
<
	ui_category = AUTHOR;
	ui_type = "list";
	ui_items = "https://space.bilibili.com/2122119709\0";
	ui_label = "bilibili";
	ui_tooltip = "空间里有视频教程喵~";
> = 0;

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

texture Crosshair_Texture_KovaaK	<source="KovaaK-Crosshair.png";>  {Width = 500; Height = 500; Format = RGBA8;};
texture Grenade_Texture_FOV90	 	<source="FOV90.png";>  			  {Width = 1920; Height = 1080; Format = RGBA8;};
texture Grenade_Texture_FOV100		<source="FOV100.png";> 			  {Width = 1920; Height = 1080; Format = RGBA8;};
texture Grenade_Texture_FOV104		<source="FOV104.png";>			  {Width = 1920; Height = 1080; Format = RGBA8;};
texture Grenade_Texture_FOV106		<source="FOV106.png";>			  {Width = 1920; Height = 1080; Format = RGBA8;};
texture Grenade_Texture_FOV110		<source="FOV110.png";> 			  {Width = 1920; Height = 1080; Format = RGBA8;};
texture Grenade_Texture_FOV120		<source="FOV120.png";> 			  {Width = 1920; Height = 1080; Format = RGBA8;};
sampler	Crosshair_Sampler_KovaaK  	{Texture = Crosshair_Texture_KovaaK;};
sampler	Grenade_Sampler_FOV90  		{Texture = Grenade_Texture_FOV90;};
sampler	Grenade_Sampler_FOV100 		{Texture = Grenade_Texture_FOV100;};
sampler	Grenade_Sampler_FOV104 		{Texture = Grenade_Texture_FOV104;};
sampler	Grenade_Sampler_FOV106 		{Texture = Grenade_Texture_FOV106;};
sampler	Grenade_Sampler_FOV110 		{Texture = Grenade_Texture_FOV110;};
sampler	Grenade_Sampler_FOV120 		{Texture = Grenade_Texture_FOV120;};

float4 VS_Crosshair(uint vid : SV_VertexID, out float2 texcoord : TexCoord) : SV_POSITION
{
  	texcoord.y = vid % 2, texcoord.x = vid / 2;
  	return float4((texcoord.x*2-1.)*Crosshair_Width*BUFFER_RCP_WIDTH,(1.-texcoord.y*2)*Crosshair_Height*BUFFER_RCP_HEIGHT,0,1);
}

float4 PS_Crosshair(float4 pos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	if (Crosshair_Flag)
	{
		switch (Crosshair_Display)
		{
			case 0:if (Mouse_Right) {return tex2D(Crosshair_Sampler_KovaaK, texcoord);} break;
			case 1:if (Mouse_Left) {return tex2D(Crosshair_Sampler_KovaaK, texcoord);} break;
			case 2:if (Mouse_Left || Mouse_Right) {return tex2D(Crosshair_Sampler_KovaaK, texcoord);} break;
			case 3:return tex2D(Crosshair_Sampler_KovaaK, texcoord);
		}
	}
	return 0;
}

float4 PS_Grenade(float4 pos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	if (Grenade_Flag && Mouse_Left || Grenade_Display)
	{
		switch (Grenade_FOV)
		{
			case 0:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV90, texcoord),tex2D(Grenade_Sampler_FOV90, texcoord).a*Grenade_Opacity);
			case 1:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV100, texcoord),tex2D(Grenade_Sampler_FOV100, texcoord).a*Grenade_Opacity);
			case 2:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV104, texcoord),tex2D(Grenade_Sampler_FOV104, texcoord).a*Grenade_Opacity);
			case 3:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV106, texcoord),tex2D(Grenade_Sampler_FOV106, texcoord).a*Grenade_Opacity);
			case 4:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV110, texcoord),tex2D(Grenade_Sampler_FOV110, texcoord).a*Grenade_Opacity);
			case 5:return lerp(tex2D(ReShade::BackBuffer, texcoord),tex2D(Grenade_Sampler_FOV120, texcoord),tex2D(Grenade_Sampler_FOV120, texcoord).a*Grenade_Opacity);
		}
	}
	return lerp(tex2D(ReShade::BackBuffer, texcoord),0,0);
}

technique ApexReticle
<
	ui_label = "APEX准星";
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
	pass GrenadePass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_Grenade;
	}
}