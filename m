Return-Path: <SRS0=lbY/=AN=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF48C433E0
	for <linux-unionfs@archiver.kernel.org>; Thu,  2 Jul 2020 07:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 143F8206BE
	for <linux-unionfs@archiver.kernel.org>; Thu,  2 Jul 2020 07:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JybjjNcZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGBH05 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 03:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgGBH04 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Jul 2020 03:26:56 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D853C08C5C1
        for <linux-unionfs@vger.kernel.org>; Thu,  2 Jul 2020 00:26:56 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id a12so27844603ion.13
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Jul 2020 00:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=llKH2L04xDKIgCANvNigp6S67w0v8zYrsg+VkKkLqkg=;
        b=JybjjNcZzaZfBkkqnzxFDpfNh5FRWPdpOec15jQ1szfs+PdphH1NqXScqzZtXukLtZ
         TgePKyI6pTFiWaa0xBFhXTphCJfmlinXwlazwEPn/WwazQnAk1HhfUXgUtK91QSeLjAI
         i1RwupZtFuwQQKpYzaIdEHuxM9AYx5D8jHMmdU/cVZ/jLtC7Ven42r+uI8dER9z5VLSL
         6NC+N05dSGSYLMWvFNfpRm+XAMnRwHWDriHcOm4kGxV+Ua/bZ4pEl6QrPpaNTE1b946j
         9MWVEezmltqJjGxWuISRkW5eqJgfS100TGnpgFRdcfnfv7fYB2FSvLuuhxFkV4HODJYm
         Gq4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=llKH2L04xDKIgCANvNigp6S67w0v8zYrsg+VkKkLqkg=;
        b=J5ogWmRp7AD8nQ5GzpDLytQc/hTmlMX2ScnVn4kQ0m6fiqjHXUFqAnS8PmQ3KYuK+x
         yMl+31oFWEU5n3xgBivwI+ki6C+KPgTqJVhXG7bJtFq5OJXywM6hSvXENWjiaLjTrxhv
         bQRPBNYjq8sq7UwV1IzKVk+/PlhKlU0XvZainnDyAGfzcz7nSCmW5GHy/zf0v59H8tlg
         PSMdQNI18HE4Ww7SSVJlaWgRuD/z3jQV01ahIL0Oap1uyOA8iGB1ShqxDfGxqKL53yOY
         UX/5BgZdyoXs058Leu2WsFqE8JrDIAA8cQizo2GVuHK/8vpe45XpWCpbdIEpz6aV8ziS
         kGtQ==
X-Gm-Message-State: AOAM533TtdwwWCZx3ljDQWDpVEDnjOI/URc3pb+jfjtp6Qn/m9hC9tlu
        wDD/DEdltsU+uKGuHp891H44mBmgJ5NaxZMy7CpNP1gw
X-Google-Smtp-Source: ABdhPJytV328ciwtzLV8HxUOu/VPsOrqASs50H4hIwgrgapP+viSLkPN3U32TVw1TeZSGnhUbeISkQcEyKuNqKkXV/k=
X-Received: by 2002:a05:6602:1225:: with SMTP id z5mr6179030iot.64.1593674815369;
 Thu, 02 Jul 2020 00:26:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200701215029.GF369085@redhat.com>
In-Reply-To: <20200701215029.GF369085@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 2 Jul 2020 10:26:44 +0300
Message-ID: <CAOQ4uxhLe3ptTcdsyGXRB=w3ub5_is3HcUY0z7OLgLPDg1Mk5w@mail.gmail.com>
Subject: Re: [RFC PATCH v3] overlayfs: Provide mount options sync=off/fs to
 skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>, pmatilai@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 2, 2020 at 12:50 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Container folks are complaining that dnf/yum issues too many sync while
> installing packages and this slows down the image build. Build
> requirement is such that they don't care if a node goes down while
> build was still going on. In that case, they will simply throw away
> unfinished layer and start new build. So they don't care about syncing
> intermediate state to the disk and hence don't want to pay the price
> associated with sync.
>
> So they are asking for mount options where they can disable sync on overlay
> mount point.
>
> They primarily seem to have two use cases.
>
> - For building images, they will mount overlay with nosync and then sync
>   upper layer after unmounting overlay and reuse upper as lower for next
>   layer.
>
> - For running containers, they don't seem to care about syncing upper
>   layer because if node goes down, they will simply throw away upper
>   layer and create a fresh one.
>
> So this patch provides two mount options "sync=off" and "sync=fs".
> First option disables all forms of sync. Now it is caller's responsibility
> to throw away upper if system crashes or shuts down and start fresh.
>
> Option "sync=fs" disables all forms of sync except syncfs/umount/remount.
> This is basically useful for image build where we want to persist upper
> layer only after operation is complete and upper will be renamed and
> reused as lower for next layer build.
>
> With sync=off, I am seeing roughly 20% speed up in my VM where I am just
> installing emacs in an image. Installation time drops from 31 seconds to
> 25 seconds when nosync option is used. This is for the case of building on top
> of an image where all packages are already cached. That way I take
> out the network operations latency out of the measurement.
>
> With sync=fs, I am seeing roughly 12% speed up.
>
> Giuseppe is also looking to cut down on number of iops done on the
> disk. He is complaining that often in cloud their VMs are throttled
> if they cross the limit. This option can help them where they reduce
> number of iops (by cutting down on frequent sync and writebacks).
>
> Changes from v2:
> - Added helper functions (Amir Goldstein)
> - Used enums to keep sync state (Amir Goldstein)

Thank you for doing that.
Sorry, but I failed to mention the practical reasons for suggesting the
enum config and you failed to read my mind :-/
So I will explain my reasoning using more words (see below)

