function txt2printf( inputfile )
%TXT2PRINTF Summary of this function goes here
%   Detailed explanation goes here
f = fopen(inputfile, 'r');
f_edited = fopen([inputfile(1:end-4) '_edited.txt'], 'wt');

% 37 *
% 39 '
% 13 \n
% 92 \
% 110 n
narg = 0; 

fprintf(f_edited, 'fprintf(f,%c', 39);
while ~feof(f)
    curr = fscanf(f, '%c', 1);
    aux = double(curr);
    if ~isempty(curr)
        switch curr
            case 9  %\t
                fprintf(f_edited, '%ct', 92);
            case 13 %\n
                fscanf(f, '%c', 1);
                fprintf(f_edited, '%cn%c', 92, 39);
                for i=1:narg
                    fprintf(f_edited, ', arg%d', i);
                end
                narg = 0;
                fprintf(f_edited, ');\n');
                fprintf(f_edited, 'fprintf(f,%c', 39);
            case 37
                fwrite(f_edited, curr);
                curr = fscanf(f, '%c', 1);
                if curr=='s'
                    narg = narg + 1;
                end
                fwrite(f_edited, curr);
            otherwise
                fwrite(f_edited, curr);
        end
    end
end
fprintf(f_edited, '%c);\n', 39);




fclose('all');

end

