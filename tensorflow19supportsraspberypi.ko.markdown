
# TensorFlow 1.9가 라스베리 파이를 공식 지원합니다

Pete Warden 소프트웨어 엔지니어

! [[*CC Photo by osde8info](https://www.flickr.com/photos/osde-info/8626662243/in/photolist-e9iU8V-c5MSNd-fmVdvx-c5MRwC-ds8ei9-cDBDks-cddC9h-e9pzWW-dcFMuG-dcwSD8-bVRjqH-c1gNLw-cdE5Wy-cddzRN-bz7n87-dC1nJE-dHqTrx-ese95j-dcFKhR-esemvj-gKRLrn-oR7oB7-cjPyjq-ejDYL4-iYkRnk-iYjUV6-BFsVnj-oviiM5-tCLwAw-esebzQ-ox49Mn-tmBYhn-eseviG-dHwhXE-eseenu-dHwfKW-cjPyDC-dS4QZz-dTsudR-coqbmw-dLAfzv-iYkXER-iYpdbG-iYmAZm-cu8JLU-bW6T8t-TaC67b-jLKzPe-cs27eU-ihce1u) *] (https://cdn-images-1.medium.com/max/2716/0*uNJCdFk4OFwlNCoj) * [*CC Photo by osde8info](https://www.flickr.com/photos/osde-info/8626662243/in/photolist-e9iU8V-c5MSNd-fmVdvx-c5MRwC-ds8ei9-cDBDks-cddC9h-e9pzWW-dcFMuG-dcwSD8-bVRjqH-c1gNLw-cdE5Wy-cddzRN-bz7n87-dC1nJE-dHqTrx-ese95j-dcFKhR-esemvj-gKRLrn-oR7oB7-cjPyjq-ejDYL4-iYkRnk-iYjUV6-BFsVnj-oviiM5-tCLwAw-esebzQ-ox49Mn-tmBYhn-eseviG-dHwhXE-eseenu-dHwfKW-cjPyDC-dS4QZz-dTsudR-coqbmw-dLAfzv-iYkXER-iYpdbG-iYmAZm-cu8JLU-bW6T8t-TaC67b-jLKzPe-cs27eU-ihce1u) **

TensorFlow가 2015 년에 처음 출시되었을 때, 우리는 그것이 &quot; [open source machine learning framework for everyone](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/pip_package/setup.py#L15) &quot; [open source machine learning framework for everyone](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/pip_package/setup.py#L15) 원했습니다. 그렇게하려면 사람들이 가능한 한 많이 사용하는 플랫폼에서 실행해야합니다. 우리는 오랫동안 Linux, MacOS, Windows, iOS 및 Android를 지원해 왔지만, 많은 기여자들의 영웅적인 노력에도 불구하고 Raspberry Pi에서 TensorFlow를 실행하면 많은 작업이 필요했습니다. [Raspberry Pi Foundation](https://www.raspberrypi.org/) 과의 협력 덕분에 TensorFlow의 최신 1.9 릴리스는 Python의 pip 패키지 시스템을 사용하여 사전 빌드 된 바이너리에서 설치할 수 있다는 것을 기쁜 마음으로 알려드립니다! Raspbian 9 (스트레치)를 실행중인 경우 터미널에서 다음 두 명령을 실행하여 설치할 수 있습니다.

    sudo apt install libatlas-base-dev

    pip3 install tensorflow

그런 다음 터미널에서 python3을 실행하고 다른 플랫폼에서와 마찬가지로 TensorFlow를 사용할 수 있습니다. 다음은 간단한 hello 예제입니다.

    # Python

    import tensorflow as tf

    tf.enable_eager_execution()

    hello = tf.constant(‘Hello, TensorFlow!’)

    print(hello)

시스템이 다음을 출력하면 TensorFlow 프로그램을 작성할 준비가 된 것입니다.

안녕하세요, TensorFlow!

[more details on installing and troubleshooting TensorFlow on the Raspberry Pi on the TensorFlow website](https://www.tensorflow.org/install/install_raspbian) 있습니다.

Riddleberry Pi는 많은 혁신적인 개발자가 사용하고 프로그래밍에 사람들을 소개하기 위해 널리 사용되기 때문에 TensorFlow를 설치하기가 쉬워지면 새로운 학습자에게 기계 학습을 개방하는 데 도움이됩니다. 우리는 이미 [DonkeyCar](http://www.donkeycar.com/) 와 같은 플랫폼에서 TensorFlow와 Raspberry Pi를 사용하여자가 운전 장난감 자동차를 만들었 [DonkeyCar](http://www.donkeycar.com/) 새로운 프로젝트가 만들어 [DonkeyCar](http://www.donkeycar.com/) 볼 수 없습니다.

Raspberry Pi 프로젝트의 창립자 인 [Eben Upton](https://twitter.com/ebenupton) 은 &quot;근대 컴퓨팅 교육은 기본과 미래 지향적 인 주제를 다루는 것이 중요합니다. 이를 염두에두고 Google은 TensorFlow 머신 학습을 Raspberry Pi 플랫폼에 가져 오기 위해 Google과 협력하게되어 매우 기쁩니다. 우리는 (모든 연령층의) 재미있는 응용 프로그램이 무엇으로 만들어 지는지보기를 기대합니다. &quot;그리고 우리는 동의합니다!

우리는 비용 효과적이고 유연한 장치로 점점 더 많은 사람들이 기계 학습의 가능성을 탐구하는 데 도움이되는 훨씬 많은 교육 자료와 자습서가 등장하기를 기대합니다.
