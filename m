Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BBCEE49A8
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 11:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbjHVLEC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 07:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbjHVLEC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 07:04:02 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527FBCCA
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 04:04:00 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2bcb89b476bso36622121fa.1
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 04:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692702238; x=1693307038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=trVN3CuZ4Zhp9Ue7PGXCyXAOehB2OZABgpBxkBylf84=;
        b=ecHGyCPQo8H5x40ZFNHOeRj5+kqZ1P4F7rr69u8S7Pw9CydrEsm0/pwYtwLuzS81nO
         S1Ig/gpZ8l1nFgbosUBJG5HQlBrJ4H1dwp2GodBlDwKFmYjEf7VXK7oS4oW0GPEdGWk4
         shnVVb8iP8RPJ9UBotomQ9DlD1tGHLyrEaWrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692702238; x=1693307038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=trVN3CuZ4Zhp9Ue7PGXCyXAOehB2OZABgpBxkBylf84=;
        b=ACH5Qar7sLaHgYMskEDTDgEc46R+OrFMwA85EUYS7vJrDV6apKMbfwZi3Icis8TJNN
         DmGmi2GTZR5lMEqoDkcu3NJOUjenYK1mnmZPTo+JXwgc8MZsXvNG8t2EjdK1R4qcyrD4
         qlJd5vmz1KZI0UeoXtUXgbhIBwNmH/DD3hpqPLW+6Sh0EkQih/83U4affkdws/Td+Cq8
         XLqg/+BfZ01d8MK2QrjsvjNNglzmj0OEo9SkcfC76In9qkP1jy6iGfiXg2ogGGYlEhet
         sQId5AGxxCFJ2VJBhTtN0nMKruwzIvICHQRuqd0TyFVRCUYQJayU/qhETHBnui30ne/y
         vp0Q==
X-Gm-Message-State: AOJu0Yzrbyk6iZodPhFoR+tiKbv/l4zDID9b8a9I3Zr7czdoHsXhHi6N
        P0/st2fU9JRDgecCkD1h56ysycekrH/JocCSsMPIZQ==
X-Google-Smtp-Source: AGHT+IEjlewioVEmIve9ohhJ00v79UX4XU1Bu1tNq5wyCv6Oj2EB7s9xjSHgBX9SsM8lUufy0Q0T9b+1h6bBcZsrmnw=
X-Received: by 2002:ac2:4db9:0:b0:500:8723:e457 with SMTP id
 h25-20020ac24db9000000b005008723e457mr2005827lfe.30.1692702238292; Tue, 22
 Aug 2023 04:03:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230519125705.598234-1-amir73il@gmail.com> <20230519125705.598234-6-amir73il@gmail.com>
 <CAJfpeguhmZbjP3JLqtUy0AdWaHOkAPWeP827BBWwRFEAUgnUcQ@mail.gmail.com>
 <CAOQ4uxhYZqe0-r9knvdW_BWNvfeKapiwReTv4FWr_Px+CB+ENw@mail.gmail.com>
 <CAOQ4uxhBeFSV7TFuWXBgJZuu-eJBjKcsshDdxCz-fie0MqwVcw@mail.gmail.com> <CAOQ4uxirdrsaHPyctxRgSMxb2mBHJCJqB12Eof02CnouExKgzQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxirdrsaHPyctxRgSMxb2mBHJCJqB12Eof02CnouExKgzQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 22 Aug 2023 13:03:46 +0200
Message-ID: <CAJfpegth3TASZKvc_HrhGLOAFSGiAriiqO6iCN2OzT2bu62aDA@mail.gmail.com>
Subject: Re: [PATCH v13 05/10] fuse: Handle asynchronous read and write in passthrough
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Daniel Rosenberg <drosen@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        Alessio Balsini <balsini@android.com>,
        fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 22 Aug 2023 at 12:18, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Aug 21, 2023 at 6:27=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:

> > Getting back to this.
> > Did you mean something like that? (only compile tested)
> >
> > https://github.com/amir73il/linux/commits/backing_fs
> >
> > If yes, then I wonder:
> > 1. Is the difference between FUSE_IOCB_MASK and OVL_IOCB_MASK
> >     (i.e. the APPEND flag) intentional?

Setting IOCB_APPEND on the backing file doesn't make a difference as
long as the backing file is not modified during the write.

In overlayfs the case of the backing file being modified is not
defined, so I guess that's the reason to omit it.  However I don't see
a problem with setting it on the backing file either, the file
size/position is synchronized after the write, so nothing bad should
happen if the backing file was modified.

> > 2. What would be the right way to do ovl_copyattr() on io completion?
> >     Pass another completion handler to read/write helpers?
> >     This seems a bit ugly. Do you have a nicer idea?
> >

Ugh, I missed that little detail.   I don't have a better idea than to
use a callback function.

>
> Hmm. Looking closer, ovl_copyattr() in ovl_aio_cleanup_handler()
> seems a bit racy as it is not done under inode_lock().
>
> I wonder if it is enough to fix that by adding the lock or if we need
> to resort to a more complicated scheme like FUSE_I_SIZE_UNSTABLE
> for overlayfs aio?

Quite recently rename didn't take inode lock on source, so
ovl_aio_cleanup_handler() wasn't the only unlocked instance.

I don't see a strong reason to always lock the inode before
ovl_copyattr(), but I could be wrong.

Thanks,
Miklos
