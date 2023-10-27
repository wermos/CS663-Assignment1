function [trainingArray, testingArray, galleryImages] = yale_path_loader
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
    testingArray = strings((NUM_PEOPLE - 1) * NUM_TRAINING_IMAGES, 2);
    galleryImages = strings(NUM_PEOPLE - 1, 1);

    trainingArrayIdx = uint16(1);
    testingArrayIdx = uint16(1);
    galleryIdx = uint16(1);
    for i = 1:39
        if i == 14
            continue
        end

        formatted_number = sprintf('%02d', i);
        dir_path = append(root_path, "yaleB", formatted_number, "/");

        counter = 1;

        image_paths = dir(dir_path);
        % Loop through the files
        for j = 1:numel(image_paths)
            if ~image_paths(j).isdir % Check if it's not a directory

                full_path = append(dir_path, image_paths(j).name);

                if counter == 1
                    galleryImages(galleryIdx) = full_path;
                    galleryIdx = galleryIdx + 1;
                end

                if counter <= 40
                    trainingArray(trainingArrayIdx) = full_path;
                    trainingArrayIdx = trainingArrayIdx + 1;
                    counter = counter + 1;
                else
                    testingArray(testingArrayIdx, 1) = full_path;
                    testingArray(testingArrayIdx, 2) = int2str(i);
                    testingArrayIdx = testingArrayIdx + 1;
                end
            end
        end
    end

    non_empty_rows = ~all(testingArray == "", 2);
    testingArray = testingArray(non_empty_rows, :);
end