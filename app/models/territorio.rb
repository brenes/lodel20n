class Territorio < ActiveRecord::Base
  has_many :escrutinios
  belongs_to :parent, :class_name => "Territorio"
  has_many :children, :class_name => "Territorio"
end
