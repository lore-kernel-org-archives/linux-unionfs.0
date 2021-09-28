Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8EDC433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Sep 2021 07:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3609F611CB
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Sep 2021 07:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbhI1HTO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 28 Sep 2021 03:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbhI1HTN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Sep 2021 03:19:13 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABC8C061575
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Sep 2021 00:17:34 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id az15so20977055vsb.8
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Sep 2021 00:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5VZceE/dQmU6bLvl6P5d+DLar0Sw2Dsq3q/ylCWAUVI=;
        b=DIATSXRBLGAqa+xswEPNBQnleXtV60+haTfFNrEmgJvJaoAll70jM44RaWWm8u0qYt
         82EyP2C1R1uHBrniA+rW8Rbfsf5K2erg6ezXvTLWSqE0CEqXv+12jhh+0+1EeEL8pjIh
         OTL3Ixk0I9sDGkcH3RFolHamWqvWcV3ocipko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5VZceE/dQmU6bLvl6P5d+DLar0Sw2Dsq3q/ylCWAUVI=;
        b=7xuT7p8M9nCa/nSd5rZW1uoE4aKVbPum7d7Puc+Hoziwo/NlmU1WOXzgNQfyd1rfdb
         B71miNCrlBxfhQDcsj7q/ISVrEhaBfzYDPP3ENLvJgazx6884O4mNW/lZjw4a7GXkxsw
         vYKafIRew+Tv+Nv3g/yKAcl/FQY0CFl6Fwh8IQUk8336rWV9+fRToM5/Fb1x0oy1ep6+
         xOo389H0cip/7xW8U3RZjLKaGM/IRFJqmBdk3y3kAEd9mt5dPuuAv0MKs9frP0j/fH8p
         VAwCiZJZZ9WKK9E+WfhKNVi+GJE5CHhGIhETqW+sDaVuAlDh0brlAoWPhbsMr9jRlRZE
         wc8Q==
X-Gm-Message-State: AOAM533XMX1EZBmldDHCmo41ivuw54qAOMYMes75NjCz53xF921ou8NU
        VvnTegK+9N1KlgcUGoLW+Hoa2a7zdcoaTm0manaejg==
X-Google-Smtp-Source: ABdhPJztRVRW3/QmckVYl4Qyku7NmhVkrLWgQRHozwyB7+hutqJ0fbJjiOdFJW0pTwJfle0znxSG5gl3KIkHsykSZyo=
X-Received: by 2002:a05:6102:3c3:: with SMTP id n3mr3785865vsq.19.1632813454116;
 Tue, 28 Sep 2021 00:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <9ef909de-1854-b4be-d272-2b4cda52329f@oppo.com>
 <20210922072326.3538-1-huangjianan@oppo.com> <e42a183f-274c-425f-2012-3ff0003e1fcb@139.com>
 <919e929d-6af7-b729-9fd2-954cd1e52999@oppo.com> <314324e7-02d7-dc43-b270-fb8117953549@139.com>
 <CAJfpegs_T5BQ+e79T=1fqTScjfaOyAftykmzK6=hdS=WhVvWsg@mail.gmail.com>
 <YVGRMoRTH4oJpxWZ@miu.piliscsaba.redhat.com> <97977a2c-28d5-1324-fb1e-3e23ab4b1340@oppo.com>
In-Reply-To: <97977a2c-28d5-1324-fb1e-3e23ab4b1340@oppo.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 28 Sep 2021 09:17:23 +0200
Message-ID: <CAJfpegsim-qtM4yaYdWo9P+QOP4UD_NrFTKADQky-HwOR=SPyQ@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: fix null pointer when filesystemdoesn'tsupportdirect
 IO
To:     Huang Jianan <huangjianan@oppo.com>
Cc:     Chengguang Xu <cgxu519@139.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org,
        guoweichao@oppo.com, yh@oppo.com, zhangshiming@oppo.com,
        guanyuwei@oppo.com, jnhuang95@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 28 Sept 2021 at 09:01, Huang Jianan <huangjianan@oppo.com> wrote:
>
> =E5=9C=A8 2021/9/27 17:38, Miklos Szeredi =E5=86=99=E9=81=93:
> > On Wed, Sep 22, 2021 at 04:00:47PM +0200, Miklos Szeredi wrote:
> >
> >> First let's fix the oops: ovl_read_iter()/ovl_write_iter() must check
> >> real file's ->direct_IO if IOCB_DIRECT is set in iocb->ki_flags and
> >> return -EINVAL if not.
> > And here's that fix.  Please test.
>
> This patch can fix the oops.
>
> Tested-by: Huang Jianan <huangjianan@oppo.com>

Thanks for testing!

Miklos
