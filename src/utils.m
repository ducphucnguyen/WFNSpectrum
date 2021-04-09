% utinity functions

classdef utils
    methods(Static)
        
          
          % save psd inside parfor loop
          function parsave(fname, psd)
                    save(fname, 'psd')
          end
    end
end