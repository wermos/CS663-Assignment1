[trainingArray, testingArray, galleryImages] = orl_path_loader();

% Initialize training data array
[num_training_rows, ~] = size(trainingArray);

trainingData = zeros(92 * 112, num_training_rows);

% load in training data
for k = 1:num_training_rows
    img = double(imread(trainingArray(k)));

    trainingData(:, k) = reshape(img, [], 1);
end

% Initialize gallery image data
[num_gallery_imgs, ~] = size(galleryImages);

galleryImageData = zeros(92 * 112, num_gallery_imgs);

% load in gallery image data
for k = 1:num_gallery_imgs
    img = double(imread(galleryImages(k)));

    galleryImageData(:, k) = reshape(img, [], 1);
end

% Gather testing data information
[num_testing_rows, ~] = size(testingArray);

% Put whatever value of `k` that you want here
k = 100;
[eigenvectors, img_avg] = PCA_covariance(trainingData, k);

% The i'th column stores the eigencoefficients of the k'th eigenvector
% for the i'th gallery image.
gallery_coeffs = eigenvectors' * galleryImageData;

threshold = 10000;
count = 0;
false_positive = 0;
false_negative = 0;
positive = 0;

% load in testing data
for j = 1:num_testing_rows
    % The correct face number
    face_num = str2double(testingArray(j, 2));

    testData = reshape(double(imread(testingArray(j, 1))), [], 1);
    testData = testData - img_avg;

    test_eigen_coeffs = eigenvectors' * testData;

    gallery_coeffs_intermediate = gallery_coeffs - test_eigen_coeffs;

    norms = zeros(num_gallery_imgs, 1);

    for k = 1:num_gallery_imgs
        norms(k) = norm(gallery_coeffs_intermediate(:, k));
    end
    
    if all(norms > threshold)
        if face_num < 32
            false_negative = false_negative + 1;
        end
    else
        if face_num > 32
            false_positive = false_positive + 1;
        end
    end
end

false_positive
false_negative