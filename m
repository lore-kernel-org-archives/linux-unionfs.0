Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2ACC77B7F
	for <linux-unionfs@archiver.kernel.org>; Sat, 20 May 2023 16:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjETQb2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 20 May 2023 12:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjETQb1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 May 2023 12:31:27 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEED125
        for <linux-unionfs@vger.kernel.org>; Sat, 20 May 2023 09:31:25 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 3E8563F229
        for <linux-unionfs@vger.kernel.org>; Sat, 20 May 2023 16:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684600284;
        bh=nFL/WdfNuQxnTHJPa9V62Gc/YJjpQeNpMhIFNqXycw8=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=DyxbGXBmMZo+JTdnpc9s+truxeAejgbFkdPOdcUVTSF6N1EjR6gikPAUlaDbRm9x/
         Xj1lKPyPVybYEjBBl6yMKFhXamVL5QU5EgoswGdyJ10RJEIsoSkw2ARjhP7HDHLyQ8
         kwwig258gOGAahO0diSC9+ULcCfMffjT22lBvsEQD1nMziNoho5sgtj7VeGeVBRe9B
         3kvJCNVf4BD6fwIVMGHjHl2NPm7UnRC9LSE+kullbN2bQ9IZtQKrjNA7svIm+NRvhY
         +ecur8cErlWBKYenxwm3BytUUMFcKf66Quna0Gh37Quxznaj1M2J1wCl05OenvZ1Oc
         Sf5/OrWAmsAgQ==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-96f4d917e06so254904966b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 20 May 2023 09:31:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684600283; x=1687192283;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nFL/WdfNuQxnTHJPa9V62Gc/YJjpQeNpMhIFNqXycw8=;
        b=MxyuPfdgHNq+3E6qYwAH0GfP17us9eGALTrr4warGN5MtJiRvX/Wf2U6RYzXwmc8wC
         yZ2GNbcOVwpOJ+DJ/TkD9vDQgXH3zkXuxAKjsV3km+1LsYE2xslp66m9tAbDW1gJxf6A
         xSFYe1J59LTKeUVhnIOd5hYPp0d4PoRfwaEcpDLSR3CqSlY7kAhY7JYJDbXsofZEhW+r
         2h27qyv59qTLIn3kloCLq8Jg+NIQgLBp/8zGOKMOdYKi6BSg7/HQ26MsR7wLUgI4rdPy
         X/XOJigfrnOcOOOSKL+rjYyLmHjYgE6+FsgZhZ/R3nJNoevTmfxjF62H1du8N747eD0J
         wi/g==
X-Gm-Message-State: AC+VfDyWJH9uS9yUMUTkmeXJtRAScQCcvbwjEkJfvLlXfq9SmOn1SG6s
        10wtjJgdA+iV01wV3BKYi0pahf38QN5Fv0YYAeYrlBA52rjg3SOWbt2chmfitWNtMXgUrs4L/QQ
        cBi1Ghb+nfIARl7pcnAfjR4NO8n42lWvfET1e+ImEonk=
X-Received: by 2002:a17:907:3ea2:b0:96a:cdff:cb61 with SMTP id hs34-20020a1709073ea200b0096acdffcb61mr6040269ejc.4.1684600283143;
        Sat, 20 May 2023 09:31:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4GtqAPmm4b+fBXdB74K1nhy+0qI+eEjf6YzhVFSutSrfnnKHK3NX21uaQFXRe9Afa5rfhy+A==
X-Received: by 2002:a17:907:3ea2:b0:96a:cdff:cb61 with SMTP id hs34-20020a1709073ea200b0096acdffcb61mr6040256ejc.4.1684600282834;
        Sat, 20 May 2023 09:31:22 -0700 (PDT)
Received: from localhost (host-87-10-127-160.retail.telecomitalia.it. [87.10.127.160])
        by smtp.gmail.com with ESMTPSA id br23-20020a170906d15700b0095342bfb701sm971297ejb.16.2023.05.20.09.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 May 2023 09:31:22 -0700 (PDT)
