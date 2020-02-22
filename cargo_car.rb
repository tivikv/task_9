# frozen_string_literal: true

class CargoCar < Car
  attr_reader :vol, :selected_vol

  def initialize(vol)
    @vol = vol
    @selected_vol = 0
  end

  def take_vol
    @selected_vol += 1 if (@vol - @selected_vol).positive?
  end

  def free_vol
    @vol - @selected_vol
  end
end
