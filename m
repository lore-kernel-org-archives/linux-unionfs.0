Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-vs1-f47.google.com ([209.85.217.47]:40752 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfFAUB6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 1 Jun 2019 16:01:58 -0400
Received: by mail-vs1-f47.google.com with SMTP id c24so8906981vsp.7
        for <linux-unionfs@vger.kernel.org>; Sat, 01 Jun 2019 13:01:57 -0700 (PDT)
MIME-Version: 1.0
From: Marco Nelissen <marco.nelissen@gmail.com>
Date: Sat, 1 Jun 2019 13:01:45 -0700
Message-ID: <CAH2+hP4Q3i4LdKL2Cz=1uWq0+JSD1RnzcdmicDtCeqEUqLo+hg@mail.gmail.com>
Subject: which lower filesystems are actually supported?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

According to the documentation, "The lower filesystem can be any filesystem
supported by Linux", however this appears to not actually be the case, since
using a vfat filesystem results in the mount command printing "mount:
wrong fs type, bad option, bad superblock on overlay, missing codepage or
helper program, or other error", with dmesg saying "overlayfs: filesystem on
'/boot' not supported".
(that's from ovl_mount_dir_noesc(), when ovl_dentry_weird() returns nonzero)

Should vfat be supported, or is the documentation wrong? If the documentation
is wrong, what other filesystems are (not) supported?
