Return-Path: <SRS0=+0RS=6H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0A9C2BA19
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 10:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD7B420704
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 10:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwMA476j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgDWKZz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 06:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726420AbgDWKZz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 23 Apr 2020 06:25:55 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A81C035493
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Apr 2020 03:25:54 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id e8so5019412ilm.7
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Apr 2020 03:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wVuNcuVJJRP7KgAHqCm3G/Gbvri3x3QJIWhj3W/hwCA=;
        b=fwMA476jZoNkXR/H6x2e8UzNXU3e8a6bHclPEMLyOyQq/v9LR4Z11zj8rgktodOna2
         YVjkhb1+nuoQzMjX9yfMRDHeTvk3T7QJ4mBvyb4uZXf5XQ7msJs3L2icgriWJNd4Twjo
         pXR+J8zY7unj9nZkMkVGCqWUDyGe2615+zgVE089TmRl66387+MwjQyGG9nI18g+pkOU
         pLybr37kIktWBFWP63pTlOSsK2E6MENAmUqfEEROv+uYeHk4/jQuOiP7LS8+BrKU6YKT
         9b2UKpROA8eO8G4e1KiZJyRBohs4KBMVyVXEM6ggX0hU9o1GoDixfAP4BsGyQ5i5dzQd
         bgfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wVuNcuVJJRP7KgAHqCm3G/Gbvri3x3QJIWhj3W/hwCA=;
        b=cZ6zVwEdnAE6jFyjMgKbP7L1a0PFNUyuuh7EowfCm/magsLfB5gycSrVPkp3HWAnfu
         c4thyis7BtXlUQhVrumsvVd+vrWr77aUdFAYH4CPFsyDnWEy9VsC5PoM/qaCGP3VQaQw
         Z/prR+jBEXq/ldAetsV1AxDRjIxSDR6+9an7k8R9e1yIzZ2j+n+jQIMtM8gLJJMnT8Jj
         UGzvcYmi1Z/QJI/GkqP7Trb4zDsqszKNo3ewKljMrd74j4HkhG/BAvCzH7tHHsWqRzsL
         AbZ4r+L19YumZrMZU4DxgaPS63OwA8hZfDwrRjdD7Rm4SC7kFQEFbfH8zqElvYqhtKZy
         Cv1Q==
X-Gm-Message-State: AGi0PubGP8eZZc+ujE+nhMnZmq+t8izS90l1GOTqn0qsfYrnhs9XfiUK
        UvLmTAvIqTnujiRDkB3gdf/nnHYarRYCL/Biah5qK87M
X-Google-Smtp-Source: APiQypLB+LztB9DLi6Su+/ekXSHUyuON+iM9jeIcysZKsO0rH9Rbbta5nKvRXCKh7FTcjewfxiVElEothRyEh1KPgeE=
X-Received: by 2002:a92:7e86:: with SMTP id q6mr2733275ill.9.1587637553629;
 Thu, 23 Apr 2020 03:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <1587625038-55484-1-git-send-email-jefflexu@linux.alibaba.com>
 <4898364f-e6e9-72e2-9b28-9a3a8f297ad4@linux.alibaba.com> <CAOQ4uxjzOmg03mgOG9cyAygK-XhfiMVh3M3k25yN1ZmvO39ckA@mail.gmail.com>
 <7297fa44-de3b-52ba-0b42-d136f672a301@linux.alibaba.com>
In-Reply-To: <7297fa44-de3b-52ba-0b42-d136f672a301@linux.alibaba.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 Apr 2020 13:25:42 +0300
Message-ID: <CAOQ4uxhyHQXDkWoiE-LwZ9dM5JV9vXupfi8RTivAd6Jx59g9Fw@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: set MS_NOSEC flag for overlayfs
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "joseph.qi" <joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 23, 2020 at 1:17 PM JeffleXu <jefflexu@linux.alibaba.com> wrote:
>
>
> On 4/23/20 4:27 PM, Amir Goldstein wrote:
> > On Thu, Apr 23, 2020 at 10:06 AM JeffleXu <jefflexu@linux.alibaba.com> wrote:
> >> It seems that MS_NOSEC flag would be problematic for network filesystems.
> >>
> >>
> >> @Amir, would you please give some suggestions on if this would break the
> >>
> >> permission control down when 'NFS export' feature enabled ?
> >>
> > I cannot think of anything specific to NFS export.
> > I think you are confusing NFS server with NFS client permissions.
> > I think network filesystems do not set SB_NOSEC, because client
> > may not have an coherent state of the xattr on server and other clients.
> >
> > To reflect on overlayfs, I think overlayfs should inherit the SB_NOSEC
> > flag from upper fs, which is most likelihood will be set.
>
> Makes sense. So maybe the following patch would be more appropriate. If
> it is OK I will send a v2 patch then.
>

Yes, it looks better.
But I could be missing other aspects.
Better post v2 and wait for more comments from Miklos.

Thanks,
Amir.
