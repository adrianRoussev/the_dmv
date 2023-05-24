require './lib/dmv'
require './lib/facility'
require './lib/vehicle'
require './lib/dmv_data_service'
require 'json'

class Create
attr_reader :facilities, :vehicles
    def initialize
        @facilities = []
        @vehicles =[]
    end

    def create_facility(facility_list)
    
        facility_list.each do|facility|
            keys =  facility.keys

            keys.each do |key|
                if key.to_s.include?('address') ||  key.to_s.include?('location') 
                        if facility.has_key?(:location_1) ==true 
                            hash = JSON.parse(facility.dig(:location_1, :human_address))
                            facility.update({:address => hash.fetch("address")})
                        else
                            facility.update({:address => facility.fetch(key)})
                        end 
                elsif   key.to_s.include?('title') ||  key.to_s.include?('name') 
                    facility.update ({:name => facility.fetch(key)})
        
                elsif   key.to_s.include?('phone') 
                        facility.update({:phone => facility.fetch(key)}) 
                end
    
            end
            facility_new = Facility.new(facility)
                @facilities << facility_new
    end
        @facilities
    end


def vehicle_factory(vehicle_list)
    vehicle_list.each do|vehicle|
    
        vehicle.flatten.each do|element|
            if element.to_s.include?('vin') 
                vehicle[:vin]  = vehicle[element]
            elsif element.to_s.include?('make')
                vehicle[:make] =  vehicle[element]
            elsif element.to_s.include?('model') && element.to_s.include?('year') == false
                vehicle[:model] =  vehicle[element]
            elsif element.to_s.include?('year')
                vehicle[:year] =  vehicle[element]
            else
                vehicle.delete(element)
            end 
        end
            vehicle.delete_if{|k,v| k != :vin && k != :make && k != :model && k != :year}
            @vehicle_new = Vehicle.new(vehicle)
            @vehicles<<@vehicle_new
    end
        @vehicles
    end
end

