Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADBBC001B0
	for <linux-unionfs@archiver.kernel.org>; Sun, 13 Aug 2023 07:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjHMHbu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 13 Aug 2023 03:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjHMHbt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 13 Aug 2023 03:31:49 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3919B1702
        for <linux-unionfs@vger.kernel.org>; Sun, 13 Aug 2023 00:31:51 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 817993F11C
        for <linux-unionfs@vger.kernel.org>; Sun, 13 Aug 2023 07:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691911908;
        bh=te/Xx2gaglQiS84JEJtTrPBsgJlPI6tJVIkSF2PcxwY=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=iiw7EGDNMJ44t/jssB6NjCeZbnB+9PfYOsliSmlnQd2zlVe0u83E5OUlUphxgAsTp
         U6VoXb8q6C52MYbALUNnUCzhQ7EvU7A/2ZwA0bal9oh/cPosaTrj/UB0UM8k3wgByY
         FOjJOnSrXE80UhV0QBaDsjtGk2wXpr88x3lo9Q/ZWrIuS1GDxy2fm9TPS2XFvjaDay
         N4XWP78Ox4FP83/YzJRnRmCW3GO/jtKd50bsjYmovs/J8AwNBfAg9w6gau+QrKyjAn
         /vVjg39II7gFqckIEV0hyuKLID1IayHR4otLutCsmLxpzg+d7EyceDtjtbsS0RKh5B
         3q3X1pWhNfagA==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-99cc32f2ec5so209781166b.1
        for <linux-unionfs@vger.kernel.org>; Sun, 13 Aug 2023 00:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691911908; x=1692516708;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=te/Xx2gaglQiS84JEJtTrPBsgJlPI6tJVIkSF2PcxwY=;
        b=NWY19Rs8/Ej++go31uEKzAGlewbM0evdAsUICwv/2+EtkmUa980NQM2NmXJNdhsFsO
         XPc1dbuOY8BoSnkaTLJFPX9IzXfsYwBBxwcBtStJDQzdvsuYGKnO2iE7txHuUgBdS4gA
         2BHQRPHOFw5nwHQhX9ix++XfHC9jD2V/H3ZvkrXt/fePdtfUZqjqWxToEYreKW2+u//J
         5oiv1hjKcn4PMnr5AvnPspSN2SafmFzGb136VyFuVD5lAssDG4cEocGk/U11GfC0bvAk
         ZU/hbg52hI8PV7FL3rk/3thugFZoBJr8fSontDB63tPEgPiU24Vtei4TgHG3e7coryv6
         YXXA==
X-Gm-Message-State: AOJu0YyfPtHyfduyrsE85zjeEZJyr3HychUVSW/8kbla7uzqNuXPNFqe
        w8wxiSieDPJ83clT9tGIgjD6z7DV5lhAkrooQ7lSCRKqLKi9pOE0Mk048lGsvXGK2oTo70DXJjQ
        fNqW7E7AqJYMqQEoP7dfXvgrtk66lh52O1VnSZmO3SOvxEBuEXIY=
X-Received: by 2002:a17:906:5dc1:b0:99b:499d:4635 with SMTP id p1-20020a1709065dc100b0099b499d4635mr4790975ejv.75.1691911908125;
        Sun, 13 Aug 2023 00:31:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEieu5fDFWQnd3rHvTclzQDXAn8xqHCVtF3qVSxzGjOrzNodbprwqBTIL2O5HPIiiujM+YvIg==
X-Received: by 2002:a17:906:5dc1:b0:99b:499d:4635 with SMTP id p1-20020a1709065dc100b0099b499d4635mr4790957ejv.75.1691911907377;
        Sun, 13 Aug 2023 00:31:47 -0700 (PDT)
Received: from localhost (host-87-17-133-161.retail.telecomitalia.it. [87.17.133.161])
        by smtp.gmail.com with ESMTPSA id kd28-20020a17090798dc00b009937e7c4e54sm4325158ejc.39.2023.08.13.00.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 00:31:46 -0700 (PDT)
