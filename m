Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F09BC433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 17:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D0712078D
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 17:02:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n98JT5//"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgEVRCv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 May 2020 13:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbgEVRCv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 May 2020 13:02:51 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D6EC061A0E;
        Fri, 22 May 2020 10:02:50 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q8so10686373iow.7;
        Fri, 22 May 2020 10:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5oEjRlutZgesjZsBZiS7Pr4cJPVCPyetipAJ+rscTg4=;
        b=n98JT5//RP8Wvyu9VLvSNejJOq74cqmdRu2GtXGCOZw+Jr0LyauRuu5OQV6CGUdNNi
         2DP0kjZCfNmTSf0pVZX1WCu5QIeTytgjkIZV3zJBapZCr5koWfmnPKoS+OH+nxl+Wp4t
         dxXL18qA4DRC+/9/9hKNPyzbz0syZ/eNn5KLQwLs3qAOE9rGdHNohtNLzMtO8L5WTWSJ
         kz8/scjklAb/6U91mL6ktfl3bgFvznonDRAem3LXoeZhLJq0Rc1XXL5aJVe05DghWd2+
         3YMOMX7RtUB9cp02VYmWO7ju0Z1h8aUJpEco4aOOCyXyjKmudu6sDy8vW1AKZlnScn4q
         4/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5oEjRlutZgesjZsBZiS7Pr4cJPVCPyetipAJ+rscTg4=;
        b=IS2Yrb4rFMGQGlbX7/EdAX9K7/DX8OASwdA1V+v/rYH0QLKOXeO4KuVMeQE9N/com5
         yGnrVjFXFTS/nSsDvZhObnpnVM3VxJBs7ITEN8X0jJBWR5932FowetcxTYWgu0mSqK2a
         YVUzEBGdy+8E2EN/LTHojjCK/uBvjnNSZABpkzPtFS1tgLEyk+DbwSOQtzHL5AVatGwH
         Ufk56jx1gSGQe5Vosi0f+wP8klN8FWLyb2+HGF8voBL+5Pr68x03xMJwlj07iN5OOEXe
         sZAk3ncp1jvgR3rsmc5B0o2GZBffCM2kbdXhid4uGsw5SFsI+D9rhFEP8XFT4LBcwhk1
         NUtw==
X-Gm-Message-State: AOAM532d7I2vRWnws7XtEA9P1O9NLok+CH3TQEquy0m8ZRzLLWlPcQ8w
        t7NmcqHwjPXf15ve9Ct91xpdcioNDJaqgKMxZ4xxClre
X-Google-Smtp-Source: ABdhPJzGYyiIz9HHCDTTzCDAm4IA7auea9SQSZM9H0EeTh377b4cTFqNt1IwzJLGdNzH58gNtehDSupkPPwT20xJQHU=
X-Received: by 2002:a5e:840d:: with SMTP id h13mr3873782ioj.64.1590166969578;
 Fri, 22 May 2020 10:02:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200522085723.29007-1-mszeredi@redhat.com> <20200522160815.GT23230@ZenIV.linux.org.uk>
 <CAOssrKcpQwYh39JpcNmV3JiuH2aPDJxgT5MADQ9cZMboPa9QaQ@mail.gmail.com>
In-Reply-To: <CAOssrKcpQwYh39JpcNmV3JiuH2aPDJxgT5MADQ9cZMboPa9QaQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 22 May 2020 20:02:37 +0300
Message-ID: <CAOQ4uxi80CFLgeTYbnHvD7GbY_01z0uywP1jF8gZe76_EZYiug@mail.gmail.com>
Subject: Re: [PATCH] ovl: make private mounts longterm
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > > -     mntput(ofs->upper_mnt);
> > > -     for (i = 1; i < ofs->numlayer; i++) {
> > > -             iput(ofs->layers[i].trap);
> > > -             mntput(ofs->layers[i].mnt);
> > > +
> > > +     if (!ofs->layers) {
> > > +             /* Deal with partial setup */
> > > +             kern_unmount(ofs->upper_mnt);
> > > +     } else {
> > > +             /* Hack!  Reuse ofs->layers as a mounts array */
> > > +             struct vfsmount **mounts = (struct vfsmount **) ofs->layers;
> > > +
> > > +             for (i = 0; i < ofs->numlayer; i++) {
> > > +                     iput(ofs->layers[i].trap);
> > > +                     mounts[i] = ofs->layers[i].mnt;
> > > +             }
> > > +             kern_unmount_many(mounts, ofs->numlayer);
> > > +             kfree(ofs->layers);
> >
> > That's _way_ too subtle.  AFAICS, you rely upon ->upper_mnt == ->layers[0].mnt,
> > ->layers[0].trap == NULL, without even mentioning that.  And the hack you do
> > mention...  Yecchhh...  How many layers are possible, again?
>
> 500, mounts array would fit inside a page and a page can be allocated
> with __GFP_NOFAIL. But why bother?  It's not all that bad, is it?

FWIW, it seems fine to me.
We can transfer the reference from upperdir_trap to layers[0].trap
when initializing layers[0] for the sake of clarity.

Thanks,
Amir.
