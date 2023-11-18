Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39980C54E76
	for <linux-unionfs@archiver.kernel.org>; Sat, 18 Nov 2023 06:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjKRG7k (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 18 Nov 2023 01:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjKRG7k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 18 Nov 2023 01:59:40 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DC210C4;
        Fri, 17 Nov 2023 22:59:37 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-6779fb43e5cso1577816d6.2;
        Fri, 17 Nov 2023 22:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700290776; x=1700895576; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F+/LrFC38HCQp0Kzc/AK0vyGJnzxQl3xrb8AVMJwJNs=;
        b=gsQqpxNUQJ/cRKRDGqemqNyk+382ABuakVKfEG6ARcjtyUHMb6GnHXt1ErUXXX2yBi
         1ptw9CtaF+WiPoZ8ejtF+YLTzgEw7cWfl/qOSZ8KmflmRexfe7JeaRP6jGD9/052Uvqw
         K5FQztlbYXHX0z9DbX7kM2sUANkN24RX67JEcNjMj4JnIJPUOPLUPDCIHbzy4GG0hvxB
         MyHO7snl/4xb7wqrPJRgSsj2CFg5tBjuxfTk/iY2ATybkRkzjFp8gMt+XrHBN6KnRr/O
         FSJWlI3mGV+ZORYio84HA/AlwyHwHcXXs0k1quik07xTuXcqFWHohUIYUN4Z+Cf9hmLg
         7OBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700290776; x=1700895576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F+/LrFC38HCQp0Kzc/AK0vyGJnzxQl3xrb8AVMJwJNs=;
        b=mCpc3f3muh+XX9iutPQNcodGWoGeFbFsePr3H5U7gzF2i6UBuv/JgOlUE5vaJauwFO
         3dPQwaWPfk0QbpmxiW1j6rOOdGxnJCGlhnav82ZXhtHCrDLipIfyDYXnZCY3aqPG+oMH
         7ec/MWmIwvDGReh8fO1JeDT6X5wQBq+OFL/t/QEQw/hTcdnC2DTObb++MLl0mMDCFi3c
         4/OcPY+ZLHjSH/EAvmO/irlHwKrij0CcLFaAkG4wI3bmZcqRJSrVrTOiduy08fiItR1H
         XACh79WrYdTZLWNf9FTWmCR9x5L/S6CBQXk3LmqvAG5ObJqm05Z9gWbd+i9/3UrKwSWT
         PTKg==
X-Gm-Message-State: AOJu0YxJKKlhsoH9XJHMld90n3cZJk/36FULAzqbjKumHLSpcjaOOc81
        6Qe5EsDwu5oZxHmYBFX9drdXQH41gBfMiksoUls=
X-Google-Smtp-Source: AGHT+IHY6wZ/vpUYbkpI16CDlh66sneMpJsg0zwXohaJPnz6Zroc+DyNKN0SviNjKe+rTIdSvmvrLirmB6M5PuwyM/o=
X-Received: by 2002:a05:6214:258b:b0:66d:9f2e:f3e6 with SMTP id
 fq11-20020a056214258b00b0066d9f2ef3e6mr1916616qvb.48.1700290776132; Fri, 17
 Nov 2023 22:59:36 -0800 (PST)
MIME-Version: 1.0
References: <20231114153254.1715969-1-amir73il@gmail.com> <20231117194443.GC1513185@perftesting>
In-Reply-To: <20231117194443.GC1513185@perftesting>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 18 Nov 2023 08:59:25 +0200
Message-ID: <CAOQ4uxjuDxSro+4qtXfodSf-EcAA8aUBGuWpaVn4+H8Ai=JcFg@mail.gmail.com>
Subject: Re: [PATCH 00/15] Tidy up file permission hooks
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Nov 17, 2023 at 9:44=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> =
wrote:
>
> On Tue, Nov 14, 2023 at 05:32:39PM +0200, Amir Goldstein wrote:
> > Hi Christian,
> >
> > I realize you won't have time to review this week, but wanted to get
> > this series out for review for a wider audience soon.
> >
> > During my work on fanotify "pre content" events [1], Jan and I noticed
> > some inconsistencies in the call sites of security_file_permission()
> > hooks inside rw_verify_area() and remap_verify_area().
> >
> > The majority of call sites are before file_start_write(), which is how
> > we want them to be for fanotify "pre content" events.
> >
> > For splice code, there are many duplicate calls to rw_verify_area()
> > for the entire range as well as for partial ranges inside iterator.
> >
> > This cleanup series, mostly following Jan's suggestions, moves all
> > the security_file_permission() hooks before file_start_write() and
> > eliminates duplicate permission hook calls in the same call chain.
> >
> > The last 3 patches are helpers that I used in fanotify patches to
> > assert that permission hooks are called with expected locking scope.
> >
> > My hope is to get this work reviewed and staged in the vfs tree
> > for the 6.8 cycle, so that I can send Jan fanotify patches for
> > "pre content" events based on a stable branch in the vfs tree.
> >
> > Thanks,
> > Amir.
>
> Amir,
>
> The last 3 patches didn't make it onto lore for some reason, so I can't r=
eview
> the last 3.  Thanks,
>

Sorry for the mishap.
The entire series was re-posted shortly after to fsdevel:
https://lore.kernel.org/linux-fsdevel/20231114153321.1716028-1-amir73il@gma=
il.com/

> You can add
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> to patches 1-11.

Thanks for the review!
Amir.
