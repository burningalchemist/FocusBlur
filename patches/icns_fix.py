#!/usr/bin/env python3
import os, json, subprocess, shutil

appiconset = "Sources/FocusBlur/Assets.xcassets/AppIcon.appiconset"  # Update path if needed
iconset = "AppIcon.iconset"

with open(os.path.join(appiconset, "Contents.json")) as f:
    data = json.load(f)

os.makedirs(iconset, exist_ok=True)

for img in data.get("images", []):
    filename = img.get("filename")
    size = img.get("size")
    scale = img.get("scale", "1x")
    
    if not filename or not os.path.exists(os.path.join(appiconset, filename)):
        continue
        
    width = int(float(size.split("x")[0]))
    
    if scale == "1x":
        out_name = f"icon_{width}x{width}.png"
    elif scale == "2x":
        out_name = f"icon_{width}x{width}@2x.png"
    else:
        continue
        
    shutil.copyfile(os.path.join(appiconset, filename), os.path.join(iconset, out_name))

subprocess.run(["iconutil", "-c", "icns", iconset])
shutil.rmtree(iconset)
