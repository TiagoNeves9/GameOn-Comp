/*k) Criar o procedimento armazenado enviarMensagem que recebe como parâmetros os
identificadores de um jogador e de uma conversa e o texto de uma mensagem e procede ao
envio dessa mensagem para a conversa indicada, associando-a ao jogador também indicado.*/


create or replace procedure enviarMensagem(id_jogador int, id_conv int, msg varchar(500))
language plpgsql
as $$
    declare
        v_username VARCHAR(40);
        v_email VARCHAR(40);
        v_nome_regiao VARCHAR(40);
        nmr_msg INT;
begin

    --Verificar que o texto da mensagem a ser enviada não é null
    if msg is null then raise exception 'A mensagem tem de ter texto!';
    end if;

     --Verificar se o id_jogador passado como parâmetro existe na tabela de jogadores.
    if not exists(select * from jogadores where id_player = id_jogador) then
        raise exception 'O id passado como parâmetro não existe na tabela JOGADORES.';
    end if;

    --Verificar se o id_conv passado como parâmetro existe na tabela de conversas.
    if not exists(select * from conversas where id_conversa = id_conv) then
        raise exception 'O id passado como parâmetro não existe na tabela CONVERSAS.';
    end if;

    create table tabelaK as
        select username, email, nome_regiao
        from jogadores
        where id_player = id_jogador;

    select username, email, nome_regiao into v_username, v_email, v_nome_regiao from tabelaK;
    select max(nmr_seq_msg)+1 into nmr_msg from mensagens where id_conversa = id_conv;

    insert into criar values (id_jogador, v_username, v_email, v_nome_regiao, id_conv);
    insert into mensagens values (id_conv, nmr_msg, msg, id_jogador, current_date);

    drop table if exists tabelaK;

end
$$;             --NAO ESTA TOTALMENTE FUNCIONAL

call enviarMensagem(1000,100002,'mekie mpts daqui quem fala é o Vascaao');
call enviarMensagem(1000,100003,'voces tao bem?');
call enviarMensagem(1000,100003,'bora embora');
select * from mensagens;
select * from conversas;
select * from criar;