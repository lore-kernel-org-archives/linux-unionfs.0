Return-Path: <SRS0=WKmv=74=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B56C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 Jun 2020 13:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1811206B7
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 Jun 2020 13:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="AXJhM/hK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgFONCH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 09:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730388AbgFONBv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jun 2020 09:01:51 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA43C08C5C2
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2020 06:01:50 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g1so11439029edv.6
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2020 06:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AvCe0HbqQ4BzGml+0DuV0nSjSHUXH/a7GtKAihE8SRE=;
        b=AXJhM/hKmiZBel7yqZsPLh+qR48DiuSWw+gN6NwcjxGonGBBT4xZNIhnQoUZBfpJfH
         1NZAFJQspIVoZmiDPMW/zVKEpYy92CPJhP1ryw7noohJnifYPJFtPAPipclcRU51LyVJ
         aFmGcX6C+7O0dfinR4r59frhdDr+6ymq5ln90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AvCe0HbqQ4BzGml+0DuV0nSjSHUXH/a7GtKAihE8SRE=;
        b=nqD1SuIb0vDFLcTqS/vaDdMpOmEywrjfDVz3HzEsV2Ti4y1YXmj7pyYy2YlltrXPwH
         Wy18F09Ox8TTJHRrUaWLg286LYidGUrthxufreeYQy6GjovIJP7QCJjzXjxj6G+13HRy
         RK/oRywMtsaGKqxQ8Zd+Gse0C4gNw3obcHOS8xPreYIE4nljymf+KYL7ElK0G8ODw5kA
         mfjSMEzTq4EouFKUYVuBp22h88CV071cbtGZAkrgn5EGLR71ye892EoCQn4ejtpmEp7G
         scSZLpV3kzQGD36PhJXrgoPURgEWZcECN84G9xQPcFg0rPPm4LsZnL5URvLbiVXRxfUy
         hp6g==
X-Gm-Message-State: AOAM533pvCilDfKRrZ41RmddiZLsqEVHThI/9l+75KGmnwXeaGuBT7ps
        CHONotFpK9lgTX22jBCvks0fEMdGwozpeGkpdSIJKw==
X-Google-Smtp-Source: ABdhPJw5bS2bqPFdNiYWV2UphtcYunDkac05QqFEUWlRJ3HITjBAcbh0ivLoUAsUyrpP21XvFyU3Zn5XsOsK+kRq7j8=
X-Received: by 2002:aa7:d9d3:: with SMTP id v19mr22985359eds.364.1592226108717;
 Mon, 15 Jun 2020 06:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200612004644.255692-1-mike.kravetz@oracle.com>
 <20200612015842.GC23230@ZenIV.linux.org.uk> <b1756da5-4e91-298f-32f1-e5642a680cbf@oracle.com>
 <CAOQ4uxg=o2SVbfUiz0nOg-XHG8irvAsnXzFWjExjubk2v_6c_A@mail.gmail.com>
 <6e8924b0-bfc4-eaf5-1775-54f506cdf623@oracle.com> <CAJfpegsugobr8LnJ7e3D1+QFHCdYkW1swtSZ_hKouf_uhZreMg@mail.gmail.com>
 <CAOQ4uxgA+_4_UtVz17_eJL6m0CsDEVuiriBj1ZOkho+Ub1yuSA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgA+_4_UtVz17_eJL6m0CsDEVuiriBj1ZOkho+Ub1yuSA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 15 Jun 2020 15:01:37 +0200
Message-ID: <CAJfpegs-Ch5ua658UD5s4u6ynKGpMzdiY31G-c4Fdu_=ZCV_uA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] hugetlb: use f_mode & FMODE_HUGETLBFS to identify
 hugetlbfs files
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Colin Walters <walters@verbum.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        syzbot <syzbot+d6ec23007e951dadf3de@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 15, 2020 at 12:05 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jun 15, 2020 at 10:53 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Sat, Jun 13, 2020 at 9:12 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > >
> > > On 6/12/20 11:53 PM, Amir Goldstein wrote:
> >
> > > As a hugetlbfs developer, I do not know of a use case for interoperability
> > > with overlayfs.  So yes, I am not too interested in making them work well
> > > together.  However, if there was an actual use case I would be more than
> > > happy to consider doing the work.  Just hate to put effort into fixing up
> > > two 'special' filesystems for functionality that may not be used.
> > >
> > > I can't speak for overlayfs developers.
> >
> > As I said, I only know of tmpfs being upper layer as a valid use case.
> >    Does that work with hugepages?  How would I go about testing that?
>
> Simple, after enabling CONFIG_HUGETLBFS:
>
> diff --git a/mount_union.py b/mount_union.py
> index fae8899..4070c70 100644
> --- a/mount_union.py
> +++ b/mount_union.py
> @@ -15,7 +15,7 @@ def mount_union(ctx):
>          snapshot_mntroot = cfg.snapshot_mntroot()
>          if cfg.should_mount_upper():
>              system("mount " + upper_mntroot + " 2>/dev/null"
> -                    " || mount -t tmpfs upper_layer " + upper_mntroot)
> +                    " || mount -t hugetlbfs upper_layer " + upper_mntroot)
>          layer_mntroot = upper_mntroot + "/" + ctx.curr_layer()
>          upperdir = layer_mntroot + "/u"
>          workdir = layer_mntroot + "/w"
>
> It fails colossally, because hugetlbfs, does not have write_iter().
> It is only meant as an interface to create named maps of huge pages.
> So I don't really see the use case for using it as upper.

Right.

I was actually asking about the tmpfs+hugepages, not the hugetlbfs case.

In the tmpfs case it looks like the lack of ->get_unmapped_area() in
overlayfs could still be an issue.   But I'm not sure how to trigger
that.

Thanks,
Miklos
