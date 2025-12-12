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
        return Participacao.objects.filter(voluntario=self.request.user)

    def perform_create(self, serializer):
        evento_id = self.request.data.get('evento')
        evento = Evento.objects.get(id=evento_id)
        user = self.request.user

        if Participacao.objects.filter(voluntario=user, evento=evento).exists():
            raise ValidationError({"erro": "Você já está inscrito neste evento!"})
        if evento.participantes >= evento.vagas:
            raise ValidationError({"erro": "Não há mais vagas disponíveis."})

        serializer.save(voluntario=user)

        # Atualiza o contador no evento (+1 participante)
        evento.participantes += 1
        evento.save()

    # Se o usuário cancelar a vaga é devolvida
    def perform_destroy(self, instance):
        evento = instance.evento
        evento.participantes -= 1
        evento.save()
        instance.delete()