class Api::V1::PolicyController < ApplicationController
  before_action :authenticate
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from JWT::DecodeError, with: :decode_error
  rescue_from JWT::VerificationError, with: :invalid_token
  rescue_from JWT::ExpiredSignature, with: :expiration_error

  def index
    @policies = Policy.all
    if @policies.present? && @policies.count > 0
      render json: @policies, status: :ok
    else
      render plain: "Não existe nenhuma Apolice", status: :ok
    end
  end

  def show
    @policy = Policy.find(params[:id])
    render json: @policy, status: :ok if @policy.present?
  end

  private

  def record_not_found
    render plain: "404 Not Found", status: :not_found
  end

  def authenticate
    @token = request.headers["Authorization"]&.split(" ")&.last
    jwt_payload = Warden::JWTAuth::TokenDecoder.new.call(@token)
    jwt_payload["sub"].present?
  end

  def invalid_token
    render json: {invalid_token: "Erro ao verificar token: O token é inválido ou modificado"},
      status: 401
  end

  def decode_error
    render json: {decode_error: "Erro ao decodificar token: formato inválido ou token inexistente."},
      status: 401
  end

  def expiration_error
    render json: {expiration_error: "Token expirado, recrie o token e tente novamente"}, status: 401
  end
end
