Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CE0CA0FEF
	for <linux-unionfs@archiver.kernel.org>; Fri,  1 Sep 2023 17:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbjIAR6X (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 13:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348292AbjIAR6W (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Sep 2023 13:58:22 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF44412B
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Sep 2023 10:58:10 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-44e3a4d0a6fso1030023137.0
        for <linux-unionfs@vger.kernel.org>; Fri, 01 Sep 2023 10:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693591089; x=1694195889; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40nc7SeW0/2lA1YhpK6kaG25eiWlx8oBzrj9+GMY+j4=;
        b=HEZuoR4klhFhZor74HwBOGAk0rgrKlvOKDpVdEI1kWJSCZM8ZKbpKom3v2ilwlX3O9
         li544cQRV8YHHK0F9snnAo/uyrfvWSpyPflo7yU7aGy9Dm7A+pXznpTPKIR9Ttw2aTJ0
         Yt2aW9J0suP435idc75vp+c900AR+nKOFh08380l5WFvcNkQkSnMM3Z6XFLnlm4puO6k
         EOxvOz8b48UtkkJCGXoZvjO2P0oUZ7kJrtYd9CAOJ1D2CaKKt9rfbYzNJ4WJUy8dZ2Ed
         e1NZKgqYrOlDKnG2KzfQgTFIVbpMfL/mhgJxC5CRCuT5vOz6bKz52JR8eSfwc3cIPS/s
         g/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693591089; x=1694195889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=40nc7SeW0/2lA1YhpK6kaG25eiWlx8oBzrj9+GMY+j4=;
        b=eBMnPXUgiyxYjHl6ToxuZAsouujRwN/SNPZqxT8ePouXZ9xJNi4+SxL2akaThtQq4/
         8MHOsSSbnc5iqu8tcyP7kkTTcwoPfGLHOULmmhKCGSMaJt4E9rBfrGbf2hnCcRQEzd7f
         skqiLkZ7P+8S8J3WvB1kVss4BLpLiCJwkTdM30nlPHH7eR3slYvzACAoGHAkBPUAdcZ6
         2wzSmGVs93213UYjFLZQBhnV1TYq9cFzoWkGt4hhcXlfp8tVVmAoTofSMryyw0SPSus6
         VXeUqnOQkbsFlvU0gu9djJ28zCHljes56v0DLMIHmaTwyyzofpzH5UGui6CdIy1JH2xQ
         QVdA==
X-Gm-Message-State: AOJu0Yzd1+xrRisn8L9cJHKeYFxDnB1C9J/oR3XotGYF7XsbY2uyl82M
        si+B+YDm0DAEm9BybPdXxDkxw2UL5rzNp0aTyQXDGedeNcw=
X-Google-Smtp-Source: AGHT+IHlpPtGzS5hoRKTm31LC1MbTxLVCUlit3q0+aQwdVRf6Ai70O52D9EjHHlMqpwKpc4BVMqJhd+xRWGb3yU4kL4=
X-Received: by 2002:a67:f80f:0:b0:44d:3aba:b03d with SMTP id
 l15-20020a67f80f000000b0044d3abab03dmr3597181vso.17.1693591089594; Fri, 01
 Sep 2023 10:58:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAKd=y5EeKfC6vBXh1xqTfeW6OQZiNWaZ04J1SNWxyEjY4QxhHw@mail.gmail.com>
 <CAKd=y5HZ0nJJ9XN9i6vnyhzM=COijmuSzgqJPAPFn6dguQyFQA@mail.gmail.com>
 <CAOQ4uxid-eDr2XBHo_JoPhiP99PrXj0eNKgEQXP-SOEbg4hn_Q@mail.gmail.com>
 <CAKd=y5Gsz1z1xSmHGyoEs+SckC=M0T7nrP7t5mvvuoWkCWkDLg@mail.gmail.com>
 <CAOQ4uxiQtSSHL0gLohBpRs7vwUrF5LqCLB=Oh6kSz1O-ga04Tw@mail.gmail.com> <CAJfpegvCEsvac5j3CSVWjjZLsxDvZ-_vX-6u1ZQra26dnUk-jg@mail.gmail.com>
In-Reply-To: <CAJfpegvCEsvac5j3CSVWjjZLsxDvZ-_vX-6u1ZQra26dnUk-jg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 1 Sep 2023 20:57:58 +0300
Message-ID: <CAOQ4uxjHob=nDUghkGHpcfoAYSUNV_MZB5YHEkTUXB+bOuUBoA@mail.gmail.com>
Subject: Re: [Bug report] overlayfs: cannot rename symlink if lower filesystem
 is FUSE/NFS
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        Sergey Kanzhelev <skanzhelev@google.com>,
        Michael Sheinin <msheinin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 1, 2023 at 1:14=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> w=
rote:
>
> On Fri, 1 Sept 2023 at 12:08, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Fri, Sep 1, 2023 at 12:59=E2=80=AFAM Ruiwen Zhao <ruiwen@google.com>=
 wrote:
> > >
> > > Thanks for the reply Amir! Really helps. I will try the easy fix (i.e=
. ignoring ENXIO) and test it. Meanwhile I have two questions:
> > >
> > > 1. Since ENXIO comes from ovl_security_fileattr() trying to open the =
symlink, I was trying to find who returns ENXIO in the first place. I did s=
ome code search on libfuse (https://github.com/libfuse/libfuse), but cannot=
 find ENXIO anywhere. Could it be from the kernel side? (I am trying to use=
 this as a justification of the easy fix.)
> > >
> >
> > I think ENXIO comes from no_open() default ->open() method.
> >
> > > 2. Miklos's commit message says "The reason is that ovl_copy_fileattr=
() is triggered due to S_NOATIME being
> > > set on all inodes (by fuse) regardless of fileattr." Does that mean `=
ovl_copy_fileattr` should not be triggered on symlink files but it is, and =
therefore it is getting the errors like ENXIO and ENOTTY?
> > >
> >
> > Miklos' comment explains why ovl_copy_fileattr() passes the gate:
> >
> >         if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
> >
> > S_NOATIME is an indication that the file MAY have fileattr FS_NOATIME_F=
L,
> > but in the case of FUSE and NFS, S_NOATIME is there for another unrelat=
ed
> > reason.
> >
> > In any case, S_NOATIME on a symlink is never an indication of fileattr,
> > so I think the correct solution is to add the conditions to the gate:
> >
> >         if (inode->i_flags & OVL_COPY_I_FLAGS_MASK &&
> >            ((S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode))) {
> >
>
> I don't think this is correct: symlink's atime is updated on readlink
> or following.

I am not saying that symlink cannot have S_NOATIME, but
i_flags of the symlink have already been copied to ovl inode.
I don't think that symlink can have fileattr, because symlink
cannot be opened for the FS_IOC_SETFLAGS ioctl, so there
is never a reason to call ovl_copy_fileattr() for anything other
than dir or regular file. Right?

Thanks,
Amir.
