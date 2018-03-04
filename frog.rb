require "test/unit"

class Frog < Test::Unit::TestCase

  def frog_jump(init, target, jump)
    return 0 if init >= target

    mod = target % jump
    if mod == 0
      jumps = (target / jump) - 1
    else
      jumps = target / jump
    end
    jumps -= init / jump
    (jumps * jump) + init >= target ? jumps : jumps + 1
  end

  def test_from_jump
    assert frog_jump(10, 90, 10) == 8
    assert frog_jump(12, 90, 10) == 8
    assert frog_jump(30, 90, 10) == 6
    assert frog_jump(100, 109, 10) == 1
    assert frog_jump(10000, 10001, 10) == 1
  end
end