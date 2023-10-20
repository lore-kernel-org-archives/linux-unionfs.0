Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C278CDB474
	for <linux-unionfs@archiver.kernel.org>; Fri, 20 Oct 2023 15:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377824AbjJTPzu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 11:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377810AbjJTPzs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Oct 2023 11:55:48 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0B4D7F
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Oct 2023 08:55:43 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-d9beb865a40so999578276.1
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Oct 2023 08:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1697817343; x=1698422143; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jx6nmfVDVS7bEGtXAZMajM3M9rkxXzo/xcGgXWsu8k=;
        b=CpGF5/O4ht0GTWriuqr7mQichvsxJEWxXJ0rWRypqhKyHJAE2WeBYLAMVsvskWcmln
         hWT9xcEHLjOhTzgCVY8I2X4pQhvvQ9MYeKp44FtLsz6VzNLBdkZxjUN5PyI65s6gFF47
         ihvnjyjzcUHlZOVLrt6deczRhgYuGUgdxKsJ5P5KzcqEt2xXJTDZrPccIWHu960jCHil
         c2maU5n3VfJqTxFWgk/0avrJj19u+1qk7fnPr/9eCTHjUeIC/nnmxnmKfGGsv2aVPxm7
         D2t5lsV6IPJBXXS7mnqUEka4jVwxVEhEpX6jve5LR4vEy9Zje+zChEludnYSC5sPTY1y
         rY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697817343; x=1698422143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jx6nmfVDVS7bEGtXAZMajM3M9rkxXzo/xcGgXWsu8k=;
        b=aC9Dn/CfSV9t6Thwt5KTyrqy7J4wxLQZD0Yl1gPkntqljDjqfu0CMb9I0bbfAcWGPB
         3oavCnA2MOu5RVCmpXFMm3KEJF5LasBgX6dm59OOTQlB58OJQNpmTobeNUpCjOPuivem
         vp7XHEfE7dYtJ7BaNSgcdfcNRfPwAWjltPBZ8MeuoOYYKReu2XDf11UiRkXDxRZU4hYf
         zKcg4dqDw35XdKbz50ZdbZYyw9UV50FQdoqgpgPJdHzp2ZZUI6vE1x/tBfEjBcrl2m5C
         VxBhlwBsXsy6id3ne4loE9oPDTyWyJNE4kulWiM9SkF97gYgaOssTgJVcXnnbOZ7I6YT
         hDdQ==
X-Gm-Message-State: AOJu0YxP8sftZ+fLap0sRchsoU1jGBav1N1SE2m4Wluly38YTrzc3lLt
        k0rX1ujv4Sf3FCFW8EvKdL4r2QWVh9wWKeR1xt6J
X-Google-Smtp-Source: AGHT+IE5ZLkKJYE3pr3/TThqNMJBVHfWrf0AG7jYWMNjBA3VlMzdcyn+XyBtKAsrMaOq9/usHh0vSGgR/0A28Da9sjY=
X-Received: by 2002:a25:2fcf:0:b0:d9a:3ba9:b884 with SMTP id
 v198-20020a252fcf000000b00d9a3ba9b884mr2162345ybv.3.1697817342704; Fri, 20
 Oct 2023 08:55:42 -0700 (PDT)
MIME-Version: 1.0
References: <20231018100815.26278-1-ddiss@suse.de> <CAEjxPJ6o8T=K+FHEHdWxn1PQN=Ew+KjooXL=coS0gx4YLuEFhw@mail.gmail.com>
In-Reply-To: <CAEjxPJ6o8T=K+FHEHdWxn1PQN=Ew+KjooXL=coS0gx4YLuEFhw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 20 Oct 2023 11:55:31 -0400
Message-ID: <CAHC9VhTLjcQXNoc8L3Uw=TRRghLuA_TnQbRkGtwnCu4kxVXE0g@mail.gmail.com>
Subject: Re: [PATCH] RFC: selinux: don't filter copy-up xattrs while uninitialized
To:     Stephen Smalley <stephen.smalley.work@gmail.com>
Cc:     David Disseldorp <ddiss@suse.de>, selinux@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 20, 2023 at 8:21=E2=80=AFAM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
> On Wed, Oct 18, 2023 at 6:08=E2=80=AFAM David Disseldorp <ddiss@suse.de> =
wrote:
> >
> > Extended attribute copy-up functionality added via 19472b69d639d
> > ("selinux: Implementation for inode_copy_up_xattr() hook") sees
> > "security.selinux" contexts dropped, instead relying on contexts
> > applied via the inode_copy_up() hook.
> >
> > When copy-up takes place during early boot, prior to selinux
> > initialization / policy load, the context stripping can be unwanted
> > and unexpected. Make filtering dependent on selinux_initialized().
> >
> > RFC: This changes user behaviour so is likely unacceptable. Still,
> > I'd be interested in hearing other suggestions for how this could be
> > addressed.
>
> IMHO, this is fixing a bug, only affects early userspace (pre policy
> load), and is likely acceptable.
> But Paul will make the final call. We can't introduce and use a new
> policy capability here because this is before policy has been loaded.

I agree with Stephen, this is a bug fix so I wouldn't worry too much
about user visible behavior.  For better or worse, the
SELinux-enabled-but-no-policy-loaded case has always been a bit
awkward and has required multiple patches over the years to correct
unwanted behaviors.

I'm open to comments on this, but I don't believe this is something we
want to see backported to the stable kernels, and considering we are
currently at v6.6-rc6, this isn't really a candidate for the upcoming
merge window.  This means we have a few more weeks to comment, test,
etc. and one of the things I would like to see is a better description
of before-and-after labeling in the commit description.  This helps
people who trip over this change, identify what changed, and helps
them resolve the problem on their systems.

Does that sound good?

--=20
paul-moore.com
