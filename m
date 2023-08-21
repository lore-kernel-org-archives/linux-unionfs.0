Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3086EEE4996
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Aug 2023 15:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjHUPcC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Aug 2023 11:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjHUPcB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Aug 2023 11:32:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C661E2
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 08:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692631878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=npFkXzbp/uLN9p13I/d5+FZXVQkLFNe8hnsyNldvLN4=;
        b=YTsTzwD1ZoXo+j8CY/2xXvKRMES7b0n87aplcBZC33b0wpszU21RbsXhtXqC2FmNqUOGUH
        TsVoonF4vSDZzXo9McWAIvPd6M22bZekqgQwrzlvBLhCipjnIjPjI/R4mlYrGQOH7q3LVM
        bLTXyOBjam+S0asGk1qAcGFYd/UPzMM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-i59vusWoNnyLZF2MauttTQ-1; Mon, 21 Aug 2023 11:31:17 -0400
X-MC-Unique: i59vusWoNnyLZF2MauttTQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-34baf55c62cso36933095ab.3
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 08:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692631877; x=1693236677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=npFkXzbp/uLN9p13I/d5+FZXVQkLFNe8hnsyNldvLN4=;
        b=fkZaA556hn3qalYJscTZCYrvQY0yIFZjAdddF8b9mCz/aGyVqrDy5XF4pJ8ZnyN8+l
         F+/lVhdEX+lDuqIhlAUdNgcYS6YCuWvUmmIaI1IynTUyFmHitVN9zE4R0wXJElCJ5oWv
         3dATSWraF6rRGP1XXtNWu6fkozERf3mV4U8ObQyhXTXJ5WfAxAyPnGkissKEQeM2F5Qo
         1XI9KMEkqM8Ijq6z97F79+0q7F0n1NDa/ZUJREC84wWVu9hbCPyKvHVi+gSbc7cW/Aed
         WlQgaQ9klp1no28k7FK0mg0zZEdvh+7AzaBDcimJf60OQNtn/j6hhFKoWes2IFZ76TAK
         w0Vw==
X-Gm-Message-State: AOJu0Yy89VJb5ESwuMyfl+PS+xTjYCO+iYFGY7xvwUzNtfAFTvysFmxp
        isSZopNjVznxkHTBbRxuV/JXUIqy5dgy5Q8yEutz8iMGwTYlQiQvXHjIDNuuL2gZLpdimsR7egU
        SH7KGkf6XS6gr4/HRfm6DOcAKhApTHkCok43cTBeZOg==
X-Received: by 2002:a05:6e02:12aa:b0:348:e4a7:7bff with SMTP id f10-20020a056e0212aa00b00348e4a77bffmr7656296ilr.21.1692631876849;
        Mon, 21 Aug 2023 08:31:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4jcPGmXoNItRLtUwq5+N7rOdpXaVLScKi3wwwoVMS9aWbsk1Lc2SXwaAosqR4KqSpKsElegjeuRyMnntaCo4=
X-Received: by 2002:a05:6e02:12aa:b0:348:e4a7:7bff with SMTP id
 f10-20020a056e0212aa00b00348e4a77bffmr7656281ilr.21.1692631876593; Mon, 21
 Aug 2023 08:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1G1uDUhOS0yJdaSKAz-8BkxS++gd29=K7Jr27zZU1wbPQ@mail.gmail.com> <CAOQ4uxgAvkrEo=ZOiaY=+HGzVMsk4UCA+D5RfYdEj2Ubffh27Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxgAvkrEo=ZOiaY=+HGzVMsk4UCA+D5RfYdEj2Ubffh27Q@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 21 Aug 2023 17:31:05 +0200
Message-ID: <CAL7ro1HskLvD6z5m_yyj6bJvzUdFk=D3jSkfeaKjgBtxCFP+Sw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 21, 2023 at 3:26=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Mon, Aug 21, 2023 at 3:55=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
> > >
> > > On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat.com> wr=
ote:
> > > >
> > > > This is needed to properly stack overlay filesystems, I.E, being ab=
le
> > > > to create a whiteout file on an overlay mount and then use that as
> > > > part of the lowerdir in another overlay mount.
> > > >
> > > > The way this works is that we create a regular whiteout, but set th=
e
> > > > `overlay.nowhiteout` xattr on it. Whenever we check if a file is a
> > > > whiteout we check this xattr and don't treat it as a whiteout if it=
 is
> > > > set. The xattr itself is then stripped and when viewed as part of t=
he
> > > > overlayfs mount it looks like a regular whiteout.
> > > >
> > >
> > > I understand the motivation, but don't have good feelings about the
> > > implementation.  Like the xattr escaping this should also have the
> > > property that when fed to an old kernel version, it shouldn't
> > > interpret this object as a whiteout.  Whether it remains hidden like
> > > the escaped xattrs or if it shows up as something else is
> > > uninteresting.
> > >
> > > It could just be a zero sized regular file with "overlay.whiteout".
> > >
> > > But we are also getting to the stage where the number of getxattr
> > > queries on lookup could be a performance problem.  Or maybe not.  It
> > > would be good to look at this aspect as well when adding xattr querie=
s
> > > to lookup.
> >
> > Wanting to avoid (as much as possible) the reading of more xattrs
> > which would affect performance of every regular file was the reason
> > for this particular implementation. I will do some more thinking and
> > see if I can come up with an alternative approach.
>
> I'd just like to add that, although the cost of getxattr is mostly fs
> dependent, from my experience, the cost of several getxattr on one
> file are usually amortized in the cost of the first getxattr on that file=
.
>
> So while it is valuable to avoid any getxattr if possible, avoid an
> extra getxattr is often less critical.
> Again, this statement may not be accurate for all fs.

I dunno. Each time I look at the xattr codepaths they seem very long,
and there is no vfs-side caching. Each getxattr() will invoke the
entire stack of reading and (re)parsing the metadata blocks needed for
xattr info. However, cpus are fast, and typically the blocks
themselves are cached in the buffer cache, so maybe this doesn't
necessarily matter.

To check this I ran some quick performance tests. A single, cached
(i.e. repeated), missed (e.g. ENODATA) getxattr call on xfs and ext4
takes about 1-1.5 microseconds. This is about the same timescale as a
stat call, so pretty fast I guess (and probably even faster when the
kernel does it, as there is no syscall overhead). However, on e.g. a
fuse mount (I used the passthrough_ll example) it takes about 20 usec
because each call must be roundtripped via the fuse daemon. Similarly
I can imagine a network filesystem may be slow here, although I see
that NFS4 has an xattr cache.

So, I guess the end result is that it's probably ok to use an extra
getxattr here, and that fuse should probably grow an xattr cache.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

