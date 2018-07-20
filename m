Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f181.google.com ([209.85.213.181]:40240 "EHLO
        mail-yb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731720AbeGTP4G (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Jul 2018 11:56:06 -0400
Received: by mail-yb0-f181.google.com with SMTP id y11-v6so4742980ybm.7
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Jul 2018 08:07:24 -0700 (PDT)
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Jul 2018 18:07:22 +0300
Message-ID: <CAOQ4uxjryJep94sLgVxV7sGab8K3yeeDUZwOYOfLtOOguW1pcA@mail.gmail.com>
Subject: [ANNOUNCE] unionmount-testsuite: master branch updated to 509b1e7
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

Hi All,

The master branch on the unionmount-testsuite tree [1] has been updated.

Changes in this update:
- Support for testing a FUSE implementation of overlayfs

Tested with fuse-overlayfs [2], which does not support redirect_dir=on:
  ./run --ov --fuse=fuse-overlayfs --xdev

Thanks,
Amir.

[1] https://github.com/amir73il/unionmount-testsuite
[2] https://github.com/containers/fuse-overlayfs

The head of the master branch is commit:

509b1e7 Ignore overlay kernel module params when testing FUSE

New commits:

Amir Goldstein (3):
      Fix layer check for FUSE overlayfs
      Expect EXDEV on ovelray dir rename with old kernels
      Ignore overlay kernel module params when testing FUSE implementation

Giuseppe Scrivano (1):
      Support testing a FUSE implementation of overlayfs
