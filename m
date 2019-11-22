Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CAOQ4uxjryJep94sLgVxV7sGab8K3yeeDUZwOYOfLtOOguW1pcA@mail.gmail.com>
 <CAOQ4uxiHKjNba8HD5JUWFxxJqyJxPMk3fFfA3fi-nO6uJngTAg@mail.gmail.com>
In-Reply-To: <CAOQ4uxiHKjNba8HD5JUWFxxJqyJxPMk3fFfA3fi-nO6uJngTAg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 22 Nov 2019 11:37:17 +0200
Message-ID: <CAOQ4uxhBBnr5zFOn1Dr-XtDSo=p3BovyhK6xZh22GA=dv1L8Bw@mail.gmail.com>
Subject: [ANNOUNCE] unionmount-testsuite: master branch updated to 1724ef2
Content-Type: text/plain; charset="UTF-8"
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

Hi All,

The master branch on the unionmount-testsuite tree [1] has been updated.

Changes in this update:
- Enhance --verify with copy up state checks
- Verify metadata only copy up with --verify --meta
- Verify unified ino domain with xino requires --verify --xino

Note that this release changes xino from a test configuration that is
implied from --verify to requiring an explicit opt-in with --xino option.

This change allows more strict checking of the xino=off configuration
and exposes a kernel v4.17 regression:

 ./run --ov=1 --verify hard-link
 ...
 /mnt/a/no_foo110: File unexpectedly on upper layer

Thanks,
Amir.

[1] https://github.com/amir73il/unionmount-testsuite

The head of the master branch is commit:

1724ef2 Decouple xino configuration from --verify

New commits:

Amir Goldstein (8):
  Fix ./run --ov --verify --recycle
  Simplify initialization of __upper
  Fix instantiation of hardlinked dentry
  Record meta copy_up vs. data copy_up
  Check that files were copied up as expected
  Reset dentry copy_up state on upper layer rotate
  Check that data was not copied up with metacopy=on
  Decouple xino configuration from --verify
