function Data = csv2cell(file, delimiter)
    
    %Delimitador padrão .csv ','
    if nargin < 2
        delimiter = ',';
    end

    fprintf('Abrindo arquivo %s\n', file);
    fid = fopen(file, 'r');
    if isempty(fid)
        error('Não foi possível abrir o arquivo %s', file);
    end
    
    %Lê o número de de linhas do arquivo CSV. 
    buffer = fread(fid, 'uint8=>char')';
    nlines = size(regexp(buffer, '\n', 'match'), 2);
    clear buffer;
    
    %Verifica tamanho do arquivo
    bytes = ftell(fid);
    fprintf('O arquivo tem %d Bytes e um total de %d linhas.\n', bytes, nlines);
    clear bytes;
    
    %Move cursor ao ponto inicial do arquivo
    fseek(fid, 0, -1);
    
    if nlines > 1
        %Executa primeira linha manualmente de modo a verificar o número de
        %colunas no arquivo .csv, de modo a alocar espaço para leitura.
        delimiter = [' ?' delimiter ' ?'];
        line = fgetl(fid);
        aux = regexp(line, delimiter, 'split');
        ncolumns = size(aux, 2);
        Data = cell(nlines, ncolumns);
        Data(1,:) = aux;
        idx = 2;
        clear aux;
        
        while ~feof(fid)
            line = fgetl(fid);
            Data(idx,:) = regexp(line, delimiter, 'split');
            idx = idx + 1;     
        end
        
    elseif nlines == 1
        %Retorna um conjunto cell diretamente lido do arquivo.
        Data = regexp(fgetl(fid), delimiter, 'split');
    else
        %Se não existem linhas no arquivo, este deve ser fechado.
        fclose(fid);
        error('Algo de errado com a formatação do arquivo %s', file);
    end
   
    fclose(fid);
end


