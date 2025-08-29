function X = add_noise(X,rate,style)
    % Add the specified type of noise to the dataset
    % Input:
    %   X - Input data (Cell array)
    %   Y - Corresponding label
    %   rate - Noise intensity
    %   style - Noise style, optional values: "Gaussian", "Gamma", "Rayleigh"
    % Output:
    %   X - Data after adding noise
    %   Y - Corresponding label (consistent with the input)
    
    % Make sure that the input X is a Cell array
    if ~iscell(X)
        error('X must be a Cell array');
    end
    
    % Add the corresponding noise according to the selected noise style
    switch lower(style)
        case 'gaussian'
            % Add Gaussian noise
            for v = 1:length(X)
                % Generate Gaussian noise of the same dimension as the data (mean 0, standard deviation 1)
                gaussian_noise = randn(size(X{v}));
                
                X{v} = X{v} + rate * gaussian_noise;
            end
            
        case 'gamma'
            % Add Gamma noise
            for v = 1:length(X)
                shape = 2;      % Shape parameters of the Gamma distribution
                scale = 2;      % The scale parameter of the Gamma distribution
                % Generate Gamma noise
                gamma_noise = gamrnd(shape, scale, size(X{v}));
                
                X{v} = X{v} + rate * gamma_noise;
            end
            
        case 'rayleigh'
            % Add Rayleigh noise
            for v = 1:length(X)
                scale_param = 1; % The scale parameter of the Rayleigh distribution
                % Generate Rayleigh noise
                rayleigh_noise = raylrnd(scale_param, size(X{v}));
             
                X{v} = X{v} + rate * rayleigh_noise;
            end
            
        otherwise
            error('For unsupported noise types, please select "Gaussian", "Gamma" or "Rayleigh"');
    end
end
