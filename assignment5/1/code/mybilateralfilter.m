function image_output = mybilateralfilter(image_input, sigma)
    sigma_s = sigma(1);
    sigma_r = sigma(2);
    [number_of_rows, number_of_columns] = size(image_input);
    image_output = zeros(number_of_rows, number_of_columns);
    threshold_spatial = ceil(3*sigma_s); % 3σ
    filter_size = 2*threshold_spatial+1;
    image_pad = padarray(image_input, [threshold_spatial, threshold_spatial]);
    [X,Y] = meshgrid(-threshold_spatial:threshold_spatial,-threshold_spatial:threshold_spatial);
    gaussian_spatial = exp(-(X.^2+Y.^2)./(2*sigma_s^2));

    for i = 1:number_of_rows
        for j = 1:number_of_columns
            image_window = image_pad(i:i+filter_size-1, j:j+filter_size-1);
            gaussian_range = exp(-((image_window-image_input(i,j)).^2)./(2*sigma_r^2));
            bilateral_filter = gaussian_spatial.*gaussian_range;
            bilateral_filter = bilateral_filter./sum(bilateral_filter(:));
            bilateral_filter = bilateral_filter.*image_window;
            image_output(i,j) = sum(bilateral_filter(:));
        end
    end
end