tic

[trainingArray, ~, ~] = orl_path_loader();

% Initialize training data array
[num_training_rows, ~] = size(trainingArray);

trainingData = zeros(92 * 112, num_training_rows);

% load in training data
for i = 1:num_training_rows
    img = double(imread(trainingArray(i)));

    trainingData(:, i) = reshape(img, [], 1);
end

k_values = [2, 10, 20, 50, 75, 100, 125, 150, 175];

% we will reconstruct this face
test_face = double(imread("../images/ORL/s1/1.pgm"));

flattened_test_face = reshape(test_face, [], 1);

tiledlayout(3, 3, "TileSpacing", "compact", "Padding", "compact");

for i = 1:numel(k_values)
    [eigenvectors, ~] = PCA(trainingData, k_values(i));

    eigen_coeffs = flattened_test_face' * eigenvectors;
    reconstructed_face = sum(eigen_coeffs .* eigenvectors, 2);
    img_data = reshape(reconstructed_face, [112, 92]);

    nexttile;
    imshow(img_data, []);
end

exportgraphics(gcf, "../images/reconstruction.png");
exportgraphics(gcf, "../images/reconstruction.pdf");

toc