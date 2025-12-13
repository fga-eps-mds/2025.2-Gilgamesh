from rest_framework import serializers
from .models import Evento

class EventoSerializer(serializers.ModelSerializer):
    criado_por = serializers.StringRelatedField(read_only=True)
    participantes = serializers.SerializerMethodField()
    
    class Meta:
        model = Evento
        fields = [
            'id',
            'titulo',
            'descricao',
            'data_inicio',
            'data_fim',
            'local',
            'criado_por',
            'criado_em',
            'atualizado_em',
            'vagas',
            'participantes', 
        ]
        read_only_fields = ['criado_por', 'criado_em', 'atualizado_em']
    
    def get_participantes(self, obj):
        return obj.participacao_set.count()