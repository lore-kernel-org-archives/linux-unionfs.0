Return-Path: <SRS0=T6lg=3U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64942C35246
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 15:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC9E220661
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 15:15:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="nTUFJOyW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgAaPPk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 10:15:40 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:35800 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729171AbgAaPPf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jan 2020 10:15:35 -0500
Received: by mail-io1-f68.google.com with SMTP id h8so8553033iob.2
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jan 2020 07:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qNOGVIc+75M2s1F0an171FX0kOJfthBjK3mNSx0gzqs=;
        b=nTUFJOyW7qYZNnkYpIbPOkVP7TA/Wzpc9oqvr6kwxfh5EE3sc79xfb0jn/s31Xr1wB
         ZMFqdCwtRt/j8pszVtXHN/TdA6T3WJdIXua66BIHfnBQXVyDpxDUEDgvS3Tt29r0MJtQ
         97vNyAFx1wGq4eeWocyS70tdeaUtXT8jRVkk8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qNOGVIc+75M2s1F0an171FX0kOJfthBjK3mNSx0gzqs=;
        b=BF6KdochtrIIzXveeE30PQI+viuC0/M8bCWhcgX+Z1EiGjkP0bxCHojhziqEZ5gTWg
         4RvheK6ZfeUezQYCZdoNlQimzNaUCA7B20PYYgQFC5sMS5P+GUM+SGtS3TSm/giPk0Zk
         qYlhcaFVPsAN/cAKasJZchfTcfL7xYDC1Ccb/Fo0SDScldErhgHKa8aCeqYCvJvWBcdD
         k9hZf3HukIFH2kBSN6RSPQXgUHeQN06GhVi6VCORgGP3lkrnNNPLIiR/wVdOZ63gUJjT
         Y9oOsfGsxxVc64TSr0/jt3EjAjDCuLaAWrfwrGN/cUGQEBdLzNVww1Nrd7OECmTwugXl
         Nm+w==
X-Gm-Message-State: APjAAAUwJHc5JbSLEqR5U/LzezyOas0GnxWkcjmPwhXx94EgmP/NS0ir
        QYDhHmX39Nd5tWUr2GNo7kCqEljiYjGiKbrDV42ZWw==
X-Google-Smtp-Source: APXvYqw6nhm24Myv1X36IeuA9xaHU4a25zpyNDyg+RpiU0BrKWDJUY9DMs7AjvpIPABAKLghFPkSuU3rflo28vHTLVc=
X-Received: by 2002:a5d:9a05:: with SMTP id s5mr8776299iol.252.1580483734425;
 Fri, 31 Jan 2020 07:15:34 -0800 (PST)
MIME-Version: 1.0
References: <20200131115004.17410-1-mszeredi@redhat.com> <20200131115004.17410-4-mszeredi@redhat.com>
 <CAOQ4uxjR+6wqWMKf18qOEKk-VndVaHPtttPf6c06yK=9OphB8Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxjR+6wqWMKf18qOEKk-VndVaHPtttPf6c06yK=9OphB8Q@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 31 Jan 2020 16:15:23 +0100
Message-ID: <CAJfpegsek1OM+XGA5mHMTuZ_r37hp_e_YkQkgaXjWJu=dvpONA@mail.gmail.com>
Subject: Re: [PATCH 3/4] ovl: decide if revalidate needed on a per-dentry bases
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > index 67cd2866aaa2..3ad8fb291f7d 100644
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -90,10 +90,19 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
> >         return oe;
> >  }
> >
> > -bool ovl_dentry_remote(struct dentry *dentry)
>
> Removed too early. It still has users.
> Otherwise looks ok.

Thanks, fixed ones pushed to @ovl-remote-upper-v2.

Thanks,
Miklos
