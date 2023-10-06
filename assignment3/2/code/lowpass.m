% : Read and display the original image
original_image = imread('../images/ori.png');

figure;
subplot(1, 3, 1);
imshow(original_image/255);
title('Original Image');

%  Compute the 2D Fourier Transform of the image
fft_image = fft2(original_image);
fft_image_shifted = fftshift(fft_image); % Shift the zero frequency components to the center

% Create the ideal low-pass filter
D1 = 40; % Cutoff frequency for the ideal filter (can change)
ideal_filter = zeros(size(original_image));
[x, y] = meshgrid(1:size(original_image, 2), 1:size(original_image, 1));
center_x = size(original_image, 2) / 2;
center_y = size(original_image, 1) / 2;
ideal_filter(sqrt((x - center_x).^2 + (y - center_y).^2) <= D1) = 1;


% appropriately pad the matrices
ideal_padded_image = padarray(ideal_filter, [ceil(size(original_image,1)/2), ceil(size(original_image,2)/2)], 0, 'both');
original_image_padded_ideal = padarray(original_image, [ceil(size(ideal_filter,1)/2), ceil(size(ideal_filter,2)/2)], 0, 'both');


% Compute the 2D Fourier Transform of the image
fft_image_ideal = fft2(original_image_padded_ideal);
fft_image_shifted_ideal = fftshift(fft_image_ideal);

% Step 4: Create the Gaussian low-pass filter without using fspecial
sigma1 = 40; % Standard deviation for the Gaussian filter(can change)
filter_size = 2 * ceil(3 * sigma1) ; % Filter size based on sigma

[x, y] = meshgrid(-(filter_size-1)/2:(filter_size-1)/2, -(filter_size-1)/2:(filter_size-1)/2);

gaussian_filter = exp(-(x.^2 + y.^2) / (2 * sigma1^2));
gaussian_filter = gaussian_filter / sum(gaussian_filter(:)); % Normalize the filter

% appropriately pad the matrices
gaussian_padded_image = padarray(gaussian_filter, [floor(size(original_image,1)/2), floor(size(original_image,2)/2)], 0, 'both');
original_image_padded_gaussian = padarray(original_image, [ceil(size(gaussian_filter,1)/2), ceil(size(gaussian_filter,2)/2)], 0, 'both');
% Compute the 2D Fourier Transform of the image
fft_image_gaussian = fft2(original_image_padded_gaussian);
fft_image_shifted_gaussian = fftshift(fft_image_gaussian);

% Apply the filters in the frequency domain
filtered_image_ideal = ifft2(ifftshift(fft_image_shifted_ideal .* ideal_padded_image));
filtered_image_gaussian = ifft2(ifftshift(fft_image_shifted_gaussian .* gaussian_padded_image));

% recover back the image portion
filtered_image_ideal = filtered_image_ideal(floor(size(original_image,1)/2) +1: end - floor(size(original_image,1)/2) -1, floor(size(original_image,2)/2) +1: end - floor(size(original_image,2)/2) -1 );
filtered_image_gaussian = filtered_image_gaussian(floor(size(gaussian_filter,1)/2) +1: end - floor(size(gaussian_filter,1)/2)-1, floor(size(gaussian_filter,2)/2) +1: end - floor(size(gaussian_filter,2)/2) -1 );

%fourier response of filtered images
fourier_ideal = fft_image_shifted_ideal .* ideal_padded_image;
fourier_ideal = fourier_ideal(floor(size(original_image,1)/2) +1: end - floor(size(original_image,1)/2)-1, floor(size(original_image,2)/2) +1: end - floor(size(original_image,2)/2) -1 );

fourier_gaussian = fft_image_shifted_gaussian .* gaussian_padded_image;
fourier_gaussian = fourier_gaussian(floor(size(gaussian_filter,1)/2) +1: end - floor(size(gaussian_filter,1)/2)-1, floor(size(gaussian_filter,2)/2) +1: end - floor(size(gaussian_filter,2)/2) -1 );




% Display the filtered images
subplot(1, 3, 2);
imshow(abs(filtered_image_ideal)/255, []);
title('Ideal Low-Pass ');

subplot(1, 3, 3);
imshow(abs(filtered_image_gaussian)/255, []);
title('Gaussian Low-Pass ');


% Display the log absolute Fourier transforms of the original and filtered images
figure;
subplot(1, 3, 1);
imshow(log(abs(fft_image_shifted) + 1), []);
title('Log Fourier Transform (Original)');colormap('jet'); colorbar;

subplot(1, 3, 2);
imshow((log(abs((fourier_ideal))) + 1), []);
title('Log Fourier Transform (Ideal Low-Pass)');colormap('jet'); colorbar;

subplot(1, 3, 3);
imshow(log(abs((fourier_gaussian)) + 1), []);colormap('jet'); colorbar;
title('Log Fourier Transform (Gaussian Low-Pass)');

% Display the frequency responses of the filters
figure;
subplot(1, 2, 1);
imshow(log(abs((ideal_filter)) + 1), []); 
title('Gaussian Low-Pass Filter Frequency Response ');colormap('jet'); colorbar;

subplot(1, 2, 2);
imshow(log(abs((gaussian_filter)) + 1), []);
title('Gaussian Low-Pass Filter Frequency Response ');colormap('jet'); colorbar;


