
# TensorFlow 1.9 Officially Supports the Raspberry Pi

By Pete Warden, Software Engineer

![[*CC Photo by osde8info](https://www.flickr.com/photos/osde-info/8626662243/in/photolist-e9iU8V-c5MSNd-fmVdvx-c5MRwC-ds8ei9-cDBDks-cddC9h-e9pzWW-dcFMuG-dcwSD8-bVRjqH-c1gNLw-cdE5Wy-cddzRN-bz7n87-dC1nJE-dHqTrx-ese95j-dcFKhR-esemvj-gKRLrn-oR7oB7-cjPyjq-ejDYL4-iYkRnk-iYjUV6-BFsVnj-oviiM5-tCLwAw-esebzQ-ox49Mn-tmBYhn-eseviG-dHwhXE-eseenu-dHwfKW-cjPyDC-dS4QZz-dTsudR-coqbmw-dLAfzv-iYkXER-iYpdbG-iYmAZm-cu8JLU-bW6T8t-TaC67b-jLKzPe-cs27eU-ihce1u)*](https://cdn-images-1.medium.com/max/2716/0*uNJCdFk4OFwlNCoj)*[*CC Photo by osde8info](https://www.flickr.com/photos/osde-info/8626662243/in/photolist-e9iU8V-c5MSNd-fmVdvx-c5MRwC-ds8ei9-cDBDks-cddC9h-e9pzWW-dcFMuG-dcwSD8-bVRjqH-c1gNLw-cdE5Wy-cddzRN-bz7n87-dC1nJE-dHqTrx-ese95j-dcFKhR-esemvj-gKRLrn-oR7oB7-cjPyjq-ejDYL4-iYkRnk-iYjUV6-BFsVnj-oviiM5-tCLwAw-esebzQ-ox49Mn-tmBYhn-eseviG-dHwhXE-eseenu-dHwfKW-cjPyDC-dS4QZz-dTsudR-coqbmw-dLAfzv-iYkXER-iYpdbG-iYmAZm-cu8JLU-bW6T8t-TaC67b-jLKzPe-cs27eU-ihce1u)**

When TensorFlow was first launched in 2015, we wanted it to be an “[open source machine learning framework for everyone](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/pip_package/setup.py#L15)”. To do that, we need to run on as many of the platforms that people are using as possible. We’ve long supported Linux, MacOS, Windows, iOS, and Android, but despite the heroic efforts of many contributors, running TensorFlow on a Raspberry Pi has involved a lot of work. Thanks to a collaboration with the [Raspberry Pi Foundation](https://www.raspberrypi.org/), we’re now happy to say that the latest 1.9 release of TensorFlow can be installed from pre-built binaries using Python’s pip package system! If you’re running Raspbian 9 (stretch), you can install it by running these two commands from a terminal:

    sudo apt install libatlas-base-dev

    pip3 install tensorflow

You can then run python3 in a terminal, and use TensorFlow just as you would on any other platform. Here’s a simple hello world example:

    # Python

    import tensorflow as tf

    tf.enable_eager_execution()

    hello = tf.constant(‘Hello, TensorFlow!’)

    print(hello)

If the system outputs the following, then you are ready to begin writing TensorFlow programs:

Hello, TensorFlow!

There are [more details on installing and troubleshooting TensorFlow on the Raspberry Pi on the TensorFlow website](https://www.tensorflow.org/install/install_raspbian).

We’re excited about this because the Raspberry Pi is used by many innovative developers, and is also widely used in education to introduce people to programming, so making TensorFlow easier to install will help open up machine learning to new audiences. We’ve already seen platforms like [DonkeyCar](http://www.donkeycar.com/) use TensorFlow and the Raspberry Pi to create self-driving toy cars, and we can’t wait to discover what new projects will be built now that we’ve reduced the difficulty.

[Eben Upton](https://twitter.com/ebenupton), founder of the Raspberry Pi project, says, “It is vital that a modern computing education covers both fundamentals and forward-looking topics. With this in mind, we’re very excited to be working with Google to bring TensorFlow machine learning to the Raspberry Pi platform. We’re looking forward to seeing what fun applications kids (of all ages) create with it,” and we agree!

We’re hoping to see a lot more educational material and tutorials emerge that will help more and more people explore the possibilities of machine learning on such a cost-effective and flexible device.
