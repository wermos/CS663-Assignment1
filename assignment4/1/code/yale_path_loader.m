function [trainingArray, testingArray] = yale_path_loader
    root_path = "../images/CroppedYale/";

    % constants
    NUM_PEOPLE = 39; % number 14 is missing so we will skip that
    NUM_TRAINING_IMAGES = 40;
    % we don't need a `NUM_TESTING_IMAGES` variable because any image
    % after the 40th one will be used for testing.

    % we only need a 1D array
    trainingArray = strings((NUM_PEOPLE - 1) * NUM_TRAINING_IMAGES, 1);
    % we needed to subtract 1 in the previous line because number 14 is
    % missing
    testingArray = [""];

    trainingArrayIdx = uint16(1);
    for i = 1:39
        if i == 14
            continue
        end

        formatted_number = sprintf('%02d', i);
        dir_path = append(root_path, "yaleB", formatted_number, "/");

        counter = uint16(1);

        image_paths = dir(dir_path);
        % Loop through the files
        for j = 1:numel(image_paths)
            if ~image_paths(j).isdir % Check if it's not a directory
                if counter <= 40
                    trainingArray(trainingArrayIdx) = image_paths(j).name;
                    trainingArrayIdx = trainingArrayIdx + 1;
                    counter = counter + 1;
                else
                    testingArray(end + 1) = image_paths(j).name;
                end
            end
        end
    end

    testingArray = testingArray'; % for homogeneity

    % disp("trainingArray:")
    % disp(trainingArray)

    % disp("testingArray:")
    % disp(testingArray')
end