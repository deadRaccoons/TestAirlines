# -*- coding: utf-8 -*-
class CreateLogins < ActiveRecord::Migration
  def change
    execute <<-SQL
      CREATE TABLE logins(
        correo text not null,
        contraseña varchar(18) not null,
        activo char(1) not null check(activo in ('y', 'n'))
      );
      
      alter table logins
      add constraint loginc
      primary key (correo);
    SQL
  end
end
