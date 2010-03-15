module Bundler
  class Runtime
    private
    def autorequires_for_groups(*groups)
      groups.map! { |g| g.to_sym }
      autorequires = Hash.new { |h,k| h[k] = [] }
    
      # ----- PATCH -----
    
      # ORIGINAL METHOD - unfortunately inside out
      # ordered_deps = []
      # specs_for(*groups).each do |g|
      #   dep = @definition.dependencies.find{|d| d.name == g.name }        
      #   ordered_deps << dep if dep && !ordered_deps.include?(dep)
      # end
    
      # NEW METHOD
      ordered_deps = []
      spec_names = specs_for(*groups).map { |s| s.name }
      @definition.dependencies.each do |dep|
        ordered_deps << dep if spec_names.include?(dep.name) && !ordered_deps.include?(dep)
      end

      # DEBUG: verify that ordered_deps are in gem file specification order
      # p ordered_deps.map { |d| d.name }
    
      # ----- /PATCH -----

      ordered_deps.each do |dep|
        dep.groups.each do |group|
          # If there is no autorequire, then rescue from
          # autorequiring the gems name
          if dep.autorequire
            dep.autorequire.each do |file|
              autorequires[group] << [file, true]
            end
          else
            autorequires[group] << [dep.name, false]
          end
        end
      end

      if groups.empty?
        autorequires
      else
        groups.inject({}) { |h,g| h[g] = autorequires[g]; h }
      end
    end
  end
end
