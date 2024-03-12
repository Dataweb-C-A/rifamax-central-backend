# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ilike(params)
    params.reduce(all) do |scope, (column, value)|
      scope.where(scope.arel_table[column].send(:matches, value))
    end
  end

  def self.between(params)
    params.reduce(all) do |scope, (column, value)|
      scope.where(scope.arel_table[column].send(:between, value..))
    end
  end
end
