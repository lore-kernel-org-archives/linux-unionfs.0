Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 4 Jul 2019 18:11:25 +0300
Message-ID: <CAOQ4uxhi63LPKdmkEJjnTEgy0VaX0qXML2Uz_258_B2iZcqd3w@mail.gmail.com>
Subject: [RFC] unionmount metacopy tests
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Vivek,

I was working on extending snapshot validation tests and got
this as a by-product:

https://github.com/amir73il/unionmount-testsuite/commits/metacopy

ca566c3 Check that data was not copied up with metacopy=on
140d99c Reset dentry copy_up state on upper layer rotate
960a5ce Check that files were copied up as expected
1bfcc7d Record meta copy_up vs. data copy_up
c3db453 Fix instantiation of hardlinked dentry
2104e51 Simplify initialization of __upper
1fc2eec Fix ./run --ov --verify --recycle

Would you be interested to review these changes,
so I would merge them to master?

Would you or someone else be interested in running those tests
regularly on pre release kernel?

If anyone is running unionmount-testsuite on regular basis
I would be happy to know which configurations are being tested,
because the test matrix grew considerably since I took over the project -
both Overlayfs config options and the testsuite config options.

Thanks,
Amir.
