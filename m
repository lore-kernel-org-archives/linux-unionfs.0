Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF2DEB64D7
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jun 2023 11:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjFUL17 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 07:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjFUL16 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2023 07:27:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C67E57
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 04:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687346838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xc1C5dGE3E84jHIb6pWdRSRyKplzGTrNuAMSPXu3ZBM=;
        b=YD036z1EE14kEpDm1gQXJqcbTTchbURZJ0bVki/Fs/esCCSzFIJOOIhqhCD2KrcIGulwKY
        B5QP4YaVu6t6VCMeNwaTOuUuV2tt5Xk2nPKY7mSfB7seBO1jUEN6hfL/0iGUO0YldRnoug
        by75CJ9heE18U4vAnHlViW06iQjGfpQ=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-P5HkV64jMw-T22TIrJ-U7A-1; Wed, 21 Jun 2023 07:27:17 -0400
X-MC-Unique: P5HkV64jMw-T22TIrJ-U7A-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-780a729b2baso169457339f.0
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 04:27:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687346836; x=1689938836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xc1C5dGE3E84jHIb6pWdRSRyKplzGTrNuAMSPXu3ZBM=;
        b=StVXfLsHH0NMiZwKl3YxYsIXOyISaJ6DqUByyXhswBerMo6e3/dV/mnFwqWmDNL4uU
         Yk9xvb4knfGKC3m0RwvB2UKP0KF9vMmKic/WgXD5ooJFYGrdQ1WW5JNZJ1770aadR6F8
         y2YeSNCGjen6p3RHFniycmfSuDiiNzm2gPaboh/6pBI/QDPDzdmZHPGGMSyGvlsH/kiZ
         Cwv8nlHMrfvmX3izoyck4p6CJXlna88mF0mhqHnPBpl6ZNg+EQmsP7NgsVwLeJ67SbND
         JdFisE8pFEzh8jBC0BlclFHPNPUhvpqQDt6etKTimbKUCfBsEoa5/Hy6BIyEX6nxMPEn
         eEbw==
X-Gm-Message-State: AC+VfDy0tCtumc7uJxaa6M4l2Mu/VHnxUHLsbaZDm7qGX6C2FP9dPN3G
        Y9WvTvrDUA5BGJjNGLXeWFBy9pdQ6P1qlfE2l4yRZ0aFV92umMzUMO2uA7wdfhivcmJOEAHbN8I
        vkAm9Gm7ujxSY1+QDbq6jCdYkd7kgNfRAfBCbUKO75Q==
X-Received: by 2002:a92:c943:0:b0:33f:bb6b:ed37 with SMTP id i3-20020a92c943000000b0033fbb6bed37mr5664438ilq.24.1687346836341;
        Wed, 21 Jun 2023 04:27:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6olE2HOhfBMxA6lDGHpd0vaEklGhfzomfGEsb3oTgsFsUJQBqcO4MUPw1RU/gUkd6HN15C8LmGbrLr0g6uGTk=
X-Received: by 2002:a92:c943:0:b0:33f:bb6b:ed37 with SMTP id
 i3-20020a92c943000000b0033fbb6bed37mr5664433ilq.24.1687346836131; Wed, 21 Jun
 2023 04:27:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687255035.git.alexl@redhat.com> <20230620161507.GA864@sol.localdomain>
In-Reply-To: <20230620161507.GA864@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 21 Jun 2023 11:27:05 +0000
Message-ID: <CAL7ro1GEObg78=LE2h7H2x0TnsuqGTmt2xvuT3grROWNPzr46w@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] ovl: Add support for fs-verity checking of lowerdata
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 20, 2023 at 6:15=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 20, 2023 at 12:15:15PM +0200, Alexander Larsson wrote:
> > This series depends on the commit
> >   fsverity: rework fsverity_get_digest() again
> > Which is in the "for-next" branch of
> >   https://git.kernel.org/pub/scm/fs/fsverity/linux.git/
> >
> > This series, plus the above commit are also in git here:
> >   https://github.com/alexlarsson/linux/tree/overlay-verity
> >
> > I would love to see this go into 6.5. So Eric, could you maybe Ack the
> > implementation patches separately from the documentation patches? Then
> > maybe we can get this in early, and I promise to try to get the
> > documentation up to standard during the 6.5 cycle as needed.
>
> I think it's gotten too late for 6.5.  If there is no 6.4-rc8, then the 6=
.5
> merge window will open just 5 days from now.  This series has recently go=
ne
> through some significant changes, including in the version just sent out =
today
> which I haven't had a chance to review yet.
>
> Please don't try to rush things in when they involve UAPI and on-disk for=
mat
> changes, which will have to be supported forever.  We need to take the ti=
me to
> get them right.
>
> I also see that the overlayfs tree is already very busy in 6.5, with the =
support
> for data-only lower layers, lazy lookup of lowerdata, and the new mount A=
PI.
>
> I think 6.6 would be a more realistic target.  That would give time to wr=
ite
> proper documentation as well, which is super important.  (Very often whil=
e
> writing documentation, I realize that I should do something differently i=
n the
> code.  Please don't think of documentation as something can be done "late=
r".)

If 6.6 is what ends up happening I'm not gonna protest, it's not a
huge issue for me, only mildly inconvenient. But, for now I'll at
least keep targeting 6.5, and then we will have to see how it works
out wrt reviews and what Miklos decides.

I pushed out a v5 series today too, because the v4 series conflicted
with some other changes in vfs.all that are staged for 6.5. v5 is also
a bit simplified based on Amirs feedback, has some documentation
updates and is refactored into more commits for easier review.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

