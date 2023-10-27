[trainingArray, ~, ~] = orl_path_loader();

% Initialize training data array
[num_training_rows, ~] = size(trainingArray);

trainingData = zeros(92 * 112, num_training_rows);

% load in training data
for i = 1:num_training_rows
    img = double(imread(trainingArray(i)));

    trainingData(:, i) = reshape(img, [], 1);
end

[eigenfaces, ~] = PCA(trainingData, 25);

tiledlayout(5, 5);

for i = 1:25
    img_data = reshape(eigenfaces(:, i), [112, 92]);

    nexttile;

    imshow(img_data, []);
end

exportgraphics(gcf, "../images/eigenfaces.png");
exportgraphics(gcf, "../images/eigenfaces.pdf");
