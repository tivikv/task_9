# frozen_string_literal: true

class PassengerCar < Car
  attr_reader :seat, :selected_seat

  def initialize(seat)
    @seat = seat
    @selected_seat = 0
  end

  def take_seat
    @selected_seat += 1 if (@seat - @selected_seat).positive?
  end

  def free_seat
    @seat - @selected_seat
  end
end
