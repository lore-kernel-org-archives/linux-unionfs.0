Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36718 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725743AbeJaFVt (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Oct 2018 01:21:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 0/2] overlayfs: Handle metacopy mount option better
Date: Tue, 30 Oct 2018 16:26:40 -0400
Message-Id: <20181030202642.5025-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

This is V2 of the patch I had posted. Right now if user passes
metacopy=on and if redirect_dir=on is not specified, metacopy is
disabled automatically and a messages is sent to console/logs.

This might be little surprising for user. A better behavior probably
is to return an error if metacopy can't be enabled. Two patches
in the series take care of that.

Vivek Goyal (2):
  overlayfs: Return error if metadata only copy-up can't be enabled
  overlayfs: Enable redirect_dir automatically if metacopy=on needs it

 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     | 73 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 68 insertions(+), 7 deletions(-)

-- 
2.13.6