Date:   Sat, 20 May 2023 18:31:21 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ovl: make consistent use of OVL_FS()
Message-ID: <ZGj12dSauIezBpgL@righiandr-XPS-13-7390>
References: <20230520120528.339680-1-andrea.righi@canonical.com>
 <CAOQ4uxjOgWDqufLcabkkPcxvFcrehzoDuO0d6kdJZuoiRBKStw@mail.gmail.com>
 <ZGjI8Hutt9JwuN/i@righiandr-XPS-13-7390>
 <CAOQ4uxi9xJWYdQnjbx7Z8ZdtB8REvnCVdg0BonWdpK0DWi5Utw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxi9xJWYdQnjbx7Z8ZdtB8REvnCVdg0BonWdpK0DWi5Utw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 20, 2023 at 06:55:44PM +0300, Amir Goldstein wrote:
> On Sat, May 20, 2023 at 4:19 PM Andrea Righi <andrea.righi@canonical.com> wrote:
> >
> > On Sat, May 20, 2023 at 03:33:32PM +0300, Amir Goldstein wrote:
> > > On Sat, May 20, 2023 at 3:20 PM Andrea Righi <andrea.righi@canonical.com> wrote:
> > ...
> > > > @@ -97,6 +99,8 @@ static inline struct mnt_idmap *ovl_upper_mnt_idmap(struct ovl_fs *ofs)
> > > >
> > > >  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> > > >  {
> > > > +       /* Make sure OVL_FS() is always used with an overlayfs superblock */
> > > > +       BUG_ON(sb->s_magic != OVERLAYFS_SUPER_MAGIC);
> > >
> > > 1. Adding new BUG_ON to kernel code is not acceptable - if anything
> > >     you can add WARN_ON_ONCE()
> >
> > OK, but accessing a pointer to a struct ovl_fs that is not really a
> > struct ovl_fs can potentially have nasty effects, even data corruption
> > maybe? I'd rather crash the system now rather than experiencing random
> > behaviors later...
> >
> 
> What you would rather do does not matter here.
> No new BUG_ON() is a rule set by Linus.
> Yes, some people (security people mostly) will prefer to crash the system
> over an "undefined" behavior later, but many non-security people would
> much rather have some processes stuck or crash than losing access to
> the entire system.
> There is no one good answer, but it is Linus who gets to decide.

I see, WARN_ON_ONCE() then seems more appropriate.

> 
> > > 2. If anything, you should check s_type == s_ovl_fs_type, not s_magic
> >
> > Hm.. is there a fast way to determine when sb->s_type == overlayfs?
> > Using get_fs_type() here seems quite expensive and I'm not even sure if
> > it's doable, is there a better way that I don't see?
> >
> 
> Not sure what you mean.
> This is what I meant:
> 
> +extern struct file_system_type ovl_fs_type;
> +
>  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
>  {
> +       WARN_ON_ONCE(sb->s_type != &ovl_fs_type);
> +
>         return (struct ovl_fs *)sb->s_fs_info;
>  }
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index f97ad8b40dbb..0c1f9d1e9135 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -2083,7 +2083,7 @@ static struct dentry *ovl_mount(struct
> file_system_type *fs_type, int flags,
>         return mount_nodev(fs_type, flags, raw_data, ovl_fill_super);
>  }
> 
> -static struct file_system_type ovl_fs_type = {
> +struct file_system_type ovl_fs_type = {
>         .owner          = THIS_MODULE,
>         .name           = "overlay",

Ah yes, we need to make ovl_fs_type non static. If it's acceptable, that
would work.

> 
> > > 3. It is very unclear to me that this check has that much value and OVL_FS()
> > >     macro is very commonly used inside internal helpers, so please add a
> > >     "why" to your patch - why do you think that it is desired and/or valuable
> > >     to fortify OVL_FS() like this?
> >
> > Sure, I can send a v2 explaining why I think this is needed. Basically I
> > was debugging a custom overlayfs patch and after a while I realized that
> > I was accessing the sb->s_fs_info of a real path (not an overlayfs sb),
> > using OVL_FS() with a proper check would have saved a me a bunch of
> > time.
> >
> 
> I think if you add this extra pedantic check, it should be ifdefed with
> some Kconfig for extra debugging.
> 
> Maybe you could add CONFIG_OVERLAY_FS_DEBUG like some
> other fs have. I am not sure if fortifying OVL_FS() is worth it, but
> maybe this config will gain more pedantics checks in the future.
> 
> It's really up to Miklos to decide if this is interesting for overlayfs.

I like the CONFIG_OVERLAY_FS_DEBUG idea. I'll send a v2 with these
changes, let's see if there's some interest in it. Thank you so much for
your suggestions!

-Andrea
