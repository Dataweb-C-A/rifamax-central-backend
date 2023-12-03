# frozen_string_literal: true

require 'test_helper'

module Rifamax
  class TicketsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @rifamax_ticket = rifamax_tickets(:one)
    end

    test 'should get index' do
      get rifamax_tickets_url, as: :json
      assert_response :success
    end

    test 'should create rifamax_ticket' do
      assert_difference('Rifamax::Ticket.count') do
        post rifamax_tickets_url,
             params: { rifamax_ticket: { is_sold: @rifamax_ticket.is_sold, number: @rifamax_ticket.number, raffle_id: @rifamax_ticket.raffle_id, serial: @rifamax_ticket.serial, sign: @rifamax_ticket.sign, ticket_nro: @rifamax_ticket.ticket_nro } }, as: :json
      end

      assert_response :created
    end

    test 'should show rifamax_ticket' do
      get rifamax_ticket_url(@rifamax_ticket), as: :json
      assert_response :success
    end

    test 'should update rifamax_ticket' do
      patch rifamax_ticket_url(@rifamax_ticket),
            params: { rifamax_ticket: { is_sold: @rifamax_ticket.is_sold, number: @rifamax_ticket.number, raffle_id: @rifamax_ticket.raffle_id, serial: @rifamax_ticket.serial, sign: @rifamax_ticket.sign, ticket_nro: @rifamax_ticket.ticket_nro } }, as: :json
      assert_response :success
    end

    test 'should destroy rifamax_ticket' do
      assert_difference('Rifamax::Ticket.count', -1) do
        delete rifamax_ticket_url(@rifamax_ticket), as: :json
      end

      assert_response :no_content
    end
  end
end
