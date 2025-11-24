from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.hashers import check_password
# (REMOVIDO): make_password não é necessário aqui, pois não vamos salvar senha nova
from django.contrib.auth import login, logout
from .models import Usuario


class LoginView(APIView):
    """
    Recebe email e senha, valida e cria sessão (ou token) de login.
    """
    def post(self, request):
        email = request.data.get('email')
        senha = request.data.get('senha')

        if not email or not senha:
            return Response({'erro': 'Email e senha são obrigatórios!'},
                            status=status.HTTP_400_BAD_REQUEST)

        # MUDANÇA 1: Troquei get_object_or_404 por try/except.
        # Motivo: Segurança. Se usarmos 404, um atacante descobre quais emails existem no banco.
        # Agora retornamos "Credenciais inválidas" (401) tanto para email errado quanto para senha errada.
        try:
            usuario = Usuario.objects.get(email=email)
        except Usuario.DoesNotExist:
            return Response({'erro': 'Credenciais inválidas'},
                            status=status.HTTP_401_UNAUTHORIZED)

        # CORREÇÃO CRÍTICA (BUG DE SEGURANÇA):
        # A linha abaixo foi REMOVIDA. Ela pegava a senha enviada, gerava um hash e
        # substituía a senha do banco na memória. Isso fazia qualquer senha ser aceita.
        # usuario.senha = make_password(senha)  <-- REMOVIDO

        # Valida senha
        # Agora comparamos a 'senha' (texto puro enviada pelo user)
        # com 'usuario.senha' (hash original salvo no banco de dados)
        if not check_password(senha, usuario.senha):
            return Response({'erro': 'Credenciais inválidas'}, # Mensagem genérica por segurança
                            status=status.HTTP_401_UNAUTHORIZED)

        # Cria a sessão Django
        # OBS: Isso agora funciona porque adicionamos o campo 'last_login' no models.py
        if usuario.tipo_usuario: # Verificação simples para garantir que o objeto está íntegro
            login(request, usuario)

        return Response({
            'mensagem': 'Login realizado com sucesso.',
            'usuario': {
                'id': usuario.id,
                'nome': usuario.nome,
                'email': usuario.email,
                'tipo_usuario': usuario.tipo_usuario
            }
        }, status=status.HTTP_200_OK)


class LogoutView(APIView):
    """
    Endpoint para encerrar a sessão do usuário.
    """
    def post(self, request):
        logout(request)
        return Response({'mensagem': 'Logout realizado com sucesso.'},
                        status=status.HTTP_200_OK)