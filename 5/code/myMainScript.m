%% MyMainScript

% tic;
%% Your code here







img1 = imread("images/goi1.jpg");
img2 = imread("images/goi2_downsampled.jpg");

img1 = double(img1);
img2 = double(img2);
x1 = zeros(1, 12);
x2 = zeros(1,12);
y1 = zeros(1,12);
y2 = zeros(1,12);


% input of control points
 for i=1:12
     figure(1); 
     imshow(img1/255);
    [x1(i), y1(i)] = ginput(1);
     figure(2);
    imshow(img2/255);
     [x2(i), y2(i)] = ginput(1);
end


% caluclate A matrix
%create P1 and P2 matrix and calculate Transformation(A) matrix
temp = ones(1,12);
P_1 = [x1;y1;temp];
P_2 = [x2;y2;temp];

A = P_2*pinv(P_1); % A converts P1(img1) to P2(img2)

% A(2,3) = 0;
% A(1,3) = 0;
% % A = [1.04650777759100,	0.00420484987313417,	22.1284245689161;
% % -0.0588679277839662,	0.99,	20.1924796652928;
% % 0,	0,	1];




[m,n] = size(img1);
img3 = zeros(m,n); % transformed image

for i=1:m
    for j=1:n
        arr = A\([i,j,1])';      % reverse wrapping



        % use nearest neighbour
        [fx,fy] = foo(arr(1), arr(2)); % nearest neightbour
        if(fx >= 1 && fx <=m && fy >=1 && fy <= n)
            img3(i,j) = img1(fx,fy); % copy intensity values
        end

        % % use bilinear
        % k = foo2(arr(1), arr(2),m,n,img1);
        % img3(i,j) = k;
    end
end



% %use inbuilt
% P1 =[x1;y1]';
% P2 =[x2;y2]';
% 
% A= fitgeotform2d(P1,P2,"similarity");
% Rfixed = imref2d(size(img2));
% 
% img3 = imwarp(img1,A,OutputView=imref2d(size(img2)));

figure(3);
% C = imfuse(img1/255, img3/255,'falsecolor','Scaling','joint','ColorChannels',[1,2,0]); % overlayed
C = imfuse(img2/255, img3/255);
imshow(C);
figure(4);
imshow(img3/255); % transformed image



% function to find nearest neighbour
function [fx,fy] = foo(x,y)

fx = round(x);
fy = round(y);

end

function i = foo2(x, y,m,n,img1)


x_ceil = ceil(x);
x_floor = floor(x);

y_ceil = ceil(y);
y_floor = floor(y);

if(x_ceil > m)
    x_ceil = m;
end

if(y_ceil > n)
    y_ceil = n;
end

if(x_floor < 1)
    x_floor = 1;
end

if(y_floor < 1)
    y_floor = 1;
end

if(x_ceil < 1)
    x_ceil = 1;
end

if(y_ceil < 1)
    y_ceil = 1;
end

if(x_floor > m)
    x_floor = m;
end

if(y_floor > n)
    y_floor = n;
end

i = (y_ceil - y)/(y_ceil - y_floor)*((x_ceil - x)/ (x_ceil - x_floor)*img1(x_floor, y_floor) + (x - x_floor)/(x_ceil - x_floor)*img1(x_ceil, y_floor)) + (y - y_floor)/(y_ceil - y_floor)*((x_ceil - x)/(x_ceil - x_floor)*img1(x_floor, y_ceil) + (x - x_floor)/(x_ceil - x_floor)*img1(x_ceil, y_ceil));

end















% toc;