>
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Anyway, you may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index b429c80879ee..e7aea92733f5 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -5,6 +5,14 @@
>   * Copyright (C) 2016 Red Hat, Inc.
>   */
>
> +enum ovl_sync_type {
> +       __OVL_SYNC_OFF          = (1 << 0),
> +       __OVL_SYNC_FS           = (1 << 1),
> +};
> +
> +#define OVL_SYNC_OFF(type)     ((type) & __OVL_SYNC_OFF)
> +#define OVL_SYNC_FS(type)      ((type) & __OVL_SYNC_FS)
> +

My unspoken intention when I wrote either "enum" or "flags" is -

If you use bitwise flags, they reflect the ovl_should_xxx queries:
__OVL_NOSYNC_FILE and __OVL_NOSYNC_FS
#define OVL_SYNC_FILE(type)     (!((type) & __OVL_NOSYNC_FILE))
#define OVL_SYNC_FS(type)      (!((type) & __OVL_NOSYNC_FS))


If you use enum (not bitwise), the distinct enum values reflect the
mount option:
OVL_SYNC_ON (=0), OVL_SYNC_OFF, OVL_SYNC_FS

I am not commenting on this because of some sort of aesthetic taste.
I am commenting on this because I think it would make parts of the
patch simpler/clearer (see below).

As far as I am concerned, for the three possible config values off/fs/on
the distinct enum values are better.
Of course, that is *my* opinion. You may disagree.

>  struct ovl_config {
>         char *lowerdir;
>         char *upperdir;
> @@ -17,6 +25,7 @@ struct ovl_config {
>         bool nfs_export;
>         int xino;
>         bool metacopy;
> +       enum ovl_sync_type sync;
>  };
>
>  struct ovl_sb {
> @@ -90,6 +99,17 @@ static inline struct ovl_fs *OVL_FS(struct super_block *sb)
>         return (struct ovl_fs *)sb->s_fs_info;
>  }
>
> +static inline bool ovl_should_fsync(struct ovl_fs *ofs)
> +{
> +       return (!OVL_SYNC_OFF(ofs->config.sync) &&
> +               ! OVL_SYNC_FS(ofs->config.sync));

option #1 (bitwise):
return OVL_SYNC_FILE(ofs->config.sync);

option #2 (distinct):
return ofs->config.sync == OVL_SYNC_ON;

> +}
> +
> +static inline bool ovl_should_syncfs(struct ovl_fs *ofs)
> +{
> +       return !OVL_SYNC_OFF(ofs->config.sync);

option #1 (bitwise):
return OVL_SYNC_FS(ofs->config.sync);

option #2 (distinct):
return ofs->config.sync != OVL_SYNC_OFF;

[...]

> @@ -362,6 +364,10 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         if (ofs->config.metacopy != ovl_metacopy_def)
>                 seq_printf(m, ",metacopy=%s",
>                            ofs->config.metacopy ? "on" : "off");
> +       if (OVL_SYNC_OFF(ofs->config.sync))
> +               seq_puts(m, ",sync=off");
> +       if (OVL_SYNC_FS(ofs->config.sync))
> +               seq_puts(m, ",sync=fs");

option #1 (bitwise):
       if (!ofs->config.sync)
               seq_puts(m, ",sync=off");
      else if (!OVL_SYNC_FILE(ofs->config.sync))
               seq_puts(m, ",sync=fs");

option #2 (distinct):
Would be better. See ovl_xino_str[].


> @@ -411,6 +419,8 @@ enum {
>         OPT_XINO_AUTO,
>         OPT_METACOPY_ON,
>         OPT_METACOPY_OFF,
> +       OPT_SYNC_OFF,
> +       OPT_SYNC_FS,
>         OPT_ERR,
>  };
>
> @@ -429,6 +439,8 @@ static const match_table_t ovl_tokens = {
>         {OPT_XINO_AUTO,                 "xino=auto"},
>         {OPT_METACOPY_ON,               "metacopy=on"},
>         {OPT_METACOPY_OFF,              "metacopy=off"},
> +       {OPT_SYNC_OFF,                  "sync=off"},
> +       {OPT_SYNC_FS,                   "sync=fs"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -573,6 +585,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         metacopy_opt = true;
>                         break;
>
> +               case OPT_SYNC_OFF:
> +                       config->sync |= __OVL_SYNC_OFF;

There is really no point in ORing with old config options here.

option #1 (bitwise):
                       config->sync = __OVL_NOSYNC_FILE | __OVL_NOSYNC_FS;

option #2 (distinct):
                       config->sync = OVL_SYNC_OFF;


> +                       break;
> +
> +               case OPT_SYNC_FS:
> +                       config->sync |= __OVL_SYNC_FS;
> +                       break;
> +
>                 default:
>                         pr_err("unrecognized mount option \"%s\" or missing value\n",
>                                         p);
> @@ -588,6 +608,17 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                 config->workdir = NULL;
>         }
>
> +       if (OVL_SYNC_OFF(config->sync) && OVL_SYNC_FS(config->sync)) {
> +               pr_err("conflicting options: sync=off,sync=fs\n");
> +               return -EINVAL;
> +       }
> +

We are not warning user that metacopy=off conflicts with metacopy=on,
we just let the last option overwrite previous ones.


> +       if (!config->upperdir &&
> +           (OVL_SYNC_OFF(config->sync) || OVL_SYNC_FS(config->sync))) {
> +               pr_info("option sync=off/fs is meaningless in a non-upper mount, ignoring it.\n");
> +               config->sync = 0;
> +       }
> +

With either bitwise/distinct options this could be simplified:

       if (!config->upperdir && config->sync)
               pr_info("option "sync=off/fs" is meaningless in a
non-upper mount, ignoring it.\n");
               config->sync = 0;

Thanks,
Amir.
