defmodule Utils.Argon do

  @secret Application.compile_env(:ice, :secret_key_pwd)

  def encode_pwd(pwd) do
    Argon2.Base.hash_password(pwd, @secret)
  end

  def verify_pwd(pwd, hash) do 
    Argon2.verify_pass(pwd, hash)
  end
end
