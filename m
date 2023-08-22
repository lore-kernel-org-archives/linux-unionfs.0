Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654FCEE4993
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 14:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjHVOhD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 10:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbjHVOhD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 10:37:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7446CD1
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 07:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692714979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B2CByX6uvSNFzbLfZeBnPrEiKMOTWQ/61IopbaeN6DY=;
        b=aWtrzgVxrEi+cIE9ty0iDvxpzPzqsFjvBjeo7pXsYoGPeYIKRy61zDJVKmSlyzO45iiTP+
        K/dtlT2Kbu0MEnrTQEJre3pOqirZbk1dncZuYBtCMkZ1uj4oZfhd4IGFmk6yMw/vHq6+/s
        kHvUjN6l11uDzswz+xSJYHQLT+4cpfI=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-pnxKt0nJN1qrhJYyXCaGaA-1; Tue, 22 Aug 2023 10:36:18 -0400
X-MC-Unique: pnxKt0nJN1qrhJYyXCaGaA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-34bb2fba921so41883435ab.3
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 07:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692714976; x=1693319776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B2CByX6uvSNFzbLfZeBnPrEiKMOTWQ/61IopbaeN6DY=;
        b=VlYKUObwsG2ROqBe7MDjUHG5uwTFsgYPMjErsGCe8O9BGj6+9OS6K6nOymuNQgmKe2
         YiEUFFHbc42x5LaJCYh3qYghrd2AQaC/BLoOUzV6cF2kl1tUhA9Aa1dbRMYBoH4YpHkE
         cvA+IMB3yPNsaNV94G7K9jWG1hwO2bZrxdjS5aBcEBgIO3LnmKW9xrboOYsuHocmrnpo
         r+rOm8TWTCGVc0LeOthChsxXs0YrV5HYNdM3+3qE4JMP1BUawzMret6mr0trjolUWoeT
         m6FWvHx5rp16mDA27b+SVilVPGSZpaTusqTVP0sBzIxTtl/rObqwCBRtIBuZISVxtBeW
         E4fg==
X-Gm-Message-State: AOJu0Yy1+BzzvJtuQpt9Zd5+hgJ0af/4SRfDpmxrKmI/5ZlVwEXfkaNY
        vGAE8ARtP1P482+g5WIHX3h8x+Q/lyLEea92tIA8iLI9Lk3Ny4cunDp5sIXNUp5YWdmAoo8PSfp
        UIfptKvsiINuqgtz3ClXDgotZ38+awMts0BGeWbkPKTJyEYN3uQ==
X-Received: by 2002:a92:c752:0:b0:34b:ba9f:679c with SMTP id y18-20020a92c752000000b0034bba9f679cmr10565001ilp.16.1692714976559;
        Tue, 22 Aug 2023 07:36:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcFu/fOlgMdYlltDEd8/4ZdfuIhl/6wj3Ss17q7IybctiieO99uc1LjYrMb4O023RZ8omem9PsFA522QcvROU=
X-Received: by 2002:a92:c752:0:b0:34b:ba9f:679c with SMTP id
 y18-20020a92c752000000b0034bba9f679cmr10564988ilp.16.1692714976345; Tue, 22
 Aug 2023 07:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com> <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
In-Reply-To: <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 22 Aug 2023 16:36:05 +0200
Message-ID: <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 22, 2023 at 4:25=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Tue, Aug 22, 2023 at 3:56=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Tue, 22 Aug 2023 at 15:22, Alexander Larsson <alexl@redhat.com> wrot=
e:
> > >
> > > On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklos@szered=
i.hu> wrote:
> > > >
> > > > On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat.com> =
wrote:
> > > > >
> > > > > This is needed to properly stack overlay filesystems, I.E, being =
able
> > > > > to create a whiteout file on an overlay mount and then use that a=
s
> > > > > part of the lowerdir in another overlay mount.
> > > > >
> > > > > The way this works is that we create a regular whiteout, but set =
the
> > > > > `overlay.nowhiteout` xattr on it. Whenever we check if a file is =
a
> > > > > whiteout we check this xattr and don't treat it as a whiteout if =
it is
> > > > > set. The xattr itself is then stripped and when viewed as part of=
 the
> > > > > overlayfs mount it looks like a regular whiteout.
> > > > >
> > > >
> > > > I understand the motivation, but don't have good feelings about the
> > > > implementation.  Like the xattr escaping this should also have the
> > > > property that when fed to an old kernel version, it shouldn't
> > > > interpret this object as a whiteout.  Whether it remains hidden lik=
e
> > > > the escaped xattrs or if it shows up as something else is
> > > > uninteresting.
> > > >
> > > > It could just be a zero sized regular file with "overlay.whiteout".
> > >
> > > So, I started doing this, where a whiteout is just a regular file wit=
h
> > > the xattr set. Initially I thought I only needed to check the xattr
> > > during lookup and convert the inode mode from S_IFREG to S_IFCHR.
> > > However, I also need to hook up readdir and convert DT_REG to DT_CHR,
> > > otherwise readdir will report the wrong d_type. To make it worse,
> > > overlayfs itself looks for DT_CHR to handle whiteouts when listing
> > > files, so nesting is not working without that.
> > >
> > > The only way I see to implement that conversion is to call getxattr()
> > > on every DT_REG file during readdir(), and while a single getxattr()
> > > on lookup is fine, I don't think that is.
> > >
> > > Any other ideas?
> >
> > Not messing with d_type seems a good idea.   How about a random
> > unreserved chardev?
>
> Only the whiteout one (0,0) can be created by non-root users.

I was thinking of (ab)using DT_SOCK or DT_FIFO, but turns out you
can't store xattrs on such files.
--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

