# frozen_string_literal: true

require 'test_helper'

module Rifamax
  class RafflesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @rifamax_raffle = rifamax_raffles(:one)
    end

    test 'should get index' do
      get rifamax_raffles_url, as: :json
      assert_response :success
    end

    test 'should create rifamax_raffle' do
      assert_difference('Rifamax::Raffle.count') do
        post rifamax_raffles_url,
             params: { rifamax_raffle: { award_no_sign: @rifamax_raffle.award_no_sign, award_sign: @rifamax_raffle.award_sign, expired_date: @rifamax_raffle.expired_date, init_date: @rifamax_raffle.init_date, is_closed: @rifamax_raffle.is_closed, is_send: @rifamax_raffle.is_send, loteria: @rifamax_raffle.loteria, numbers: @rifamax_raffle.numbers, payment_id: @rifamax_raffle.payment_id, plate: @rifamax_raffle.plate, price: @rifamax_raffle.price, refund: @rifamax_raffle.refund, rifero_id: @rifamax_raffle.rifero_id, serial: @rifamax_raffle.serial, year: @rifamax_raffle.year } }, as: :json
      end

      assert_response :created
    end

    test 'should show rifamax_raffle' do
      get rifamax_raffle_url(@rifamax_raffle), as: :json
      assert_response :success
    end

    test 'should update rifamax_raffle' do
      patch rifamax_raffle_url(@rifamax_raffle),
            params: { rifamax_raffle: { award_no_sign: @rifamax_raffle.award_no_sign, award_sign: @rifamax_raffle.award_sign, expired_date: @rifamax_raffle.expired_date, init_date: @rifamax_raffle.init_date, is_closed: @rifamax_raffle.is_closed, is_send: @rifamax_raffle.is_send, loteria: @rifamax_raffle.loteria, numbers: @rifamax_raffle.numbers, payment_id: @rifamax_raffle.payment_id, plate: @rifamax_raffle.plate, price: @rifamax_raffle.price, refund: @rifamax_raffle.refund, rifero_id: @rifamax_raffle.rifero_id, serial: @rifamax_raffle.serial, year: @rifamax_raffle.year } }, as: :json
      assert_response :success
    end

    test 'should destroy rifamax_raffle' do
      assert_difference('Rifamax::Raffle.count', -1) do
        delete rifamax_raffle_url(@rifamax_raffle), as: :json
      end

      assert_response :no_content
    end
  end
end
