Return-Path: <SRS0=S/v9=A2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5419FC433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31AC22067D
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="NqlKYQZR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgGOUEh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgGOUEg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 16:04:36 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E345C061755
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 13:04:36 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p20so3487702ejd.13
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 13:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OsdYTh66GawLF001qoNWypYG6/HfTfwcYe6aTI2xSHc=;
        b=NqlKYQZRvsp8i3jAALJdfstMR2ALSydqmx2amq+60pcoR40d+1BtDvcwDKUtgmyHrZ
         5Cp6TdnWkc9yF3gGzXXKs6GZNSLeyXoML3BWkILdfK/dkb507z0MOEjo2Q7SrAwEpHiN
         5fSjxUFPTWYGUK+5v+uyRMvIYwXw2XVtu9JyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OsdYTh66GawLF001qoNWypYG6/HfTfwcYe6aTI2xSHc=;
        b=pZfUCdBA9mZOcuzrdY7oAsx23wMts5ejO0AT0RPnOMFnLfCX4wBtT/vy+AlkdTS0a2
         uqdQOC4VpbUZeVuJj0JwFS1po5g8ucVlkCS5rVMzz6nR4PEKQWCG0svTqDxf1PxJrVrn
         tEt4CiznWprjT+W4gqGmrh5vhC/eK7u3S3JwKeWMJA/vWd+7KSPYup+wwNRaTwvdawI0
         qwF1Rg+IM/gNgLX/IyuEuYvFzLVfwaXN9SfB+tj/k9r+YbA/SAV3BWoE6zqCE3BYWlPg
         zUG65McmQK1OgLXC1VONLWZW3tmcNMg+42r++oJmKSGSUw2ikJv/8nQbxj3X212OjYTn
         IRYg==
X-Gm-Message-State: AOAM530lUKvR4aoYxIsVSjp24Cmw7MTBPmf3c9n1PnsxRJvP/OkaOOvE
        ZfadCw+7wmsEW4770LXC7mlvjZuojbTd4IWXmWF1Rg==
X-Google-Smtp-Source: ABdhPJzkBoxBgCXhmy05b67rNhChexKR5nudH23tZtpg2hEaBV70k4OOguhFvniuE7aGWvzz0QIpOoc78RMbwBIFp1U=
X-Received: by 2002:a17:906:144b:: with SMTP id q11mr536301ejc.511.1594843475149;
 Wed, 15 Jul 2020 13:04:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-2-amir73il@gmail.com>
 <20200714181804.GF324688@redhat.com> <CAOQ4uxj_GMcWvSGSWkTQvKj2gPCP1=R9T-t=baDrH+V3Q1mPrQ@mail.gmail.com>
 <20200714183819.GH324688@redhat.com>
In-Reply-To: <20200714183819.GH324688@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Jul 2020 22:04:23 +0200
Message-ID: <CAJfpegsW_FHO5He1VdKvE6KG02S=47-Nv=6O2Wh5xARUn40bfw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: force read-only sb on failure to create index dir
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 8:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Jul 14, 2020 at 09:32:51PM +0300, Amir Goldstein wrote:
> > On Tue, Jul 14, 2020 at 9:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Mon, Jul 13, 2020 at 05:19:43PM +0300, Amir Goldstein wrote:
> > > > With index feature enabled, on failure to create index dir, overlay
> > > > is being mounted read-only.  However, we do not forbid user to remount
> > > > overlay read-write.  Fix that by setting ofs->workdir to NULL, which
> > > > prevents remount read-write.
> > > >
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > >
> > > This patch does not apply for me. What branch you have generated it
> > > against. I am using 5.8-rc4.
> >
> > It's from my ovl-fixes branch.
> >
> > Sorry I did not notice that it depends on a previous patch that Miklos
> > just picked up:
> >
> > "ovl: fix oops in ovl_indexdir_cleanup() with nfs_export=on"
>
> I dont see it here.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git/log/?h=overlayfs-next
>
> Is there another tree/branch miklos is maintaining which I should use? Or
> you just happen to know that Miklos has committed this internally and
> not published yet.

Will push shortly to #overlayfs-next.

Thanks,
Miklos
