from rest_framework.exceptions import PermissionDenied
from rest_framework.viewsets import ModelViewSet
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework import status
from .models import Evento
from .serializers import EventoSerializer
from autenticacao.permissions import IsONG
from participacoes.models import Participacao
from participacoes.serializers import ParticipacaoDetalhadaSerializer

class EventoViewSet(ModelViewSet):
    queryset = Evento.objects.all().order_by('-data_inicio')
    serializer_class = EventoSerializer
    permission_classes = [IsAuthenticatedOrReadOnly, IsONG]

    def get_queryset(self):
        queryset = super().get_queryset()
        cidade = self.request.query_params.get('cidade')
        estado = self.request.query_params.get('estado')

        if cidade:
            queryset = queryset.filter(local__icontains=cidade)
        if estado:
            queryset = queryset.filter(local__icontains=estado)
        
        meus_eventos = self.request.query_params.get('meus_eventos')
        if meus_eventos and self.request.user.is_authenticated:
            queryset = queryset.filter(criado_por=self.request.user)
        
        return queryset

    def perform_create(self, serializer):
        serializer.save(criado_por=self.request.user)

    def perform_update(self, serializer):
        evento = self.get_object()
        
        # Correção: Lançar exceção interrompe o fluxo imediatamente
        if evento.criado_por != self.request.user:
            raise PermissionDenied("Você não tem permissão para editar este evento.")
            
        serializer.save()

    @action(detail=True, methods=['get'], permission_classes=[IsAuthenticated])
    def participantes(self, request, pk=None):

        evento = self.get_object()
        
        if evento.criado_por != request.user:
            return Response(
                {"erro": "Você não tem permissão para visualizar os participantes deste evento."},
                status=status.HTTP_403_FORBIDDEN
            )
        
        participacoes = Participacao.objects.filter(evento=evento).select_related('voluntario')
        serializer = ParticipacaoDetalhadaSerializer(participacoes, many=True)
        
        return Response({
            "evento_id": evento.id,
            "evento_titulo": evento.titulo,
            "total_participantes": participacoes.count(),
            "vagas_disponiveis": evento.vagas - participacoes.count(),
            "participantes": serializer.data
        })
