Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAF6C7EE29
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jun 2023 13:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjFINm4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 09:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjFINmz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2023 09:42:55 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9345C30E4
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jun 2023 06:42:54 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id ada2fe7eead31-43ddbfd7479so292449137.2
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2023 06:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686318173; x=1688910173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDudJ/03qv99Vpwwz0G5EtwyY57Wf9FrBjccqRQhZDI=;
        b=pnIbplxS+GGA20BHKIGfZyjGNHAg6gCQS6a1j0ZQEI1OYfbnUtL4IccWbmeYGfR2eg
         Xm5MXJdE70ThP2GNb5vX/TM0I49AVmIVwXZREw1DvLYfrWLU/CxH5++F7foMpc5zzl8v
         56Afn5MOzw/ibOddXflwkCqoVKPR+EcQtl3q9GBYX+XjH74i2MjMEo6Y5KYMSTx0tq1c
         R8q8KeQ3ZwxAyIpCosehn7bD1TK/7AyzaAmM0XSU+iaJh87eT4NaBnVEuzGM0TLblLxT
         uwQOxQNFuz4eKY55nHnxUn9i+VBnHcRRMI+P3C3SdJyXGJ6CY8C4nSQ+EvuuJzuFR8IW
         R2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686318173; x=1688910173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDudJ/03qv99Vpwwz0G5EtwyY57Wf9FrBjccqRQhZDI=;
        b=K6pc6MmrwWZjPDJXjXNJfT+r6LS2bPreOFRqcGXlKxD6L9a2uaGpJSemGRfdHXLTcq
         C3bikxBRNbR+xU1AjfYsXBjmkhLKUJ4oF156u2yFlCoAT5Z33M7L6UfN4OMOYKcPJ4Gx
         Fqj7lFkaumghCa4A2GC6tfMPTSf+W2chgbFk5Mmx4iFjDsKebzNVfmaSI4LLFdD6oNiK
         vDKieclt6O7vYTY9iUlHUVpv3eeeVUL+5xR2UOwOcStPy+KgzzIuRmKtZjuneFRggIsJ
         ydckjFHTG3Y6Fuh2rJ8BhsauY0I0zTjkwqwoQ4jT4/KLMiCi7nGEtupu5NJhvbMKuvxp
         PEKw==
X-Gm-Message-State: AC+VfDzL5YA8su/MaRbXnj6mBThFY0f21tgQtINnP52kA2OMWUn1bYH0
        r8ymRF5gUILf75pLaVXuY5IC5frsC34KuCRjMCo=
X-Google-Smtp-Source: ACHHUZ5lTpuIQ8EddaRlbxOhtjSq2wUzJ+wQZ+pC+frnLV2dYTpsER6kqi1sWI2M0+L0z51yyrl8GkqZnM8SD15KKAM=
X-Received: by 2002:a05:6102:102:b0:436:2c6f:205f with SMTP id
 z2-20020a056102010200b004362c6f205fmr419676vsq.5.1686318173567; Fri, 09 Jun
 2023 06:42:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com> <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
 <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
 <CAOQ4uxh14O9aRiewc+nq+AL-029YGu4bb4AZpp854r78Jm=_dw@mail.gmail.com> <CAJfpegvnBrLtNcW0Oy8Y7seju96scQ0-FHoiXxx3+A3X4N_LMQ@mail.gmail.com>
In-Reply-To: <CAJfpegvnBrLtNcW0Oy8Y7seju96scQ0-FHoiXxx3+A3X4N_LMQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 9 Jun 2023 16:42:42 +0300
Message-ID: <CAOQ4uxjPe5DBBFN5XfUPoYE1rKdbzTLsP9yOa2V9Ej4K8U4oEA@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 9, 2023 at 10:24=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Tue, 30 May 2023 at 16:15, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, May 30, 2023 at 5:08=E2=80=AFPM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
> > >
> > > On Sat, 27 May 2023 at 16:04, Amir Goldstein <amir73il@gmail.com> wro=
te:
> > >
> > > > If we would want to support data-only layers in the middle on the
> > > > stack, which would this syntax make sense?
> > > > lowerdir=3Dlower1::data1:lower2::data2
> > > >
> > > > If this syntax makes sense to everyone, then we can change the synt=
ax
> > > > of data-only in the tail from lower1::data1:data2 to lower1::data1:=
:data2
> > > > and enforce that after the first ::, only :: are allowed.
> > > >
> > > > Miklos, any thoughts?
> > > > I have a feeling that this was your natural interpretation when you=
 first
> > > > saw the :: syntax.
> > >
> > > Yes, I think it's more natural to have a prefix for each data-only
> > > layer.  And this is also good for extensibility, as discussed.
> > >
> >
> > Good timing ;-)
> >
> > I was just about to say that I changed the syntax and pushed to:
> >
> > https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata-v3
> > https://github.com/amir73il/xfstests/commits/ovl-lazy-lowerdata
> >
> > The gist of the documentation of v3 is:
> >
> > Below the top most lower layer, any number of lower most layers may be =
defined
> > as "data-only" lower layers, using double colon ("::") separators.
> > A normal lower layer is not allowed to be below a data-only layer, so s=
ingle
> > colon separators are not allowed to the right of double colon ("::") se=
parators.
> >
> > For example:
> >
> >   mount -t overlay overlay -olowerdir=3D/l1:/l2:/l3::/do1::/do2 /merged
> >
> >
> > Do you need me to post the v3 patches?
> >
> > The changes since ovl-lazy-lowerdata-v2 branch are:
> > - Reabse on 6.4-rc2 + NULL deref fixes
> > - Syntax change
>
> Patches look good to me.
>
> Pushed v3 to overlayfs-next.
>

Miklos,

I see you pushed the branch as is.

Please be warned that it contains the following unexplained
merge commit:

commit b892fac09d57668181ff5c433958e96ec7755453
Merge: f1fcbaa18b28 7cdafe6cc4a6
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Thu May 25 15:14:13 2023 +0300

    Merge remote-tracking branch 'jack/fsnotify' into next

And you know how Linus hates unexplained merge commits.

In this case, it is unexplained and also does not have a
good reason in the context of an ovl pull request.

Thanks,
Amir.
