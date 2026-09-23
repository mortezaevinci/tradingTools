camera = webcam; % Connect to the camera
net = googlenet;   % Load the neural network
    inputSize = net.Layers(1).InputSize;
while true
    im = snapshot(camera);       % Take a picture
    image(im);                   % Show the picture

    im = imresize(im,inputSize(1:2));
    label = classify(net,im);    % Classify the picture
    title(char(label));          % Show the class label
    drawnow
end