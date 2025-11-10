## Q:
Understand a basic hybrid computer vision pipeline combining traditional and AI methods.
Use traditional techniques for image preparation (pre-processing/segmentation).
Use a pre-trained Convolutional Neural Network (CNN) for image classification (AI component).
Analyze how the combination of methods improves results over using just one approach.

Pipeline overview: Traditional step segments the object (k-means in Lab* + morphology), then a pre-trained SqueezeNet classifies.

Why hybrid helps: Removing background clutter focuses the CNN on the object → often higher top-1 confidence (and sometimes a better label).

Results (example):

Raw input: Top-1 = <label>, confidence = xx.xx%

Isolated input: Top-1 = <label>, confidence = yy.yy%

ΔConfidence = yy.xx - xx.xx percentage points (improvement).

Visual evidence: (If Grad-CAM used) Heatmaps show attention moving from background to the segmented object after preprocessing.

Limitations: k-means may mis-segment in low contrast scenes; try different nColors, or add spatial priors / superpixels for tougher images.

<img width="1295" height="690" alt="image" src="https://github.com/user-attachments/assets/dd39e4f1-92d4-4a79-abbd-49eb08b02245" />

<img width="1093" height="551" alt="image" src="https://github.com/user-attachments/assets/d6374d0c-8c14-4ca9-9fe9-4e0e7705c953" />
