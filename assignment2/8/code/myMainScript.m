sigma_spatial = [2 0.1 3];
sigma_range = [2 0.1 15];
sigma_spatial_range = [sigma_spatial; sigma_range];
sigma_noise = [5 10];

process("barbara256", sigma_spatial_range, sigma_noise);
process("kodak24", sigma_spatial_range, sigma_noise);

function [] = process(image_name, sigma_spatial_range, sigma_noise)
    image = imread("../images/"+ image_name +".png");
    image = double(image);
    
    % Apply bilateral on original image
    for sigma = sigma_spatial_range
        image_output = mybilateralfilter(image, sigma);
        filename = "../images/" + image_name + ",σ_spatial" + string(sigma(1)) + ",σ_range" + string(sigma(2)) + ".png";
        save_image(image_output, filename);
    end

    % Apply bilateral on noisy image
    for noise = sigma_noise
        rng(0);
        image_with_gaussian_noise = gaussian_noise_adder(image, 0, noise);
        filename = "../images/" + image_name + ",σ_noise" + string(noise) + ".png";
        save_image(image_with_gaussian_noise, filename);
        for sigma = sigma_spatial_range
            image_output = mybilateralfilter(image_with_gaussian_noise, sigma);
            filename = "../images/" + image_name + ",σ_noise" + string(noise) + ",σ_spatial" + string(sigma(1)) + ",σ_range" + string(sigma(2)) + ".png";
            save_image(image_output, filename);
        end
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
    imwrite(image, filename)
end