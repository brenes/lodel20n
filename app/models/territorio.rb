class Territorio < ActiveRecord::Base
  has_many :escrutinios
  belongs_to :padre, :class_name => "Territorio", :foreign_key => "territorio_padre_id"
  has_many :hijos, :class_name => "Territorio", :foreign_key => "territorio_padre_id"
end
