module SassAccessor

  Sass::Script::Functions.send :include, self
  def self.variables
    @variables ||= {}
  end

  def self.set(values = {})
    variables.merge! values
  end

  def variable(v)
    SassAccessor.variables[v.value]
  end

  def xbg_for(v)
    result = variable(v)
    Sass::Script::String.new(result)
  end

end