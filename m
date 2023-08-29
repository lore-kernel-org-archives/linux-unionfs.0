Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8DBFC83F14
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Aug 2023 12:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbjH2Mm4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 08:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjH2Mm2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Aug 2023 08:42:28 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79E6D7
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Aug 2023 05:42:22 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-52a3aa99bcdso6085865a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Aug 2023 05:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1693312941; x=1693917741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TemF0jUjMAO+8hJZS7nEbVsze7Vi55cm3C8VYiV8NKU=;
        b=Nl87rNoPS83EQR+PwTR149vZ4Vsgd3FN2ceLP6dCGbu6jfFoRQfLtj51aVW18OJVcN
         9kCDN7t6xwjd78J9iebgDJ54KGnkhyUJiAGoj6NWfxx/WBIeTYgLSonZBS24TY0+SwqU
         AMC36Nu54zR//2pHgzHsGqmAWBQVs4wjHn2hs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693312941; x=1693917741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TemF0jUjMAO+8hJZS7nEbVsze7Vi55cm3C8VYiV8NKU=;
        b=F/7UgSxkBcaAZ+GaeD3eIEoK4IMeq7jeTW3ao0ASwWwgwnvDndZ5pLb7f9UX2xt5WU
         q42cqKlCD7qtVXplfocFRKbKL3x0U2m9A0DuCeSq0w03o2YAZ5gb/Kzerti0pNREpCOl
         dRcN265N9CvYeLhSww9WsBkbZYDO1U5lIu9LarH9EgzmK2pHqIiLQifoD7VmBBrj1E0/
         Y/sfQsl+LLvl2UAUTBgtlgty+2vZwlf6ma3dqT7RR9QVmv7NPwipusv7oLJivCMs1E9Z
         b12ZyayaQDu2yNxf1o0ywiQQIeV7A9SCIDt8N/7f60trWF8LG4ccmHU5JFCbF0gzUQCy
         91KQ==
X-Gm-Message-State: AOJu0YxLBBdqA2MtHIFMKbUJip7XxzNCmaFyUUGsFRs599xudcQbxuu1
        Mpnkn+Ak1m68QtFyfctRLAc7fcpNI8t8W0C/APGopw==
X-Google-Smtp-Source: AGHT+IGJ0ydHLDAokapfFjVf0X192kt5yyGqnkaENd6kAcH7qyGwUNEfb3IGvy5ZcA06uzhmDt10c0bFuIQTtJwCU3Y=
X-Received: by 2002:a17:906:1dd:b0:99b:dd1d:bc58 with SMTP id
 29-20020a17090601dd00b0099bdd1dbc58mr23749885ejj.41.1693312941245; Tue, 29
 Aug 2023 05:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230519125705.598234-1-amir73il@gmail.com> <20230519125705.598234-6-amir73il@gmail.com>
 <CAJfpeguhmZbjP3JLqtUy0AdWaHOkAPWeP827BBWwRFEAUgnUcQ@mail.gmail.com>
 <CAOQ4uxhYZqe0-r9knvdW_BWNvfeKapiwReTv4FWr_Px+CB+ENw@mail.gmail.com>
 <CAOQ4uxhBeFSV7TFuWXBgJZuu-eJBjKcsshDdxCz-fie0MqwVcw@mail.gmail.com>
 <CAOQ4uxirdrsaHPyctxRgSMxb2mBHJCJqB12Eof02CnouExKgzQ@mail.gmail.com>
 <CAJfpegth3TASZKvc_HrhGLOAFSGiAriiqO6iCN2OzT2bu62aDA@mail.gmail.com> <CAOQ4uxgzYevVCaGBjjckOr1vv0gKvVPYiOAL6E_KQY-YQx_7hg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgzYevVCaGBjjckOr1vv0gKvVPYiOAL6E_KQY-YQx_7hg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 29 Aug 2023 14:42:09 +0200
Message-ID: <CAJfpeguDP8T8P4u6ipdwhJmiV3C40Okq+y6AkVs3A1eWFzSsvA@mail.gmail.com>
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

On Thu, 24 Aug 2023 at 14:12, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Aug 22, 2023 at 2:03=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Tue, 22 Aug 2023 at 12:18, Amir Goldstein <amir73il@gmail.com> wrote=
:
> > >
> > > On Mon, Aug 21, 2023 at 6:27=E2=80=AFPM Amir Goldstein <amir73il@gmai=
l.com> wrote:
> >
> > > > Getting back to this.
> > > > Did you mean something like that? (only compile tested)
> > > >
> > > > https://github.com/amir73il/linux/commits/backing_fs
> > > >
> > > > If yes, then I wonder:
> > > > 1. Is the difference between FUSE_IOCB_MASK and OVL_IOCB_MASK
> > > >     (i.e. the APPEND flag) intentional?
> >
> > Setting IOCB_APPEND on the backing file doesn't make a difference as
> > long as the backing file is not modified during the write.
> >
> > In overlayfs the case of the backing file being modified is not
> > defined, so I guess that's the reason to omit it.  However I don't see
> > a problem with setting it on the backing file either, the file
> > size/position is synchronized after the write, so nothing bad should
> > happen if the backing file was modified.
> >
>
> That raises the question if FUSE passthrough behavior is defined when
> backing file is being modified. Should it be any different than ovl?
> I don't really care if we set IOCB_APPEND or not, just if we need
> a different mask for ovl and FUSE.

Dunno.

I feel that instead of making the behavior defined when file is
modified behind fuse's back, there should be some mechanism between
the server and the client (userspace and kernel) that allows proper
handling of "remote" modification (oplocks/leases/younameit).

I thought about this quite a bit, and even have some patches for the
read-only lease case.  But this is far from trivial.

In the meantime just setting IOCB_APPEND is quite harmless, so I think
we should do it for both overlayfs and fuse for consistency.

>
> > > > 2. What would be the right way to do ovl_copyattr() on io completio=
n?
> > > >     Pass another completion handler to read/write helpers?
> > > >     This seems a bit ugly. Do you have a nicer idea?
> > > >
> >
> > Ugh, I missed that little detail.   I don't have a better idea than to
> > use a callback function.
> >
>
> Ok. added the cleanup callback.
> I think it's not that bad?
>
> https://github.com/amir73il/linux/commits/backing_fs

Looks good.


>
> > >
> > > Hmm. Looking closer, ovl_copyattr() in ovl_aio_cleanup_handler()
> > > seems a bit racy as it is not done under inode_lock().
> > >
>
> Decided to fix that by taking ovl inode spinlock inside ovl_copyattr()
> and did the same for ovl_file_accessed() for read ops.
>
> I've found and fixed two other issues with aio completion on this branch,
> one of them is a fix for a possible realfile refcount leak, so will proba=
bly
> need to backport this one.

Great.  Thanks.

Miklos
