function varargout = csp_feats(C,arg2,mode,varargin)
% csp_feats Common Spatial Pattern (csp) features.
% PROJ = csp_feats(COVS,LABELS,'train') computes the projection matrix from 
% the P by P by N array of covariance matrices COVS and the vector LABELS 
% of N labels. Only two classes are allowed. Each row of the Q by P matrix 
% PROJ holds a spatial pattern.
%
% SCORE = csp_feats(COVS,PROJ,'test') computes the csp features of the P by
% P by N array of covariance matrices COVS given the Q by P linear mapping 
% PROJ. The rows of SCORE correspond to the N observations and the columns
% to the Q features.

if size(C,1)~=size(C,2)
    error('Non square covariance matrices (size(COVS,1)~=size(COVS,2)).')
end
P = size(C,1);
N = size(C,3);

parser = inputParser;
addRequired(parser,'C',@isnumeric);
addRequired(parser,'arg2',@isnumeric);
addOptional(parser,'weights',ones(N,1),@isnumeric);
addOptional(parser,'Q',3,@isnumeric);
addOptional(parser,'Tikhonov',0,@isnumeric);
addOptional(parser,'PriorCovariance',ones(P,P,2),@isnumeric);
addOptional(parser,'PriorTrials',1,@isnumeric);
addOptional(parser,'PriorWeight',0,@isnumeric);
addOptional(parser,'L2Penalty',zeros(P),@isnumeric);
% addOptional(parser,'PenaltyWeight',0,@isnumeric);
parse(parser,C,arg2,varargin{:});
%alpha = parser.Results.PenaltyWeight;
gamma = parser.Results.Tikhonov;
beta  = parser.Results.PriorWeight;
pC    = parser.Results.PriorCovariance;
pN    = parser.Results.PriorTrials;
Q     = parser.Results.Q;

if strcmp(mode,'train')
    y = arg2;
    labels = unique(y);
    w = reshape(parser.Results.weights,1,1,N);
    % guarantee sum(w_{class}) = 1
    w(1,1,y==labels(1)) = w(1,1,y==labels(1))/sum(w(1,1,y==labels(1)));
    w(1,1,y==labels(2)) = w(1,1,y==labels(2))/sum(w(1,1,y==labels(2)));
    C = bsxfun(@times,C,w);    
    Ca = sum(C(:,:,y==labels(1)),3);
    Cb = sum(C(:,:,y==labels(2)),3);
    % Two-step regularization procedure:  
    Ca = ((1-beta)*Ca + beta*pC(:,:,1))/((1-beta)*N + beta*pN);
    Cb = ((1-beta)*Cb + beta*pC(:,:,2))/((1-beta)*N + beta*pN);    
    Ca = (1-gamma)*Ca + gamma/P*trace(Ca)*eye(P);
    Cb = (1-gamma)*Cb + gamma/P*trace(Cb)*eye(P);
    [varargout{1},varargout{2}]= csp(Ca,Cb,1,4,parser.Results.L2Penalty,Q);
elseif strcmp(mode,'test')
    W = arg2;
    X = zeros(size(C,3),size(W,1));
    for trial = 1:size(C,3)
        tmp = W*C(:,:,trial)*W';
        X(trial,:) = log(diag(tmp)/trace(tmp));
    end
    varargout{1} = X;
end