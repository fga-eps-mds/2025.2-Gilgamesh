from django.contrib import admin
from .models import Evento, Participacao

# O @admin.register é uma forma mais limpa de registrar um model
# A classe EventoAdmin personaliza como o model 'Evento' aparece no admin

@admin.register(Evento)
class EventoAdmin(admin.ModelAdmin):
    # list_display define quais colunas aparecem na lista de eventos
    list_display = ('nome_evento', 'data_evento', 'localizacao_evento', 'vagas_totais', 'numero_participantes')
    
    # search_fields adiciona uma barra de busca
    search_fields = ('nome_evento', 'localizacao_evento')
    
    # list_filter adiciona um filtro rápido na lateral
    list_filter = ('data_evento', 'localizacao_evento')

@admin.register(Participacao)
class ParticipacaoAdmin(admin.ModelAdmin):
    # list_display para as participações
    list_display = ('id_evento', 'id_usuario', 'status', 'data_inscricao')
    
    # list_filter para filtrar por status ou evento
    list_filter = ('status', 'id_evento')
    
    # search_fields para buscar por usuário (pelo email, por exemplo)
    search_fields = ('id_usuario__email',) # Busca dentro do modelo relacionado