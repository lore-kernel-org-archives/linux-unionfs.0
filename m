From: Amir Goldstein <amir73il@gmail.com>
Subject: [ANNOUNCE] unionmount-testsuite: Amir's master branch updated
Date: Tue, 5 Dec 2017 22:20:25 +0200
Message-ID: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Hi All,

The master branch on my unionmount-testsuite tree [1] has been updated.

The head of the master branch is commit:
6d04664 Add a test for rename over empty union dir

This small update contains:
- A few new simple dir rename and dir remove tests
- A fix for running on kernel <= v4.9 with no redirect_dir support
- A new setup option --squashfs to setup lower as read-only squashfs

With index enabled, there are no known failures.
With index disabled this test fails on non-constant st_ino for lower hardlink
copy up:
  run --ov=1 --samefs --verify rename-mass-5

Thanks,
Amir.

[1] https://github.com/amir73il/unionmount-testsuite
