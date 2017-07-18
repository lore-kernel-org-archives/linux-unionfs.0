From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/2] overlayfs forward compat index changes
Date: Tue, 18 Jul 2017 21:07:41 +0300
Message-ID: <1500401263-25562-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34910 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdGRSHc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Jul 2017 14:07:32 -0400
Received: by mail-wr0-f195.google.com with SMTP id c24so1780756wra.2
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Jul 2017 11:07:31 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

I did not get any NACK nor ACK from you on the patch:
[08/10] ovl: do not cleanup directory and whiteout index entries
from the v4.13 assorted fixes series.

So I've NACKed it myself, because we should not be allowing
rw mount with index entries from the future.

So patch 1 is resend of that patch which returns EROFS from
ovl_indexdir_cleanup() if entries from the future are found.
I'll leave it to you to decide if this error translates to
mount failure or fallback to read-only mount.

Patch 2 takes care of another forward compact issue related
index entries from the future in ovl_lookup_index(), but it
is really a sanity check that we should have had there (we
forgot to check that found index is of same file type as lower).

FYI, I have a WIP for whiteout index implementation at [1]
with these patched:
  ovl: verify directory and whiteout index entries
  ovl: whiteout index on last unlink

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-index-wip

Amir Goldstein (2):
  ovl: do not cleanup directory and whiteout index entries
  ovl: check for bad and whiteout index on lookup

 fs/overlayfs/namei.c   | 41 ++++++++++++++++++++++++++++++++---------
 fs/overlayfs/readdir.c |  5 ++++-
 2 files changed, 36 insertions(+), 10 deletions(-)

-- 
2.7.4
