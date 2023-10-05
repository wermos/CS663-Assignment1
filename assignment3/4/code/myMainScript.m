img = zeros(201, 201);
img(101, :) = 255 * ones(1, 201);

imwrite(img, "../images/raw_img.png");

transform = fftshift(fft2(img));

log_transform = log(abs(transform) + 1);

output = imagesc(log_transform);

colormap('jet'); colorbar;

saveas(output, "../images/fft.png");