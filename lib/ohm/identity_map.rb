require "ohm"

module Ohm::IdentityMap
  VERSION = "0.1.0"

  def self.included(model)
    model.extend(Macros)

    class << model
      alias original_loader []

      def [](id)
        if map = Thread.current[:_ohm_identity_map]
          map.fetch(id) { map[id] = original_loader(id) }
        else
          original_loader(id)
        end
      end

      alias original_fetch fetch

      def fetch(ids)
        if map = Thread.current[:_ohm_identity_map]
          missing_ids, missing_indices = [], []

          mapped = ids.map.with_index do |id, index|
            map.fetch(id) do
              missing_ids << id
              missing_indices << index
              nil
            end
          end

          original_fetch(missing_ids).each.with_index do |instance, index|
            mapped[missing_indices[index]] = instance
            map.store(missing_ids[index], instance)
          end

          mapped
        else
          original_fetch(ids)
        end
      end
    end
  end

  module Macros
    def identity_map
      Thread.current[:_ohm_identity_map] = {}
      yield
    ensure
      Thread.current[:_ohm_identity_map] = nil
    end
  end
end

Ohm::Model.send(:include, Ohm::IdentityMap)
