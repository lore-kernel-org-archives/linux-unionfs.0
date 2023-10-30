Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98089C4332F
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 18:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjJ3SqE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 14:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjJ3SqD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 14:46:03 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E1ECC
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 11:46:00 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-57d086365f7so3001148eaf.0
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 11:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698691560; x=1699296360; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kf6uqddEp5QaayzRRCwyvWQft1k/s4Gi6xcPXrweP+8=;
        b=Fv+LlNXgWrAdV6QZ0GTjVKhoczowasJfLLiOQh8tbi+weIAXisghepQyIQokmNf9wL
         tYDGoiWDx8VX3CMrAphTd6YMHgYed6FP8KVqsYQZbD0NyIG1NVf8zq/d1xwV/lIU7aJH
         d6x25q7a9RohqOnV/+d9GbMw6OyI2xzFda+W45ghlHiLB5YCgTyoEJ1DIBpf/zJtsuLC
         vPJE2/a8W/52JfHtIR1J3lbs4F8MtCdb8ZJKkHrwJ7CMIggzLCQdDG8yTL6wRxpBVGA2
         bdP8acKzhmvVlbzBtLE4ciJwzmqmPDGBB+NrjQma+EUleYq2SKBdt60lKMwfy9xcy+YR
         BbUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698691560; x=1699296360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kf6uqddEp5QaayzRRCwyvWQft1k/s4Gi6xcPXrweP+8=;
        b=HKBnfAwrN8069AMoM54VxNRrou/t8WHrAMIp3Bq85WYguRuqpEbmQhl/o3F1ZbuboE
         52V5U1AXwRVdYLJhGp+B9wwFuBnPbADWl3E28lB06H9rKOy3ZtFszi4ZLgj7FKiYHMR/
         rap9qpZK6aDPsBAK45KWudfMufCuhYGBxEUgFxG6PstSkQvL0hXzYUs63vTNcUCEg9uN
         RaKKBmrku44vg8nokAidLKvuZlsCcb30tbdvP8uN+lmWvkSJrkeDWyHPqbZyS19+Mequ
         SedUUT9IAQQIyUZ520hQ6Zzjbr87v7U7T3qk9W04oxDyRtrguqAbk5r7BXGLulYxdQG+
         0PCA==
X-Gm-Message-State: AOJu0Yx589KcaSrfXMYGCmV8C09lWwAYSLXqj9tJRMrYbkqT6GjobuYc
        fFv71R/mAmybqeCIJ6E+sz5vb0WY3IpZYIp5y3k=
X-Google-Smtp-Source: AGHT+IEBxREuQYdz6uF+hr0p/ByZq9SJm72irQe3ANzmkX7UOMZj43yh1HzixomZye52jIjdpadA4DzMaGgnEPrBJqg=
X-Received: by 2002:a05:6358:3396:b0:168:f67b:cbf8 with SMTP id
 i22-20020a056358339600b00168f67bcbf8mr13307398rwd.28.1698691559812; Mon, 30
 Oct 2023 11:45:59 -0700 (PDT)
MIME-Version: 1.0
References: <20231030120419.478228-1-amir73il@gmail.com> <CAJfpegvMtqk6eiLvGbC+2oQDHSP6M2HEZVWzTFpVpbWN6GCaOQ@mail.gmail.com>
In-Reply-To: <CAJfpegvMtqk6eiLvGbC+2oQDHSP6M2HEZVWzTFpVpbWN6GCaOQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 30 Oct 2023 20:45:47 +0200
Message-ID: <CAOQ4uxjD6_G_u7jP88D-mpYAEjYDLEUQcZ=HTR1ub0ts5+dFRw@mail.gmail.com>
Subject: Re: [PATCH 0/4] ovl: new mount options lowerdir+,datadir+
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 30, 2023 at 5:41=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Mon, 30 Oct 2023 at 13:04, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Miklos,
> >
> > As discussed, here are the patches for the new mount options.
> >
> > - Only string format is supported
> > - Legacy lowerdir=3D cannot be mixed with new lowerdir+,datadir+
> > - lowerdir+,datadir+ are not escaped
> > - lowerdir,upperdir,workdir are escaped as always
> >
> > I did not find a good reason to change escaping of upperdir,workdir.
> > We can skip escaping when we add support for path format.
>
> Looks good, other than the minor error reporting issue.
>

Pushed fix to overlayfs-next and added some documentation.

Thanks,
Amir.
