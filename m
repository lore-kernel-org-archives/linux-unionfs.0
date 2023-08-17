Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6657BC2FC14
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 13:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351599AbjHQN4g (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351598AbjHQN4H (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 09:56:07 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9FA2710
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 06:56:06 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-4476a2a5bc9so3066151137.2
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 06:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692280566; x=1692885366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=08J1Fg47Ao6TsIUlIXv2QxzyqeF884SJshMCvD90wy0=;
        b=Fx060NUsiYK/l5CLCEiGk/LEa8FSut2ACjbv3h/oCl9Z+HH2bbROEzfswb01gb+4Zk
         1gLC2wisNFZ1m0Z+r6J0VDSe7kxiAGkIf0uFee0+vfBBkTrYKO810YTHN9Derpjb8s8h
         V9yTCYku115YjgI5bTpLpd2n9l66DmM7xVWIU2IkR8sVfIz7E8ZiPo/83Bq0YKiY3eLz
         nDtSr9ECjpwluQR4rWjDSdbUiceoDhnW/BDDrwCet79dMXXFzXor8nmeBsrh6IPPqk5F
         k9aAiopT3Sblhiwkturpwen+wGHILXtXVIksgPD4HAi1UIf90hVcWA5uIGu7uvMTspKS
         /wwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692280566; x=1692885366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=08J1Fg47Ao6TsIUlIXv2QxzyqeF884SJshMCvD90wy0=;
        b=gw1H9ZBXx6A92TYeZ70Fh4cvufQPTBbC1cLCa1FCNsckq3yxMsln0cno2HchbbDGVl
         vdqck3Oqv/1emr8tRWrrn1ZZo1N6JQt4wqPIKdohfOCXprRopsSISO8h50zHFGo0Mi/Z
         3U9zo1SftIXRo9EoEMuv3uGv+5LHaU3kd2O8Q319B1bxPgjom4q47OOwfmSRZEhPfODk
         SUUhTmul0CGuajyy6x3epSeXV3cs26YOu9Vaw56GVpmuPvldxsq1mzMhgP3UrVb7zIoO
         d8BVHTZGbrRGpk/+V6cJQcWNXwMvmBvpxPM6brmfMAMCe2TVQshS/iNkup96HoXAUSAm
         /vrw==
X-Gm-Message-State: AOJu0YxawJkWtbbPQ1tyOSGkID89LCZ7OZ4HEKW6NFtxChA6Lhy4RfrJ
        5tWGVhfC7apmqCB8zvV8IW5u2rMaVXbgLaNNuuA=
X-Google-Smtp-Source: AGHT+IE08EZhFvv0Yfi9NtNOoIWnAUMKM02nLTj6JJ5SsIZQDHdhXJXbYlJdFeKrnpl+FkIfgL3evfXdhLIz39amzr8=
X-Received: by 2002:a67:b90d:0:b0:44a:f966:b629 with SMTP id
 q13-20020a67b90d000000b0044af966b629mr4137906vsn.31.1692280566057; Thu, 17
 Aug 2023 06:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230816152334.924960-1-amir73il@gmail.com> <20230817054446.961644-1-amir73il@gmail.com>
 <20230817-vagabunden-glatze-c30318a0ecc0@brauner>
In-Reply-To: <20230817-vagabunden-glatze-c30318a0ecc0@brauner>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Aug 2023 16:55:55 +0300
Message-ID: <CAOQ4uxhsyGwoOiTAegPmFBQiJmuhs_RZNzrb7L3gXLRxNmR3HA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] fs: export __mnt_{want,drop}_write to modules
To:     Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 17, 2023 at 4:38=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Aug 17, 2023 at 08:44:46AM +0300, Amir Goldstein wrote:
> > overlayfs is going to use those to grab a write reference on the
> > upper fs during copy up.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Christian,
> >
> > This patch is needed for the ovl_want_write() changes [1],
> > which I forgot to CC you on.
> >
> > Please ACK if you approve.
> >
> > Thanks,
> > Amir.
> >
> > [1] https://lore.kernel.org/linux-unionfs/20230816152334.924960-1-amir7=
3il@gmail.com/
> >
> >  fs/namespace.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index e157efc54023..370328b204f1 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -386,6 +386,7 @@ int __mnt_want_write(struct vfsmount *m)
> >
> >       return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(__mnt_want_write);
>
> Puh, not excited about that but also no real reason to say no other than
> generic worries about it being abused.
> But maybe let's not export underscore variants. Might make sense to at
> least name them differently? mnt_want_write_locked()?

Heh, it's not locked. It happens to be called with sb_start_write() from
mnt_want_write(), but from do_dentry_open() it's actually called *before*
file_start_write(), because the mnt_writers refcount and sb_writers lock
are not strictly ordered, which is very convenient for ovl copy up.

We could go for mnt_{get,put}_write(), but that's a bit close to
mnt_get_writers().

We could go for mnt_{get,put}_write_access(), like helpers with similar
names for inode.

I don't really mind, as long as this doesn't become a bike shedding thing..=
.

Thanks,
Amir.
