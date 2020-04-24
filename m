Return-Path: <SRS0=0l2z=6I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C179C54FCB
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Apr 2020 14:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC5AB2071E
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Apr 2020 14:49:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5sK4/6p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgDXOtM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726301AbgDXOtM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 24 Apr 2020 10:49:12 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45513C09B045
        for <linux-unionfs@vger.kernel.org>; Fri, 24 Apr 2020 07:49:12 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id u5so9517494ilb.5
        for <linux-unionfs@vger.kernel.org>; Fri, 24 Apr 2020 07:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jxiVP27prJIseCZdSttgwf69wkuMo7J50IABJ0usKGE=;
        b=d5sK4/6p8yR8tIy6AWRZ0zWc7Y6Jo3dhNT67Mr9ytoEmhsLtdI9n3P+rd2i3zvb3Ew
         VYc2Qdo1TIQlTHC5UicuAiSL57aUOj2Ez3ER1buFhtl6hoo/HmWjN8GdWdbI4flqD2Ym
         jcKK5IYqh2BD9FyMW95rkk2PMu/wsRrODW69q0LQoYtMyd8roOjRzXvOyCo0szk5KwZu
         5TudWeEFdc0o+xtfJJ9/6DXYzRm83LfaurwrRch0QtqVxHUGDvnAKJG+7OuS//ucX6wi
         anZaXYtqKK1l1u8li1uW+iNcBpZsuyJkX9mNyRYCPrwuX5DmBsL/mmTXgAu7BnAWZbe8
         eSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jxiVP27prJIseCZdSttgwf69wkuMo7J50IABJ0usKGE=;
        b=B10tz+KLMpukI6AjU2kxkDaXjWRD2GDY/KqJswWYRc2CeFbXKs555e4e5JFRz0bMhB
         JNfCPoE1j5VnWt8mQeTmHpzk969+gmWu8AQO3U9TiADZGrX4+SGytiUUs9NvGGhgNfIM
         /kQTsp198QrrfpngGLwujBLeOoF+tp/B9NVq1A0uZLODzv2iQ2NFvoEES3JEuVA+2XSk
         tSAJxeYY4l/oRVowN46KGPlvYYJlM8q42hGGLoZQ50Rn99fusV/B+gZ39jxe6TN2vd2H
         iHX6kbctCE/MkeRABcqs1fQWlVsSU7zQkjivZbgCtFTAg4S1FhV0Ecx58tOcOAcK6jxn
         3eJw==
X-Gm-Message-State: AGi0PuZdfoqc+84ZvcxMaMXfvUrN6EIs1/aRPfa9ZpOJ5XMFtMV2Fc3D
        135nAd219DOpEZ+Y9pEL7SfUXw0/q6wG5mro69JRNGgw
X-Google-Smtp-Source: APiQypLswLjioDtzn5P3IhIs3YnODYYyoWAfC5CLdzOHLtb7N1SFltJcpCfEfUwK7UEjCV16m5lfJLofCSPv/LEgRhE=
X-Received: by 2002:a92:7e86:: with SMTP id q6mr9234326ill.9.1587739751547;
 Fri, 24 Apr 2020 07:49:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200422102740.6670-1-cgxu519@mykernel.net> <CAOQ4uxj5JsWOgQ8vHqTkAXx16Y9URTgNpALY5XO=VNUAMTkOMw@mail.gmail.com>
 <171a49cb02a.e6962d897896.4484083556616944063@mykernel.net>
 <CAOQ4uxhowSRqD9kSoUHg+D8-RdxF8vBbTauTchgnpG5MoSNSEA@mail.gmail.com> <171aadd9966.100e576ad1248.8616898883060201949@mykernel.net>
In-Reply-To: <171aadd9966.100e576ad1248.8616898883060201949@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 24 Apr 2020 17:49:00 +0300
Message-ID: <CAOQ4uxi_zp45KrjnR4FJx56gsDPsoim4U0H7hj1ta4+gXAwQtQ@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: whiteout inode sharing
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 24, 2020 at 9:26 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-04-24 14:02:00 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > >  > > +               case OPT_WHITEOUT_LINK_MAX:
>  > >  > > +                       if (match_int(&args[0], &link_max))
>  > >  > > +                               return -EINVAL;
>  > >  > > +                       if (link_max < ovl_whiteout_link_max_de=
f)
>  > >  > > +                               config->whiteout_link_max =3D l=
ink_max;
>  > >  >
>  > >  > Why not allow link_max > ovl_whiteout_link_max_def?
>  > >  > admin may want to disable ovl_whiteout_link_max_def by default
>  > >  > in module parameter, but allow it for specific overlay instances.
>  > >  >
>  > >
>  > > In this use case, seems we don't need module param any more, we just=
 need to set  default value for option.
>  > >
>  > > I would like to treate module param as a total switch, so that it co=
uld disable the feathre for all instances at the same time.
>  > > I think sometimes it's helpful for lazy admin(like me).
>  > >
>  >
>  > I am not convinced.
>  >
>  > lazy admin could very well want to disable whiteout_link_max by defaul=
t,
>  > but allow user to specify whiteout_link_max for a specific mount.
>  >
>  > In fact, in order to preserve existing behavior and not cause regressi=
on with
>  > some special filesystems, distros could decide that default disabled i=
s
>  > a reasonable choice.
>  >
>  > I don't understand at all what the purpose of this limitation is.
>  >
>
> If user sets a ridiculous  link_max which is larger than valid range of u=
pper fs, I think it is hard to verify in the stage of option parsing.
> So I hope to fix the upper limit using module parameter, we can set defau=
lt mount option to  0/1 for the use case you mentioned above.
>

I didn't mean we need to check if link_max  is valid range for upper fs.
We anyway use minimum of user requested value and upper fs max.

Frankly, I think there are only two sane options for system wide configurat=
ion:
1. disable whiteout link
2. enable whiteout link with ofs->workdir->d_sb->s_max_links

So perhaps the module param should be a boolean ovl_whiteout_link_def?
Perhaps Kconfig should determine the build time default.

Setting whiteout_link smaller than d_sb->s_max_links should be
possible via mount option.

We may want to support the mount options:
whiteout_link_max=3D<N>
whiteout_link_max=3Dauto

It should be simple to parse whiteout_link_max=3Dauto, just
set config->whiteout_link_max to max uint and let later code
reduce it to upper fs max.

For ovl_show_options() is slightly more complicated to get right.

I am not hooked on any of the ideas above, but I find the current
configuration options in v4/v5 not good enough.

As an exercise you can try to document those options and
see how clear the text is.

Thanks,
Amir.
