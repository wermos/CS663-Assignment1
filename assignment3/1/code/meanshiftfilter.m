function image_output = meanshiftfilter(image_input, sigma, epsilon)
    sigma_s = sigma(1);
    sigma_r = sigma(2);
    [number_of_rows, number_of_columns] = size(image_input);
    image_output = zeros(number_of_rows, number_of_columns);
    threshold_spatial = ceil(3*sigma_s); % 3σ
    filter_size = 2*threshold_spatial+1;
    image_pad = padarray(image_input, [threshold_spatial, threshold_spatial]);
    [X,Y] = meshgrid(-threshold_spatial:threshold_spatial,-threshold_spatial:threshold_spatial);
    gaussian_spatial_x = exp(-(X.^2)./(2*sigma_s^2));
    gaussian_spatial_y = exp(-(Y.^2)./(2*sigma_s^2));

    for i = 1:number_of_rows
        for j = 1:number_of_columns
            % temp = [i,j]
            image_window = image_pad(i:i+filter_size-1, j:j+filter_size-1);
            v = [i;j;image_input(i,j)];
            while true
                V(:,:,1) = i+X;
                V(:,:,2) = j+Y;
                V(:,:,3) = image_window;
                gaussian_range_I = exp(-((V(:,:,3)-image_input(i,j)).^2)./(2*sigma_r^2));
                mean_shift_filter = gaussian_spatial_x .* gaussian_spatial_y .* gaussian_range_I;
                
                denominator = sum(mean_shift_filter(:));
                mean_shift_filter = V.*mean_shift_filter;
                numerator = sum(mean_shift_filter(:,:,:));
                v_next = (1./denominator).*[sum(numerator(:,:,1));sum(numerator(:,:,2));sum(numerator(:,:,3))];
                mean_shift = norm(v_next-v);
                if (mean_shift < epsilon)
                    break;
                end
                v = v_next;
                image_output(i,j) = v_next(3);
        end
    end
end