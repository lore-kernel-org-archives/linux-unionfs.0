Return-Path: <SRS0=0kBH=DA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF57C2D0A8
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B99720791
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:36:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hupGvrAW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgIWQgN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWQgN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Sep 2020 12:36:13 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798FDC0613CE;
        Wed, 23 Sep 2020 09:36:13 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id h2so170319ilo.12;
        Wed, 23 Sep 2020 09:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7kxcMzSJOu9MRUeXMXsPNJHKsz/cSDIqf1ztUHh+hbg=;
        b=hupGvrAW1PU1XHVqgGlDPNjfWAM6aiQKfO2db0dqqhjlxJIRcm8Qy89a5csCD5aiRZ
         zRKBSZNSqaOfuQV6rIcv25EqxsRxGo400sWROPMxq92k91eJWUrzPyW40mUjaDlpbC5m
         vXteF6iQYnDyQCKrzcF3SD3xYpfZ1RrrYI4+B0Ty9d5TPL/fxEERRP8XZ157vSlCidgo
         lZz8DvkCUmD6EC6x/0kuykVsGPhBx3tHtwVl8v390oAmFai+kQvEL8ZJi9VFHzMvt5md
         OvH30JveLpQ5/bExiAdX9qC9Z1hp11vSj0ekH5R6owmZyaLD+uvlRp1jtSNflr5nAOgo
         kUQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7kxcMzSJOu9MRUeXMXsPNJHKsz/cSDIqf1ztUHh+hbg=;
        b=NNjmLFmdzAfMnQq4KXxx/V2LYwXc9fE4Vm92orZblx9Sv6skkiR0ENKnEaILgp89Yz
         QxaEntSWYYQVc2VK8y1ccECTHroRv8oymiHr20YKbjuJ3WIeYRu2pRehofvNnwUy3Bex
         aCfFZtGU9jth7V3GmQGjQQhXDtytmMc1+LfSdr6xZCkx30RgD1umW9V6zyT6ojP9KTfK
         WgIRtsFWqRv6pRIHEqeAAfYtWO+aComRnBWh0Y39Ekx5VPdero85FoIcVM9Zu0QJE6FQ
         9sxHuW092+HDgQ6a6tPn0SbohPNU7nDiTL4zbZMoDBpprbzxtkuCyqmCjZmfb04AhJCz
         IXfA==
X-Gm-Message-State: AOAM5325e8XF4xUMcK2EKbIvM31wGQEZA/LYJuH8+s63BrRz/UNQ19D1
        pdaZlQ5oLXnKHBk7smzAaGrksO28UPLqC1OjB7w=
X-Google-Smtp-Source: ABdhPJzS4BrlNB2C19arwtVi2wp4blqZny3A+tjNFQw+wk3ylhNsull61eeG7KeQpz0HQ6JeMd1TI9/zsv7EpBMRk4w=
X-Received: by 2002:a92:8b41:: with SMTP id i62mr564007ild.9.1600878972555;
 Wed, 23 Sep 2020 09:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200923152308.3389-1-ptikhomirov@virtuozzo.com> <CAOQ4uxjxYjRkkB3tFqdZiOwj=2_+Ghzf5AvmptVLQM22K5DWfg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjxYjRkkB3tFqdZiOwj=2_+Ghzf5AvmptVLQM22K5DWfg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 23 Sep 2020 19:36:01 +0300
Message-ID: <CAOQ4uxhjWsK1dfQu4K8uvRyGeGnFrM6opq32RxMOT4pWdqm+3A@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: introduce new "index=nouuid" option for inodes
 index feature
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > @@ -414,7 +415,7 @@ static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
> >   * Return 0 on match, -ESTALE on mismatch, < 0 on error.
> >   */
> >  static int ovl_verify_fh(struct dentry *dentry, const char *name,
> > -                        const struct ovl_fh *fh)
> > +                        const struct ovl_fh *fh, bool nouuid)
> >  {
> >         struct ovl_fh *ofh = ovl_get_fh(dentry, name);
> >         int err = 0;
> > @@ -425,8 +426,14 @@ static int ovl_verify_fh(struct dentry *dentry, const char *name,
> >         if (IS_ERR(ofh))
> >                 return PTR_ERR(ofh);
> >
> > -       if (fh->fb.len != ofh->fb.len || memcmp(&fh->fb, &ofh->fb, fh->fb.len))
> > +       if (fh->fb.len != ofh->fb.len) {
> >                 err = -ESTALE;
> > +       } else {
> > +               if (nouuid && !uuid_equal(&fh->fb.uuid, &ofh->fb.uuid))
> > +                       ofh->fb.uuid = fh->fb.uuid;
> > +               if (memcmp(&fh->fb, &ofh->fb, fh->fb.len))
> > +                       err = -ESTALE;
> > +       }
> >

On second thought I am wondering if we should do that differently.
If users want to work with index=nouuid, they need to work with it from day 1.
index=nouuid should export null uuid in NFS handles and write null uuid
in trusted.overlay.origin xattr.

So in ovl_encode_real_fh() you set null uuid and
instead of relaxing uuid_equal() in ovl_decode_real_fh()
you change it to uuid_is_null().

Do you have a problem with that for Virtuozzo use case?

Thanks,
Amir.
