class Resultado < ActiveRecord::Base
  belongs_to :escrutinio
  belongs_to :partido
end
