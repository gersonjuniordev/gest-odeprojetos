# Gestão Mobile - Guia de Configuração

Aplicativo mobile para gestão de equipes e projetos desenvolvido com Flutter, Dart e Firebase.

## Pré-requisitos

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/)
- [Conta Firebase](https://firebase.google.com/)
- [Node.js](https://nodejs.org/) (para Firebase Functions)

## 1. Criar o Projeto

Criar novo projeto Flutter:

```bash
flutter create gestao_equipes
```

Entrar na pasta do projeto:

```bash
cd gestao_equipes
```
pubspec.yaml
name: gestao_equipes
description: Aplicativo de gestão de equipes e projetos
environment:
sdk: ">=3.0.0 <4.0.0"
dependencies:
flutter:
sdk: flutter
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
cloud_firestore: ^4.13.6
firebase_messaging: ^14.7.9
provider: ^6.1.1
hive: ^2.2.3
hive_flutter: ^1.1.0
connectivity_plus: ^5.0.2
fl_chart: ^0.60.0
dev_dependencies:
flutter_test:
sdk: flutter
flutter_lints: ^2.0.0
flutter:
uses-material-design: true

## 3. Configuração do Firebase

1. Criar projeto no Firebase Console:
   - Acesse [console.firebase.google.com](https://console.firebase.google.com)
   - Clique em "Criar Projeto"
   - Nome: "gestao_equipes"
   - Siga o assistente de configuração

2. Instalar e configurar Firebase CLI:
   - [Instalar Firebase CLI](https://firebase.google.com/docs/cli)
   - `npm install -g firebase-tools`
   - `firebase login`
   - `firebase init`

3. Configurar Firebase no projeto Flutter:
   - No arquivo `android/app/src/main/AndroidManifest.xml`, adicione:
     ```xml
     <application
       android:name="io.flutter.embedding.android.FlutterApplication"
       android:label="gestao_equipes"
       android:icon="@mipmap/ic_launcher">
     ```

## 4. Configurar Firebase Functions

1. Criar no Firebase Console:
   - Acesse [console.firebase.google.com](https://console.firebase.google.com)
   - Clique em "Criar Projeto"
   - Nome: "gestao_equipes"
   - Siga o assistente de configuração

2. Configurar Firebase Functions:
   - No arquivo `functions/src/index.ts`, adicione:
     ```ts
     import * as functions from 'firebase-functions';
     import * as admin from 'firebase-admin';
     ```
## 5. Executar o Projeto

1. Executar no Android Studio:
   - `flutter run`

2. Executar no VS Code:
   - `flutter run`

## 6. Testar o Projeto

1. Executar no Android Studio:
   - `flutter test`

2. Executar no VS Code:
   - `flutter test`

## 7. Deploy

1. Deploy no Firebase Functions:
   - `firebase deploy --only functions`

2. Deploy no Firebase App:
   - `firebase deploy --only app`

## 8. Testar o Deploy

1. Acessar o app no Firebase Console:
   - Acesse [console.firebase.google.com](https://console.firebase.google.com)
   - Selecione o projeto "gestao_equipes"
   - Acesse a seção "Testes"
   - Clique em "Executar teste"

## 9. Desenvolvimento

1. Adicionar novas funcionalidades:
   - Crie novas classes no diretório `lib`
   - Adicione novas telas no diretório `lib/screens`
   - Adicione novas rotas no arquivo `lib/main.dart`

2. Testar no Android Studio:
   - `flutter test`

3. Testar no VS Code:
   - `flutter test`

## Firebase não iniciliza

1. Verificar se o projeto está no Firebase Console
2. Verificar se o projeto está no arquivo `pubspec.yaml`
3. Verificar se o projeto está no arquivo `android/app/src/main/AndroidManifest.xml`
4. Verificar se o projeto está no arquivo `functions/src/index.ts`

## Problemas com notificações

1. Verificar se o projeto está no Firebase Console
2. Verificar se o projeto está no arquivo `pubspec.yaml`
3. Verificar se o projeto está no arquivo `android/app/src/main/AndroidManifest.xml`
4. Verificar se o projeto está no arquivo `functions/src/index.ts`

## Erro nas permissões do Firebase

1. Verificar se o projeto está no Firebase Console
2. Verificar se o projeto está no arquivo `pubspec.yaml`
3. Verificar se o projeto está no arquivo `android/app/src/main/AndroidManifest.xml`
4. Verificar se o projeto está no arquivo `functions/src/index.ts`

## 10. Comandos úteis

- `flutter clean`: Limpar o projeto
- `flutter pub get`: Atualizar as dependências
- `flutter pub run build_runner build`: Atualizar as dependências

## Suporte

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio)
- [VS Code](https://code.visualstudio.com/)
- [Firebase](https://firebase.google.com/)
- [Node.js](https://nodejs.org/)   


