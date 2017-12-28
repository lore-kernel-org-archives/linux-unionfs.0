From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v3 0/6] overlay: implement fsck.overlay utility
Date: Thu, 28 Dec 2017 19:40:17 +0800
Message-ID: <20171228114023.43999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:44779 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751043AbdL1LdP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Dec 2017 06:33:15 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Hi all,

Here is the third version of fsck.overlay. Most of comments from last
two iterations have been handled, major changes split to each patch
for readability and minor fix has been squashed into the first patch
"overlay: implement fsck utility".

Please review and any comments is helpful, thanks!

Changes since v2(v1):

- Add "-n -p -y" options. (Comment from Amir and Darrick)
- Change underlying dirs input to '-o' option like mount(8). (Miklos)
- Remove invalid opaque check. (Miklos)
- Correct redirect xattr check. (Amir and Miklos)
- Fix lower target lookup, handle the missing case of opaque and
  redirect parent.
- Add impure xattr check. (Amir)

Latest descriptions:

fsck.overlay
============

fsck.overlay is used to check and optionally repair underlying
directories of overlay-filesystem.

Check the following points:

Whiteouts
---------

A whiteout is a character device with 0/0 device number. It is used to
record the removed files or directories, When a whiteout is found in a
directory, there should be at least one directory or file with the
same name in any of the corresponding lower layers. If not exist, the
whiteout will be treated as orphan whiteout and remove.

Redirect directories
--------------------

An redirect directory is a directory with "trusted.overlay.redirect"
xattr valued to the path of the original location from the root of
the overlay. It is only used when renaming a directory and "redirect
dir" feature is enabled.

If an redirect directory is found, the following must be met:
1) The directory path pointed by redirect xattr should exist in one of
   lower layers.
2) The origin directory should be redirected only once in one layer,
   which means there is only one redirect xattr point to this origin
   directory in the specified layer.
3) There must be something with the same name to the rename origin in
   its origin place, maybe a whiteout/file or a(an) opaque/redirect
   directory covering the lower target, maybe a new created directory
   merging with lower origin directory.

If not,
1) The redirect xattr is invalid and need to remove.
2) One of the redirect xattr is redundant but not sure which one is,
   ask user or warn in auto mode.
3) Create a whiteout device if there nothing exists in its place. If
   the lower targed was covered by a directory which is not an another
   redirect directory, it could be created after rename in overlayfs
   or created in underlying directory when overlay is offline, not sure
   this directory is merged or not, ask user by default.

If an invalid redirect xattr was removed by fsck and there is a
corresponding lower directory with the same name exists, not sure this
directory is merged or not, ask user to make a decision.

Impure directories
------------------

An impure directory is a directory with "trusted.overlay.impure" xattr
valued 'y', which indicate that this directory may contain copy-uped
targets from lower layers. In oredr to prevent 'd_ino' change while
copy-up (it create a new inode in upper layer) in getdents(2), impure
xattr will be set in the parent directory, letting overlay filesystem
check and get d_ino from lower origin target to ensure consistent d_ino.

There are three situations of setting impure xattr:
1) Copyup lower target in a directory.
2) Link an origined target (already copy-uped, have origin xattr) into
   a directory.
3) Rename an origined target (include merged subdirectories) into a
   new directory.

So, if a direcotry which contains several origined targets or redirect
directories, the impure xattr should be set. If not, fix this xattr.

Usage
=====

1. Ensure overlay filesystem is not mounted based on directories which
   need to check.

2. Run fsck.overlay program:
   Usage:
   fsck.overlay [-o lowerdir=<lowers>,upperdir=<upper>,workdir=<work>][-pnyvhV]

   Options:
   -o,                    specify underlying directories of overlayfs:
                          multiple lower directories use ':' as separator
   -p,                    automatic repair (no questions)
   -n,                    make no changes to the filesystem
   -y,                    assume "yes" to all questions
   -v, --verbose          print more messages of overlayfs
   -h, --help             display this usage of overlayfs
   -V, --version          display version information

   Example:
   fsck.overlay -o lowerdir=lower,upperdir=upper,workdir=work

3. Exit value:
   0      No errors
   1      Filesystem errors corrected
   2      System should be rebooted
   4      Filesystem errors left uncorrected
   8      Operational error
   16     Usage or syntax error
   32     Checking canceled by user request
   128    Shared-library error

Todo
====

1. Overlay filesystem mounted check. Prevent fscking when overlay is
   online. Now, We cannot distinguish mounted directories if overlayfs
   was mounted with relative path. Should modify kernel together to
   support.
2. Check and fix invalid redirect xattr through origin xattr.
3. Symbolic link check.
4. Check origin/nlink xattr.
5. Check index feature consistency.
6. ...


zhangyi (F) (6):
  overlay: implement fsck utility
  fsck.overlay: add -n -p and -y options
  fsck.overlay: encapsulate underlying directories options
  fsck.overlay: correct redirect xattr check
  fsck.overlay: fix lower target lookup
  fsck.overlay: add impure xattr check
