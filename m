Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC2DC6FD18
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 14:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjDROVt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 10:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjDROVa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2023 10:21:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1888DC161
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 07:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681827644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C4ATO9nd2CUliTZxZlOKqkhuST/ECDO2XmOaOuQqd50=;
        b=IOAQVo6MoJyQE4DrRnIbsL/RGxlPzjc1tTLZISG+e7mPEX2ho69rJA9uYFoO0NdGdUr5Dv
        UA2z90puhcZFLiluimVXTgzT/Ql+k2tKMEdTFOksWChu8jE52N79ORb/+yC6aB0zIL+58t
        n8IqaNHeG2sLyGCfVU/3S0MSM+hzaS0=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-Hu1I0t3WPnO2-FxSnVK58w-1; Tue, 18 Apr 2023 10:20:43 -0400
X-MC-Unique: Hu1I0t3WPnO2-FxSnVK58w-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4ecb00906d0so1026860e87.1
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 07:20:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827641; x=1684419641;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C4ATO9nd2CUliTZxZlOKqkhuST/ECDO2XmOaOuQqd50=;
        b=e/zwPXL/ciOTvuEgGqzM3+7QRVBJAhqF9qMyhc8Xx+3WzHvwBNcotS158cXoLoigPX
         KodggEUcMl/6L1i4vsw5nXv0mhnBf6rC4Q7Noub2fjtXz+kwyOOXWY/C+Dd2dAW0VkeO
         ABUfVfO8SJH0vzHJi+OlYL4us9OLeGYKt+5sYl6gALDUO8pzNuq724RjHGpAv2wrrb+w
         v+kCCtLT1Fl/5t6Z9pFZikgGYD4J7/XICa5HWr0EkJTgo4VMJblg+QrBM65XvXCIp/XI
         xwRZDg4iYmYsU0p5l8Tbu7YIqX/BFtrwfKG3l4EMQ3Jl4T22hLgF0Gxl3pVZwNtT77aF
         D+hg==
X-Gm-Message-State: AAQBX9cw6DyAXqOX695pwF55ljb7TQJqN4iedQGLiz31bjDnsMVTGcsf
        EIGbcv4/WdWpSOHWSG6G7N0sBMD8wFYrU1Oc8JqBvF2AulvMDVJJIvxUdfnR52shyMov2ZiQnH/
        ArUS6Th1N9yQMO9FAyQFNLOihWESjKjhetZsK
X-Received: by 2002:a19:ee0e:0:b0:4e7:fa9a:4d3c with SMTP id g14-20020a19ee0e000000b004e7fa9a4d3cmr2654923lfb.16.1681827641253;
        Tue, 18 Apr 2023 07:20:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZN/jOGXAI60tb5QDySBoaEq/YEGJib+Lm0Jz3ZcGZl0dDzLsvfRKTAurpUraHyuPdVSkJzPw==
X-Received: by 2002:a19:ee0e:0:b0:4e7:fa9a:4d3c with SMTP id g14-20020a19ee0e000000b004e7fa9a4d3cmr2654916lfb.16.1681827640905;
        Tue, 18 Apr 2023 07:20:40 -0700 (PDT)
Received: from greebo.mooo.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.gmail.com with ESMTPSA id g25-20020a19ee19000000b004eb252e3eb5sm2386104lfb.135.2023.04.18.07.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:20:40 -0700 (PDT)
Message-ID: <228e85e2c247da98cebea09ce2af418c64b60c85.camel@redhat.com>
Subject: Re: [PATCH 2/5] ovl: introduce data-only lower layers
From:   Alexander Larsson <alexl@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Date:   Tue, 18 Apr 2023 16:20:39 +0200
In-Reply-To: <CAOQ4uxgU4LZy5=ouqFDWAPn=t17mavfhs_1915-HW3AGywjYkw@mail.gmail.com>
References: <20230412135412.1684197-1-amir73il@gmail.com>
         <20230412135412.1684197-3-amir73il@gmail.com>
         <8ac422621de7b422cf4b744463f3c1e4bae148d9.camel@redhat.com>
         <CAOQ4uxgU4LZy5=ouqFDWAPn=t17mavfhs_1915-HW3AGywjYkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 2023-04-18 at 16:33 +0300, Amir Goldstein wrote:
> On Tue, Apr 18, 2023 at 3:02=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om>
> wrote:
> >=20
> >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 * fh->uuid to layer.
> > > @@ -907,7 +907,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> > > struct dentry *dentry,
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!d.stop && ovl_numlowe=
r(poe)) {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 err =3D -ENOMEM;
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 stack =3D ovl_stack_alloc(ofs->numlayer - 1);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 stack =3D ovl_stack_alloc(ovl_numlowerlayer(ofs));
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 if (!stack)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto =
out_put_upper;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > Again, surely ovl_numlower(poe) is a better size here?
>=20
> Intentional. that is changed in the following patch.
> (to ovl_numlowerlayer(ofs) + 1)
> As the commit message says:
> "Following changes will implement lookup in the data layers."

Still, you might have 10 lower layers in the overlay mount overall, but
this particular parent may only have 1 lower layer, no? So
numlower(poe) would be smaller that numlowerlayer(ofs).

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's an all-American vegetarian romance novelist who must take
medication=20
to keep him sane. She's a vivacious extravagent stripper from Mars.
They=20
fight crime!=20

