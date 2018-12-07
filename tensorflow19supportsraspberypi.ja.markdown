
# TensorFlow 1.9はラズベリーパイを正式にサポート

ソフトウェアエンジニア、Pete Warden

![[*CC Photo by osde8info](https://www.flickr.com/photos/osde-info/8626662243/in/photolist-e9iU8V-c5MSNd-fmVdvx-c5MRwC-ds8ei9-cDBDks-cddC9h-e9pzWW-dcFMuG-dcwSD8-bVRjqH-c1gNLw-cdE5Wy-cddzRN-bz7n87-dC1nJE-dHqTrx-ese95j-dcFKhR-esemvj-gKRLrn-oR7oB7-cjPyjq-ejDYL4-iYkRnk-iYjUV6-BFsVnj-oviiM5-tCLwAw-esebzQ-ox49Mn-tmBYhn-eseviG-dHwhXE-eseenu-dHwfKW-cjPyDC-dS4QZz-dTsudR-coqbmw-dLAfzv-iYkXER-iYpdbG-iYmAZm-cu8JLU-bW6T8t-TaC67b-jLKzPe-cs27eU-ihce1u)*](https://cdn-images-1.medium.com/max/2716/0*uNJCdFk4OFwlNCoj)[CC Photo by osde8info](https://www.flickr.com/photos/osde-info/8626662243/in/photolist-e9iU8V-c5MSNd-fmVdvx-c5MRwC-ds8ei9-cDBDks-cddC9h-e9pzWW-dcFMuG-dcwSD8-bVRjqH-c1gNLw-cdE5Wy-cddzRN-bz7n87-dC1nJE-dHqTrx-ese95j-dcFKhR-esemvj-gKRLrn-oR7oB7-cjPyjq-ejDYL4-iYkRnk-iYjUV6-BFsVnj-oviiM5-tCLwAw-esebzQ-ox49Mn-tmBYhn-eseviG-dHwhXE-eseenu-dHwfKW-cjPyDC-dS4QZz-dTsudR-coqbmw-dLAfzv-iYkXER-iYpdbG-iYmAZm-cu8JLU-bW6T8t-TaC67b-jLKzPe-cs27eU-ihce1u)

2015年にTensorFlowが初めて発売されたとき、我々はそれを「 [open source machine learning framework for everyone](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/pip_package/setup.py#L15) 」にしたいと考えました。そのためには、できるだけ多くの人々が使用しているプラ​​ットフォームを実行する必要があります。 Linux、MacOS、Windows、iOS、Androidは長い間サポートしてきましたが、多くの寄稿者の勇敢な努力にもかかわらず、Raspberry PiでTensorFlowを実行すると多くの作業が必要でした。 [Raspberry Pi Foundation](https://www.raspberrypi.org/)とのコラボレーションのおかげで、Pythonのpipパッケージシステムを使って、TensorFlowの最新の1.9リリースを、ビルド済みのバイナリからインストールすることができます。 Raspbian 9（ストレッチ）を実行している場合は、ターミナルから次の2つのコマンドを実行してインストールできます。

    sudo apt install libatlas-base-dev

    pip3 install tensorflow

ターミナルでpython3を実行し、他のプラットフォームと同じようにTensorFlowを使用することができます。こんにちは、世界の例です:

    # Python

    import tensorflow as tf

    tf.enable_eager_execution()

    hello = tf.constant(‘Hello, TensorFlow!’)

    print(hello)

システムから次の情報が出力された場合は、TensorFlowプログラムの作成を開始する準備が整いました。

こんにちは、TensorFlow！

[more details on installing and troubleshooting TensorFlow on the Raspberry Pi on the TensorFlow website](https://www.tensorflow.org/install/install_raspbian)があります。

ラズベリーパイは多くの革新的な開発者によって使用されており、プログラミングに人を紹介するための教育でも広く使用されているため、これに興奮しています.TensorFlowをインストールしやすくすると、新しい学習者に機械学習を開くのに役立ちます。 [DonkeyCar](http://www.donkeycar.com/)ようなプラットフォームでは、TensorFlowとRaspberry Piを使って[DonkeyCar](http://www.donkeycar.com/)用のおもちゃ車を作ることができました。難易度を下げた今、新しいプロジェクトが作られるのを待つことはできません。

ラズベリーパイプロジェクトの創設者である[Eben Upton](https://twitter.com/ebenupton)は、「現代のコンピューティング教育は、基礎と将来のトピックの両方をカバーすることが不可欠です。これを念頭に置いて、TensorFlowのマシン学習をRaspberry PiプラットフォームにもたらすためにGoogleと協力することに非常に興奮しています。われわれは（あらゆる年齢の）子供たちが楽しいアプリケーションを作ってくれるのを楽しみにしている」と同氏は同意する。

このような費用対効果に優れた柔軟なデバイスで機械学習の可能性を探るために、より多くの教材やチュートリアルが登場することを期待しています。
