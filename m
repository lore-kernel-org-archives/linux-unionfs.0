Return-Path: <SRS0=Ys2z=CK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665E2C433E2
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 08:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B9F9206CD
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 08:11:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IyzAP9ys"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgIAILR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 04:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgIAILQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Sep 2020 04:11:16 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C6FC061244
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Sep 2020 01:11:16 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b16so315071ioj.4
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Sep 2020 01:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XJCqqItV3e6SmFuK7k22XYyc/+C6u1M2BItXKQ9D4bM=;
        b=IyzAP9ysyRKbv/V0ZMxeBEUs2YOefz3qXaWuAT1XIw0i9ULV3p66AlG2OJTla55q9z
         zGycqXBZ9yWSHm1YEFRx998m9f2zT5vntKZAKcQzrqs+GtvlP2vsa8yQSEsDNmPqvHrB
         of6wbFUdKGWeNnyvzw8YkgBQDm2XfjI+HWxjRTG+BXgPlEGJZTXtJgWLIrzNYAuLwLIb
         NTurKaEnH8Fuif4hF/hSasc07EMn1q5EoWWIJUIAMDS2XI5EuHRcDuVprON/c98FpW/c
         VmfgyuEhuc1AFOUQ3rYnEvZNxybBA+VfC6b2Hnqs1eMYI1FAuz8IUegka6kWPweluhLD
         +UvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XJCqqItV3e6SmFuK7k22XYyc/+C6u1M2BItXKQ9D4bM=;
        b=Pm2LWfOhZUu6YzruWBjGGCGq7P70ebCThXlz2XcTlIx0zNScSspzlcr+r4WFk0SiDj
         dRhtSl3WUonGeE3BPSsmMN5qtgxANUJodb25xPAClkeTiirtjiYqI4srt7jeBZ7s+5qd
         YcxjT9gfo3Ysgskf4YOZgrt8tUnslrIbay04tQzl9K7hJ4njzql2yWDaCsS7PqHq2N8L
         KH+XCIoDNLZ0ZcITj/Ai4yP/O2Hj3RFECsp/OX8ToIFC4UiTLMfZTb2Yp3OElDkQTbcH
         HGfGqAEhSJkVKFDGwGymU4y224JwFNmvXi+3NSGahvVDlz9tdrJhXQw2vfzpEon/wEa9
         9PRA==
X-Gm-Message-State: AOAM530c1614skO1ICujytw5aSe+NxasCGeqY/otaMSPPvnLpi/zquZJ
        azoFikJZvKxYUdSgypzVTqEoyp7rpG810mlfEc8=
X-Google-Smtp-Source: ABdhPJwerP0uL6kTMyMkm0lzIgtMukEsj25kD3Uucxs9Q//lHVco8ElkiUx2+SrJc9RwEEIUuUm3JtmTtVmzRLcfLCs=
X-Received: by 2002:a05:6602:2f8a:: with SMTP id u10mr539117iow.72.1598947872691;
 Tue, 01 Sep 2020 01:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200830202803.25028-1-amir73il@gmail.com> <20200831161230.GB1172775@redhat.com>
In-Reply-To: <20200831161230.GB1172775@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Sep 2020 11:11:01 +0300
Message-ID: <CAOQ4uxjQ7p19kHxKTAAbffWrtmZOS_=SQTJTi=vNK9TCMgtRAQ@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: check for incomapt features in work dir
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 31, 2020 at 7:12 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Sun, Aug 30, 2020 at 11:28:03PM +0300, Amir Goldstein wrote:
>
> [..]
> > @@ -1079,21 +1090,29 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
> >                               continue;
> >                       if (p->len == 2 && p->name[1] == '.')
> >                               continue;
> > +             } else if (incompat) {
> > +                     pr_warn("overlay with incompat feature '%.*s' cannot be mounted\n",
> > +                             p->len, p->name);
> > +                     err = -EEXIST;
> > +                     break;
>
> Hi Amir,
>
> Should above be pr_err() instead of pr_warn()?
>

Sure.

I suppose Miklos can fix that on commit...

Thanks,
Amir.
