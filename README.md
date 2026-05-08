# PIV Image Pre-Processing (MATLAB)

A MATLAB toolkit for PIV/PTV image pre-processing, including normalization, adaptive enhancement, background subtraction, masking, and particle detection.

## Requirements

- MATLAB R2019b+ recommended
- MATLAB R2014b+ minimum for modern parallel APIs (`parpool`)
- Image Processing Toolbox (required)
- Parallel Computing Toolbox (optional)
- Image Acquisition Toolbox (optional, for video workflows)

## Quick Start

1. Open MATLAB in the repository root.
2. Run:
   ```matlab
   PIVPreProcess
   ```
3. Select a pipeline and an input directory.
4. Processed images are written to `Pre_Processed/` under the selected input folder.

## Pipelines

- `pipelines/RunSlidingMinMaxPipeline.m`
  - Sliding-min background suppression + local min-max normalization.
- `pipelines/RunAdaptiveBandPassPipeline.m`
  - Adaptive histogram equalization (CLAHE) with optional band-pass filtering.
- `pipelines/RunBackgroundSubtraction.m`
  - Pairwise background subtraction and normalization (`median` or `minmax` mode).

## Entry Points

- `PIVPreProcess.m` (recommended unified entry)
- Legacy wrappers:
  - `PIV_ImagePreProcessing.m`
  - `PIV_ImagePreProcessing_AdaptiveBandPass.m`

## Folder Structure

- `pipelines/` High-level reusable workflows
- `functions/` Core image processing utilities
  - `filters/`
  - `normalization/`
  - `background/`
  - `masking/`
  - `particleDetection/`
- `examples/` Example scripts for each pipeline
- `tests/` MATLAB unit tests
- `archive/` Legacy debug/development scripts

## Running Tests

```matlab
runAllTests
```
