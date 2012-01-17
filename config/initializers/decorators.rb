ActiveRecord::Base.class_eval do
  def decorator(format)
    @__decorators ||= {}
    @__decorators[format] ||= eval("Decorators::#{self.class.name}::#{format}.new(self)")
  end
end