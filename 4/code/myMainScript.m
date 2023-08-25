J1 = double(imread("T1.jpg"));
J2 = double(imread("T2.jpg"));

J3 = imrotate(J2, 28.5);

for angle = -45:1:45 % start, increment, end
    J4 = imrotate(J3, angle);

    ncc = normxcorr2(J3, J4)
    je = 
    qmi = 
end