Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9783C77B78
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 15:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjDRPaA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 11:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjDRP3v (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2023 11:29:51 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A86B125B8
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 08:29:44 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id u12so81853vst.11
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 08:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681831783; x=1684423783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oqRpxEBs6vax8hy9M6yY3xC3tO4kl0eQMqTXxKhKgkE=;
        b=VJuG4nqRzhfCKUfy6xtLf5hcU15sm5uFA1SbLycIpizcZ1y6zehOFkD54UDJTkpgJy
         +nDyPe0AMuNeTt7y+6hFcnGf/R2RJLAcsOv7aWFvjs5sawVnJUDpWjqxKV5SoLMgJCkB
         kNCAWq/MFLyE0AOKF0h+hW1/u2zyKM2eSrDBNpIrlx0v9T584s7liZB5kVwtXwhTC/9F
         ZENdHE/mqy2zRWKdeiaKE+LBH0Xq/ZVXfmpJrIS4RMAV7nLso1hipJWvXLuOOk6klkF9
         pTmtqX18IE82Y1CJ8tO1Y4yEDHuAgdXY+ZzBRfxQwyxm6ZLcqD23BguYXr2qxNgF+tNo
         o5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681831783; x=1684423783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oqRpxEBs6vax8hy9M6yY3xC3tO4kl0eQMqTXxKhKgkE=;
        b=KayOUo9ADAq9MJcaeAAMO3U7F4zA2ikknUqxkLedYjI16TCvbHIpWuzekiAG3gW44c
         Ra8Q6UsTzhXdf42snE4NqevjI682rJgugCLpGpV92baNWjhzNKrzFOeFi26HjGSRB/Mz
         MYwnoYVchWRDhM62+j+3GGCW+BiVEMwXABzizk6XjkQ09MRk7dpMinj2OXfbo+hwtZ6v
         rSpC1tbyeJIfSJQdITr6FxuBWO22WfAliBUdFkNPdaYAKOHihafqyCaGNNzRj3602a0E
         ROplOngNpfv4qiXoCGr0JXTkdzTzu/IWT7ImszOfRqtX0MZth/luChsSb6BHum4NnmjN
         hirQ==
X-Gm-Message-State: AAQBX9fKLiZnuLk5CiRjdpX/QLQ6BSYRDQMEAvztKizaBUWxdCg4mZwE
        vaERT0HJx226oeipaCWBhBkt/opwgEcOZMwZVf4=
X-Google-Smtp-Source: AKy350aOAbZxyitSQC9BuKhTZ8jrdV9lqJIDU+jwWTt4Dr+8rzjXk5m50/uZKJO92CIoa3+3sbMmZeTIPsaniqxlYy4=
X-Received: by 2002:a67:e046:0:b0:42e:9b1e:1db5 with SMTP id
 n6-20020a67e046000000b0042e9b1e1db5mr5450317vsl.0.1681831783077; Tue, 18 Apr
 2023 08:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230412135412.1684197-1-amir73il@gmail.com> <20230412135412.1684197-3-amir73il@gmail.com>
 <8ac422621de7b422cf4b744463f3c1e4bae148d9.camel@redhat.com>
 <CAOQ4uxgU4LZy5=ouqFDWAPn=t17mavfhs_1915-HW3AGywjYkw@mail.gmail.com> <228e85e2c247da98cebea09ce2af418c64b60c85.camel@redhat.com>
In-Reply-To: <228e85e2c247da98cebea09ce2af418c64b60c85.camel@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Apr 2023 18:29:31 +0300
Message-ID: <CAOQ4uxiWEhG0fqUJONPR=gWyZW0DuL=0uF_H0paONABhKYnAmw@mail.gmail.com>
Subject: Re: [PATCH 2/5] ovl: introduce data-only lower layers
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2023 at 5:20=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Tue, 2023-04-18 at 16:33 +0300, Amir Goldstein wrote:
> > On Tue, Apr 18, 2023 at 3:02=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com>
> > wrote:
> > >
> > >
> > > >                  * fh->uuid to layer.
> > > > @@ -907,7 +907,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> > > > struct dentry *dentry,
> > > >
> > > >         if (!d.stop && ovl_numlower(poe)) {
> > > >                 err =3D -ENOMEM;
> > > > -               stack =3D ovl_stack_alloc(ofs->numlayer - 1);
> > > > +               stack =3D ovl_stack_alloc(ovl_numlowerlayer(ofs));
> > > >                 if (!stack)
> > > >                         goto out_put_upper;
> > > >         }
> > >
> > > Again, surely ovl_numlower(poe) is a better size here?
> >
> > Intentional. that is changed in the following patch.
> > (to ovl_numlowerlayer(ofs) + 1)
> > As the commit message says:
> > "Following changes will implement lookup in the data layers."
>
> Still, you might have 10 lower layers in the overlay mount overall, but
> this particular parent may only have 1 lower layer, no? So
> numlower(poe) would be smaller that numlowerlayer(ofs).

Ah, I understand your question.
The answer is that absolute redirect (a.k.a poe =3D roe) can change
numlower(poe) after the stack was allocated.

There are several "optimizations" that could be done, but they
are useless, because stack is a temporary allocation.
The permanent stack allocation is done at the end of lookup
with ovl_alloc_entry(ctr).

Which means I could have also left it ofs->numlayer - 1
this change ends up being just semantic.

Thanks,
Amir.
