Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0067CA0FE6
	for <linux-unionfs@archiver.kernel.org>; Fri,  1 Sep 2023 10:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjIAKOu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 06:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbjIAKOt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Sep 2023 06:14:49 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6416EE7F
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Sep 2023 03:14:44 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-52a4818db4aso2223150a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 01 Sep 2023 03:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1693563283; x=1694168083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4yBma5PSR2vAVSt80K0f8R5+JOC5XIkGZE0DB0Iwfk=;
        b=EoZ028zhbJK66eleON6DD4PUibvofvPIblWfAoGqLVxAPwgzgLJU3ieH5eBuBmuDX7
         +lZbimesHfkTq/SH8b75sJ4mMV2AKRe+X8JtKZX4dthnbOPqQSALJxZRXwBXA9fe9ss6
         a1zOH7wPcf5rsAHpEhzqirupKbSRIbn8LpTRE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693563283; x=1694168083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X4yBma5PSR2vAVSt80K0f8R5+JOC5XIkGZE0DB0Iwfk=;
        b=NBArsajQ/+oLayBjUlN+4UKad9sKIZo3owH8bpe/vaN1ziKwtnNAPIusmz32+gixYW
         idqP98uwHCaHIwq8TtEwq9tISmyMMl3RyXkZlDlWcg52aoq13LF5fhrd3b9d1HUaOOeN
         j9BTmZZGvSSV7A+RlrrN3fHoICNPmGtObGe+UOgxM0a08c/NBTorzxrlcKwNROSxvwLC
         /Y4D+ExuLzGD9SvV32JrYWgOIBl7QAtSj7S3dI4lAKTGvS2Utlz1MnZxmD+sLyLrP+L9
         DMV6dnZzrfP1R7s0IebOSEdFp+U0+rejiVO6bfgndZDP9hE5zhYH6F3PqNNi8NnxzjJv
         Y0sA==
X-Gm-Message-State: AOJu0Yzdvc6ZlrddakqReMra1GwuxeqK20XSrvQ07+aBVcOZCc27hyAT
        C92cXDbxmsKtM5MbItmhpy5xk/EbYm1jbdNcdZf0jw==
X-Google-Smtp-Source: AGHT+IGJskPyt8XO61qa80XhIPsAxjo7ZKX44bCgTOp3VqSiQyvIXe1txj8Y4SRyMq1XtyyOWXkkV68y6eKnm6IsIJk=
X-Received: by 2002:a17:906:7c13:b0:9a5:cf23:de54 with SMTP id
 t19-20020a1709067c1300b009a5cf23de54mr1166324ejo.38.1693563282642; Fri, 01
 Sep 2023 03:14:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAKd=y5EeKfC6vBXh1xqTfeW6OQZiNWaZ04J1SNWxyEjY4QxhHw@mail.gmail.com>
 <CAKd=y5HZ0nJJ9XN9i6vnyhzM=COijmuSzgqJPAPFn6dguQyFQA@mail.gmail.com>
 <CAOQ4uxid-eDr2XBHo_JoPhiP99PrXj0eNKgEQXP-SOEbg4hn_Q@mail.gmail.com>
 <CAKd=y5Gsz1z1xSmHGyoEs+SckC=M0T7nrP7t5mvvuoWkCWkDLg@mail.gmail.com> <CAOQ4uxiQtSSHL0gLohBpRs7vwUrF5LqCLB=Oh6kSz1O-ga04Tw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiQtSSHL0gLohBpRs7vwUrF5LqCLB=Oh6kSz1O-ga04Tw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 1 Sep 2023 12:14:30 +0200
Message-ID: <CAJfpegvCEsvac5j3CSVWjjZLsxDvZ-_vX-6u1ZQra26dnUk-jg@mail.gmail.com>
Subject: Re: [Bug report] overlayfs: cannot rename symlink if lower filesystem
 is FUSE/NFS
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        Sergey Kanzhelev <skanzhelev@google.com>,
        Michael Sheinin <msheinin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 1 Sept 2023 at 12:08, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Sep 1, 2023 at 12:59=E2=80=AFAM Ruiwen Zhao <ruiwen@google.com> w=
rote:
> >
> > Thanks for the reply Amir! Really helps. I will try the easy fix (i.e. =
ignoring ENXIO) and test it. Meanwhile I have two questions:
> >
> > 1. Since ENXIO comes from ovl_security_fileattr() trying to open the sy=
mlink, I was trying to find who returns ENXIO in the first place. I did som=
e code search on libfuse (https://github.com/libfuse/libfuse), but cannot f=
ind ENXIO anywhere. Could it be from the kernel side? (I am trying to use t=
his as a justification of the easy fix.)
> >
>
> I think ENXIO comes from no_open() default ->open() method.
>
> > 2. Miklos's commit message says "The reason is that ovl_copy_fileattr()=
 is triggered due to S_NOATIME being
> > set on all inodes (by fuse) regardless of fileattr." Does that mean `ov=
l_copy_fileattr` should not be triggered on symlink files but it is, and th=
erefore it is getting the errors like ENXIO and ENOTTY?
> >
>
> Miklos' comment explains why ovl_copy_fileattr() passes the gate:
>
>         if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
>
> S_NOATIME is an indication that the file MAY have fileattr FS_NOATIME_FL,
> but in the case of FUSE and NFS, S_NOATIME is there for another unrelated
> reason.
>
> In any case, S_NOATIME on a symlink is never an indication of fileattr,
> so I think the correct solution is to add the conditions to the gate:
>
>         if (inode->i_flags & OVL_COPY_I_FLAGS_MASK &&
>            ((S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode))) {
>

I don't think this is correct: symlink's atime is updated on readlink
or following.

Thanks,
Miklos
