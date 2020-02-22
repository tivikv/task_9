# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'car'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_car'
require_relative 'cargo_car'

class RailWay
  attr_accessor :trains, :cars, :stations, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @cars = []
    route = nil
  end

  def choice
    puts '1, если необходимо Cоздать станцию'
    puts '2, если необходимо Cоздать поезд'
    puts '3, если необходимо Создать/изменять маршрут'
    puts '4, если необходимо Назначить маршрут поезду'
    puts '5, если необходимо Добавить вагоны к поезду'
    puts '6, если необходимо Отцепить вагоны от поезда'
    puts '7, если необходимо Перемещать поезд на 1 станцию'
    puts '8, если необходимо Просмотреть список станций и список поездов'
    puts '0, для Выхода из программы'
  end

  def action
    loop do
      print 'Введите номер команды: '
      choice

      case gets.chomp.to_i

      when 0
        puts 'До новых встреч!'
        break
      when 1
        create_station
      when 2
        create_train
      when 3
        create_route
      when 4
        assign_route
      when 5
        add_car
      when 6
        delete_car
      when 7
        move_train
      when 8
        list_trains
      when 9
        take_place
      end
    end
  end

  def create_station
    puts 'Введите название станции'
    name = gets.chomp
    @stations << Station.new(name)
    puts "Создана станция #{name}"
    puts "Все станции: #{stations}"
  end

  def create_train
    puts 'Введите номер поезда'
    number_train = gets.chomp.to_i
    puts "Введите тип поезда: 1 - 'passenger' или 2 -'cargo'"
    type = gets.chomp.to_i
    if type == 1
      trains << PassengerTrain.new(number_train, type)
      puts "Пассажирский поезд #{number_train}"
    elsif type == 2
      trains << CargoTrain.new(number_train, type)
      puts "Грузовой поезд #{number_train}"
    end
  end

  def create_route
    puts 'Введите порядковый номер начальной станции'
    index_start_station = gets.chomp.to_i
    puts 'Введите порядковый номер конечной станции'
    index_end_station = gets.chomp.to_i
    start_station = @stations[index_start_station - 1]
    end_station = @stations[index_end_station]
    route = Route.new(start_station, end_station)
    @routes << route
    puts 'Введите порядковый номер cтанции, которую хотите добавить в маршрут'
    index_add_station = gets.chomp.to_i
    station = @stations[index_add_station - 1]
    route.add_station(station)
    puts "Станция #{station} добавлена в маршрут"
    puts 'Введите порядковый номер станции, которую хотите удалить'
    index_delete_station = gets.chomp.to_i
    station = @stations[index_delete_station - 1]
    route.delete_station(station)
    puts "Станция #{station} удалена из маршрута"
    puts "Маршрут: #{route.stations}"
  end

  def assign_route
    puts "Все поезда: #{trains}"
    puts 'Выберите поезд для назначения маршрута'
    number_train = gets.chomp.to_i
    train = trains.find { |_train| @number_train = number_train }
    puts train.to_s
    puts 'Выберите номер маршрута'
    index = gets.chomp.to_i
    route = @routes [index - 1]
    puts "Маршрут: #{route}"

    train.route = route
    puts "Поезду #{number_train} назначен маршрут #{routes}"
  end

  def add_car
    puts 'Выберите тип создаваемого вагона 1 - пассажирский или 2- грузовой'
    type = gets.chomp.to_i
    puts 'Пронумеруйте вагон'
    number = gets.chomp.to_i

    if type == 1
      car = PassengerCar.new(number, type)
    elsif type == 2
      car = CargoCar.new(number, type)
    end

    @cars << car
    # puts "#{@cars}"
    puts 'Выберите порядковый номер прицепляемого вагона'
    index_car = gets.chomp.to_i
    car = @cars[index_car - 1]
    puts 'К какому поезду прицепить вагон'
    number_train = gets.chomp.to_i
    train = trains.find { |_train| @number_train = number_train }
    # puts "#{train}"
    train.add_car(car)
    puts "Прицеплен вагон #{train.cars} к поезду #{train}"
    train.car_train do |car|
      puts "Номер вагона: #{car.number}, Тип вагона: #{car.type}"
      if car.type == 1
        puts "Количество мест: #{car.seat}, Занято: #{car.selected_seat}"
      else
        puts "Объем: #{car.vol}, Заполненный объем: #{car.selected_vol}"
      end
    end
  end

  def delete_car
    puts 'От какого поезда нужно отцепить вагон'
    number_train = gets.chomp.to_i
    train = trains.find { |_train| @number_train = number_train }
    puts train.to_s
    train.delete_car
    puts 'Отцеплен вагон'
  end

  def move_train
    puts 'Выбираем поезд'
    number_train = gets.chomp.to_i
    train = trains.find { |_train| @number_train = number_train }
    if train.route.nil?
      puts 'Необходимо назначить маршрут!'
    else
      puts 'Направляем поезд вперед (1) или назад(2)?'
      action = gets.chomp.to_i
      case action
      when 1
        train.move_forward
      when 2
        train.move_back
      end
    end
  end

  def list_trains
    puts 'Введите номер станции'
    station_index = gets.chomp
    station = @stations[station_index - 1]
    station = @stations.detect { |station| station.name == name }
    if station.nil?
      puts 'Выбранной станции нет'
    else
      station.train_on_station do |train|
        puts "#{train.number}, #{train.type}"
      end
    end
  end

  def take_place
    puts 'Выберите поезд, в котором хотите выбрать вагон'
    number_train = gets.chomp.to_i
    puts 'Выберите вагон для бронирования места'
    index_car = gets.chomp.to_i
    car = @cars[index_car - 1]
    if type == 1
      if car.free_seat.positive?
        car.take_seat
      else
        puts 'Нет свободного места'
      end
    elsif type == 2
      if car.free_vol.positive?
        car.take_vol
      else
        puts 'Нет свободного места'
      end
    end
  end
end

railway = RailWay.new
railway.action
