class TaggedBuilder < ActionView::Helpers::FormBuilder 
  
  # <p> 
  # <label for="product_description">Description</label><br/> 
  # <%= form.text_area 'description' %> 
  #</p> 
  def self.create_tagged_field(method_name) 
    method_name == 'check_box' ? line_break = '' : line_break = '<br/>'
    define_method(method_name) do |label, *args| 
      @template.content_tag("p", 
        @template.content_tag("label" , label.to_s.humanize, 
                              :for => "#{@object_name}_#{label}") + 
      line_break + super) 
    end 
  end 
    
  field_helpers.each do |name| 
    create_tagged_field(name) 
  end 
  
end 
