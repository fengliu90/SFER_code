function R = fuzzy_matrix_times(A,B)
% Fuzzy relation matrix A /times Fuzzy relation matrix A using min-max
% operator
[n,~] = size(A);
[~,m] = size(B);
% tic
for i = 1:n
    for j = 1:m
        R(i,j) = max(min([A(i,:);B(:,j)']));
    end
end
% toc