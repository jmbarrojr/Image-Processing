function B = IntensityCapping(A,ROI)
%
% Input Image needs to be double

B = A;
b = B(ROI(2):ROI(4),ROI(1):ROI(3));
Imed = median(b(:));
Istd = std(b(:));
c = 2;
true = B > (Imed + c*Istd);
B(true) = Imed + c*Istd;

