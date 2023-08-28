J1 = double(imread("T1.jpg"));
J2 = double(imread("T2.jpg"));
J3 = imrotate(J2, 28.5, "bilinear", "crop");

X = linspace(-45, 45, 91);

ncc_values = arrayfun(@NCCHelper, X);
joint_entropy_values = arrayfun(@JointEntropyHelper, X);
qmi_values = arrayfun(@QMIHelper, X);

plot(X, ncc_values);
saveas(gcf, "ncc.pdf");

plot(X, joint_entropy_values);
saveas(gcf, "je.pdf");

plot(X, qmi_values);
saveas(gcf, "qmi.pdf");

[~, index] = min(joint_entropy_values);

% 1st element corresponds to -45 degrees, so -45. We add the index. Then,
% we subtract 1 because indexing in MATLAB starts at 1.
best_angle = -45 + index - 1;

closest_image = imrotate(J3, best_angle, "bilinear", "crop");

jh = JointHistogram(J1, J4);

histogram = imagesc(jh)
colorbar

saveas(histogram, "histogram.pdf");

function ncc = NCCHelper(angle)
    global J1;
    global J3;

    J4 = imrotate(J3, angle, "bilinear", "crop");
    ncc = NCC(J1, J4);
end

function je = JointEntropyHelper(angle)
    global J1;
    global J3;

    J4 = imrotate(J3, angle, "bilinear", "crop");
    je = JointEntropy(J1, J4);
end

function qmi = QMIHelper(angle)
    global J1;
    global J3;

    J4 = imrotate(J3, angle, "bilinear", "crop");
    qmi = QMI(J1, J4);
end