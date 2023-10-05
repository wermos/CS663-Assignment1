img = zeros(201, 201);
img(101, :) = 255 * ones(1, 201);

transform = fftshift(fft2(img));

transformed_img = log(abs(transform));

imagesc(transformed_img);

colorbar