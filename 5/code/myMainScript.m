%% MyMainScript

% tic;
%% Your code here



img1 = imread("..\images\goi1.jpg");
img2 = imread("..\images\goi2_downsampled.jpg");
img1 = double(img1);
img2 = double(img2);
number_of_control_points = 12;
% x1 = zeros(1, number_of_control_points);
% x2 = zeros(1,number_of_control_points);
% y1 = zeros(1,number_of_control_points);
% y2 = zeros(1,number_of_control_points);
% 
% 
% input of control points
 for i=1:number_of_control_points
    figure(1); 
    imshow(img1/255);
    [x1(i), y1(i)] = ginput(1);
    figure(2);
    imshow(img2/255);
    [x2(i), y2(i)] = ginput(1);
end


% caluclate A matrix
% create P1 and P2 matrix and calculate Transformation(A) matrix
temp = ones(1,number_of_control_points);
P_1 = [x1;y1;temp];
P_2 = [x2;y2;temp];

A = P_2*pinv(P_1); % A converts P1(img1) to P2(img2)

[m,n] = size(img1);
img3 = zeros(m,n); % transformed image
img4 = zeros(m,n); % transformed image

for i=1:m
    for j=1:n
        arr = A\([i;j;1]);      % reverse wrapping

        % use nearest neighbour
        [fx,fy] = nearest_neighbour(arr(1), arr(2)); % nearest neightbour
        if(fx >= 1 && fx <=m && fy >=1 && fy <= n)
            img3(i,j) = img1(fx,fy); % copy intensity values
        end

        % use bilinear
        img4(i,j) = bilinear_interpolation(arr(1), arr(2),m,n,img1);
    end
end

C = imfuse(img2/255, img3/255);
D = imfuse(img2/255, img4/255);
figure(3);
imshow(C);
figure(4);
imshow(D);
figure(5);
imshow(img3/255); % transformed image using nearest neighbour
figure(6);
imshow(img4/255); % transformed image using bilinear interpolation

img2(img2 < 0) = 0; img2(img2 > 255)= 255; img2 = uint8(img2);
imwrite(img2,"..\images\b.jpg"); % before using imwrite, you MUST conver the image into uint8 format!

img3(img3 < 0) = 0; img3(img3 > 255)= 255; img3 = uint8(img3);
imwrite(img3,"..\images\c.jpg"); % before using imwrite, you MUST conver the image into uint8 format!

img4(img4 < 0) = 0; img4(img4 > 255)= 255; img4 = uint8(img4);
imwrite(img4,"..\images\d.jpg"); % before using imwrite, you MUST conver the image into uint8 format!

% function to find nearest neighbour
function [fx,fy] = nearest_neighbour(x,y)
    fx = round(x);
    fy = round(y);
end

function i = bilinear_interpolation(x, y,m,n,img1)

    x_ceil = max(1,min(m,ceil(x)));
    x_floor = max(1,min(m,floor(x)));

    y_ceil = max(1,min(n,ceil(y)));
    y_floor = max(1,min(n,floor(y)));

    i = (y_ceil-y)*(x_ceil-x)*img1(x_floor, y_floor) + (y_ceil-y)*(x-x_floor)*img1(x_ceil, y_floor) + (y-y_floor)*(x_ceil-x)*img1(x_floor, y_ceil) + (y-y_floor)*(x-x_floor)*img1(x_ceil, y_ceil);

end










% toc;