J1 = double(imread("T1.jpg"));
J2 = double(imread("T2.jpg"));
J3 = imrotate(J2, 28.5, "bilinear", "crop");

X = linspace(-45, 45, 91);

ncc_values = arrayfun(@NCCHelper, X);
joint_entropy_values = arrayfun(@JointEntropyHelper, X);
qmi_values = arrayfun(@QMIHelper, X);

% plot(X, ncc_values, X, joint_entropy_values, X, qmi_values)

plot(X, ncc_values);
saveas(gcf, "ncc.png");

plot(X, joint_entropy_values);
saveas(gcf, "je.png");

plot(X, qmi_values);
saveas(gcf, "qmi.png");

function ncc = NCCHelper(angle)
    global J1;
    global J2;
    global J3;

    J4 = imrotate(J3, angle, "bilinear", "crop");
    ncc = NCC(J1, J4);
end

function je = JointEntropyHelper(angle)
    global J1;
    global J2;
    global J3;

    J4 = imrotate(J3, angle, "bilinear", "crop");
    je = JointEntropy(J1, J4);
end

function qmi = QMIHelper(angle)
    global J1;
    global J2;
    global J3;

    J4 = imrotate(J3, angle, "bilinear", "crop");
    qmi = QMI(J1, J4);
end