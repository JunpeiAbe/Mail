/*
// 参考：https://zenn.dev/flyingbarbarian/articles/8253b3a2b42e6c
 
1. Rubyがインストールされているか確認
$ ruby --version

2. RubyGemsのアップデート(推奨)
$ sudo gem update --system

3. CocoaPodsのインストール
$ sudo gem install cocoapods

4. CocoaPodsのバージョン確認
$ pod --version
 
 ⚠️M1 Mac（Apple Silicon）には特有のアーキテクチャ(Arm64)による制約があるため、CocoaPodsのインストールにおいて追加の手順が必要になる場合がある。
   以下は、M1 Mac向けの手順を含むインストール方法。
   CocoaPodsは古いバージョンのアーキテクチャを採用しているためArm64で実行できる形に調節が必要

 手順 1: 必要なツールのインストール
 1.1 Homebrewのインストール
 Homebrewがインストールされていない場合は、以下を実行。

 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
 確認: インストール後に以下を実行し、Homebrewが正しくインストールされているか確認します。
 brew --version
 
 1.2 rbenvのインストール
 rbenvを使用してRubyのバージョンを管理します。
 <インストール>
 brew install rbenv
 
 rbenvのパスをシェルに追加（.zshrcまたは.bashrcに追記）
 <設定ファイルの編集>
 nano ~/.zshrc
 
 <追加項目>
 # rbenvの初期化
 export PATH="$HOME/.rbenv/bin:$PATH"
 eval "$(rbenv init -)"
 
 <保存方法（nanoエディタ使用時)>
 Ctrl + O → 保存
 Enter → 確定
 Ctrl + X → 終了
 
<設定の反映>
 source ~/.zshrc
 
 <確認>
 rbenv --version
 
 1.3 Rubyのインストール
 Apple Siliconでは、システムRuby(デフォルトで入っているもの)に制約があるため、rbenvで新しいRubyをインストールします。

 <bash>
 rbenv install 3.2.2
 rbenv global 3.2.2
 インストール後にruby --versionを実行し、正しいバージョンが選択されていることを確認。
 ruby --version
 
 1.4 CocoaPodsのインストール
 以下のコマンドを実行して、CocoaPodsをインストール：
 <bash>
 gem install cocoapods
 
 <CocoaPodsのセットアップ>
 初回セットアップを行う：

 <bash>
 pod setup
 
 <インストール確認>
 以下を実行してCocoaPodsが正しくインストールされているか確認：
 pod --version

 
 
<構成>
 Mac
 　├ Homebrew：Macにインストールするライブラリを管理。全てのライブラリ管理ツールの親。
 　│　└ rbenv：rubyのバージョンを管理に必要。homebrewの子としてインストール。
 　│　　　└ ruby：rbenvの子としてインストール。Gemのインストールに必要。GemとはRubyで書かれたライブラリのこと。
 　│　　　　　└ CocoaPods：iOSアプリのライブラリ管理に必要。rubyの子としてインストール。
 　└ Xcode
 

*/
