#include "PainterEngine/PainterEngine.h"

px_texture tex;
PX_Object *canvas_root;
PX_CanvasVM canvasvm;
PX_Object *Canvas, *Layer, *PainterBox, *Menu;
px_byte data[16 * 1024 * 1024];

 px_void PX_MenuExecuteOnOpenFile(px_void *buffer, px_int size, px_void *userPtr)
{
    // 打开并导入文件
    PX_CanvasVMImport(&canvasvm, buffer, size);
}

px_void PX_MenuExecuteOpenFile(px_void *userPtr)
{
    // 打开文件对话框
    PX_RequestData("open", data, sizeof(data), userPtr, PX_MenuExecuteOnOpenFile);
}

px_void PX_MenuExecuteExportSaveFile(px_void *userPtr)
{
    // 保存文件
    px_memory data;
    PX_MemoryInitialize(mp_static, &data);
    PX_CanvasVMExport(&canvasvm, &data);
    PX_RequestData("download:PainterEngine.pe", data.buffer, data.usedsize, userPtr, 0);
    PX_MemoryFree(&data);
}

px_void PX_MenuExecuteExportPngFile(px_void *userPtr)
{
    // 导出为png图片
    px_memory data;
    PX_MemoryInitialize(mp_static, &data);
    PX_CanvasVMExportAsPng(&canvasvm, &data);
    PX_RequestData("download:image.png", data.buffer, data.usedsize, userPtr, 0);
    PX_MemoryFree(&data);
}

int main()
{
    PX_IO_Data data;
    PainterEngine_Initialize(1200, 600);
    PainterEngine_SetBackgroundColor(PX_COLOR(255, 224, 224, 224));

    // Canvas虚拟机
    PX_CanvasVMInitialize(mp, &canvasvm, 600, 600, App.runtime.surface_width - 224 - 200, App.runtime.surface_height - 128);
    canvas_root = PX_ObjectCreate(mp, root, 0, 0, 0, 0, 0, 0);

    // 调色板
    PainterBox = PX_Object_PainterBoxCreate(mp, canvas_root, 0, 28, &canvasvm);

    // 图层
    Layer = PX_Object_LayerBoxCreate(mp, canvas_root, App.runtime.surface_width - 196, 64, 0, &canvasvm);

    // 画板
    Canvas = PX_Object_CanvasCreate(mp, canvas_root, 200, 64, &canvasvm);

    // 菜单
    Menu = PX_Object_MenuCreate(mp, canvas_root, 0, 0, 128, 0);
    PX_Object_MenuAddItem(Menu, 0, "Open File", PX_MenuExecuteOpenFile, 0);
    PX_Object_MenuAddItem(Menu, 0, "Save File", PX_MenuExecuteExportSaveFile, 0);
    PX_Object_MenuAddItem(Menu, 0, "Export to PNG file", PX_MenuExecuteExportPngFile, 0);

    // 示范:加载绘制的文件
    data = PX_LoadFileToIOData("assets/PainterEngine.pe");
    if (data.size)
        PX_CanvasVMImport(&canvasvm, data.buffer, data.size);

    PX_FreeIOData(&data);

    return 0;
}
