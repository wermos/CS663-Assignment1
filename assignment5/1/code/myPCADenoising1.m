function reconstructed = myPCADenoising1(image_input, sigma_noise)
    [rows, cols] = size(image_input);

    % Calculate the number of rows and columns in the resulting matrix
    numRows = rows - 6;
    numCols = cols - 6;

    N = numRows * numCols;
    % Preallocate the result matrix
    P = zeros(49, N);
    
    % Extract overlapping grids and reshape into columns of resultMatrix
    idx = 1;
    for i = 1:numRows
        for j = 1:numCols
            grid = image_input(i:i+6, j:j+6);
            P(:, idx) = reshape(grid, [49, 1]);
            idx = idx + 1;
        end
    end

    [eigenvectors, ~] = eigs(P * P');

    % Compute eigencoefficients for each patch
    eigencoeffs = eigenvectors' * P;

    eigencoeff_sum = max([0, (1 / N * sum(eigencoeffs, 1)) - sigma_noise ^ 2]);

    disp(eigencoeff_sum);

    denoised_coeffs = eigencoeffs ./ (1 + (sigma_noise * sigma_noise ./ eigencoeff_sum .^ 2));

    new_patches = eigenvectors * denoised_coeffs;

    % Initialize the matrix for the reconstructed image
    reconstructed_image = zeros(256, 256);

    % Initialize a matrix for counting overlapping contributions
    overlap_count = zeros(256, 256);

    idx = 1;
    for row = 1:250
        for col = 1:250
            patch = reshape(new_patches(:, idx), [7 7]);
            % disp(patch);
            reconstructed_image(row:row+6,col:col+6) = reconstructed_image(row:row+6,col:col+6) + patch;
            overlap_count(row:row+6,col:col+6) = overlap_count(row:row+6,col:col+6) + 1;

            idx = idx + 1;
        end
    end

    reconstructed = uint8(reconstructed_image ./ overlap_count);
end