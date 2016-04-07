class PagesController < ApplicationController
  before_action :items

  ITEMS = {
    present: {1 => '이승만', 2 => '박정희', 3 => '김대중', 4 => '노무현', 5 => '이명박', 7 => '잘 모름'},
    north_korea: {1 => '민간차원의 인도적 지원은 필요', 2 => '북한의 태도변화가 없으면 지원불가', 3 => '잘 모름'},
    news_paper: {1 => '조선일보', 2 => '한겨레신문', 3 => '중앙일보', 4 => '경향신문', 5 => '동아일보', 6 => '상황에 따라 다름', 7 => '잘 모름'},
    party: {1 => ' 예전에 지지했던 정당을 지지할 것 같다.', 2 => '예전에 지지했던 정당을 지지하지만, 후보는 보고 결정할 것 같다.', 3 => '지지하는 정당도 없고, 후보도 보고 결정하겠다.', 4 => '선거막판까지 가 봐야 알 것 같다.', 5 => '잘 모름'},
    age: {1 => '10대', 2 => '20대', 3 => '30대', 4 => '40대', 5 => '50대', 6 => '60대이상'},
    political_view: {1 => '매우 진보성향', 2 => '약간 진보성향', 5 => '매우 보수성향', 4 => '약한 보수성향', 3 => '중도성향'},
    policy: {1 => '산업정책', 2 => '고용노동정책', 3 => '외교안보정책', 4 => '복지정책', 5 => '환경정책', 6 => '가족 및 여성정책', 7 => '교육정책', 8 => '금융정책', 9 => '국민안전정책', 10 => '그 외 및 잘 모름'}
  }

  TABLE = {
    theminju: {
      intercept: -1.074,
      present: {1 => -1.523, 2 => -1.209, 3 => 1.249, 4 => 1.493, 5 => -0.947, 6 => -0.235, 7 => 0},
      north_korea: {1 => 0.475, 2 => -0.370, 3 => 0},
      news_paper: {1 => -1.159, 2 => 0.784, 3 => -0.075, 4 => 0},
      party: {1 => -0.958, 2 => -0.485, 3 => -0.837, 4 => 0.057, 5 => 0},
      age: {1 => 0, 2 => 1.324, 3 => 0.340, 4 => 0.641, 5 => 0.503, 6 => 0},
      political_view: { 1 => 1.270, 2 => 1.181, 3 => 1.003, 4 => -0.013, 5 => 0}
    },
    kookmin: {
      intercept: -3.087,
      present: {1 => 0.147, 2 => -1.095, 3 => 1.805, 4 => 1.132, 5 => -1.545, 6 => -0.004, 7 => 0},
      north_korea: {1 => 2.501, 2 => 2.371, 3 => 0},
      news_paper: {1 => -1.414, 2 => 0.427, 3 => -0.151, 4 => 0},
      party: {1 => -3.312, 2 => -0.798, 3 => -0.590, 4 => 0.311, 5 => 0},
      age: {1 => 0, 2 => 0.254, 3 => -0.513, 4 => 0.427, 5 => 0.277, 6 => 0},
      political_view: {1 => 0.298, 2 => 0.686, 3 => 0.737, 4 => 0.443, 5 => 0}
    },
    etc: {
      intercept: -20.871,
      present: {1 => -0.114, 2 => -1.017, 3 => 1.198, 4 => 0.760, 5 => -2.434, 6 => 0.821, 7 => 0},
      north_korea: {1 => 1.843, 2 => 0.334, 3 => 0},
      news_paper: {1 => -2.052, 2 => 1.417, 3 => 0.783, 4 => 0},
      party: {1 => 15.330, 2 => 16.308, 3 => 16.283, 4 => 17.561, 5 => 0},
      age: {1 => 0, 2 => 1.987, 3 => 1.793, 4 => 2.085, 5 => 0.399, 6 => 0},
      political_view: {1 => 0.886, 2 => 0.129, 3 => -0.279, 4 => -0.647, 5 => 0}
    },
    unknow: {
      intercept: 0.971,
      present: {1 => 0.005, 2 => -1.142, 3 => 0.172, 4 => 0.781, 5 => -17.104, 6 => 0.020, 7 => 0},
      north_korea: {1 => 0.050, 2 => -0.390, 3 => 0},
      news_paper: {1 => -1.352, 2 => -0.354, 3 => -0.193, 4 => 0},
      party: {1 => -4.185, 2 => -2.250, 3 => -1.091, 4 => -0.711, 5 => 0},
      age: {1 => 0, 2 => 1.325, 3 => 1.192, 4 => 1.340, 5 => 0.471, 6 => 0},
      political_view: {1 => -0.319, 2 => -0.125, 3 => 0.250, 4 => -0.375, 5 => 0}
    }
  }

  def next_step
    if params[:back].present?
      @step = params[:step].try(:to_i) - 2 || 0
      @step = 0 if @step < 0
    else
      @step = params[:step].try(:to_i) || 0
    end
    render 'step'
  end

  def result
    choice_params = params[:answers].reject{|k,v| k == 'name' or k == 'policy'}
    theminju_base = base(:theminju, choice_params)
    kookmin_base = base(:kookmin, choice_params)
    etc_base = base(:etc, choice_params)
    unknow_base = base(:unknow, choice_params)

    sum_base = theminju_base + kookmin_base + etc_base + unknow_base

    @name = params[:answers][:name]
    @seanuri = 1/(1+sum_base)
    @theminju = theminju_base/(1+sum_base)
    @kookmin = kookmin_base/(1+sum_base)
    @etc = etc_base/(1+sum_base)
    @d_day = unknow_base/(1+sum_base)
    @vote_rate =rand(55...87)
  end

  def social_card
    render layout: nil
  end

  private

  def items
    @items = ITEMS
  end

  def base(party, choice_params)
    Math.exp(choice_params.map { |k, v| (k == 'news_paper' ? TABLE[party][k.to_sym][parse_new_paper_value(v)] : TABLE[party][k.to_sym][v.to_i]) }.sum + TABLE[party][:intercept])
  end

  def parse_new_paper_value(value)
    return 1 if %w(1 3 5).include?(value)
    return 2 if %w(2 4).include?(value)
    return 3 if value == '6'
    return 4
  end
end
