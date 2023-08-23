Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9A4EE4993
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Aug 2023 15:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjHWPDG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 11:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbjHWPDF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Aug 2023 11:03:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AE8FB
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 08:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692802934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iInQJFuRPkyPa++LK14kV1E/T1CGD8AvyYuXUXM3SxU=;
        b=EbLHvR2S9S8AIvIPjYCcqdgRDo0Q0hhLst/5XnkQI3TqAVGnUfnO4YDgnGe2xNeelXPmse
        L66teTN1GoCeSa53O/iSu2Zbnj8B+KqD2N6KqTy2l57h1gPHP1CWIGuh7vu4wT2aeLLWeI
        S1dIuKN+rDNLGuVjmE/4rVYhFwFYA54=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-QxgFyiIXNc6yDsKxQ0RFXw-1; Wed, 23 Aug 2023 11:02:12 -0400
X-MC-Unique: QxgFyiIXNc6yDsKxQ0RFXw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-34cb37f2780so17715015ab.3
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 08:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692802932; x=1693407732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iInQJFuRPkyPa++LK14kV1E/T1CGD8AvyYuXUXM3SxU=;
        b=MIE1dSXwBpBzf2rId3pgmoIWL/lKGFSKej+TmbKO9NIrkaX+mTjs2Gda/EaYUh6/pZ
         D2A7qoLTrn/8HKuBkaClkuR1m22FNaFhjismUs3Kh1ReyCYiwtF5BSh97rLOnrNUaPww
         8cLxrucrP01zNf80T3390JwdGOKNlvKp0eA3coX8vGPIC1EA+KZIENj+ExDfr0seWJol
         dW5uh7yt/rxMqLXKc54d0JM2SFapkfjEVNr9Vk5NnWP+8TJREAaP4NqmQY0kULGnF5Ym
         j+na/ahEsptMuU5IvzNDCf/27gw5yFI7gMSFShvCjk8w5R/bVNtQeX75PMxBYD+H8wIa
         3ZQg==
X-Gm-Message-State: AOJu0YwYe81isOrPrqKNf2vfwU+lAR1dSmKh60mzMKHOiaOd8NdKYy1y
        VhSZ+nZHcrYF86BzQ0K0+bNeZPr9lknw8oZpzcYrYPmpZJkwK4lLvXfaEGxAF5Wzl20CSnXUPmu
        8pf1Y+1rQJ9raM6iAqb45QgZ9YnDo4o3Py42hM8qxnQ==
X-Received: by 2002:a05:6e02:1c89:b0:340:79ff:c1b6 with SMTP id w9-20020a056e021c8900b0034079ffc1b6mr3776670ill.4.1692802931835;
        Wed, 23 Aug 2023 08:02:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGhAN2N/klD9NjK1B/TefydSTsrS0WCGtWTQ41HWD+D7dWEmF7iEOCcZV0DlYgvqast9Ltx8r3QTBrKFwq8VeQ=
X-Received: by 2002:a05:6e02:1c89:b0:340:79ff:c1b6 with SMTP id
 w9-20020a056e021c8900b0034079ffc1b6mr3776650ill.4.1692802931601; Wed, 23 Aug
 2023 08:02:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
 <CAL7ro1GS9ieN=ZuDLE9mreiiYH4KUK6xWxp40hS-7ZTzf+r6Gg@mail.gmail.com>
 <CAOQ4uxhYH1SH5TbYfARDkep5p+xspUX2gq1HgMyLnv7J4=1emg@mail.gmail.com> <CAJfpegsv3fHwutkEq7S8PV9fYWC07BRUE8GMEpsnK1XkE2hb5w@mail.gmail.com>
In-Reply-To: <CAJfpegsv3fHwutkEq7S8PV9fYWC07BRUE8GMEpsnK1XkE2hb5w@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 23 Aug 2023 17:02:00 +0200
Message-ID: <CAL7ro1E8aa1Qsqbo61=KSEkX0qsz0g+=3gpzqgr90rvt47mBDg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 23, 2023 at 4:52=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Wed, 23 Aug 2023 at 16:43, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > If we do this, then both overlay.whiteout and overlay.xattr_whiteouts
> > xattrs will be xattrs that the overlayfs driver never sets.
> > It's a precedent, but as long as it is properly documented and encoded
> > in fstests, I will be fine with it. Not sure about Miklos.
>
> Firstly I need to properly understand the proposal.  At this point I'm
> not sure what overlay.whiteout is supposed to mean.   Does it mean the
> same as a whiteout (chrdev(0,0))?  Or does it mean that overlayfs
> should not treat it as a whiteout, but instead transform that into a
> chrdev(0,0) for the top overlay to interpret as a whiteout?  Or
> something else?

Both of these have been discussed, and I tried both in my two
alternative proposals in the other mail I just sent. Also, both
approaches could use the taint-the-directory xattr approach amir
proposed here.

I think the overlay.whiteout transforms to chrdev(0,0) approach is
better, because that will allow the resulting unescaped whiteout to be
used by both regular and userxattr overlay mounts.

I'll have a go at combining the transform approach with a directory
xattr, because that could use regular files that get transformed to
whiteouts, which means it could also work with user.overlay.whiteout
xattrs.


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

