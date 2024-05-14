# ApexReticle

这是一个易于使用、可自定义、支持中文、基于ReShade、为Apex Legends开发的准星插件

## 安装ReShade

1. 进入[Reshade官网](https://reshade.me/)
2. 点击`Download`，选择`Download ReShade X.X.X`
3. 打开下载得到的`ReShade_Setup_X.X.X.exe`
4. 选择列表中的`Apex Legends (r5apex.exe)`，点击`Next`  
   如果列表中没有`Apex Legends (r5apex.exe)`，点击`Browse...`，进入游戏根目录，然后选择`r5apex.exe`，点击`Next`
5. 选择`Microsoft® DirectX® 10/11/12`，点击`Next`
6. 如果这是你第一次为游戏安装ReShade，这里应当出现的界面是`Select effects to install`，点击`Uncheck all`，然后点击`Next`  
   如果以前你曾为游戏安装过ReShade，这里出现的界面可能会是`Select the operation to perform:`，建议选择`Uninstall ReShade and effects`，然后点击`Next`,之后点击`Back`，再重复`步骤4~6`
7. 等待下载完成，然后点击`Finish`

## 安装ApexReticle

1. 下载ApexReticle[最新发行版](https://github.com/roundRekt/ApexReticle/releases/latest/download/ApexReticle.zip)
2. 打开游戏根目录  
   Steam端：打开`Steam-库-ApexLegends`，点击`设置`（右侧齿轮图标），选择`管理`，选择`浏览本地文件`  
   EA端：打开`EA-ApexLegends`，点击`管理`，选择`查看属性`，点击`浏览`
3. 将`ApexReticle.zip`中的`reshade-shaders`文件夹拖入游戏根目录

## 设置ApexReticle

1. 启动`Apex Legends`
2. 点击键盘上的`Home`键（默认的ReShade设置面板切换键）以打开设置面板
3. 继续或跳过教程
4. 勾选插件列表中的`APEX准星`
5. 更改下方的设置选项
6. 再次点击键盘上的`Home`键（默认的ReShade设置面板切换键）以关闭设置面板

## 自定义准星

1. 进入[Koovak's准星生成器](https://crosshair.themeta.gg/)，制作一个喜爱的准星，并点击下方的`DOWNLOAD CROSSHAIR PNG`下载准星图片
2. 对着下载好的图片右键，选择`属性-详细信息`，查看图片的`宽度`和`高度`
3. 将准星图片复制到`游戏根目录/reshade-shaders/Textures/`并覆盖
4. 如果更新准星时游戏正在运行，点击键盘上的`Home`键（默认的ReShade设置面板切换键），然后点击下方的`重新加载`
5. 在设置选项中调整自定义准星的宽度和高度（建议设置为`步骤2`中的`宽度`和`高度`）
6. 如果需要将其他来源的图片设置为准星，请将图片文件名修改为`KovaaK-Crosshair.png`，然后进行`步骤2~5`，图片的宽度和高度不应超过`500像素`

## 建议和反馈

 * 如果有建议或者反馈欢迎在bilibili私信我或者在视频下留言
 * 我会继续维护项目并更新一些新功能
 * [GitHub](https://github.com/roundRekt)
 * [bilibili](https://space.bilibili.com/2122119709)
