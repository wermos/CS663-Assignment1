%% MyMainScript

tic;
%% Your code here






img1 = imread("goi1.jpg");
img2 = imread("goi2_downsampled.jpg");
img1 = double(img1);
img2 = double(img2);
x1 = zeros(1, 12);
x2 = zeros(1,12);
y1 = zeros(1,12);
y2 = zeros(1,12);


% input of control points
 for i=1:16
     figure(1); 
     imshow(img1/255);
    [x1(i), y1(i)] = ginput(1);
     figure(2);
    imshow(img2/255);
     [x2(i), y2(i)] = ginput(1);
end

% create P1 and P2 matrix and calculate Transformation(A) matrix
temp = ones(1,16);
 P_1 = [x1;y1;temp];
 P_2 = [x2;y2;temp];

A = P_2*P_1'/(P_1*P_1'); % A converts P1(img1) to P2(img2)



[m,n] = size(img1);
img3 = zeros(m,n); % transformed image

for i=1:m
    for j=1:n
        arr = A\([i,j,1])';      % reverse wrapping

        [fx,fy] = foo(arr(1), arr(2)); % nearest neightbour
        if(fx >= 1 && fx <=m && fy >=1 && fy <= n)
            img3(i,j) = img1(fx,fy); % copy intensity values
        end
    end
end

figure(3);
C = imfuse(img1/255, img3/255);
imshow(C);
figure(4);
imshow(img3/255);



% function to find nearest neighbour
function [fx,fy] = foo(x,y)

x_ceil = ceil(x);
x_floor = floor(x);

y_ceil = ceil(y);
y_floor = floor(y);

if(abs(x_ceil - x) < abs( x_floor - x))
    fx = x_ceil;
else
    fx = x_floor;
end

if(abs(y_ceil - y) < abs( y_floor - y))
    fy = y_ceil;
else
    fy = y_floor;
end

end






toc;
