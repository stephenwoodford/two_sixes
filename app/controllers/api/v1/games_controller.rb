module Api
  module V1
    class GamesController < ApiController
      before_action :authenticate_user!, except: [:events]

      def bid
        game = current_user.games.find(params[:id])
        number = params[:number]
        face_value = params[:face_value]
        errors = []
        errors << "The bid must include a total number." unless number
        errors << "The bid must include a valid total number." unless number =~ /\A\d+\z/
        errors << "The bid must include a face value." unless face_value =~ /\A\d+\z/
        errors << "The bid must include a valid face value." unless face_value =~ /\A\d+\z/

        render status: 400, json: {errors: errors} and return if errors.any?

        bid = Bid.new(number.to_i, face_value.to_i)
        game.bid(current_user, bid)

        render json: { bid: { number: bid.number, faceValue: bid.face_value } }
      end

      def bs
        game = current_user.games.find(params[:id])
        game.bs(current_user)

        render json: { bs: true }
      end

      def comments
        game = current_user.games.find(params[:id])
        game.add_comment(current_user, params[:message])

        render json: {}
      end

      def events
        game = Game.find(params[:id])
        player = game.player_for(current_user) if current_user

        ret = game.events(params[:prev_event]).reject{|event| game.filter_event?(player, event) }.map do |event|
          {
            number: event.number,
            event: event.name,
            data: event.action.to_hash
          }
        end
        render json: ret
      end
    end
  end
end
