function [import_mapping] = mapsource(example_record, db_Variables)
%MAPSOURCE creates a variable mapping table, using import data and an
%existing variable list

% existing import data variables
import_var = fieldnames(example_record);
numvar = numel(import_var);

% get import data types
for var_i = 1:numvar
    import_type{var_i,1} = class(example_record.(import_var{var_i}));    
end

% preallocate conversion cell string
conversion(1:numvar,1) = {''};

% database variables will be stored as a categorical array, for user selection
db_var = repmat(categorical({'<KEEP>'}),numvar,1);
db_var = addcats(db_var,[{'<DISCARD>'};db_Variables.var_name]);

% Create a table from the existing table variables
column_headers =     {'import_var' 'import_type' 'db_var' 'conversion'};
import_mapping = table(import_var,  import_type,  db_var,  conversion,'VariableNames',column_headers);

for var_i = 1:numvar
    
    % find matching variables (not case-sensitive)
    db_var_opt = categories(import_mapping.db_var);
    var_matches = find(matches(lower(db_var_opt),lower(import_mapping.import_var(var_i))));
    
    % if exactly one match, set initial mapping
    if nnz(var_matches) == 1
        import_mapping.db_var(var_i) = db_var_opt(var_matches);
    end        
end

