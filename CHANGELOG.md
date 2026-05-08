# Changelog

## 2026-05-08

### Added
- Unified entry point: `PIVPreProcess.m`
- Reusable pipeline functions in `pipelines/`
- Consolidated background API: `BackgroundSubtractNormalize.m`
- Example scripts in `examples/`
- MATLAB unit tests in `tests/`
- `runAllTests.m` test harness

### Changed
- Refactored repository structure into `functions/` categories
- Renamed `PIV_ImagePreProcessing_Adpative_BandPass.m` to `PIV_ImagePreProcessing_AdaptiveBandPass.m`
- Renamed `BackgourndSubtraction_TK.m` to `BackgroundSubtraction_TK.m`
- Replaced `matlabpool` usage with `parpool`/`gcp` in background scripts
- Improved validation and numerical stability in normalization/background functions

### Removed / Archived
- Removed conflict file `PIV_ImagePreProcessing_Adpative_BandPass[Conflict].m`
- Archived debug scripts under `archive/BackgroundSubtraction/`
- Removed duplicate `Copy_of_MinMaxNormalization.m`
