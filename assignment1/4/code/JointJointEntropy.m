function output = JointJointEntropy(I1, I2)
    % we assume that the dimensions for both images are the same
    [height, width] = size(I1);

    p = JointHistogram(I1, I2) / (height * width);

    % now we have the probability distributions for both images

    output = 0;
    for i = 1:26
        for j = 1:26
            if p(i, j) ~= 0
                output = output + (p(i, j) * log2(p(i, j)));
            end
        end
    end
    output = output * -1;
end