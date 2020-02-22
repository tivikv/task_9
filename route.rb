# frozen_string_literal: true

class Route
  require_relative 'modules.rb'
  include InstanceCounter
  attr_reader :start_station, :end_station, :stations

  NAME_FORMAT = /^[а-яА-ЯёЁa-zA-Z0-9]+$/.freeze

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @stations = [start_station, end_station]
    validate!
    instances_quantity
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  # Добавляет промежуточную станцию
  def add_station(station)
    @stations.insert(1, station)
  end

  # Удаляет промежуточную станцию
  def delete_station(station)
    @stations.delete(station)
  end

  protected

  def validate!
    station_nil?
    station_station?
    correct_name?
  end

  def station_nil?
    if start_station || end_station.nil?
      raise 'Не указана начальная и/или конечная станция'
    end
  end

  def station_station?
    if @stations[index_start_station - 1] == @stations[index_end_station]
      raise 'Начальная станция должная быть отличной от конечной станции'
    end
  end

  def correct_name?
    if start_station !~ NAME_FORMAT && end_station !~ NAME_FORMAT
      raise 'Некорректное название станции'
    end
  end
end
