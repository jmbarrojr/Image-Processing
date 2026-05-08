function [Sub_rAfinal, Sub_rBfinal] = BackgroundSubNormalization(A, B, Win)
%BACKGROUNDSUBNORMALIZATION Backward-compatible wrapper.
%
% [Sub_rAfinal, Sub_rBfinal] = BackgroundSubNormalization(A, B, Win)
%
% OIST - 2026
% see also: BackgroundSubtractNormalize

[Sub_rAfinal, Sub_rBfinal] = BackgroundSubtractNormalize(A, B, Win, 'Method', 'median');
