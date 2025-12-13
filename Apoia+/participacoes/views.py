from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import ValidationError
from .models import Participacao
from .serializers import ParticipacaoSerializer
from eventos.models import Evento

class ParticipacaoViewSet(viewsets.ModelViewSet):
    serializer_class = ParticipacaoSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # Garante que o usuário só vê as próprias inscrições
        return Participacao.objects.filter(voluntario=self.request.user)

    def perform_create(self, serializer):
        # O Serializer já validou o ID e buscou o objeto. 
        # Pegamos o objeto pronto aqui:
        evento = serializer.validated_data['evento']
        user = self.request.user

        # 1. Validação de Duplicidade
        if Participacao.objects.filter(voluntario=user, evento=evento).exists():
            raise ValidationError({"erro": "Você já está inscrito neste evento!"})
        
        # 2. Validação de Vagas
        if evento.participantes >= evento.vagas:
            raise ValidationError({"erro": "Não há mais vagas disponíveis."})

        # --- CORREÇÃO: Apenas salvar. O Model dispara a lógica de +1 ---
        serializer.save(voluntario=user)

    def perform_destroy(self, instance):
        # --- CORREÇÃO: Apenas deletar. O Model dispara a lógica de -1 ---
        instance.delete()
