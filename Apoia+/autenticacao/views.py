from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.hashers import check_password, make_password
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

        usuario = get_object_or_404(Usuario, email=email)
        usuario.senha = make_password(senha)

        # Valida senha
        if not check_password(senha, usuario.senha):
            return Response({'erro': 'Senha incorreta!'},
                            status=status.HTTP_401_UNAUTHORIZED)

        # Cria a sessão Django
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