Date:   Sun, 13 Aug 2023 09:31:45 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] ovl: validate superblock in OVL_FS()
Message-ID: <ZNiG4WFcQRGL1dWx@righiandr-XPS-13-7390>
References: <20230521082813.17025-1-andrea.righi@canonical.com>
 <20230521082813.17025-4-andrea.righi@canonical.com>
 <CAJfpegtK=dh0yNdvxSC8YF6vOYqGPM5EOWny07jYDdFc0qfhTQ@mail.gmail.com>
 <CAOQ4uxjxSVNqicAUhevCXEuRZGZdAPhz4BksM8yE5HbE0piZ6A@mail.gmail.com>
 <CAOQ4uxgzVVh1F6QiMKcXdBsYaVC7zsF4mCLciYnFU8hBvxzgkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgzVVh1F6QiMKcXdBsYaVC7zsF4mCLciYnFU8hBvxzgkA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Aug 12, 2023 at 07:26:01PM +0300, Amir Goldstein wrote:
> On Fri, Aug 11, 2023 at 12:14 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Jul 24, 2023 at 5:43 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Sun, 21 May 2023 at 10:28, Andrea Righi <andrea.righi@canonical.com> wrote:
> > > >
> > > > When CONFIG_OVERLAY_FS_DEBUG is enabled add an explicit check to make
> > > > sure that OVL_FS() is always used with a valid overlayfs superblock.
> > > > Otherwise trigger a WARN_ON_ONCE().
> > > >
> > > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > > > Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> > > > ---
> > > >  fs/overlayfs/ovl_entry.h | 12 ++++++++++++
> > > >  1 file changed, 12 insertions(+)
> > > >
> > > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > > > index b32c38fdf3c7..e156649d9c71 100644
> > > > --- a/fs/overlayfs/ovl_entry.h
> > > > +++ b/fs/overlayfs/ovl_entry.h
> > > > @@ -97,8 +97,20 @@ static inline struct mnt_idmap *ovl_upper_mnt_idmap(struct ovl_fs *ofs)
> > > >
> > > >  extern struct file_system_type ovl_fs_type;
> > > >
> > > > +static inline bool is_ovl_fs_sb(struct super_block *sb)
> > > > +{
> > > > +       return sb->s_type == &ovl_fs_type;
> > > > +}
> > > > +
> > > > +#ifdef CONFIG_OVERLAY_FS_DEBUG
> > > > +#define OVL_VALIDATE_SB(__sb)  WARN_ON_ONCE(!is_ovl_fs_sb(__sb))
> > > > +#else
> > > > +#define OVL_VALIDATE_SB(__sb)
> > > > +#endif
> > > > +
> > > >  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> > > >  {
> > > > +       OVL_VALIDATE_SB(sb);
> > >
> > > This could be written simply and naturally:
> > >
> > >     if (IS_ENABLED(CONFIG_OVERLAY_FS_DEBUG))
> > >          WARN_ON_ONCE(sb->s_type != &ovl_fs_type)
> > >
> >
> > Andrea,
> >
> > There is an inherent challenge with a cleanup series like this one
> > that touches many functions to avoid merge conflicts with other
> > devel branches. I did not try, but I expect there are conflicts
> > with the current overlayfs-next branch.
> >
> > I also see at least one new direct reference of sb->s_fs_info
> > in ovl_maybe_validate_verity().
> >
> > Please make sure to base your next submission on overlayfs-next
> > branch from git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git.
> >
> > Once you do that, we could apply your patches to overlayfs-next
> > so they won't get stale again.
> 
> Nevermind, I had rebased overlayfs-next, so already applied your
> patches with the needed conflict resolutions and addressed Miklos' comment.

Sorry for the late response, I was on vacation (with a poor internet
connection). However, it looks like there's not much to do for me at
this point, thanks for taking care of this! :)

-Andrea

> 
> Thanks,
> Amir.
