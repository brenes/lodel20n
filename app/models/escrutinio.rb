class Escrutinio < ActiveRecord::Base
  belongs_to :territorio
  has_many :resultados
end
