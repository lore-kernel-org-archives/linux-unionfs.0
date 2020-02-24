Return-Path: <SRS0=h7tn=4M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A26C35671
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Feb 2020 11:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1F972072D
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Feb 2020 11:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="IcONktVG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgBXLlh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 06:41:37 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:42387 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbgBXLlg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Feb 2020 06:41:36 -0500
Received: by mail-il1-f194.google.com with SMTP id x2so7432477ila.9
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Feb 2020 03:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jP7tPQthTCdqsQoSQguZoX+h+n6UlrM3WkA7Pz2gGL4=;
        b=IcONktVG7p3r8BDyQLzLuFyy7u56CujNrQ0ffvSizSPbajb9Qb1Mj++rcPG9T2zWNl
         bD2L9VlVhDko4rwY9UquFpldPs6k4ko4+NWQ55ACSKsgMYvPiB+2c8RXk6fpEJK38Yfm
         SOga/UdIrp3hqNLo6VyjxRjsla9gSwBggh9tI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jP7tPQthTCdqsQoSQguZoX+h+n6UlrM3WkA7Pz2gGL4=;
        b=qQJEwTiNZgqo2UNp3nSQab7mpAUb2M8AjWsPoMlss3yhxWWl0seK4ZAILfgYyT5aPz
         lC1tmxwjh9GTztmKgZt3n+aX2m7W1Q+aEvwXa/JhSKZwCcXLsZRAMJxnrIKYHt9U3o/4
         Ch5hN9C5fSMFpdj1csVY1RspTKvibMjOvZtavxEuDznUokJIoc5wQrLHIc4ffdS1O/3z
         PWK5WW0w3XsXf4fYurlvHDvSjassww5wI8U3NYDl4dVygrK1vPEaXyI05ZDHN3zy6rUc
         kdOx70mnaYr8i//tbLyF7CsVQ7lGq96rb9u5PGHr250Wtf1OYBaBmg4b4fEGKDR9YHe6
         pQhQ==
X-Gm-Message-State: APjAAAWNfhi14TEOk0IChzH+U1Ppgx7Nkka9Il74tHnknIJ4mngQNbWS
        TdrlqDizg4K1ZjGgBR+bl8gGEc/juCpDXax87x+xUWUJ
X-Google-Smtp-Source: APXvYqwk2KI+V3HnS4JFEFSydWF4eMRkDLUEDgWBvEXgSeWMXSu6q4ixrua+9gddKFfVKiqUKvYtE5fScGvQYobd+lM=
X-Received: by 2002:a92:89c2:: with SMTP id w63mr55859983ilk.252.1582544496035;
 Mon, 24 Feb 2020 03:41:36 -0800 (PST)
MIME-Version: 1.0
References: <20200221143446.9099-1-amir73il@gmail.com> <20200221143446.9099-2-amir73il@gmail.com>
In-Reply-To: <20200221143446.9099-2-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 24 Feb 2020 12:41:25 +0100
Message-ID: <CAJfpegu6OUgwt1+m9ByoDzdZ-ye6sygbY5kR0SQsvVUroymk8Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: fix some xino configurations
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Feb 21, 2020 at 3:34 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Fix up two bugs in the coversion to xino_mode:
> 1. xino=off does not alway end up in disabled mode

s/alway/always/

> 2. xino=auto on 32bit arch should end up in disabled mode
>
> Take a proactive approach to disabling xino on 32bit kernel:
> 1. Disable XINO_AUTO config during build time
> 2. Disable xino with a warning on mount time
>
> As a by product, xino=on on 32bit arch also ends up in disabled mode.
> We never intended to enable xino on 32bit arch and this will make the
> rest of the logic simpler.
>
> Fixes: 0f831ec85eda ("ovl: simplify ovl_same_sb() helper")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/Kconfig | 1 +
>  fs/overlayfs/super.c | 9 ++++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 444e2da4f60e..714c14c47ca5 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -93,6 +93,7 @@ config OVERLAY_FS_XINO_AUTO
>         bool "Overlayfs: auto enable inode number mapping"
>         default n
>         depends on OVERLAY_FS
> +       depends on 64BIT
>         help
>           If this config option is enabled then overlay filesystems will use
>           unused high bits in undelying filesystem inode numbers to map all
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 6dc45bc7d664..f4c0ad69f9a6 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1489,6 +1489,8 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
>                 if (ofs->config.xino == OVL_XINO_ON)
>                         pr_info("\"xino=on\" is useless with all layers on same fs, ignore.\n");
>                 ofs->xino_mode = 0;
> +       } else if (ofs->config.xino == OVL_XINO_OFF) {
> +               ofs->xino_mode = -1;
>         } else if (ofs->config.xino == OVL_XINO_ON && ofs->xino_mode < 0) {
>                 /*
>                  * This is a roundup of number of bits needed for encoding
> @@ -1735,8 +1737,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         sb->s_stack_depth = 0;
>         sb->s_maxbytes = MAX_LFS_FILESIZE;
>         /* Assume underlaying fs uses 32bit inodes unless proven otherwise */
> -       if (ofs->config.xino != OVL_XINO_OFF)
> +       if (ofs->config.xino != OVL_XINO_OFF) {
>                 ofs->xino_mode = BITS_PER_LONG - 32;
> +               if (!ofs->config.xino) {

Did you mean (!ofs->xino_mode)?


Thanks,
Miklos
