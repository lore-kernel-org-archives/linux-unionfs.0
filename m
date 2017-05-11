From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] ovl: constant d_ino across copy up
Date: Thu, 11 May 2017 16:42:25 +0300
Message-ID: <1494510147-18658-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33732 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755908AbdEKNmP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 May 2017 09:42:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id y10so7110327wmh.0
        for <linux-unionfs@vger.kernel.org>; Thu, 11 May 2017 06:42:15 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

Miklos,

Following patches fix constant d_ino.
I've tested them with the improved xfstest overlay/017.

Fixing constat d_ino for this merge cycle is not urgent,
although you may consider the patch simple enough to be
a candidate for rc2.

However, I do recommend that you consider the "impure"
dir patch for this merge cycle. If you include it, it will
guaranty the on-disk rule:
A) An upper directory that contains entries with valid
   "origin" is either "merge" or marked "impure"

If you don't include it in the same merge window as constant
st_ino, then we will need to deal with violations of this rule.
OTOH, we already do need to deal with the situation of:
B) Non-merge upper directory that contains dir entries with
   "redirect" that is not marked "impure"

Assuming that we will not want to give up on the "impure"
optimization for ovl_iterate(), then dealing with B) is quite
simple - let old redirected dirs have d_ino != st_ino.
'find -ino' never looks at d_ino of subdirs and I don't know
which programs do care about it. Also, d_ino != st_ino for
subdirs also in past kernels, so it won't be a regression.

Dealing with A) (if "impure" doesn't go into 4.12) will be
more challenging, because it will allow the following combinations:
- non constant st_ino, which is consistent with d_ino (<= v4.11)
- constant st_ino, which is consistent with d_ino (>= v4.13)
- constant st_ino, which is sometimes consistent with d_ino
  (depending on whether the file was moved with kernel v4.12 or v4.13)

Thoughts?

Amir Goldstein (2):
  ovl: mark upper dir with type origin entries "impure"
  ovl: constant d_ino across copy up

 fs/overlayfs/dir.c       |  41 ++++++++++++++++-
 fs/overlayfs/namei.c     |  25 +++++++++--
 fs/overlayfs/overlayfs.h |   5 ++-
 fs/overlayfs/ovl_entry.h |   1 +
 fs/overlayfs/readdir.c   | 115 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/overlayfs/util.c      |  15 +++++++
 6 files changed, 189 insertions(+), 13 deletions(-)

-- 
2.7.4
