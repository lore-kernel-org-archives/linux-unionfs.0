Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1704C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 06:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEFD520771
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 06:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kGI8P71D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408138AbgDPGrP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408083AbgDPGrM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 02:47:12 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A063C061A0C
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 23:47:12 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i19so19866700ioh.12
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 23:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PGOzlYRjdlOKiEH07zb09yd6jCSYco/X+/n3vVKlbII=;
        b=kGI8P71DdKY+f/S7XPgH7nxrHPrIUFVwXaT8/ThuAWyLEWAxcqyDI/ZbQH7v3AlvpJ
         W8m63ZNjbreLqS3FfOsJFOieQ1AO467+zjZZC/NoleNQ9pCr03GtRC8mjqMs3cRjLqby
         ETKpob9TJ8clp7k+B6amW480/ZkJ+Ffn4JBfbscT+6bueBSb801Bk2G9IrVufFeVefmS
         M/yj9ck3lSca/IAN4FfiJ+89oI4Jkmg5CvMdvcl9Gl23SFXPWiQm4EUhAKMM44xtI6gi
         YXFeSmQ6vKkJ+Kbzvk2HP2a8G+EGM6C18kjaUvom9ms8VTMJOPuo5zioYpyHwkUQmPxF
         H+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PGOzlYRjdlOKiEH07zb09yd6jCSYco/X+/n3vVKlbII=;
        b=Um6IoJtBCOlS7PK9HvWJFXZAW53cgL7iJmNJofKMxx+a+WV3tITQudFgdQkAovY0RD
         OYhF+Qq/2G9ZZMytpTua0qItWCHxDer62VG17PzkZ4zNCPsLXem9108Xz18iVnMtTvN6
         GoB3WMuAEwAKryuDsA7jv6MYhCpdltnVYdz9bGQm4A1WSGF/fvrW3e2gKr4ILGFO1bof
         uNfLdVmvnpdawgrcpjhPz2lUG6AxUM5fV5daIki57/GjwlQXUGuTo9edF7LkEr289gD4
         sXzGYA3sHUu+/vGN3mqqQp//Eoj4+2DEMplAL3nmzaWGpoEWn+ZJWDCIZP+oWMWobMDl
         Qcfw==
X-Gm-Message-State: AGi0PuaLOmWV6PdSXrb0yHM5nFZO7lO/alX+gskkEThlGi2eNy7qr6Yx
        J+JDicClyT468od0SlALZmK9LSrcziT4jQ7XUtijLA==
X-Google-Smtp-Source: APiQypIGMO2aQMuQmgzliezHG4TRD3+cJOHN30BDnLgVYXuGkFCUygpgnaZB3EEXjaue5blB2STAR5U8B1ur6Ge6c3o=
X-Received: by 2002:a6b:ef03:: with SMTP id k3mr18695763ioh.203.1587019631284;
 Wed, 15 Apr 2020 23:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200414095310.31491-1-cgxu519@mykernel.net> <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
 <1717b5c51ab.f6b667969599.7086962587723946588@mykernel.net>
 <CAOQ4uxg+ds5O9gHZs3+sgo08Ut84LPn5MeC=duRqPBtuAOtezw@mail.gmail.com>
 <1717cdb4bcf.11544259d10401.8883493846177492528@mykernel.net>
 <CAOQ4uxg0CYuQ-EfOphk-v-o5hvyVr0UbD5nngse9Zi4M5ZxNgw@mail.gmail.com>
 <1717cf65ddb.d406587710513.3094673612298718285@mykernel.net>
 <CAOQ4uxgXtjsZXkm60J2omXmnj-2cHwQZ=jmf3+GYN_KdW8JovA@mail.gmail.com> <17181ae4719.11b6a2eaa836.5332868079279852281@mykernel.net>
In-Reply-To: <17181ae4719.11b6a2eaa836.5332868079279852281@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Apr 2020 09:47:00 +0300
Message-ID: <CAOQ4uxgt=znEgw_V-a+8wJrN_gptoCk8ifZAAOz40wppBtJ2Nw@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: whiteout inode sharing
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

>  > > In case of any unexpected errors, we could set a error limit(for example, 10),
>  > > if link error count exceeds the limit then we disable the feature.
>  > >
>  >
>  > As far as I am concerned, you may post the patch without auto disable,
>  > but I object to using an arbitrary number of errors (10) as trigger for auto
>  > disable.
>  >
>  > I do think that it is important to communicate to admin that the whiteout
>  > sharing is not working as expected and it is not acceptable to flood
>  > log with warning on each and every whiteout creation, not even with
>  > pr_warn_ratelimited.
>  >
>  > There are several ways you can go about this, but here is a suggestion:
>  >
>  > +        if (err) {
>  > +               ofs->whiteout_link_max >>= 1;
>  > +               pr_warn("failed to link whiteout (nlink=%u, err = %i)
>  > - lowering whiteout_link_max to %u\n",
>  > +                             ofs->whiteout->d_inode->i_nlink, err,
>  > ofs->whiteout_link_max);
>  > +               should_link = false;
>  > +               ovl_cleanup(wdir, ofs->whiteout);
>  > +       }
>  >
>
> Frankly speaking, I don't like heuristic method to automatically enable/disable feature,
> so I perfer to disable the feature immediately after hitting any error just like your previous suggestion,

Fine by me.

> and I also hope to add a mount option for this feature to mitigate global effect to different overlayfs instances.
>

I think that would make sense.

Off topic: from system perspective, the fact that whiteouts take up inodes
to begin with is a shame. If one had control over the underlying filesystem,
whiteout should have been implemented as a constant and immutable special
inode with no nlink count at all and getdents would return DT_WHITEOUT for
those entries.

Thanks,
Amir.
