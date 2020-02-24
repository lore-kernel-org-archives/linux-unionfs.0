Return-Path: <SRS0=h7tn=4M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17550C35671
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Feb 2020 13:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F972080D
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Feb 2020 13:27:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SvUKOW1b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgBXN11 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:27:27 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:41414 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgBXN11 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:27:27 -0500
Received: by mail-io1-f67.google.com with SMTP id m25so10202146ioo.8
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Feb 2020 05:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U80JNwjabc0huzMYY+BuNCBM9yPtojRjTC9cLjsVko8=;
        b=SvUKOW1b7Ai9fSy11/paU+xfKe8mw1glEenwTgWt7/ZQvIvY3F4FMqtv2zkBk3nLEI
         HUhfohjIHVasNwV8yqU8f1b7qe7wZO4vK2nN0bey9sq0zVy7gYNEWyxC9Ne0A3OSn8ET
         G8lhwKqLv56AleO29WiQnbWrBjo34ERNXidnYN+4i9opFddHZ0mPZ+zPvFrbn7ziMTYJ
         ptRrk8NIjNsvPXVILjkB64k8Xc+PEz6cLpTkgZ8QStTHu96Da9FFUxjrZCN6spFNqfGi
         ZeYZfZ3oLdA3MP0irbGTlxrzNyNmr6bUB6ooz6JXL8YJD5K04u1ydeCd5ntiItA+D5Mm
         Adhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U80JNwjabc0huzMYY+BuNCBM9yPtojRjTC9cLjsVko8=;
        b=eHQn3u3cSpRm/bjbOkCi5rscxfSUW9zOei5r6Fnr5SsSJF7CBnCN2VxzY079MylNjb
         n8n7tdptXbYjRMFLl0BKqYOfM0hyhF1Isqd7Fu6S9MDuM43/JYid7+8b3wnzHZfRFo1H
         RcY4MTLUvnlWCHzgsInYWCG1iAiyCd75KMhMqsEAjGqshjUEi/WWKqW/pryl13A2kaaU
         TPUi7dyottwxyndeCQlFxcFCbgl0YwxIzmiFeDdkCdAzIBdtRitI8z+0oJJbFhKiqCie
         +DfwyYNSgkHinUTUPOBJHif3LyZZZRdgafuNcLd2pg4yGjCkiRnS78EZttKGqVMY6JXu
         Z0nQ==
X-Gm-Message-State: APjAAAUipkOSr/SUbvn6DWrThhbLDGpe1S0qa6bRBxwtnKsjdJjXQ7Oc
        FfKW9a1oSHN1Usx8KdUH0I/yUtbc19698gdTQWZ6mE1z
X-Google-Smtp-Source: APXvYqy/kb1kFrcFw2bHrvRRXl7MhlXAVibX7gUg/Gew/02wgDZ8BB4LZSYOUctAFBeAUO8OBmTvEQ8yQHrxmdkgbts=
X-Received: by 2002:a02:8817:: with SMTP id r23mr51192513jai.120.1582550846571;
 Mon, 24 Feb 2020 05:27:26 -0800 (PST)
MIME-Version: 1.0
References: <20200221143446.9099-1-amir73il@gmail.com> <20200221143446.9099-2-amir73il@gmail.com>
 <CAJfpegu6OUgwt1+m9ByoDzdZ-ye6sygbY5kR0SQsvVUroymk8Q@mail.gmail.com>
In-Reply-To: <CAJfpegu6OUgwt1+m9ByoDzdZ-ye6sygbY5kR0SQsvVUroymk8Q@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Feb 2020 15:27:15 +0200
Message-ID: <CAOQ4uxg+SC6UZAX+z_D9D9Y0-jvDvk44v74NT7tGGDrTmOyjKQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: fix some xino configurations
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Feb 24, 2020 at 1:41 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Fri, Feb 21, 2020 at 3:34 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Fix up two bugs in the coversion to xino_mode:
> > 1. xino=off does not alway end up in disabled mode
>
> s/alway/always/
>
> > 2. xino=auto on 32bit arch should end up in disabled mode
> >
> > Take a proactive approach to disabling xino on 32bit kernel:
> > 1. Disable XINO_AUTO config during build time
> > 2. Disable xino with a warning on mount time
> >
> > As a by product, xino=on on 32bit arch also ends up in disabled mode.
> > We never intended to enable xino on 32bit arch and this will make the
> > rest of the logic simpler.
> >
> > Fixes: 0f831ec85eda ("ovl: simplify ovl_same_sb() helper")
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/Kconfig | 1 +
> >  fs/overlayfs/super.c | 9 ++++++++-
> >  2 files changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> > index 444e2da4f60e..714c14c47ca5 100644
> > --- a/fs/overlayfs/Kconfig
> > +++ b/fs/overlayfs/Kconfig
> > @@ -93,6 +93,7 @@ config OVERLAY_FS_XINO_AUTO
> >         bool "Overlayfs: auto enable inode number mapping"
> >         default n
> >         depends on OVERLAY_FS
> > +       depends on 64BIT
> >         help
> >           If this config option is enabled then overlay filesystems will use
> >           unused high bits in undelying filesystem inode numbers to map all
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 6dc45bc7d664..f4c0ad69f9a6 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1489,6 +1489,8 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
> >                 if (ofs->config.xino == OVL_XINO_ON)
> >                         pr_info("\"xino=on\" is useless with all layers on same fs, ignore.\n");
> >                 ofs->xino_mode = 0;
> > +       } else if (ofs->config.xino == OVL_XINO_OFF) {
> > +               ofs->xino_mode = -1;
> >         } else if (ofs->config.xino == OVL_XINO_ON && ofs->xino_mode < 0) {
> >                 /*
> >                  * This is a roundup of number of bits needed for encoding
> > @@ -1735,8 +1737,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >         sb->s_stack_depth = 0;
> >         sb->s_maxbytes = MAX_LFS_FILESIZE;
> >         /* Assume underlaying fs uses 32bit inodes unless proven otherwise */
> > -       if (ofs->config.xino != OVL_XINO_OFF)
> > +       if (ofs->config.xino != OVL_XINO_OFF) {
> >                 ofs->xino_mode = BITS_PER_LONG - 32;
> > +               if (!ofs->config.xino) {
>
> Did you mean (!ofs->xino_mode)?

Yes, I certainly did :)
And no, I did not test on a 32bit kernel...

Thanks,
Amir.
