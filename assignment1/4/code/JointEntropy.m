function output = JointEntropy(I1, I2)
    % we assume that the dimensions for both images are the same
    [height, width] = size(I1);

    p = JointHistogram(I1, I2) / (height * width);

    % now we have the probability distribution for both images

    values = arrayfun(@helper, p);
    output = -sum(sum(values, "omitnan"), "all");
end

function val = helper(input)
    val = input * log2(input);
end