From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix wrong WARN_ON() in ovl_cache_update_ino()
Date: Fri, 24 Jan 2020 08:49:49 +0200
Message-ID: <CAOQ4uxh3b1AEBEAax8OvXvyUXw5K9YJNo-tqvWuKdSpJVdYBRg@mail.gmail.com>
References: <20191223064025.23801-1-amir73il@gmail.com> <CAOQ4uxh4NygFUFvUp3xs8rZRUkc3SDxO1DL6YrNhx3j0SBgAJg@mail.gmail.com>
 <CAOQ4uxjsiQ5PKYSPLmgk5b5O_e5255+QK8Obgs9K--cTi3z=7w@mail.gmail.com> <CAJfpegtcpqhiOqbdCCEz5_h=2WbYDWvLihAUYPC9KkB-uCmDbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:43489 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730310AbgAXGuB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 24 Jan 2020 01:50:01 -0500
Received: by mail-io1-f67.google.com with SMTP id n21so856158ioo.10
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2020 22:50:01 -0800 (PST)
In-Reply-To: <CAJfpegtcpqhiOqbdCCEz5_h=2WbYDWvLihAUYPC9KkB-uCmDbg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

> I'm working this into the next batch bound for 5.6, unless something
> more urgent comes up before that.
>

overlayfs-next tested.
ovl-ino rebased.

You would probably want to squash the "merge conflict" below to overlayfs-next.

Thanks,
Amir.


--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1348,7 +1348,7 @@ static int ovl_get_layers(struct super_block
*sb, struct ovl_fs *ofs,
         */
        err = get_anon_bdev(&ofs->fs[0].pseudo_dev);
        if (err) {
-               pr_err("overlayfs: failed to get anonymous bdev for
upper fs\n");
+               pr_err("failed to get anonymous bdev for upper fs\n");
                goto out;
        }

@@ -1409,7 +1409,7 @@ static int ovl_get_layers(struct super_block
*sb, struct ovl_fs *ofs,
         */
        if (ofs->numfs - !ofs->upper_mnt == 1) {
                if (ofs->config.xino == OVL_XINO_ON)
-                       pr_info("overlayfs: \"xino=on\" is useless
with all layers on same fs, ignore.\n");
+                       pr_info("\"xino=on\" is useless with all
layers on same fs, ignore.\n");
                ofs->xino_mode = 0;
        } else if (ofs->config.xino == OVL_XINO_ON && ofs->xino_mode < 0) {
