Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660BCC64EC4
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Mar 2023 15:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjCIP6e (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Mar 2023 10:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjCIP6c (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Mar 2023 10:58:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09161F7EC4
        for <linux-unionfs@vger.kernel.org>; Thu,  9 Mar 2023 07:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678377463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/YMudSIAMWQkSvHaQfj0qGZSmFme8VRUADcoJ23XIE=;
        b=FYFw8kusokn3lcCDXFai/SPnrr3kSc59KwOy/c/8SsUY5ogUqTIq/c1eCC32FpVtuG8x3D
        wwFzzDKKvHRG9g1ULiMt/kkcBl1tV9pGs7/iCB3nGx1Yyw/Cn4JgY+Nx0MohzB1ZpBPcRV
        uzxm+3hGwl86wMoN0QjdSOhOMfhSBbg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-x3tEXPuEPsm__7ZHVbAwuA-1; Thu, 09 Mar 2023 10:57:42 -0500
X-MC-Unique: x3tEXPuEPsm__7ZHVbAwuA-1
Received: by mail-il1-f199.google.com with SMTP id k13-20020a056e021a8d00b0031bae68b383so1091674ilv.18
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Mar 2023 07:57:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678377462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x/YMudSIAMWQkSvHaQfj0qGZSmFme8VRUADcoJ23XIE=;
        b=QTgfctuujiRZX3U25NNFsw/2C/BvHGZLGwCgW/vbl60kAiC38VuFxvB2+nuK2T+4n1
         kzI66gQQ7cOj/CK23Nr9ZQdC7eQkrko9wxNcCCz79Ay+7dxcp+pbt0RL2uuY1UQUuEyJ
         5U5/7FmsOXx5VlwdE74TQVcDt2wqYab++3A/yoiBaW5zGwhnB1qziu2WlEmRXnRLZh3q
         DTXVYaGdQhRaTzyhNs3pEIEiy44yhKtJ99zKGVHNX6fAolvzT8vPYV/yueaVMsl/0RDv
         MNRjaG2RqcbkUGrITvPMWhzOkD43pw85B279qB/kPnDZfKIy3d2qhMj9JzF7vpUWPBnB
         /KQA==
X-Gm-Message-State: AO0yUKXifjwzDE+s7Okhx6nif3c42oQ6FKlF1iXDTlXsTpwUbEEv+SpW
        1pDWDmNkU4GpFF3Oy4UnvWYTBKP9zDb+ioJzpG+fzkD79Fely/N50QLswqnspLAiBla/xATfn8z
        zQ5E2SQEDkHYdk/GPfkopX8D2BvrEhLFDrTC3SSpvxw==
X-Received: by 2002:a6b:d609:0:b0:74e:7a27:d183 with SMTP id w9-20020a6bd609000000b0074e7a27d183mr3473200ioa.2.1678377462110;
        Thu, 09 Mar 2023 07:57:42 -0800 (PST)
X-Google-Smtp-Source: AK7set86fAfUQkKvpUK+xHJFUmAgxxlIToVNKF4WKExdqAu/b7y4cSEYxaCASiTA/FBQfNVCKsocZw69QbrVN1/07Js=
X-Received: by 2002:a6b:d609:0:b0:74e:7a27:d183 with SMTP id
 w9-20020a6bd609000000b0074e7a27d183mr3473195ioa.2.1678377461882; Thu, 09 Mar
 2023 07:57:41 -0800 (PST)
MIME-Version: 1.0
References: <CAL7ro1GQcs28kT+_2M5JQZoUN6KHYmA85ouiwjj6JU+1=C-q4g@mail.gmail.com>
 <CAJfpeguTqXKuBcR3ZBbpWTPTbhnLja0QkBz3ASa4mgaw+A4-rQ@mail.gmail.com> <b1ec4ce2-1be3-4aaa-9d43-86bcd66b88f0@app.fastmail.com>
In-Reply-To: <b1ec4ce2-1be3-4aaa-9d43-86bcd66b88f0@app.fastmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 9 Mar 2023 16:57:30 +0100
Message-ID: <CAL7ro1E2eU9yVL+YW6qbi6jz4eG-hrqe9=Wi2AM-CfO-sTYcEA@mail.gmail.com>
Subject: Re: WIP: verity support for overlayfs
To:     Colin Walters <walters@verbum.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Mar 9, 2023 at 4:26=E2=80=AFPM Colin Walters <walters@verbum.org> w=
rote:
>
>
>
> On Thu, Mar 9, 2023, at 9:59 AM, Miklos Szeredi wrote:
> > On Wed, 8 Mar 2023 at 16:29, Alexander Larsson <alexl@redhat.com> wrote=
:
> >>
> >> As was recently discussed in the various threads about composefs we
> >> want the ability to specify a fs-verity digest for metacopy files,
> >> such that the lower file used for the data is guaranteed to have the
> >> specified digest.
> >>
> >> I wrote an initial version of this here:
> >>
> >>   https://github.com/alexlarsson/linux/tree/overlay-verity
> >>
> >> I would like some feedback on this approach. Does it make sense?
> >>
> >> For context, here is the main commit text:
> >>
> >> This adds support for a new overlay xattr "overlay.verity", which
> >> contains a fs-verity digest. This is used for metacopy files, and
> >> whenever the lowerdata file is accessed overlayfs can verify that
> >> the data file fs-verity digest matches the expected one.
> >>
> >> By default this is ignored, but if the mount option "verity_policy" is
> >> set to "validate" or "require", then all accesses validate any
> >> specified digest. If you use "require" it additionally fails to access
> >> metacopy file if the verity xattr is missing.
> >>
> >> The digest is validated during ovl_open() as well as when the lower fi=
le
> >> is copied up. Additionally the overlay.verity xattr is copied to the
> >> upper file during a metacopy operation, in order to later do the valid=
ation
> >> of the digest when the copy-up happens.
> >
> > Hmm, so what exactly happens if the file is copied up and then
> > modified?  The verification will fail, no?
>
> I believe the intention here is to deploy this without a writable upper d=
ir by default, so there's no copy-up, the calling code just gets -EROFS.  T=
he intention is to also use this to push the podman/docker/kube style ecosy=
stem away from "mutable by default" container images i.e. to "readonlyRootF=
ilesystem" by default (xref https://kubernetes.io/docs/tasks/configure-pod-=
container/security-context/ )

That is indeed some of the primary usecases for this. However, that
doesn't mean it is not useful also for other usecases.

> But yes, some scenarios will still want a writable upper dir for default,=
 as long as that writable upper dir is discarded across reboots (to aid in =
anti-persistence).  Maybe this needs to be configurable; I could imagine pe=
ople wanting a writable upper dir, but to still enforce fs-verity for *exis=
ting* content.  Other cases may want the logic to just strip away the fsver=
ity xattr across copy-up in this case.

I've been chatting with amir in github about this, and yes, we can
have options that make this useful also with an upper. I'll try to
post a new version with this tomorrow.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

