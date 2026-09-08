import zipfile
import os
import shutil

template_zip = "C:/Users/Dejunai/AppData/Roaming/Godot/export_templates/4.7.2.stable/web_nothreads_release.zip"
out_dir = "builds/web"

os.makedirs(out_dir, exist_ok=True)

with zipfile.ZipFile(template_zip, "r") as z:
    for filename in z.namelist():
        print("Template contains:", filename)
        if filename.endswith(".wasm"):
            with z.open(filename) as src, open(os.path.join(out_dir, "index.wasm"), "wb") as dst:
                shutil.copyfileobj(src, dst)
            print("Extracted -> index.wasm")
        elif filename.endswith(".js"):
            with z.open(filename) as src, open(os.path.join(out_dir, "index.js"), "wb") as dst:
                shutil.copyfileobj(src, dst)
            print("Extracted -> index.js")
        elif filename.endswith(".html"):
            with z.open(filename) as src:
                content = src.read().decode("utf-8")
            # Replace placeholder if present
            content = content.replace("$GODOT_BASENAME", "index")
            content = content.replace("$GODOT_PROJECT_NAME", "Three Colors of Madness")
            content = content.replace("$GODOT_HEAD_INCLUDE", "")
            with open(os.path.join(out_dir, "index.html"), "w", encoding="utf-8") as dst:
                dst.write(content)
            print("Extracted & configured -> index.html")

print("Web export bundle successfully assembled in:", out_dir)
