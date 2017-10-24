From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/4] Overlayfs index features
Date: Tue, 24 Oct 2017 13:02:57 +0300
Message-ID: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:55573 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbdJXKCd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2017 06:02:33 -0400
Received: by mail-wr0-f195.google.com with SMTP id l8so7187903wre.12
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2017 03:02:32 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

This series is an attempt not to repeat the mistakes of the past
w.r.t. overlayfs features.

I have given a lot of though about how to scale up with more
compat/incompat features instead of an ever growing disclaimer matrix
in overlafs/Kconfig.

My proposed solution only covers features compatibility among
sub-features of index or features which rely on index being enabled.
There is also a best effort attempt to impose features compatibility
as far as v3.18 using a trick with a dirty work dir.

Although this series is based on the stable fix patch "ovl: do not
cleanup unsupported index entries", it does NOT rely on the fix being
applied on v4.13 kernel for correct behavior on downgrade.

The first use case for incompat index features is going to be index=all
for NFS export - probably rocompat, not sure yet.

I don't think there is anything is this that should be backported
to v4.13 or rushed into v4.14.
What do you think?

Amir.

Amir Goldstein (4):
  ovl: introduce incompatible index feature
  ovl: declare index feature backward compatible
  ovl: cast a shadow of incomapt index into the past
  ovl: check incompat/rocompat index features

 fs/overlayfs/Kconfig     |  25 ++++++++---
 fs/overlayfs/dir.c       |  66 +++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  20 ++++++++-
 fs/overlayfs/readdir.c   | 108 +++++++++++++++++++++++++++++++++++++++++++----
 fs/overlayfs/super.c     |  50 ++++++++++++++++++++--
 fs/overlayfs/util.c      | 105 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 354 insertions(+), 20 deletions(-)

-- 
2.7.4
