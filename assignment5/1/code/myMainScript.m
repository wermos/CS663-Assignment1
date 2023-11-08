sigma_noise = 20;
dimensions = [256;256];
size_patch = 7;
size_neighborhood = 31;
K = 200;
sigma_spatial = [3 6];
sigma_range = [15 30];
sigma_bilateral = [sigma_spatial; sigma_range];

image_names = ["barbara256", "stream"]
for image_name = image_names
    process(image_name, sigma_noise, sigma_bilateral, dimensions, size_patch, size_neighborhood, K);
end

function [] = process(image_name, sigma_noise, sigma_bilateral, dimensions, size_patch, size_neighborhood, K)
    image = imread("../images/"+ image_name +".png");
    % Image Cropping
    image = image(1:dimensions(1), 1:dimensions(2));
    image = double(image);
    
    % Noisy image generation   
    rng(0);
    image_with_gaussian_noise = gaussian_noise_adder(image, 0, sigma_noise);
    filename = "../images/" + image_name + ",σ_noise" + string(sigma_noise) + ".png";
    save_image(image_with_gaussian_noise, filename);

    % ---------------- a) --------------------
    % image_output = myPCADenoising1(image, size_patch);
    % ---------------- b) --------------------
    % image_output = myPCADenoising2(image, size_patch, size_neighborhood, K);
    % ---------------- c) --------------------
    % Apply bilateral on original image
    for sigma_spatial_range = sigma_bilateral
        image_output = mybilateralfilter(image, sigma_spatial_range);
        filename = "../images/" + image_name + ",σ_spatial" + string(sigma_spatial_range(1)) + ",σ_range" + string(sigma_spatial_range(2)) + ".png";
        save_image(image_output, filename);
    end
    % Apply bilateral on noisy image
    for sigma_spatial_range = sigma_bilateral
        image_output = mybilateralfilter(image_with_gaussian_noise, sigma_spatial_range);
        filename = "../images/" + image_name + ",σ_noise" + string(sigma_noise) + ",σ_spatial" + string(sigma_spatial_range(1)) + ",σ_range" + string(sigma_spatial_range(2)) + ".png";
        save_image(image_output, filename);
    end
end

function image_with_gaussian_noise = gaussian_noise_adder(image_input, mean, sigma)
    image_with_gaussian_noise = image_input + normrnd(mean, sigma, size(image_input));
end

function image_integer = image_double_to_integer(image_double)
    image_double(image_double < 0) = 0;
    image_double(image_double > 255)= 255;
    image_integer = uint8(image_double);
end

function [] = save_image(image, filename)
    image = image_double_to_integer(image);
    imwrite(image, filename);
end