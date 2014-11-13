class CreateTarjeta < ActiveRecord::Migration
  def change
    execute <<-SQL
      CREATE TABLE tarjetas(
        noTarjeta varchar(16) not null primary key,
        idusuario int not null references usuarios(idusuario),
        valor int,
        saldo numeric(10,2)
      );
    SQL
  end
end
