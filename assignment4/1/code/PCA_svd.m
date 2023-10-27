function [eigenvectors, avg] = PCA_svd(data, k)
    % `data` must be a matrix of dimensions (wh × I) where w is the width
    % of the image, h is the height, and I is the number of images.
    %
    % Each column of `data` corresponds to one image. The image matrix,
    % whose dimensions are w x h, is flattened to a wh × 1 vector. All
    % these image column vectors are then put one after the other in `data`.

    % this returns a column vector containing the mean of each row, which
    % is precisely what we need here.
    avg = mean(data, 2);
    
    xi = data - avg;

    L = xi' * xi;

    [U, ~, ~] = svd(L);

    eigenvectors = U(:, 1:k);
end