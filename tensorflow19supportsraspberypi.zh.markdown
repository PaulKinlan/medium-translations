
# TensorFlow 1.9正式支持Raspberry Pi

作者:Pete Warden，软件工程师

！ [[*CC Photo by osde8info](https://www.flickr.com/photos/osde-info/8626662243/in/photolist-e9iU8V-c5MSNd-fmVdvx-c5MRwC-ds8ei9-cDBDks-cddC9h-e9pzWW-dcFMuG-dcwSD8-bVRjqH-c1gNLw-cdE5Wy-cddzRN-bz7n87-dC1nJE-dHqTrx-ese95j-dcFKhR-esemvj-gKRLrn-oR7oB7-cjPyjq-ejDYL4-iYkRnk-iYjUV6-BFsVnj-oviiM5-tCLwAw-esebzQ-ox49Mn-tmBYhn-eseviG-dHwhXE-eseenu-dHwfKW-cjPyDC-dS4QZz-dTsudR-coqbmw-dLAfzv-iYkXER-iYpdbG-iYmAZm-cu8JLU-bW6T8t-TaC67b-jLKzPe-cs27eU-ihce1u) *]（https://cdn-images-1.medium.com/max/2716/0*uNJCdFk4OFwlNCoj）* [*CC Photo by osde8info](https://www.flickr.com/photos/osde-info/8626662243/in/photolist-e9iU8V-c5MSNd-fmVdvx-c5MRwC-ds8ei9-cDBDks-cddC9h-e9pzWW-dcFMuG-dcwSD8-bVRjqH-c1gNLw-cdE5Wy-cddzRN-bz7n87-dC1nJE-dHqTrx-ese95j-dcFKhR-esemvj-gKRLrn-oR7oB7-cjPyjq-ejDYL4-iYkRnk-iYjUV6-BFsVnj-oviiM5-tCLwAw-esebzQ-ox49Mn-tmBYhn-eseviG-dHwhXE-eseenu-dHwfKW-cjPyDC-dS4QZz-dTsudR-coqbmw-dLAfzv-iYkXER-iYpdbG-iYmAZm-cu8JLU-bW6T8t-TaC67b-jLKzPe-cs27eU-ihce1u) **

当TensorFlow于2015年首次推出时，我们希望它成为“ [open source machine learning framework for everyone](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/pip_package/setup.py#L15) ”。要做到这一点，我们需要尽可能多地运行人们正在使用的平台。我们长期以来一直支持Linux，MacOS，Windows，iOS和Android，但是尽管许多贡献者付出了巨大努力，但在Raspberry Pi上运行TensorFlow还是需要做很多工作。感谢与[Raspberry Pi Foundation](https://www.raspberrypi.org/)的合作，我们现在很高兴地说，可以使用Python的pip包系统从预构建的二进制文件安装最新的1.9版TensorFlow！如果你正在运行Raspbian 9（拉伸），你可以通过从终端运行这两个命令来安装它:

    sudo apt install libatlas-base-dev

    pip3 install tensorflow

然后，您可以在终端中运行python3，并像在任何其他平台上一样使用TensorFlow。这是一个简单的hello world示例:

    # Python

    import tensorflow as tf

    tf.enable_eager_execution()

    hello = tf.constant(‘Hello, TensorFlow!’)

    print(hello)

如果系统输出以下内容，那么您就可以开始编写TensorFlow程序了:

你好，TensorFlow！

有[more details on installing and troubleshooting TensorFlow on the Raspberry Pi on the TensorFlow website](https://www.tensorflow.org/install/install_raspbian) 。

我们对此感到很兴奋，因为Raspberry Pi被许多创新开发人员使用，并且还广泛用于教育以向人们介绍编程，因此使TensorFlow更易于安装将有助于向新受众开放机器学习。我们已经看到像[DonkeyCar](http://www.donkeycar.com/)这样的平台使用TensorFlow和Raspberry Pi来制造自动驾驶玩具车，我们迫不及待想要发现现在我们已经减少了难度的新项目。

Raspberry Pi项目的创始人[Eben Upton](https://twitter.com/ebenupton)说:“现代计算机教育必须涵盖基础知识和前瞻性主题，这一点至关重要。考虑到这一点，我们非常高兴能与Google合作，将TensorFlow机器学习带入Raspberry Pi平台。我们期待看到孩子（所有年龄段）用它创造有趣的应用程序，“我们同意！

我们希望看到更多教育材料和教程的出现，这将有助于越来越多的人在这种经济高效且灵活的设备上探索机器学习的可能性。
