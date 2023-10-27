tic

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

k_values = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];

recognition_rate = zeros(1, numel(k_values));

for i = 1:numel(k_values)
    [eigenvectors, img_avg] = PCA(trainingData, 100);

    % The i'th row of `coeffs` stores the eigencoefficients of the k'th
    % eigenvector for the i'th gallery image.
    gallery_coeffs = eigencoefficient(galleryImageData, eigenvectors);
    
    % Initialize testing data array
    [num_testing_rows, ~] = size(testingArray);
    
    % a counter to keep track of how many times the system recognized the
    % face correctly.
    correct_counter = 0;
    
    % load in testing data
    for j = 1:num_testing_rows
        % The correct face number
        face_num = str2double(testingArray(j, 2));
    
        testData = reshape(double(imread(testingArray(j, 1))), [], 1);
        testData = testData - img_avg;
    
        test_eigen_coeffs = eigenvectors' * testData;
    
        gallery_coeffs_intermediate = gallery_coeffs - test_eigen_coeffs;
    
        norms = zeros(1, num_gallery_imgs);
    
        for k = 1:num_gallery_imgs
            norms(k) = norm(gallery_coeffs_intermediate(k));
        end
    
        [~, face_num_guess] = min(norms);
    
        if face_num == face_num_guess
            correct_counter = correct_counter + 1;
        end

        % disp(face_num_guess);
        % disp(face_num);
    end

    recognition_rate(i) = correct_counter;
end

plot(k_values, recognition_rate);

toc

function coeffs = eigencoefficient(galleryImageData, eigenVectors)
    % face coefficient calculator for the eigenfaces
    coeffs = eigenVectors' * galleryImageData;
end
