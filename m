Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 7 May 2018 13:08:33 +0300
Message-ID: <CAOQ4uxgk+UowKMJB3+C6w6HMSBucWsL4ZE88=3hVarYN-X7j8Q@mail.gmail.com>
Subject: [ANNOUNCE] unionmount-testsuite: master branch updated to a698fa8
Content-Type: text/plain; charset="UTF-8"
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

Hi All,

The master branch on my unionmount-testsuite tree [1] has been updated.

Notable changes in this update:
- Regression testing for kernel commit 9f99e50d460a
  ("ovl: set lower layer st_dev only if setting lower st_ino")
- Auto enable features "redirect_dir", "index", "xino" when
  supported by kernel
- New test option --maxfs=M for multiple lower layers with
  multiple underlying filesystems
- Deprecate run --um (union mounts)
- Fix run --no (bind mounts)
- Update README and link to Overlayfs-testing wiki

There are no known failures with latest kernel.
Known failures with old kernels are documented in the wiki page.
The following test run configurations passed with kernel v4.17-rc3
as well as with Miklos' overlayfs-rorw branch:

./run --ov [--samefs|--maxfs=0]
./run --ov=10 [--samefs|--maxfs=0|--maxfs=1|--maxfs=10] --verify

Thanks,
Amir.

[1] https://github.com/amir73il/unionmount-testsuite

The head of the master branch is commit:

a698fa8 Fix cleanup of existing mounts for run --no

New commits:

Amir Goldstein (13):
      rename-mass-sym: fix subtest nr
      Cleanup leftover from snapshot patches
      Update README with advanced overlayfs test options
      Check constant st_dev on copy up
      Record overlay st_dev after cycle mount
      Add option run --ov=N --maxfs=M to configure number of different fs
      Auto enable xino feature with --verify
      Auto enable redirect_dir feature
      Auto enable inode index feature with --verify
      Rename "remount=" arg to "recycle="
      Remove support for run --um
      Use grep -q instead of redirecting grep output to /dev/null
      Fix cleanup of existing mounts for run --no
