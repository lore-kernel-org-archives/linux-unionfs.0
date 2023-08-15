Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787D5C001B0
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Aug 2023 14:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237511AbjHOOKx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Aug 2023 10:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbjHOOKm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2023 10:10:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E27A1B2
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 07:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692108598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tZWwqINAit/0aODEyKvr4Bhydzcr8w+lzz/GmQea0fI=;
        b=Q9D12S7woDtxm10BwOCfYblM8YAet9vQq0pnl4JWFEsTvB2mYWMaBFmx74oswYxOOhyS/S
        iF01yGeoqU9v7DL+G/p6cGrHa/InboPK6nVWgWiQ1US2uud3a/9c1AcGt54eo5YrXJpJ62
        PdG7E4/M71av+WwQS0TM0QagGLrOQLQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-rq7O4VtvN664gT5mfuAEqg-1; Tue, 15 Aug 2023 10:09:56 -0400
X-MC-Unique: rq7O4VtvN664gT5mfuAEqg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3499993f380so36997115ab.3
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 07:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692108595; x=1692713395;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tZWwqINAit/0aODEyKvr4Bhydzcr8w+lzz/GmQea0fI=;
        b=DDWoENzFl8qIPjIfiLKS5cTKPaEuWh5B9XagVEQe089rJW5tWmayNVmcWgGMeCGeEz
         rJQfUrWIvsKCxjcB48N1KvJigXf2mmcMiWBLjkhjtJvU/wQfJP33DNbJqygkkZEGMyvm
         e8IppWBwtgF8Z6Z/q3etpFC2kENQg+tWq0qn0CsLn9E82L1JMHaKho5v9YfqCZj42rp0
         DeJ6So758LnUmQ9X07C431kebGg3S9W1wBH6kTRCMXPq/fTHbxZgjUFd7ltxt+HiuTmq
         yaHbPagUsyw/AxE6RFMaepPkd8oF3Qmt/xGjx8ADTsKDsE7xUQ7VuOGyA1UwAydDLvf1
         /46g==
X-Gm-Message-State: AOJu0Yw/9Es3Z9U6XQyglhXBxcxdumSDRlKrZxWUdauI4hnIQfOwYf7Z
        hWUAcpMQF2byJNHa01jqn5wMC/OQkklI1++n+AQQPGQ/t2zG6UvC2jw+cHWszvEtxkt8lRSQs7u
        d42TMybt0WHEjLnAnuFZI6xeWS974LqJwb1vH2RwpkA==
X-Received: by 2002:a05:6e02:12b1:b0:348:d0e5:dbc8 with SMTP id f17-20020a056e0212b100b00348d0e5dbc8mr12567566ilr.31.1692108595501;
        Tue, 15 Aug 2023 07:09:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXyGzcQlNBOczLw4V5o73m9oJ3bSIfr7Wm2j3uF0zXBXH7Tm/wwZTzGPxWqVTPRg+3eSMHpDUcMiPt9xrn6/g=
X-Received: by 2002:a05:6e02:12b1:b0:348:d0e5:dbc8 with SMTP id
 f17-20020a056e0212b100b00348d0e5dbc8mr12567557ilr.31.1692108595281; Tue, 15
 Aug 2023 07:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAL7ro1EArefty01rFo4-D98YcSZ3F6qCRboM=qwU84jWjrJJ4w@mail.gmail.com>
 <CAOQ4uxg6V7J=ZZxQjPPivLtRNVqnNiJ=PAPfYtsS=zN5C29oRA@mail.gmail.com>
In-Reply-To: <CAOQ4uxg6V7J=ZZxQjPPivLtRNVqnNiJ=PAPfYtsS=zN5C29oRA@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 15 Aug 2023 16:09:44 +0200
Message-ID: <CAL7ro1HDZz0vyQV4nn7Jvf5FteEMnaWvMYeGXbF-gZSS6BG9RQ@mail.gmail.com>
Subject: Re: Nesting overlay instances (whiteouts/xattrs)
To:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Bringing this design discussion to the list.

On Tue, Aug 15, 2023 at 3:53=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Tue, Aug 15, 2023 at 3:33=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > Hi, as discussed in https://github.com/containers/composefs/issues/172
> > we have some issues with a composefs rootfs that contains lower dirs.
> > The "inner" overlayfs will consume the overlay xattrs and the
> > whiteouts that were targeting the outer instance.
> >
> > I came up with this patchset to fix this:
> > https://github.com/alexlarsson/linux/tree/ovl-nesting
> >
> > There are two parts, first of all, any xattrs called
> > overlay.escape.XYZ in the lower/upper will be not be treated specially
> > by overlayfs itself, but exposed as overlay.XYZ in the overlayfs
> > mount. This can be nested by using overlay.escape.escape.XYZ, although
> > the stacking limit makes this stop at two levels.
>
> This part looks fine to me.
> I'd consider overlay.overlay.XYZ for the nested overlay xattr prefix,
> but that is just my own taste of playful aesthetics ;-)

Heh.

> > Secondly, and whiteouts in lower/upper that have a overlay.nowhiteout
> > xattrs will not be treated as a whiteout by the overlayfs mount.
> > However, since this xattr is stripped as part of the overlayfs mount,
> > the outer instance will apply it. This can be combined with escaping
> > to create a whiteout in a stacked overlayfs instance.
> >
>
> It looks sane.
>
> I am a bit concerned about introducing extra overhead for the
> common case, but maybe whiteouts are rare enough or the overhead
> low enough that it shouldn't matter?

Yeah, I was somewhat worried about this too, and this is the reason
the code is structured so that it only ever reads this new xattr for
whiteout files. The hope is indeed that they are uncommon enough in
practice to not make this a large issue.

One thing I noticed is that whiteouts are used in a bunch of places
for the handling of index files. I'm not completely up to speed on
these, but it looks like they are always in the work dir, am I right?
So, we could potentially avoid the check for a nowhiteout xattr for
these for a slight performance improvement. Correct?

> > Does this make sense to you?
>
> Yes, but it needs documentation.

I'll add some.

> > Do we need options for enabling these features?
>
> Don't think so.
> I see no risk of regressions (i.e. that the escaped xattrs currently
> exist in the wild).
>
> It is easy for userspace to test if kernel supports xattr escaping
> even if there are no escaped xattrs, getxattr(trusted.overlay.escaped.bla=
h)
> would return either ENOTSUPP or ENODATA (if escaping is supported).

Yeah, that makes sense.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

