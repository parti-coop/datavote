require 'test_helper'
require 'csv'

class ResultTest < ActionDispatch::IntegrationTest
  test 'result' do
    #대통령,대북지원입장,신뢰하는신문사,정당,연령,이념,새누리당,더민주당,국민의당,정의당,지지확률투표당일 지지정당후보 결정

    CSV.foreach(File.join(Rails.root, 'test', 'integration', 'data.csv')) do |row|
      post result_path(answers: {
        present: row[0], north_korea: row[1],
        news_paper: to_real_new_paper(row[2]), party: row[3],
        age: row[4], political_view: row[5], policy: 1}), format: :js
      puts row.inspect
      puts assigns.inspect
      assert_in_delta row[6].to_f, assigns(:seanuri), 0.009
      assert_in_delta row[7].to_f, assigns(:theminju), 0.009
      assert_in_delta row[8].to_f, assigns(:kookmin), 0.009
      assert_in_delta row[9].to_f, assigns(:etc), 0.009
      assert_in_delta row[10].to_f, assigns(:d_day), 0.009
    end
  end

  test 'result_row' do
    skip
    #대통령,대북지원입장,신뢰하는신문사,정당,연령,이념,새누리당,더민주당,국민의당,정의당,지지확률투표당일 지지정당후보 결정
    row = ["2", "1", "4", "1", "3", "1", "0.6743029647", "0.2121848028", "0.00368893914", "0.08803333407", "0.02178995934"]
    post result_path(answers: {
      present: row[0], north_korea: row[1],
      news_paper: to_real_new_paper(row[2]), party: row[3],
      age: row[4], political_view: row[5], policy: 1}), format: :js
    puts row.inspect
    puts assigns.inspect
    assert_in_delta row[6].to_f, assigns(:seanuri), 0.009
    assert_in_delta row[7].to_f, assigns(:theminju), 0.009
    assert_in_delta row[8].to_f, assigns(:kookmin), 0.009
    assert_in_delta row[9].to_f, assigns(:etc), 0.009
    assert_in_delta row[10].to_f, assigns(:d_day), 0.009
  end

  def to_real_new_paper(value)
    return %w(1 3 5).sample if value == '1'
    return %w(2 4).sample if value == '2'
    return '6' if value == '3'
    return '7' if value == '4'
   end
end
