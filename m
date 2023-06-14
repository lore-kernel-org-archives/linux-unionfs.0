Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B9E1EB64D8
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jun 2023 05:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241554AbjFNFjV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 01:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbjFNFjU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2023 01:39:20 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928E41984
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 22:39:19 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id ada2fe7eead31-43f50c79be8so27586137.0
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 22:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686721158; x=1689313158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JOto0oV1KbYIXydS1unCesgaw4Xm/o4kcrhMQN7gU0=;
        b=FH9C+T6Bxk5czO7c6yApIJmidspEcPdBq2vduJ8rT+Z2Cb8S+ysQf7kPmhTBZCn7G8
         Sp35Kd69u6QIEzk/Vt3+PtJubNfPwijGELlYLW0Vnf2KpllPcq1PvkiLX1tLynpIscIH
         c+jHoYVmlTqNebRQZvLcMCwiDoK70Cx0CH6G4AryEHPZ4c8LJOp76AMOjJRL/cpY+cCS
         KrS+/l0pyMM5LjQTPevAoPBA3SY9Tg1cGfrXdPTa9OXKC1A7NZeoDq5Qv1A/E1BLAWk5
         TL5Ctg8vOwhwj1lNfbBbMeG8MIB8zfU37RjSuh6aXojxlFxN3WsC94V4JZyz9EbuEO8z
         FZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686721158; x=1689313158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0JOto0oV1KbYIXydS1unCesgaw4Xm/o4kcrhMQN7gU0=;
        b=hlyOCGhQm1NJGsZwY9AAl+260FmDKUP0FOo7liSVHN/jZWSBLWcX6p2gJ1fAyt2j1l
         kFNm/6b8TlKl1YvW+h7b5gr1ktAKZZGqDSxH+k6EGSUvhu1ZCRXZA/VRog45ZuLgLuCz
         /UKFteS9dm7YYY4aKuUv4zRUMOzPO80UntSccnOn+PB7xdZ2GVv6NLVoZA4ekSM+e4n0
         n0Igvfh7CP2D+5sb3WSWlpx8Z5AzSm57c4wJ+wO+ncsUYXMmF68ti5mXWyH0GfskZjnx
         qyxcip8PjpXtVB7/hD9ZBbeI12yXf9kbxfEWp8nqRmczmTxr6gHPJBnUSoBppx7Ag8j/
         jrVg==
X-Gm-Message-State: AC+VfDzopfK48wUKPKHXsw6XrFSoq7a4x+pVqUzkaQOGpIKsFV1jd8Iy
        23RZbXZLJtbXs6oGwM4KtQtBXeR6faVULOHRknY=
X-Google-Smtp-Source: ACHHUZ6hzlkxJm8Et0uYbPgVEPBVMhFmphOWG9zzSZGc3yT/qQ7Jbwz2JdG9qP1msNbAt+Vlz+AWMr967nzli0af6VU=
X-Received: by 2002:a67:f705:0:b0:439:31ec:8602 with SMTP id
 m5-20020a67f705000000b0043931ec8602mr5131231vso.27.1686721158556; Tue, 13 Jun
 2023 22:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <dd294a44e8f401e6b5140029d8355f88748cd8fd.1686565330.git.alexl@redhat.com>
 <20230612190944.GB847@sol.localdomain> <CAL7ro1Feep_aQimxEJzKk+4cv6-UNgco3VNDKZrrC3y2u04DCw@mail.gmail.com>
 <20230613175759.GA1139@sol.localdomain> <20230614032813.GA1146@sol.localdomain>
In-Reply-To: <20230614032813.GA1146@sol.localdomain>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 14 Jun 2023 08:39:07 +0300
Message-ID: <CAOQ4uxh2jS=MsM-xs_fgFkBzN40ypADizw9tvsdizrXuVOXtVQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: Validate verity xattr when resolving lowerdata
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Larsson <alexl@redhat.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev, Mimi Zohar <zohar@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 14, 2023 at 6:28=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 13, 2023 at 10:57:59AM -0700, Eric Biggers wrote:
> > On Tue, Jun 13, 2023 at 01:41:34PM +0200, Alexander Larsson wrote:
> > > > Can you consider
> > > > https://lore.kernel.org/r/20230612190047.59755-1-ebiggers@kernel.or=
g which would
> > > > make fsverity_get_digest() support both types of IDs?  Then you can=
 use
> > > > FS_VERITY_HASH_ALG_*, which I think would make things slightly easi=
er for you.
> > >
> > > Sounds very good to me. I'll rebase the patchset on top of it. Not
> > > sure how to best land this though, are you ok with this landing via
> > > overlayfs-next?
> >
> > If you're confident that this series will land in v6.4, then sure, you =
can apply
> > my patch "fsverity: rework fsverity_get_digest() again" to overlayfs-ne=
xt,
> > instead of me taking it through fsverity/for-next.  (Hopefully the IMA
> > maintainer will ack it as well, as it touches security/integrity/.)

Mimi,

Can you please take a look:

https://lore.kernel.org/linux-integrity/20230612190047.59755-1-ebiggers@ker=
nel.org/

> >
> > Just be careful about being overly-optimistic about features landing in=
 the next
> > release.  I've had experience with cases like this before, where I didn=
't apply
> > something for a reason like this, but then the series didn't make it in=
 right
> > away so it was worse than me just taking the patch in the first place.
> >
> > I do see that the other prerequisites were just applied to overlayfs-ne=
xt, so
> > maybe this is good to go now.  It's up to the other overlayfs folks.
>
> I meant to say 6.5, not 6.4.
>
> Anyway, just let me know if I should apply it or not, before it gets too =
late.

If you want to make sure that your patch lands in 6.5, you'd better take
it through your tree.

If you provide a stable branch with the patch, Miklos will be able to merge
your branch if he wishes to take Alex's patches for 6.5.

Thanks,
Amir.
