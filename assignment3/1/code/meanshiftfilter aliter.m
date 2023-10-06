function image_output = meanshiftfilter(image_input, sigma, epsilon)
    sigma_s = sigma(1);
    sigma_r = sigma(2);
    [number_of_rows, number_of_columns] = size(image_input);
    image_output = zeros(number_of_rows, number_of_columns);
    threshold_spatial = ceil(3*sigma_s); % 3σ (filter_size = 2*threshold_spatial+1)

    for i = 1:number_of_rows
        i
        for j = 1:number_of_columns
            v = [i;j;image_input(i,j)];
            c = 0;
            while true
                x = v(1);
                y = v(2);
                I_xy = v(3);
                [left, right, top, bottom] = neighbourhood(x, y, number_of_rows, number_of_columns, threshold_spatial);
                [X,Y] = meshgrid(-(y-left):(right-y),-(x-top):(bottom-x));
                image_window = image_input(top:bottom, left:right);
                gaussian_spatial_x = exp(-(X.^2)/(2*sigma_s^2));
                gaussian_spatial_y = exp(-(Y.^2)/(2*sigma_s^2));
                gaussian_range_I = exp(-((image_window-I_xy).^2)/(2*sigma_r^2));
                mean_shift_filter = gaussian_spatial_x .* gaussian_spatial_y .* gaussian_range_I;
                v_next = [sum((Y-Y(1)+1).*mean_shift_filter)/sum(mean_shift_filter); sum((X-X(1)+1).*mean_shift_filter)/sum(mean_shift_filter); sum((image_window).*mean_shift_filter)/sum(mean_shift_filter)];
                mean_shift = norm(v_next-v);
                v = v_next;
                c = c + 1;
                if (mean_shift < epsilon || c > 1e2)
                    image_output(i,j) = v(3);
                    break;
                end
            end
        end
    end
end

function [left, right, top, bottom] = neighbourhood(x, y, number_of_rows, number_of_columns, threshold_spatial)
    x = max(1, min(number_of_rows, ceil(x)));
    y = max(1, min(number_of_columns, ceil(y)));
    left = max(1, y - threshold_spatial);
    right = min(number_of_columns, y + threshold_spatial);
    top = max(1, x - threshold_spatial);
    bottom = min(number_of_rows, x + threshold_spatial);
end