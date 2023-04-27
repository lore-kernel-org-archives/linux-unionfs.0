Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F5AC77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 06:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjD0Gc2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 02:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbjD0Gc0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 02:32:26 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE9C210A
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 23:32:25 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id a1e0cc1a2514c-7782debbc4bso5322833241.2
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 23:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682577144; x=1685169144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nYPuMBT40eG8szrpwX7JJCcnMbJolGw+oh7yUYYVFH8=;
        b=Q2KacqkObR3EXTVDvAyBCc90tWJMSW9mlrbm17g5crp8gZNmLt9gxJIYAa759lQ2mz
         ki/Rf5Y7lbj1BTyqTjC3ql+0IGoUpocVUCKc3fKZnNZDT+m+s7M2DReqSO+m5pKkQBWg
         gtD7+9aS2c04H+PiPQIamHA8gTY+asS8hvsllGuvwIwtWauSbeaOML+t5BxKSSG9O4z3
         xvqVHYoyj5E/Qj8bAOSls1bC33fTwbrMYuSHcM+fbGbbPqZU6Q2Whu3r/0QEsUR9wYaz
         G4yXIA5KJUoPy5ttQvCWEj/P3zMkFbzKGpeVVPtJtHy/12vfNmUWQtCy3LxnpOZ6pAB9
         2sTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682577144; x=1685169144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nYPuMBT40eG8szrpwX7JJCcnMbJolGw+oh7yUYYVFH8=;
        b=HxtuXX8xoEptBtrh0Jb4CaU1JKj82EsVki7btGpH1auBg3G/EwdTbjzF7/wbpyrOYO
         4URhWxBKFEFOG3vYv/YSoj/NTIufqCgHh+8GxdRoDsAttGW8zdBrHP/U+UtZki0bJAx1
         w9t3uX/otXyQeNrtObD7QdJlKpSoCeOmm+Z6YxMsvPUdUkXU9nqI5+ZYg93pvL3xbLip
         m+Qv4CYJmCMrWabijLHJPiyNJzeIUomXkUMb3JmQGvfduV3mAnHXwA0AIM3xYegbj4eJ
         0aOqUg+vkHm7DfIbc+A19bO2sh1zMR4JsoxT3WziPhbnaLoZlCaDS9aSRtFvikNInCz9
         GUJw==
X-Gm-Message-State: AC+VfDzl9e2zPp+9pB5ig2GmELihTlbA2TthkuD0wNThVBdkhYkAyPaE
        MIwhUHzU9f7f+Jf2sz6cyJ5tV+vh2V4h7+BcdiWIGhUxD0FKfg==
X-Google-Smtp-Source: ACHHUZ6YRKYLk3loyfocKiY4Lq2wEWKtoWSXee7Qby4jEgLLShYs/JoRIaXFL4edYrIL3BS7qjjRU5e+8qc04a7QXh4=
X-Received: by 2002:a67:f58e:0:b0:42e:4fb0:af1b with SMTP id
 i14-20020a67f58e000000b0042e4fb0af1bmr294191vso.34.1682577144646; Wed, 26 Apr
 2023 23:32:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230408164302.1392694-1-amir73il@gmail.com> <20230408164302.1392694-8-amir73il@gmail.com>
 <CAJfpegu3HBQyKkUFmYywwKqifwWVO6CYjt3O0WiEdzUirjt9mA@mail.gmail.com>
In-Reply-To: <CAJfpegu3HBQyKkUFmYywwKqifwWVO6CYjt3O0WiEdzUirjt9mA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Apr 2023 09:32:13 +0300
Message-ID: <CAOQ4uxiibBpK28QsqhNgsT7wcfd2H14cWJfq7xEkpN4hTd-AHA@mail.gmail.com>
Subject: Re: [PATCH 7/7] ovl: replace lowerdata inode reference with lowerdata redirect
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 26, 2023 at 3:39=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Sat, 8 Apr 2023 at 18:43, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Now that we have the entire lower stack in ovl_inode, we do not
> > need to hold another reference to the lowerdata inode.
> >
> > Instead, use the vacant ovl_inode space as a place holder for lowerdata
> > redirect path from the metacopy to lowerdata, which is going to be used
> > later on for lazy lowerdata lookup.
>
> Seems like this patch is combining two independent changes into one.
> Could this be spit into
>
>   - remove lowerdata
>   - add lowerdata_redirect
>
> ?

Yeh, ok.
I posted it like that for review because I thought it would be
easier to review.
But really remove lowerdata belongs to this prep series
and add lowerdata_redirect belongs to the next one so
I wont mix them

>
>
>
> > +               /* Store lowerdata redirect for lazy lookup */
> > +               if (ctr > 1 && !d.is_dir && !stack[ctr - 1].dentry) {
>
>  So lazy lookup will be signaled with a NULL dentry?  This should be
> spelled out in the patch header.
>

This also doesnt belong to this series.

Thanks,
Amir.
