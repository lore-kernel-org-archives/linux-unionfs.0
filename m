Return-Path: <SRS0=188/=DB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DCBC4363D
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 14:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6262220D
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 14:33:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lC4XLEk3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgIXOdv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 10:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbgIXOdv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Sep 2020 10:33:51 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F475C0613CE;
        Thu, 24 Sep 2020 07:33:51 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y74so3460999iof.12;
        Thu, 24 Sep 2020 07:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PXWSZ+VrZm35k0O0ZxUenkT2cVVC+SUtKwC8n3lqlpQ=;
        b=lC4XLEk3b/P7rF8cJyJNWEukkijBdZLAi8GVyZAibM3MbVMz2aIn6Nr4mhIXE7fwZn
         2ThxZwhcnFA8FRgj/ecpgtCsuxjnF9f0kxevHPHV9At+Ul8F2N2kMui3qKP3bYu9t+S1
         08hXYyUK5KMHTF6ndLdZxfYBa7jww2Pmuu5wuy8wD5yY23UEZNMshH5cUBsa08kzT/kD
         Gn/9Di1l76Qa4iCbCFUDwap08iO6llbhmSzyffyU1YfI8gxTSnvBuupexH5/tGF8xtYK
         o9eUdPVddRHWnAXI+HswxQh7/xB9kRDEB708aSHhOPlmoux1KweZ6dggLSOnNn6o6WfY
         w/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PXWSZ+VrZm35k0O0ZxUenkT2cVVC+SUtKwC8n3lqlpQ=;
        b=GkqDk+98mJJFT3uoeY7JvmfjGrooWm6dydafu6aTmp7057EV3jcqykzC6euHSw+tyQ
         S/95hK6XI49rcTX+kWkyFyB8xMVFjAx2wDNPnQFjzU5MAaDjXfdNODMOfqFSS6x8Cjso
         zbNb2vHeBP0inpXUPKx0HBg6Ypuj4txy+48YQDcNdyd3KFuiEc5muxzP3vb2s1o7PL/V
         UBScNpRcQKRkpKe13h7JcETs9ZmZZybfBAWPaa75GjsWdN04gn1LLx5o6j0Asf+bQzAV
         Zogkl8GXiWcyNIJMF7qnVi3yVbuOFXnLKMlX+rArT8t0xcbdJga4L8HhkdGZb08/aFB4
         AGoQ==
X-Gm-Message-State: AOAM533744nDCj8gyeole7MHtPcXPcYF2y8GsgBmqmc9l88ZiKAEqy1E
        /FJCiuvReSoaJvPkmIidbOZfnh4Zl17mY3bDhxbGw6RZ
X-Google-Smtp-Source: ABdhPJz7fwlGNfduKtuy9Wm5RIs9GAzBnywJSe+NLkui8+fhFm8NdD5cyDxHQeRzvNdSTjWuQNIZOVfGsJ8XVqOQ3Wk=
X-Received: by 2002:a05:6602:2e81:: with SMTP id m1mr3485683iow.64.1600958030718;
 Thu, 24 Sep 2020 07:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200923152308.3389-1-ptikhomirov@virtuozzo.com>
 <20200923194713.GD88270@redhat.com> <CAOQ4uxjZ58bCNz7K6_2bk+O2ALEVFxoNPBXABKMC-+D9-oZ6=w@mail.gmail.com>
 <20200924131853.GA132653@redhat.com>
In-Reply-To: <20200924131853.GA132653@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 24 Sep 2020 17:33:39 +0300
Message-ID: <CAOQ4uxizU=0htHdu7JBBx6a4UB0Lj6HN3nf+mykinm+_1XLWGg@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: introduce new "index=nouuid" option for inodes
 index feature
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 24, 2020 at 4:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Sep 24, 2020 at 05:44:22AM +0300, Amir Goldstein wrote:
> > On Wed, Sep 23, 2020 at 10:47 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Wed, Sep 23, 2020 at 06:23:08PM +0300, Pavel Tikhomirov wrote:
> > > > This relaxes uuid checks for overlay index feature. It is only possible
> > > > in case there is only one filesystem for all the work/upper/lower
> > > > directories and bare file handles from this backing filesystem are uniq.
> > >
> > > Hi Pavel,
> > >
> > > Wondering why upper/work has to be on same filesystem as lower for this to
> > > work?
> > >
> >
> > I reckon that's because I asked for this constraint, so I will answer.
> >
> > You are right that the important thing is that all lower layers are
> > on the same fs, but because of
> >   a888db310195 ovl: fix regression with re-formatted lower squashfs
>
> Hi Amir,
>
> So with "upper on same as lower fs" contstraint we are just making it
> little harder so that people don't use recreated lower with existing
> upper? Is that the intention behind this constraint.
>
> On a side note, I have a question about above commit.
>
> So this is basically the issue of upper stored file handle resolving to
> a different file (in recreated lower). And we are considering this to
> be a corner case. But the very fact a user was running into it, it
> probably is not that hard to reproduce. So with the fix a888db310195,
> we avoided the problem for simple configurations (no-index, no-metacopy,
> and no xino). But if same user runs with index=on, with recreatd lower,
> they can still run into similar issues?
>
> >
> > I preferred to keep the rules simpler.
> >
> > Pavel's use case is clone of disk and change of its UUID.
> > This is a real use case and I don't think it is unique to Virtuozzo,
> > so I wanted index=nouuid to address that use case only and
> > I prefer that it is documented that way too.
>
> Sure. I understand that. I am only harping on this to make sure
> we tell people to not use this "recreated lower with existing upper".
> In Pavel's use case, it is more of a cloned use case and not
> re-created use case.
>
> Otherwise people will re-create lower layers with regular filesystems and
> use index=nouuid and then run into squashfs like issue one day.
>
> Or we could document what Miklos had said. Using existing upper
> with recreated lower will likely run into issues with advanced
> overlay features like (index, metacopy, xino etc).
>

I am perfectly fine with saying that
and with allowing the special case of cloning disk with index=nouuid.

There was a "patch" floating around for improving the doc,
I was assuming you will pick it up add your own proposed changes
and make it into a proper patch.

> >
> > Ironically, one of the justifications for index=nouuid is virtiofs -
> > because fuse is now allowed as upper (or as same fs),
> > one can already use fuse passthough (or one could use fuse
> > passthrough when nfs export works correctly) as a "uuid anonymizer"
> > for any fs, so in practice, index=nouuid cannot do any more harm
> > then one can already do when enabling index over virtiofs.
>
> Interesing. Using virtiofs or a fuse passthrough filesystem on top
> just to avoid uuid check will be lot of work.
>
> But keeping upper/ on same fs as lower fs constraint does not help with this.
>

No, it does not. I am only saying index=nouuid is "just" as bad
as what people can already do with virtiofs. Not much worse.

> >
> > That is why I prefer the interpretation that index=nouuid means
> > "use null uuid instead of s_uuid for ovl_fh" over the interpretation
> > "relax comparison of uuid in ovl_fh".
>
> So bottom line is that there are many ways where users can recreate
> lower layers and run into issues.
>
> - squashfs with index
> - use a fuse passthrough filesystem
> - use index=nouuid
>
> So to me documenting that don't use existig upper with recreated lower
> should help with all.
>
> And putting a constraint of "lower and upper being on same fs" seems fine
> for now but I am not sure it helps a lot. Anyway, I am fine with this
> constratint. Just wanted to understand the rationale behind it.
>

Only rational is - it is intended for cloned disk - don't make it easy
to use this for
anything else.

Thanks,
Amir.
