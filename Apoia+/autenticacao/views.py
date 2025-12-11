from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.hashers import check_password
from django.contrib.auth import login, logout, authenticate
from .models import Usuario
from .serializers import UsuarioSerializer
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication



class LoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        senha = request.data.get('senha')

        if not email or not senha:
            return Response({'erro': 'Email e senha obrigatórios'}, status=status.HTTP_400_BAD_REQUEST)

        # Procura o usuário pelo email
        # Verifica o hash da senha automaticamente
        # Retorna o usuário pronto para login (ou None se falhar), tudo feito pelo Django
        user = authenticate(request, email=email, password=senha)

        if user is not None:
            
            token, created = Token.objects.get_or_create(user=user) #gera ou recupera token de usuário
            
            return Response({
                'mensagem': 'Login realizado com sucesso.',
                'token' : token.key, #flutter precisa desse token
                'usuario': {
                    'id': user.id,
                    'nome': user.nome,
                    'email': user.email,
                    # Se tiver mudado para AbstractBaseUser, acesse os campos corretamente
                    'tipo_usuario': getattr(user, 'tipo_usuario', 'desconhecido') 
                }
            }, status=status.HTTP_200_OK)
        else:
            return Response({'erro': 'Credenciais inválidas'}, status=status.HTTP_401_UNAUTHORIZED)
        
class LogoutView(APIView):
    """
    Endpoint para encerrar a sessão do usuário.
    """
    def post(self, request):
        logout(request)
        return Response({'mensagem': 'Logout realizado com sucesso.'},
                        status=status.HTTP_200_OK)
        
class CadastroView(APIView):
    """
    Recebe os dados do formulário, valida via Serializer e cria o usuário.
    """
    def post(self, request):
        # Passamos os dados do request para o Serializer
        serializer = UsuarioSerializer(data=request.data)
        
        # O serializer valida tudo (se email já existe, se CNPJ é obrigatório, etc)
        if serializer.is_valid():
            # O método .save() chama o create() que escrevemos no serializer
            novo_usuario = serializer.save()
            
            return Response({
                'mensagem': 'Usuário cadastrado com sucesso!',
                'usuario': {
                    'id': novo_usuario.id,
                    'nome': novo_usuario.nome,
                    'email': novo_usuario.email,
                    'tipo': novo_usuario.tipo_usuario
                }
            }, status=status.HTTP_201_CREATED)
            
        # Se houver erro (ex: senha curta, email repetido), retorna o erro detalhado
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    




class AtualizarUsuarioView(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        serializer = UsuarioSerializer(request.user)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def put(self, request):
        usuario = request.user        
        campos_bloqueados = ['email', 'tipo_usuario', 'cpf', 'cnpj', 'password']
        
        dados_permitidos = {
            k: v for k, v in request.data.items() 
            if k not in campos_bloqueados
        }
        
        serializer = UsuarioSerializer(
            usuario, 
            data=dados_permitidos, 
            partial=True
        )
        
        if serializer.is_valid():
            serializer.save()
            return Response({
                'mensagem': 'Dados atualizados com sucesso!',
                'usuario': serializer.data
            }, status=status.HTTP_200_OK)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class AlterarSenhaView(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        usuario = request.user
        
        senha_atual = request.data.get('senha_atual')
        nova_senha = request.data.get('nova_senha')
        confirma_senha = request.data.get('confirma_senha')
        
        if not senha_atual or not nova_senha or not confirma_senha:
            return Response(
                {'erro': 'Todos os campos são obrigatórios'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if not check_password(senha_atual, usuario.password):
            return Response(
                {'erro': 'Senha atual incorreta'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if nova_senha != confirma_senha:
            return Response(
                {'erro': 'As novas senhas não coincidem'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if senha_atual == nova_senha:
            return Response(
                {'erro': 'A nova senha deve ser diferente da atual'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if len(nova_senha) < 6:
            return Response(
                {'erro': 'A senha deve ter no mínimo 6 caracteres'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        usuario.set_password(nova_senha)
        usuario.save()
        
        return Response(
            {'mensagem': 'Senha alterada com sucesso!'}, 
            status=status.HTTP_200_OK
        )