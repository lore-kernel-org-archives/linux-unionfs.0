Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177C4C61DA4
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Mar 2023 15:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjCIPq1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Mar 2023 10:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjCIPq0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Mar 2023 10:46:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6668E4844
        for <linux-unionfs@vger.kernel.org>; Thu,  9 Mar 2023 07:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678376744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=37/w03iyTP4+W8iPKFzYFgUbiQ52iRaqgtdVrDhT9xs=;
        b=PSwkJ2jfh/Q1wzU1FQELNbWABHXie3ElG6EUf/+Yq6PmHZZV4MfcKCONQ6HisW7P8+gOzM
        JZR6vkNX+apuXHF0kH35aLQGUsfeo6s3GQIJzTe0F1MTq9L80+WQ6uIymrkEcjsPjnuZMB
        pmyuOkN4Ye6aOxlfy+P5r5oBywKnPwU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-ptClpdiNP9qWm_UFQuGa9g-1; Thu, 09 Mar 2023 10:45:44 -0500
X-MC-Unique: ptClpdiNP9qWm_UFQuGa9g-1
Received: by mail-io1-f71.google.com with SMTP id g21-20020a6be615000000b0074cb292f57dso1016098ioh.17
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Mar 2023 07:45:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678376743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=37/w03iyTP4+W8iPKFzYFgUbiQ52iRaqgtdVrDhT9xs=;
        b=qbrO7eAusCxOxeRWgVUjywuh1axauTpEY8yccZGJ23vm6VpvbROdIlIRoaOCXQXD/z
         U9ouNGIyBaro5cmeSi/q7KGxEMbAsKIcMIRmmIJDaIkkGf34TEmYBfs5uDLSJyfLgQvU
         b/GYtULuCbxokM352RSlCLAoXsq1z/DYiuwIy0L0gSIS5q0LLIuygeRTkMtQv5arfe7F
         HRifjJEsqvAlsQZC/hv72qFp9nkaJJWIdshHegP7P2sJlh/Lwz81DfXUZWColPWw/8a8
         el6CG7qQ0e5VbxrHQDuPPBHrALuugj16aSLtMIwPn/sSf8IXxOmQ/YKJFKkQpTzfS3qb
         TtJg==
X-Gm-Message-State: AO0yUKUbeSfQ4uk/U/y/DwKAsx0+1XrqBCO3k6BT0UGguPAdedorcdD0
        ojDbMQQSvKKEYftVGtWcNAt/rAgDUIoIZa5yak0CKYspwqkkJD1NdnlhLv4jVIPQFBCRXJZPH9x
        i+5R1ey48fgCJ4je8bZwLgRm6dzp1Rfthg+CTa1vquN+91dCSTQ==
X-Received: by 2002:a02:aa1c:0:b0:3b4:42bd:bec with SMTP id r28-20020a02aa1c000000b003b442bd0becmr11003176jam.4.1678376743051;
        Thu, 09 Mar 2023 07:45:43 -0800 (PST)
X-Google-Smtp-Source: AK7set8QBRuryYFdirBo6eHZdfY2571MUkP1FwqMyqR1gOwhXmwSuzQmRXV2DIONkq+83p0UnSvSoKwmFcBwJVN7bHM=
X-Received: by 2002:a02:aa1c:0:b0:3b4:42bd:bec with SMTP id
 r28-20020a02aa1c000000b003b442bd0becmr11003168jam.4.1678376742785; Thu, 09
 Mar 2023 07:45:42 -0800 (PST)
MIME-Version: 1.0
References: <CAL7ro1GQcs28kT+_2M5JQZoUN6KHYmA85ouiwjj6JU+1=C-q4g@mail.gmail.com>
 <CAJfpeguTqXKuBcR3ZBbpWTPTbhnLja0QkBz3ASa4mgaw+A4-rQ@mail.gmail.com>
In-Reply-To: <CAJfpeguTqXKuBcR3ZBbpWTPTbhnLja0QkBz3ASa4mgaw+A4-rQ@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 9 Mar 2023 16:45:31 +0100
Message-ID: <CAL7ro1FZKNa1vMJ0CLsGr0Wcg=TSm_2Ehso=adQEVnn3G5i=xQ@mail.gmail.com>
Subject: Re: WIP: verity support for overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Mar 9, 2023 at 3:59=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> w=
rote:
>
> On Wed, 8 Mar 2023 at 16:29, Alexander Larsson <alexl@redhat.com> wrote:
> >
> > As was recently discussed in the various threads about composefs we
> > want the ability to specify a fs-verity digest for metacopy files,
> > such that the lower file used for the data is guaranteed to have the
> > specified digest.
> >
> > I wrote an initial version of this here:
> >
> >   https://github.com/alexlarsson/linux/tree/overlay-verity
> >
> > I would like some feedback on this approach. Does it make sense?
> >
> > For context, here is the main commit text:
> >
> > This adds support for a new overlay xattr "overlay.verity", which
> > contains a fs-verity digest. This is used for metacopy files, and
> > whenever the lowerdata file is accessed overlayfs can verify that
> > the data file fs-verity digest matches the expected one.
> >
> > By default this is ignored, but if the mount option "verity_policy" is
> > set to "validate" or "require", then all accesses validate any
> > specified digest. If you use "require" it additionally fails to access
> > metacopy file if the verity xattr is missing.
> >
> > The digest is validated during ovl_open() as well as when the lower fil=
e
> > is copied up. Additionally the overlay.verity xattr is copied to the
> > upper file during a metacopy operation, in order to later do the valida=
tion
> > of the digest when the copy-up happens.
>
> Hmm, so what exactly happens if the file is copied up and then
> modified?  The verification will fail, no?

When we do a meta-copy-up we need to look at the data file and
synthesize an overlay.verity xattr in the upper dir based on the
existing fs-verity diges. At least if the file has fs-verity enabled.
And indeed, in the verify_policy=3Drequired case, if there is no
fs-verity in the lower file we should fall back to a full copy-up
instead of a metacopy-up, or we will end up with a metacopy we can't
validate.

However, if you actually modify a file I don't really see the problem,
you will get a non-verified upper layer file with the changes. It will
not fail validation because it is at that point not validated. Really
we can only expect to validate the lower layers.


--
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

